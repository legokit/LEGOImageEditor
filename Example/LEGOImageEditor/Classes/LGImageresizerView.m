
//
//  LGImageresizerView.m
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/17.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LGImageresizerView.h"
#import "LGImageresizerFrameView.h"

@interface LGImageresizerView () <UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) LGImageresizerFrameView *frameView;
@property (nonatomic, strong) NSMutableArray *allDirections;

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, assign) CGRect maskRect;
@end

@implementation LGImageresizerView {
    CGSize _contentSize;
    UIViewAnimationOptions _animationOption;
}

#pragma mark - setter/getter
- (void)setBgColor:(UIColor *)bgColor {
    if (bgColor == [UIColor clearColor]) bgColor = [UIColor blackColor];
    self.backgroundColor = bgColor;
    if (_frameView) [_frameView setFillColor:bgColor];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    self.frameView.strokeColor = strokeColor;
}

- (void)setResizeImage:(UIImage *)resizeImage {
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

- (UIImage *)resizeImage {
    return _imageView.image;
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
    LGImageresizerView *imageresizerView = [[self.class alloc] initWithResizeImage:configure.resizeImage
                                                                             frame:configure.viewFrame
                                                                         fillColor:configure.fillColor
                                                                       strokeColor:configure.strokeColor
                                                                     resizeWHScale:configure.resizeWHScale];
    return imageresizerView;
}

- (instancetype)initWithResizeImage:(UIImage *)resizeImage
                              frame:(CGRect)frame
                          fillColor:(UIColor *)fillColor
                        strokeColor:(UIColor *)strokeColor
                      resizeWHScale:(CGFloat)resizeWHScale {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = fillColor;
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        _contentSize = CGSizeMake(width, height);
        _maskRect = CGRectZero;
        [self setupBase];
        [self setupScorllView];
        [self setupImageViewWithImage:resizeImage];
        [self setupFrameViewWithFillColor:fillColor
                              strokeColor:strokeColor
                            resizeWHScale:resizeWHScale];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;
        shapeLayer.lineWidth = 0;
        shapeLayer.fillRule = kCAFillRuleEvenOdd;
        shapeLayer.fillColor = fillColor.CGColor;
        [self.layer addSublayer:shapeLayer];
        self.bgLayer = shapeLayer;
    }
    return self;
}

- (void)setupBase {
    self.clipsToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
    self.allDirections = [@[@(LGImageresizerVerticalUpDirection),
                            @(LGImageresizerHorizontalLeftDirection),
                            @(LGImageresizerVerticalDownDirection),
                            @(LGImageresizerHorizontalRightDirection)] mutableCopy];
}

- (void)setupScorllView {
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
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupImageViewWithImage:(UIImage *)image {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat maxW = width;
    CGFloat maxH = height;
    CGFloat whScale = image.size.width / image.size.height;
    CGFloat w = maxW;
    CGFloat h = w / whScale;
    if (h > maxH) {
        h = maxH;
        w = h * whScale;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, w, h);
    imageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    CGFloat verticalInset = (self.scrollView.bounds.size.height - h) * 0.5;
    CGFloat horizontalInset = (self.scrollView.bounds.size.width - w) * 0.5;
    self.scrollView.contentSize = imageView.bounds.size;
    self.scrollView.contentInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
    self.scrollView.contentOffset = CGPointMake(-horizontalInset, -verticalInset);
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
    [self addSubview:frameView];
    self.frameView = frameView;
}

#pragma mark - 更新布局
- (void)updateSubviewLayouts {
    [self setupBgLayerPathDismiss];
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
    [self setupBgLayerPathDismiss];
    self.directionIndex = 0;
    CGFloat x = (_contentSize.width - self.scrollView.bounds.size.width) * 0.5;
    CGFloat y = (_contentSize.height - self.scrollView.bounds.size.height) * 0.5;
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = x;
    frame.origin.y = y;
    
    // 做3d旋转时会遮盖住上层的控件，设置为-400即可
    self.layer.zPosition = -400;
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
    CGRect maskRect = [self convertRect:self.frameView.imageresizerFrame fromView:self.frameView];
    NSLog(@"maskRect=%@",[NSValue valueWithCGRect:maskRect]);
    
    [self setupBgLayerPathShowWithRect:maskRect completion:^{
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
        [UIView animateWithDuration:duration delay:0 options:_animationOption animations:^{
            self.scrollView.layer.transform = svTransform;
            self.frameView.layer.transform = fvTransform;
            [self.frameView rotationWithDirection:direction rotationDuration:duration];
        } completion:nil];
    }];
}

#pragma mark - 修改比例
- (void)setResizeWHScale:(CGFloat)resizeWHScale {
    [self setResizeWHScale:resizeWHScale animated:NO];
}
- (void)setResizeWHScale:(CGFloat)resizeWHScale animated:(BOOL)isAnimated {
    [self setupBgLayerPathDismiss];
    [self.frameView setResizeWHScale:resizeWHScale animated:isAnimated];
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

- (void)setupBgLayerPathDismiss {
    self.bgLayer.hidden = YES;
}

- (void)setupBgLayerPathShowWithRect:(CGRect)maskRect completion: (void (^)(void))completion {
    self.bgLayer.hidden = NO;
    if (fabs(maskRect.origin.x - self.maskRect.origin.x) < 1 &&
        fabs(maskRect.origin.y - self.maskRect.origin.y) < 1 &&
        fabs(maskRect.size.width - self.maskRect.size.width) < 1 &&
        fabs(maskRect.size.height - self.maskRect.size.height) < 1) {
        !completion ? :completion();
    }
    else {
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithRect:self.bounds];
        UIBezierPath *framePath = [UIBezierPath bezierPathWithRect:maskRect];
        [bgPath appendPath:framePath];
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.bgLayer.path = bgPath.CGPath;
        [CATransaction commit];
        [CATransaction setCompletionBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                !completion ? :completion();
            });
        }];
    }
    self.maskRect = maskRect;
}

@end