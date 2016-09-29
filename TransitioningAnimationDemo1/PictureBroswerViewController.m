//
//  PictureBroswerViewController.m
//  TransitioningAnimationDemo
//
//  Created by JiongXing on 16/9/28.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import "PictureBroswerViewController.h"

@interface PictureBroswerViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PictureBroswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.imageView.image = self.image;
    self.imageView.frame = self.view.bounds;
    [self.view addSubview:self.imageView];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTap:)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (void)onImageViewTap:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
