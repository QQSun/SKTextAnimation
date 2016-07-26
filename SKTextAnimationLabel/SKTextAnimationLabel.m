//
//  SKTextAnimationLabel.m
//  SKTextAnimation
//
//  Created by nachuan on 16/7/25.
//  Copyright © 2016年 nachuan. All rights reserved.
//

#import "SKTextAnimationLabel.h"
@interface SKTextAnimationLabel () <NSLayoutManagerDelegate>

/** 用于存储文字的每个textLayer */
@property (nonatomic, strong) NSMutableArray *characterTextLayers;

@property (nonatomic, strong) NSMutableArray *oldCharacterTextLayers;

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

- (void)setup
{
    _textColor = [UIColor blackColor];
    _font = [UIFont systemFontOfSize:14];
    _textAlignment = NSTextAlignmentCenter;
    _numberOfLines = 1;
    _lineBreakMode = NSLineBreakByCharWrapping;
    
    _textStorage = [[NSTextStorage alloc] init];
    
    _textContainer = [[NSTextContainer alloc] init];
    _textContainer.size = self.bounds.size;
    _textContainer.maximumNumberOfLines = _numberOfLines;
    _textContainer.lineBreakMode = _lineBreakMode;
    
    _layoutManager = [[NSLayoutManager alloc] init];
    _layoutManager.delegate = self;
    
    [_textStorage addLayoutManager:_layoutManager];
    [_layoutManager addTextContainer:_textContainer];
    
    
    _characterTextLayers = [[NSMutableArray alloc] init];
    _oldCharacterTextLayers = [[NSMutableArray alloc] init];
}

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

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [self cleanOutOldCharacterTextLayers];
    [_oldCharacterTextLayers addObjectsFromArray:_characterTextLayers];
    [_textStorage setAttributedString:attributedText];
    [self startAnimation:^{}];
    [self endAnimation:nil];
    
}

- (void)cleanOutOldCharacterTextLayers
{
    for (CATextLayer *textLayer in _oldCharacterTextLayers) {
        [textLayer removeFromSuperlayer];
    }
    [_oldCharacterTextLayers removeAllObjects];
}


- (void)startAnimation:(textAnimation)textAnimation
{
    NSInteger animationDuration = 0.0;
    NSInteger animationIndex = -1;
    NSInteger index = 0;
    
    for (CATextLayer *textLayer in _oldCharacterTextLayers) {
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
        
        [SKLayerAnimation textLayerAnimation:textLayer durationTime:duration delayTime:delay animation:^CALayer *(CALayer *layer) {
            layer.transform = transform;
            layer.opacity = 0.0;
            return layer;
        } completion:^(BOOL finished) {
            [textLayer removeFromSuperlayer];
            if (_oldCharacterTextLayers.count > animationIndex && textLayer == _oldCharacterTextLayers[animationIndex]) {
                if (_animationOut) {
                    _animationOut();
                }
            }
        }];
        ++index;
    }
}

- (void)endAnimation:(textAnimation)textAnimation
{
    for (CATextLayer *textLayer in _characterTextLayers) {
        CGFloat duration = arc4random_uniform(200) / 100 + 0.25;
        CGFloat delay = 0.06;
        [SKLayerAnimation textLayerAnimation:textLayer durationTime:duration delayTime:delay animation:^CALayer *(CALayer *layer) {
            layer.opacity = 1.0;
            return layer;
        } completion:^(BOOL finished) {
            if (_animationIn) {
                _animationIn();
            }
        }];
    }
}


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

- (void)layoutManager:(NSLayoutManager *)layoutManager textContainer:(NSTextContainer *)textContainer didChangeGeometryFromSize:(CGSize)oldSize
{
    
}

- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag
{
    [self calculateTextLayer];
}

/**
 *  计算每个textLayer的rect
 */
- (void)calculateTextLayer
{
    [_characterTextLayers removeAllObjects];
    NSAttributedString *attributedString = [self getAttributedTextWithString:_textStorage.string];
    NSString *text        = _textStorage.string;
    NSRange textRange     = NSMakeRange(0, text.length);
    CGRect layoutRect     = [_layoutManager usedRectForTextContainer:_textContainer];
    NSInteger index       = textRange.location;
    NSInteger totalLength = NSMaxRange(textRange);
    
    while (index < totalLength) {
        NSRange glyphRange             = NSMakeRange(index, 1);
        NSRange characterRange         = [_layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:nil];
        NSTextContainer *textContainer = [_layoutManager textContainerForGlyphAtIndex:index effectiveRange:nil];
        CGRect glyphRect               = [_layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
        
        if (self.numberOfLines != 0 && (glyphRect.origin.y / glyphRect.size.height >= self.numberOfLines)) {
            return;
        }else if (glyphRect.origin.y + glyphRect.size.height > self.bounds.size.height){
            return;
        }
        
        NSRange kerningRange = [_layoutManager rangeOfNominallySpacedGlyphsContainingIndex:index];
        if (kerningRange.location == index && kerningRange.length > 1) {
            if (_characterTextLayers.count > 0) {
                CATextLayer *previousLayer = _characterTextLayers[_characterTextLayers.count - 1];
                CGRect frame        = previousLayer.frame;
                frame.size.width   += CGRectGetMaxX(glyphRect) - CGRectGetMaxX(frame);
                previousLayer.frame = frame;
            }
        }
        
        if (_numberOfLines == 0) {
            glyphRect.origin.y += (self.bounds.size.height - layoutRect.size.height) / 2.0;
        }else{
            glyphRect.origin.y += (self.bounds.size.height - glyphRect.size.height * _numberOfLines) / 2.0;
        }
        
        CATextLayer *textLayer = [[CATextLayer alloc] init];
        textLayer.frame   = glyphRect;
        textLayer.string  = [attributedString attributedSubstringFromRange:glyphRange];
        textLayer.opacity = 0.0;
        [self.layer addSublayer:textLayer];
        [_characterTextLayers addObject:textLayer];
        index += characterRange.length;
    }
    
}





























@end
