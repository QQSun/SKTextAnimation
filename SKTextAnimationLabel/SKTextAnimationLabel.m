//
//  SKTextAnimationLabel.m
//  SKTextAnimation
//
//  Created by nachuan on 16/7/25.
//  Copyright © 2016年 nachuan. All rights reserved.
//

#import "SKTextAnimationLabel.h"
#import "SKLayerAnimation.h"

@interface SKTextAnimationLabel () <NSLayoutManagerDelegate>

/** 用于存储将要展示文字的每个字符的textLayer */
@property (nonatomic, strong) NSMutableArray <CATextLayer *>*textLayers;

/** 用于存储以展示的文字的每个字符的textLayer */
@property (nonatomic, strong) NSMutableArray <CATextLayer *>*oldTextLayers;

@end

@implementation SKTextAnimationLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  初始化相关内容
 */
- (void)setup
{
    _textColor     = [UIColor blackColor];
    _font          = [UIFont systemFontOfSize:14];
    _textAlignment = NSTextAlignmentCenter;
    _numberOfLines = 1;
    _lineBreakMode = NSLineBreakByCharWrapping;
    
    _textStorage        = [[NSTextStorage alloc] init];
    _textContainer      = [[NSTextContainer alloc] init];
    _textContainer.size = self.bounds.size;
    _textContainer.maximumNumberOfLines = _numberOfLines;
    _textContainer.lineBreakMode        = _lineBreakMode;
    
    _layoutManager = [[NSLayoutManager alloc] init];
    _layoutManager.delegate = self;
    
    [_textStorage addLayoutManager:_layoutManager];
    [_layoutManager addTextContainer:_textContainer];
    
    
    _textLayers    = [[NSMutableArray alloc] init];
    _oldTextLayers = [[NSMutableArray alloc] init];
}

#pragma mark - setter方法
- (void)setFrame:(CGRect)frame
{
    _textContainer.size = frame.size;
    [self setTextStorage];
    [super setFrame:frame];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [self setTextStorage];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setTextStorage];
}

- (void)setTextStorage
{
    if (!_textStorage) {
        return;
    }else{
        [self setText:_textStorage.string];
    }
}
- (void)setNumberOfLines:(NSUInteger)numberOfLines
{
    _numberOfLines = numberOfLines;
    _textContainer.maximumNumberOfLines = _numberOfLines;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    _lineBreakMode = lineBreakMode;
    _textContainer.lineBreakMode = _lineBreakMode;
    [self setTextStorage];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    [self setTextStorage];
}

- (void)setText:(NSString *)text
{
    [self setAttributedText:[self getAttributedTextWithString:text]];
}

/**
 *  赋值要显示的attributedeText
 */
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [self cleanOutOldTextLayers];
    [_oldTextLayers addObjectsFromArray:_textLayers];
    [_textStorage setAttributedString:attributedText];
    [self oldTextLayerAnimation:^{}];
    [self textLayerAnimation:nil];
    
}

/**
 *  清除显示的的textLayer
 */
- (void)cleanOutOldTextLayers
{
    for (CATextLayer *textLayer in _oldTextLayers) {
        [textLayer removeFromSuperlayer];
    }
    [_oldTextLayers removeAllObjects];
}

/**
 *  以展示的textLayer要消失时候的动画
 */
- (void)oldTextLayerAnimation:(textLayerAnimation)textLayerAnimation
{
    NSInteger animationDuration = 0.0;
    NSInteger animationIndex = -1;
    NSInteger index = 0;
    
    for (CATextLayer *textLayer in _oldTextLayers) {
        CGFloat duration = arc4random_uniform(100) / 125 + 0.35;
        CGFloat delay = arc4random_uniform(100) / 500;
        CGFloat distance = arc4random_uniform(50) + 25;
        CGFloat angle = arc4random()/M_PI_2 - M_PI_4;
        
        CATransform3D transform = CATransform3DMakeTranslation(0, distance, 0);
        transform = CATransform3DRotate(transform, angle, 0, 0, 1);
        
        if (delay + duration > animationDuration) {
            animationDuration = delay + duration;
            animationIndex    = index;
        }
        
        [SKLayerAnimation layerAnimation:textLayer durationTime:duration delayTime:delay animation:^CALayer *(CALayer *layer) {
            layer.transform = transform;
            layer.opacity = 0.0;
            return layer;
        } completion:^(BOOL finished) {
            [textLayer removeFromSuperlayer];
            if (_oldTextLayers.count > animationIndex && textLayer == _oldTextLayers[animationIndex]) {
                if (_animationOut) {
                    _animationOut();
                }
            }
        }];
        ++index;
    }
}

/**
 *  将要展示的textLayer出现时的动画
 */
- (void)textLayerAnimation:(textLayerAnimation)textLayerAnimation
{
    for (CATextLayer *textLayer in _textLayers) {
        CGFloat duration = arc4random_uniform(200) / 100 + 0.25;
        CGFloat delay = 0.06;
        [SKLayerAnimation layerAnimation:textLayer durationTime:duration delayTime:delay animation:^CALayer *(CALayer *layer) {
            layer.opacity = 1.0;
            return layer;
        } completion:^(BOOL finished) {
            if (_animationIn) {
                _animationIn();
            }
        }];
    }
}

/**
 *  获取attributedString
 *
 *  @param string 普通string
 */
- (NSMutableAttributedString *)getAttributedTextWithString:(NSString *)string
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = _textAlignment;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange textRange = NSMakeRange(0, string.length);
    [attributedText addAttribute:NSFontAttributeName value:_font range:textRange];
    [attributedText addAttribute:NSForegroundColorAttributeName value:_textColor range:textRange];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:textRange];
    return attributedText;
}


#pragma mark - layoutManagerDelegate相关方法
/**
 *  layoutManager完成文字布局后回调
 *
 *  @param layoutManager      layoutManager
 *  @param textContainer      该layoutManager持有的textContainer
 *  @param layoutFinishedFlag 布局完成标志
 */
- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag
{
    [self calculateTextLayer];
}

/**
 *  计算每个textLayer的rect
 */
- (void)calculateTextLayer
{
    [_textLayers removeAllObjects];
    NSAttributedString *attributedString = [self getAttributedTextWithString:_textStorage.string];
    NSString *text        = _textStorage.string;
    NSRange textRange     = NSMakeRange(0, text.length);
    CGRect layoutRect     = [_layoutManager usedRectForTextContainer:_textContainer];//文字布局后所占用的rect
    NSInteger index       = textRange.location;
    NSInteger totalLength = NSMaxRange(textRange);
    
    while (index < totalLength) {
        NSRange glyphRange             = NSMakeRange(index, 1);//单个字形range
        NSRange characterRange         = [_layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:nil]; //字符range
        NSTextContainer *textContainer = [_layoutManager textContainerForGlyphAtIndex:index effectiveRange:nil];       //存放该字符的textContainer
        CGRect glyphRect               = [_layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];//字形rect
        
        /** 超出显示范围的glyphRect不要显示 */
        if (self.numberOfLines != 0 && (glyphRect.origin.y / glyphRect.size.height >= self.numberOfLines)) {
            return;
        }else if (glyphRect.origin.y + glyphRect.size.height > self.bounds.size.height){
            return;
        }
        
        /** 字距调整 调整字符的textLayer的width.防止被切割*/
        NSRange kerningRange = [_layoutManager rangeOfNominallySpacedGlyphsContainingIndex:index];
        if (kerningRange.location == index && kerningRange.length > 1) {
            if (_textLayers.count > 0) {
                CATextLayer *previousLayer = [_textLayers lastObject];//因为总是在存进后才检测.而且总是位于数组的最后一个
                CGRect frame        = previousLayer.frame;
                frame.size.width   += CGRectGetMaxX(glyphRect) - CGRectGetMaxX(frame);
                previousLayer.frame = frame;
            }
        }
        
        /** 调整垂直居中 */
        if (_numberOfLines == 0) {
            glyphRect.origin.y += (self.bounds.size.height - layoutRect.size.height) / 2.0;
        }else{
            glyphRect.origin.y += (self.bounds.size.height - glyphRect.size.height * _numberOfLines) / 2.0;
        }
        CATextLayer *textLayer = [self textLayerWithFrame:glyphRect attributedString:attributedString glyphRange:glyphRange opacity:0.0];
        [self.layer addSublayer:textLayer];
        [_textLayers addObject:textLayer];
        index += characterRange.length;
    }
    
}

/**
 *  实例textLayer对象
 *
 *  @param frame            frame
 *  @param attributedString attributedString
 *  @param glyphRange       字形的范围
 *  @param opacity          透明度
 */
- (CATextLayer *)textLayerWithFrame:(CGRect)frame attributedString:(NSAttributedString *)attributedString glyphRange:(NSRange)glyphRange opacity:(CGFloat)opacity
{
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    textLayer.frame   = frame;
    textLayer.string  = [attributedString attributedSubstringFromRange:glyphRange];
    textLayer.opacity = opacity;
    return textLayer;
}



























@end
