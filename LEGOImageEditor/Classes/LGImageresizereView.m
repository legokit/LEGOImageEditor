
//
//  LGImageresizerView.m
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/17.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LGImageresizereView.h"
#import "LGImageresizerFrameView.h"

@interface LGImageresizereView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) LGImageresizerFrameView *frameView;
@property (nonatomic, strong) NSMutableArray *allDirections;

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, assign) CGRect maskRect;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@end

@implementation LGImageresizereView {
    CGSize _contentSize;
    UIViewAnimationOptions _animationOption;
}

#pragma mark - setter/getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            CGFloat h = _contentSize.height;
            CGFloat w = h * h / _contentSize.width;
            CGFloat x = (self.bounds.size.width - w) * 0.5;
            CGFloat y = 0;
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.frame = CGRectMake(x, y, w, h);
            scrollView.delegate = self;
            scrollView.minimumZoomScale = 1.0;
            scrollView.maximumZoomScale = MAXFLOAT;
            scrollView.alwaysBounceVertical = YES;
            scrollView.alwaysBounceHorizontal = YES;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.autoresizingMask = UIViewAutoresizingNone;
            scrollView.clipsToBounds = NO;
            if (@available(iOS 11.0, *)) scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
            scrollView;
        });
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = ({
            CGFloat width = self.frame.size.width;
            CGFloat height = self.frame.size.height;
            CGFloat maxW = width;
            CGFloat maxH = height;
            CGFloat whScale = self.resizeImage.size.width / self.resizeImage.size.height;
            CGFloat w = maxW;
            CGFloat h = w / whScale;
            if (h > maxH) {
                h = maxH;
                w = h * whScale;
            }
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.resizeImage];
            imageView.frame = CGRectMake(0, 0, w, h);
            imageView.userInteractionEnabled = YES;
            
            imageView;
        });
    }
    return _imageView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.userInteractionEnabled = NO;
        _shadowView.layer.shadowOffset = CGSizeMake(0,0);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius = 2;
        _shadowView.layer.borderWidth = 3;
    }
    return _shadowView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
    }
    return _rightView;
}

- (void)setBgColor:(UIColor *)bgColor {
    if (bgColor == [UIColor clearColor]) bgColor = [UIColor blackColor];
    self.backgroundColor = bgColor;
    if (_frameView) [_frameView setFillColor:bgColor];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    self.frameView.strokeColor = strokeColor;
}

- (void)setResizeImage:(UIImage *)resizeImage {
    _resizeImage = resizeImage;
    self.imageView.image = resizeImage;
    [self updateSubviewLayouts];
}

- (void)setIsClockwiseRotation:(BOOL)isClockwiseRotation {
    if (_isClockwiseRotation == isClockwiseRotation) return;
    _isClockwiseRotation = isClockwiseRotation;
    [self.allDirections exchangeObjectAtIndex:1 withObjectAtIndex:3];
    if (self.directionIndex == 1) {
        self.directionIndex = 3;
    } else if (self.directionIndex == 3) {
        self.directionIndex = 1;
    }
}

- (UIColor *)strokeColor {
    return _frameView.strokeColor;
}

- (CGFloat)resizeWHScale {
    return _frameView.resizeWHScale;
}

- (BOOL)isCanRotation {
    return _frameView.isCanRotation;
}

- (BOOL)isCanResizeWHScale {
    return _frameView.isCanResizeWHScale;
}

#pragma mark - init
+ (instancetype)imageresizerViewWithConfigure:(LGImageresizerConfigure *)configure {
    LGImageresizereView *imageresizerView = [[self.class alloc] initWithResizeImage:configure.resizeImage
                                                                              frame:configure.viewFrame
                                                                          fillColor:configure.fillColor
                                                                        strokeColor:configure.strokeColor
                                                                        borderColor:configure.borderColor
                                                                      resizeWHScale:0];
    return imageresizerView;
}

- (instancetype)initWithResizeImage:(UIImage *)resizeImage
                              frame:(CGRect)frame
                          fillColor:(UIColor *)fillColor
                        strokeColor:(UIColor *)strokeColor
                        borderColor:(UIColor *)borderColor
                      resizeWHScale:(CGFloat)resizeWHScale {
    if (self = [super initWithFrame:frame]) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        _contentSize = CGSizeMake(width, height);
        _maskRect = CGRectZero;
        _resizeImage = resizeImage;
        self.clipsToBounds = YES;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.allDirections = [@[@(LGImageresizerVerticalUpDirection),
                                @(LGImageresizerHorizontalLeftDirection),
                                @(LGImageresizerVerticalDownDirection),
                                @(LGImageresizerHorizontalRightDirection)] mutableCopy];
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        
        CGFloat verticalInset = (self.scrollView.bounds.size.height - self.imageView.frame.size.height) * 0.5;
        CGFloat horizontalInset = (self.scrollView.bounds.size.width - self.imageView.frame.size.width) * 0.5;
        self.scrollView.contentSize = self.imageView.bounds.size;
        self.scrollView.contentInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
        self.scrollView.contentOffset = CGPointMake(-horizontalInset, -verticalInset);
        
        [self setupFrameViewWithFillColor:fillColor
                              strokeColor:strokeColor
                            resizeWHScale:resizeWHScale];
        
        //        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        //        shapeLayer.frame = self.bounds;
        //        shapeLayer.lineWidth = 0;
        //        shapeLayer.fillRule = kCAFillRuleEvenOdd;
        //        shapeLayer.fillColor = fillColor.CGColor;
        //        [self.layer addSublayer:shapeLayer];
        //        self.bgLayer = shapeLayer;
        
        [self addSubview:self.shadowView];
        self.shadowView.layer.shadowColor = borderColor.CGColor;
        self.shadowView.layer.borderColor = borderColor.CGColor;
        
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
        self.topView.backgroundColor = fillColor;
        self.bottomView.backgroundColor = fillColor;
        self.leftView.backgroundColor = fillColor;
        self.rightView.backgroundColor = fillColor;
    }
    return self;
}

- (void)setupFrameViewWithFillColor:(UIColor *)fillColor
                        strokeColor:(UIColor *)strokeColor
                      resizeWHScale:(CGFloat)resizeWHScale {
    LGImageresizerFrameView *frameView =
    [[LGImageresizerFrameView alloc] initWithFrame:self.scrollView.frame
                                       contentSize:_contentSize
                                         fillColor:fillColor
                                       strokeColor:strokeColor
                                     resizeWHScale:resizeWHScale
                                        scrollView:self.scrollView
                                         imageView:self.imageView];
    __weak typeof(self)weakSelf = self;
    frameView.imageresizerFrameChange = ^(CGRect imageresizerFrame) {
        [weakSelf imageresizerFrameChange:imageresizerFrame];
    };
    [self addSubview:frameView];
    self.frameView = frameView;
}

#pragma mark - 更新遮罩层
- (void)imageresizerFrameChange:(CGRect)imageresizerFrame {
    CGRect maskRect = [self convertRect:imageresizerFrame fromView:self.frameView];
    
    //    UIBezierPath *bgPath = [UIBezierPath bezierPathWithRect:self.bounds];
    //    UIBezierPath *framePath = [UIBezierPath bezierPathWithRect:maskRect];
    //    [bgPath appendPath:framePath];
    //
    //    [CATransaction begin];
    //    [CATransaction setDisableActions:YES];
    //    self.bgLayer.path = bgPath.CGPath;
    //    [CATransaction commit];
    //    [CATransaction setCompletionBlock:^{
    //
    //    }];
    
    [UIView animateWithDuration:0.035 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.shadowView.frame = maskRect;
        self.topView.frame = CGRectMake(0, 0, self.bounds.size.width, CGRectGetMinY(maskRect));
        self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(maskRect), self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(maskRect));
        self.leftView.frame = CGRectMake(0, 0, CGRectGetMinX(maskRect), self.bounds.size.height);
        self.rightView.frame = CGRectMake(CGRectGetMaxX(maskRect), 0, self.bounds.size.width - CGRectGetMaxX(maskRect), self.bounds.size.height);
    } completion:nil];
    
    self.maskRect = maskRect;
}

#pragma mark - 更新布局
- (void)updateSubviewLayouts {
    self.directionIndex = 0;
    self.scrollView.layer.transform = CATransform3DIdentity;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    
    CGFloat maxW = self.frame.size.width;
    CGFloat maxH = self.frame.size.height;
    CGFloat whScale = self.imageView.image.size.width / self.imageView.image.size.height;
    CGFloat w = maxW;
    CGFloat h = w / whScale;
    if (h > maxH) {
        h = maxH;
        w = h * whScale;
    }
    self.imageView.frame = CGRectMake(0, 0, w, h);
    
    CGFloat verticalInset = (self.scrollView.bounds.size.height - h) * 0.5;
    CGFloat horizontalInset = (self.scrollView.bounds.size.width - w) * 0.5;
    
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.contentInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
    self.scrollView.contentOffset = CGPointMake(-horizontalInset, -verticalInset);
}

#pragma mark - 重置
- (void)recovery {
    self.directionIndex = 0;
    CGFloat x = (_contentSize.width - self.scrollView.bounds.size.width) * 0.5;
    CGFloat y = (_contentSize.height - self.scrollView.bounds.size.height) * 0.5;
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = x;
    frame.origin.y = y;
    
    self.layer.zPosition = -400;    // 做3d旋转时会遮盖住上层的控件，设置为负数
    NSTimeInterval duration = 0.25;
    [UIView animateWithDuration:duration delay:0 options:_animationOption animations:^{
        
        self.layer.transform = CATransform3DIdentity;
        self.scrollView.layer.transform = CATransform3DIdentity;
        self.frameView.layer.transform = CATransform3DIdentity;
        
        self.scrollView.frame = frame;
        self.frameView.frame = frame;
        
        [self.frameView recovery];
        
    } completion:^(BOOL finished) {
        self.layer.zPosition = 0;
    }];
}

#pragma mark - 旋转
- (void)rotation {
    self.directionIndex += 1;
    if (self.directionIndex > self.allDirections.count - 1) self.directionIndex = 0;
    
    LGImageresizerRotationDirection direction = [self.allDirections[self.directionIndex] integerValue];
    
    CGFloat scale = 1;
    if (direction == LGImageresizerHorizontalLeftDirection ||
        direction == LGImageresizerHorizontalRightDirection) {
        scale = self.frame.size.width / self.scrollView.bounds.size.height;
    } else {
        scale = self.scrollView.bounds.size.height / self.frame.size.width;
    }
    
    CGFloat angle = (self.isClockwiseRotation ? 1.0 : -1.0) * M_PI * 0.5;
    
    CATransform3D svTransform = self.scrollView.layer.transform;
    svTransform = CATransform3DScale(svTransform, scale, scale, 1);
    svTransform = CATransform3DRotate(svTransform, angle, 0, 0, 1);
    
    CATransform3D fvTransform = self.frameView.layer.transform;
    fvTransform = CATransform3DScale(fvTransform, scale, scale, 1);
    fvTransform = CATransform3DRotate(fvTransform, angle, 0, 0, 1);
    
    NSTimeInterval duration = 0.23;
    self.scrollView.maximumZoomScale = MAXFLOAT;
    [UIView animateWithDuration:duration delay:0 options:_animationOption animations:^{
        self.scrollView.layer.transform = svTransform;
        self.frameView.layer.transform = fvTransform;
        [self.frameView rotationWithDirection:direction rotationDuration:duration];
    } completion:^(BOOL finished) {
        if (finished) {
            [self setMaximumScalingRatio];
        }
    }];
}

- (void)setMinZoomScale:(CGFloat)minZoomScale {
    _minZoomScale = minZoomScale;
    self.frameView.minZoomScale = minZoomScale;
    self.scrollView.maximumZoomScale = MAXFLOAT;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setMaximumScalingRatio];
    });
}

- (void)setMaximumScalingRatio {
    CGFloat maxZoomScale = [self.frameView getCurrMaxmumZoomScale];
    if (maxZoomScale > self.scrollView.minimumZoomScale) {
        self.scrollView.maximumZoomScale = maxZoomScale;
    }
    else {
        self.scrollView.maximumZoomScale = MAXFLOAT;
    }
}
- (void)setMaxZoomScale:(CGFloat)maxZoomScale {
    _maxZoomScale = maxZoomScale;
    self.frameView.maxZoomScale = maxZoomScale;
}

#pragma mark - 修改比例
- (void)setResizeWHScale:(CGFloat)resizeWHScale {
    [self setResizeWHScale:resizeWHScale animated:NO];
}
- (void)setResizeWHScale:(CGFloat)resizeWHScale animated:(BOOL)isAnimated {
    self.scrollView.maximumZoomScale = MAXFLOAT;
    [self.frameView setResizeWHScale:resizeWHScale animated:isAnimated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setMaximumScalingRatio];
    });
}

#pragma mark - 截图
- (void)originImageresizerWithComplete:(void (^)(UIImage *))complete {
    [self imageresizerWithComplete:complete isOriginImageSize:YES referenceWidth:0];
}

- (void)imageresizerWithComplete:(void (^)(UIImage *))complete referenceWidth:(CGFloat)referenceWidth {
    [self imageresizerWithComplete:complete isOriginImageSize:NO referenceWidth:referenceWidth];
}

- (void)imageresizerWithComplete:(void (^)(UIImage *))complete {
    [self imageresizerWithComplete:complete isOriginImageSize:NO referenceWidth:0];
}

- (void)imageresizerWithComplete:(void (^)(UIImage *))complete isOriginImageSize:(BOOL)isOriginImageSize referenceWidth:(CGFloat)referenceWidth {
    [self.frameView imageresizerWithComplete:complete isOriginImageSize:isOriginImageSize referenceWidth:referenceWidth];
}

#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    !self.zoom ? :self.zoom(scale);
}



@end
