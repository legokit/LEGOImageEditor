

//
//  UISliderControl.m
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/23.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "UISliderControl.h"
#import <Masonry/Masonry.h>

@interface UISliderControl ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *scaleImageView;
@property (nonatomic, assign) BOOL finishLayout;
@property (nonatomic, assign) CGFloat halfScreenWidth;
@end
@implementation UISliderControl

- (instancetype)init {
    if (self = [super init]) {
        [self setSliderControl];
    }
    return self;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return _scrollView;
}

- (UIImageView *)scaleImageView {
    if (!_scaleImageView) {
        _scaleImageView = [[UIImageView alloc] init];
        _scaleImageView.image = [UIImage imageNamed:@"image_ssssss"];
    }
    return _scaleImageView;
}

- (void)setSliderControl {
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(15);
        make.height.mas_equalTo(30);
    }];
    [self.scrollView addSubview:self.scaleImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.halfScreenWidth = self.bounds.size.width / 2;
    if (!self.finishLayout) {
        [self.scaleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.offset(self.halfScreenWidth);
            make.right.offset(-self.halfScreenWidth);
            make.size.mas_equalTo(CGSizeMake(self.halfScreenWidth * 2, 30));
        }];
        
        self.scrollView.contentOffset = CGPointMake(self.halfScreenWidth, 0);
        self.finishLayout = YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(beginTrackingWithTouch)]) {
        [self.delegate beginTrackingWithTouch];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat total = self.maximumValue - self.minimumValue;
    if (!total) {
        return;
    }
    CGFloat ratio = self.scrollView.contentOffset.x / (self.halfScreenWidth * 2);
    //    if (fabs(ratio) <= 0.05 || fabs(ratio - 1) <= 0.05) {
    //        ratio = [[NSString stringWithFormat:@"%.3f",ratio] floatValue];
    //    }
    //    else {
    //        ratio = [[NSString stringWithFormat:@"%.3f",ratio] floatValue];
    //    }
    NSLog(@"ratio=%f",ratio);
    self.value = ratio * total + self.minimumValue;
    if (self.delegate && [self.delegate respondsToSelector:@selector(continueTrackingWithTouch:)]) {
        [self.delegate continueTrackingWithTouch:self.value];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(endTrackingWithTouch)]) {
        [self.delegate endTrackingWithTouch];
    }
}


//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    CGRect bounds = self.bounds;
//    bounds = CGRectMake(self.bounds.origin.x - 50, self.bounds.origin.y, self.bounds.size.width + 2 * 50, self.bounds.size.height);
//    return CGRectContainsPoint(bounds, point);
//}

//- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
//    CGPoint location = [touch locationInView:self];
//    if (CGRectContainsPoint(self.slider.frame, location)) {
//        self.touchEnble = YES;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(beginTrackingWithTouch)]) {
//            [self.delegate beginTrackingWithTouch];
//        }
//    }
//    else {
//        self.touchEnble = NO;
//    }
//    return YES;
//}
//
//- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
//    if (!self.touchEnble) return YES;
//    CGPoint location = [touch locationInView:self];
//    NSLog(@"continueTrackingWithTouch=%@",[NSValue valueWithCGPoint:location]);
//    CGFloat offset = location.x - self.bounds.size.width / 2.0;
//    if (offset < -self.bounds.size.width / 2.0) {
//        offset = -self.bounds.size.width / 2.0;
//    }
//    if (offset > self.bounds.size.width / 2.0) {
//        offset = self.bounds.size.width / 2.0;
//    }
//    [self.slider mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mas_centerX).offset(offset);
//    }];
//    CGFloat total = self.maximumValue - self.minimumValue;
//    CGFloat value = total / self.bounds.size.width * offset;
//    self.value = value;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(continueTrackingWithTouch:)]) {
//        [self.delegate continueTrackingWithTouch:value];
//    }
//    return YES;
//}
//
//- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
//    if (!self.touchEnble) return ;
//    CGPoint location = [touch locationInView:self];
//    NSLog(@"endTrackingWithTouch=%@",[NSValue valueWithCGPoint:location]);
//    if (self.delegate && [self.delegate respondsToSelector:@selector(endTrackingWithTouch)]) {
//        [self.delegate endTrackingWithTouch];
//    }
//}
//
//- (void)cancelTrackingWithEvent:(nullable UIEvent *)event {
//    NSLog(@"cancelTrackingWithEvent=%@",event);
//}
//
@end


@interface UISliderView ()

@property (nonatomic, strong) UIView *sign;
@end

@implementation UISliderView

- (instancetype)init {
    if (self = [super init]) {
        [self setSliderView];
    }
    return self;
}

- (UIView *)sign {
    if (!_sign) {
        _sign = [[UIView alloc] init];
        _sign.backgroundColor = [UIColor redColor];
    }
    return _sign;
}

- (void)setSliderView {
    [self addSubview:self.sign];
    [self.sign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 50));
        make.center.mas_equalTo(self);
    }];
}

@end
