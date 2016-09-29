//
//  ViewController.m
//  TransitioningAnimationDemo1
//
//  Created by JiongXing on 16/9/29.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import "ViewController.h"
#import "PictureBroswerViewController.h"
#import "PictureBroswerTransitionAnimator.h"

@interface ViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) UIImageView *selectedView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat margin = 30;
    CGFloat size = (CGRectGetWidth(self.view.frame) - margin * 3) / 2.0;
    for (NSInteger row = 0; row < 2; row ++) {
        for (NSInteger col = 0; col < 2; col ++) {
            UIImageView *view = [self generateImageView];
            view.frame = CGRectMake(margin + col * (size + margin),
                                    margin + row * (size + margin) + 64,
                                    size,
                                    size);
            [self.view addSubview:view];
        }
    }
}

- (UIImageView *)generateImageView {
    UIImageView *view = [[UIImageView alloc] init];
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
    view.image = [self generateImageWithColor:color];
    
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTap:)];
    [view addGestureRecognizer:tap];
    
    return view;
}

- (UIImage*)generateImageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)onImageViewTap:(UITapGestureRecognizer *)tap {
    self.selectedView = (UIImageView *)tap.view;
    
    PictureBroswerViewController *vc = [[PictureBroswerViewController alloc] init];
    vc.image = [self.selectedView image];
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [self generateAnimatorWithPresenting:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self generateAnimatorWithPresenting:NO];
}

- (PictureBroswerTransitionAnimator *)generateAnimatorWithPresenting:(BOOL)presenting {
    PictureBroswerTransitionAnimator *animator = [[PictureBroswerTransitionAnimator alloc] init];
    animator.presenting = presenting;
    animator.originFrame = [self.selectedView.superview convertRect:self.selectedView.frame toView:nil];
    return animator;
}


@end
