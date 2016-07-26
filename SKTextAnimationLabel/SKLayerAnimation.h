//
//  SKLayerAnimation.h
//  SKTextAnimation
//
//  Created by nachuan on 16/7/22.
//  Copyright © 2016年 nachuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  完成动画回调
 */
typedef void(^completion)(BOOL finished);

/**
 *  动画作用的layer
 *
 *  @param layer 动画作用前的layer
 *
 *  @return 动画作用后的新属性的layer
 */
typedef CALayer *(^effectAnimatableLayer)(CALayer *layer);


@interface SKLayerAnimation : NSObject

/**
 *  为layer添加动画
 *
 *  @param layer           需要添加动画的layer
 *  @param duration        动画时长
 *  @param delay           动画延时
 *  @param effectAnimation 动画作用layer后新的layer属性
 *  @param completion      动画结束回调
 */
+ (void)layerAnimation:(CALayer *)layer durationTime:(CGFloat)duration delayTime:(CGFloat)delay animation:(effectAnimatableLayer)effectAnimation completion:(completion)completion;

@end
