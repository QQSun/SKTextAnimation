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
 *  动画回调
 */
typedef void(^textAnimation)(void);

/**
 *  完成动画回调
 */
typedef void(^completion)(BOOL finished);

/**
 *  动画作用的layer
 */
typedef CALayer *(^effectAnimatableLayer)(CALayer *layer);


@interface SKLayerAnimation : NSObject

+ (void)textLayerAnimation:(CALayer *)layer durationTime:(CGFloat)duration delayTime:(CGFloat)delay animation:(effectAnimatableLayer)effectAnimation completion:(completion)completion;

@end
