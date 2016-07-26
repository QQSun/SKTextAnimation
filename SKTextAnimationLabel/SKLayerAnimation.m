//
//  SKLayerAnimation.m
//  SKTextAnimation
//
//  Created by nachuan on 16/7/22.
//  Copyright © 2016年 nachuan. All rights reserved.
//

#import "SKLayerAnimation.h"

@interface SKLayerAnimation ()

@property (nonatomic, copy) completion completion;
@property (nonatomic, strong) CALayer *textLayer;

@end

static NSString *kTextAnimationGroupKey = @"textAnimationGroupKey";

@implementation SKLayerAnimation

+ (void)textLayerAnimation:(CALayer *)layer durationTime:(CGFloat)duration delayTime:(CGFloat)delay animation:(effectAnimatableLayer)effectAnimation completion:(completion)completion
{
    SKLayerAnimation *layerAnimation = [[SKLayerAnimation alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CALayer *olderLayer = [layerAnimation animatableLayerCopy:layer];
        CALayer *newLayer = nil;
        CAAnimationGroup *animationGroup = nil;
        layerAnimation.completion = completion;
        
        if (effectAnimation) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            newLayer = effectAnimation(layer);
            [CATransaction commit];
        }
        animationGroup = [layerAnimation groupAnimationWithLayerChanges:olderLayer new:newLayer];
        if (animationGroup) {
            layerAnimation.textLayer = layer;
            animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animationGroup.beginTime = CACurrentMediaTime();
            animationGroup.duration = duration;
            animationGroup.delegate = layerAnimation;
            [layer addAnimation:animationGroup forKey:kTextAnimationGroupKey];
        }else{
            if (completion) {
                completion(YES);
            }
        }
        
    });
}

- (CALayer *)animatableLayerCopy:(CALayer *)layer
{
    CALayer *layerCopy = [[CALayer alloc] init];
    layerCopy.opacity = layer.opacity;
    layerCopy.bounds = layer.bounds;
    layerCopy.transform = layer.transform;
    layerCopy.position = layer.position;
    return layerCopy;
}

- (CAAnimationGroup *)groupAnimationWithLayerChanges:(CALayer *)oldLayer new:(CALayer*)newLayer
{
    CAAnimationGroup *animationGroup = nil;
    NSMutableArray <CABasicAnimation *>*animations = [NSMutableArray array];;
    if (!CGPointEqualToPoint(oldLayer.position, newLayer.position)) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.fromValue = [NSValue valueWithCGPoint:oldLayer.position];
        basicAnimation.toValue = [NSValue valueWithCGPoint:newLayer.position];
        basicAnimation.keyPath = @"position";
        [animations addObject:basicAnimation];
    }
    
    if (!CATransform3DEqualToTransform(oldLayer.transform, newLayer.transform)) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        basicAnimation.fromValue = [NSValue valueWithCATransform3D:oldLayer.transform];
        basicAnimation.toValue = [NSValue valueWithCATransform3D:newLayer.transform];
        [animations addObject:basicAnimation];
    }
    
    if (!CGRectEqualToRect(oldLayer.frame, newLayer.frame)) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"frame"];
        basicAnimation.fromValue = [NSValue valueWithCGRect:oldLayer.bounds];
        basicAnimation.toValue = [NSValue valueWithCGRect:newLayer.bounds];
        [animations addObject:basicAnimation];
    }
    
#warning 第二个参数可能是oldLayer.bounds
    if (!CGRectEqualToRect(oldLayer.bounds, oldLayer.bounds)) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        basicAnimation.fromValue = [NSValue valueWithCGRect:oldLayer.bounds];
        basicAnimation.toValue = [NSValue valueWithCGRect:newLayer.bounds];
        [animations addObject:basicAnimation];
    }
    
    if (oldLayer.opacity != newLayer.opacity) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        basicAnimation.fromValue = @(oldLayer.opacity);
        basicAnimation.toValue = @(newLayer.opacity);
        [animations addObject:basicAnimation];
    }
    
    if (animations.count > 0) {
        animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = animations;
    }
    return animationGroup;
    
}

#pragma mark - animationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.completion) {
        [self.textLayer removeAnimationForKey:kTextAnimationGroupKey];
        self.completion(flag);
    }
}






























@end
