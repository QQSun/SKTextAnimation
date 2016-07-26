//
//  SKTextAnimationLabel.h
//  SKTextAnimation
//
//  Created by nachuan on 16/7/25.
//  Copyright © 2016年 nachuan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  textLayer动画
 */
typedef void(^textLayerAnimation)(void);

@interface SKTextAnimationLabel : UIView

/** NSMutableAttributedString的子类，持有文字内容，当字符发生改变时，通知NSLayoutManager对象 */
@property (nonatomic, strong) NSTextStorage *textStorage;

/** 从NSTextStorage里获取文字内容后，转换成对应的 glyph，根据NSTextContainer的 visible Region 显示 glyph */
@property (nonatomic, strong) NSTextContainer *textContainer;

/** 确定一个 region 来放置 text。这个 region 被NSLayoutManager用来决定哪里可以 break lines */
@property (nonatomic, strong) NSLayoutManager *layoutManager;

/** 文本 */
@property (nonatomic, strong) NSString *text;

/** 字体 */
@property (nonatomic, strong) UIFont *font;

/** 文本颜色 */
@property (nonatomic, strong) UIColor *textColor;

/** 文本对齐方式 */
@property (nonatomic, assign) NSTextAlignment textAlignment;

/** 显示行数 */
@property (nonatomic, assign) NSUInteger numberOfLines;

/** 截断方式.建议用默认 */
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;

/** 渐出动画结束后回调 */
@property (nonatomic, copy) textLayerAnimation animationOut;

/** 渐入动画结束后回调 */
@property (nonatomic, copy) textLayerAnimation animationIn;

@end
