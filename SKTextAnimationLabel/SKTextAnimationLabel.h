//
//  SKTextAnimationLabel.h
//  SKTextAnimation
//
//  Created by nachuan on 16/7/25.
//  Copyright © 2016年 nachuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKLayerAnimation.h"
@interface SKTextAnimationLabel : UIView

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSTextStorage *textStorage;

@property (nonatomic, strong) NSTextContainer *textContainer;

@property (nonatomic, strong) NSLayoutManager *layoutManager;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, assign) NSUInteger numberOfLines;

@property (nonatomic, assign) NSLineBreakMode lineBreakMode;

/**
 *  渐出动画
 */
@property (nonatomic, copy) textAnimation animationOut;

/**
 *  渐入动画
 */
@property (nonatomic, copy) textAnimation animationIn;

@end
