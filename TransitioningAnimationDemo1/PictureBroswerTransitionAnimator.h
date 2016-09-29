//
//  PictureBroswerTransitionAnimator.h
//  TransitioningAnimationDemo
//
//  Created by JiongXing on 16/9/28.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

@import UIKit;

@interface PictureBroswerTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/// 动画时间
@property (nonatomic, assign) CGFloat duration;

/// 图片原位置
@property (nonatomic, assign) CGRect originFrame;

/// 展示或消失
@property (nonatomic, assign) BOOL presenting;

@end
