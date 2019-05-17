//
//  JPImageresizerFrameView.m
//  DesignSpaceRestructure
//
//  Created by 周健平 on 2017/12/11.
//  Copyright © 2017年 周健平. All rights reserved.
//

#import "JPImageresizerFrameView.h"
#import "UIImage+JPExtension.h"

/** keypath */
#define aKeyPath(objc, keyPath) @(((void)objc.keyPath, #keyPath))

typedef NS_ENUM(NSUInteger, JPLinePosition) {
    JPHorizontalLine,
    JPVerticalLine
};

@interface JPImageresizerFrameView ()
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) CAShapeLayer *bgLayer;

@property (nonatomic, strong) NSMutableArray <NSArray <CAShapeLayer *> *> *lines;

@property (nonatomic, assign) CGRect originImageFrame;
@property (nonatomic, assign) CGRect maxResizeFrame;
@property (nonatomic, assign) CGRect imageresizerFrame;

@property (nonatomic, assign) BOOL isCanRotation;
@property (nonatomic, assign) BOOL isCanResizeWHScale;


- (CGSize)imageresizerSize;
- (CGSize)imageViewSzie;
@end

@implementation JPImageresizerFrameView {
    CGFloat _baseImageW;
    CGFloat _baseImageH;
    CGSize _contentSize;
}

#pragma mark -setter / getter

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.bgLayer.fillColor = _fillColor.CGColor;
    [CATransaction commit];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    CGColorRef strokeCGColor = strokeColor.CGColor;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    for (NSArray *array in self.lines) {
        for (CAShapeLayer *line in array) {
            line.strokeColor = strokeCGColor;
        }
    }
    [CATransaction commit];
}

- (void)setImageresizerFrame:(CGRect)imageresizerFrame {
    _imageresizerFrame = imageresizerFrame;
 }

- (void)setResizeWHScale:(CGFloat)resizeWHScale {
    [self setResizeWHScale:resizeWHScale animated:NO];
}

- (CGSize)imageresizerSize {
    CGFloat w = ((NSInteger)(self.imageresizerFrame.size.width)) * 1.0;
    CGFloat h = ((NSInteger)(self.imageresizerFrame.size.height)) * 1.0;
    return CGSizeMake(w, h);
}

- (CGSize)imageViewSzie {
    CGFloat w = ((NSInteger)(self.imageView.frame.size.width)) * 1.0;
    CGFloat h = ((NSInteger)(self.imageView.frame.size.height)) * 1.0;
    if (self.rotationDirection == JPImageresizerVerticalUpDirection ||
        self.rotationDirection == JPImageresizerVerticalDownDirection) {
        return CGSizeMake(w, h);
    } else {
        return CGSizeMake(h, w);
    }
}

- (CGRect)baseImageresizerFrame {
    CGFloat w = 0;
    CGFloat h = 0;
    if (_baseImageW >= _baseImageH) {
        h = _baseImageH;
        w = h * _resizeWHScale;
        if (w > self.maxResizeFrame.size.width) {
            w = self.maxResizeFrame.size.width;
            h = w / _resizeWHScale;
        }
    } else {
        w = _baseImageW;
        h = w / _resizeWHScale;
        if (h > self.maxResizeFrame.size.height) {
            h = self.maxResizeFrame.size.height;
            w = h * _resizeWHScale;
        }
    }
    CGFloat x = self.maxResizeFrame.origin.x + (self.maxResizeFrame.size.width - w) * 0.5;
    CGFloat y = self.maxResizeFrame.origin.y + (self.maxResizeFrame.size.height - h) * 0.5;
    return CGRectMake(x, y, w, h);
}

- (CGRect)adjustResizeFrame {
    CGFloat resizeWHScale = _resizeWHScale;
    CGFloat adjustResizeW = 0;
    CGFloat adjustResizeH = 0;
    if (resizeWHScale >= 1) {
        adjustResizeW = self.maxResizeFrame.size.width;
        adjustResizeH = adjustResizeW / resizeWHScale;
        if (adjustResizeH > self.maxResizeFrame.size.height) {
            adjustResizeH = self.maxResizeFrame.size.height;
            adjustResizeW = self.maxResizeFrame.size.height * resizeWHScale;
        }
    } else {
        adjustResizeH = self.maxResizeFrame.size.height;
        adjustResizeW = adjustResizeH * resizeWHScale;
        if (adjustResizeW > self.maxResizeFrame.size.width) {
            adjustResizeW = self.maxResizeFrame.size.width;
            adjustResizeH = adjustResizeW / resizeWHScale;
        }
    }
    CGFloat adjustResizeX = self.maxResizeFrame.origin.x + (self.maxResizeFrame.size.width - adjustResizeW) * 0.5;
    CGFloat adjustResizeY = self.maxResizeFrame.origin.y + (self.maxResizeFrame.size.height - adjustResizeH) * 0.5;
    return CGRectMake(adjustResizeX, adjustResizeY, adjustResizeW, adjustResizeH);
}

- (UIEdgeInsets)scrollViewContentInsetWithAdjustResizeFrame:(CGRect)adjustResizeFrame {
    // scrollView宽高跟self一样，上下左右不需要额外添加Space
    CGFloat top = adjustResizeFrame.origin.y; // + veSpace?
    CGFloat bottom = self.bounds.size.height - CGRectGetMaxY(adjustResizeFrame); // + veSpace?
    CGFloat left = adjustResizeFrame.origin.x; // + hoSpace?
    CGFloat right = self.bounds.size.width - CGRectGetMaxX(adjustResizeFrame); // + hoSpace?
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGFloat)scrollViewMinZoomScaleWithResizeSize:(CGSize)size {
    CGFloat minZoomScale = 1;
    CGFloat w = size.width;
    CGFloat h = size.height;
    if (w >= h) {
        minZoomScale = w / self->_baseImageW;
        CGFloat imageH = self->_baseImageH * minZoomScale;
        CGFloat trueImageH = h;
        if (imageH < trueImageH) {
            minZoomScale *= (trueImageH / imageH);
        }
    } else {
        minZoomScale = h / self->_baseImageH;
        CGFloat imageW = self->_baseImageW * minZoomScale;
        CGFloat trueImageW = w;
        if (imageW < trueImageW) {
            minZoomScale *= (trueImageW / imageW);
        }
    }
    return minZoomScale;
}

- (CAShapeLayer *)createShapeLayer:(CGFloat)lineWidth {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    [self.layer addSublayer:shapeLayer];
    return shapeLayer;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
                  contentSize:(CGSize)contentSize
                    fillColor:(UIColor *)fillColor
                  strokeColor:(UIColor *)strokeColor
                resizeWHScale:(CGFloat)resizeWHScale
                   scrollView:(UIScrollView *)scrollView
                    imageView:(UIImageView *)imageView {
    
    if (self = [super initWithFrame:frame]) {
        self.scrollView = scrollView;
        self.imageView = imageView;

        _sizeScale = 1.0;
        _rotationDirection = JPImageresizerVerticalUpDirection;
        _contentSize = contentSize;
        
        _isCanRotation = YES;
        _isCanResizeWHScale = YES;
        
        self.bgLayer = [self createShapeLayer:0];
        
        self.lines = [[NSMutableArray alloc] init];
        NSMutableArray *horLines = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i++) {
            CAShapeLayer *line = [self createShapeLayer:1];
            [horLines addObject:line];
        }
        NSMutableArray *verLines = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i++) {
            CAShapeLayer *line = [self createShapeLayer:1];
            [verLines addObject:line];
        }
        [self.lines addObjectsFromArray:@[horLines,verLines]];

        self.fillColor = fillColor;
        self.strokeColor = strokeColor;
        self.resizeWHScale = resizeWHScale;
    }
    return self;
}

#pragma mark -更新页面
- (void)updateImageOriginFrameWithDirection:(JPImageresizerRotationDirection)rotationDirection {
    _baseImageW = self.imageView.bounds.size.width;
    _baseImageH = self.imageView.bounds.size.height;
    CGFloat x = (self.bounds.size.width - _baseImageW) * 0.5;
    CGFloat y = (self.bounds.size.height - _baseImageH) * 0.5;
    self.originImageFrame = CGRectMake(x, y, _baseImageW, _baseImageH);
    [self updateRotationDirection:rotationDirection];
    [self updateImageresizerFrame:[self baseImageresizerFrame]];
    [self updateImageresizerZoomWithAnimateDuration:0];
}

#pragma mark -重置
- (void)recovery {
    [self recoveryWithDirection:JPImageresizerVerticalUpDirection];
}

- (void)recoveryWithDirection:(JPImageresizerRotationDirection)direction {
    [self updateRotationDirection:direction];
    CGRect adjustResizeFrame = [self adjustResizeFrame];
    UIEdgeInsets contentInset = [self scrollViewContentInsetWithAdjustResizeFrame:adjustResizeFrame];
    CGFloat minZoomScale = [self scrollViewMinZoomScaleWithResizeSize:adjustResizeFrame.size];
    CGFloat contentOffsetX = -contentInset.left + (_baseImageW * minZoomScale - adjustResizeFrame.size.width) * 0.5;
    CGFloat contentOffsetY = -contentInset.top + (_baseImageH * minZoomScale - adjustResizeFrame.size.height) * 0.5;
    [self updateImageresizerFrame:adjustResizeFrame];
    self.scrollView.minimumZoomScale = minZoomScale;
    self.scrollView.zoomScale = minZoomScale;
    self.scrollView.contentInset = contentInset;
    self.scrollView.contentOffset = CGPointMake(contentOffsetX, contentOffsetY);
}

#pragma mark -刚刚选中区域
- (void)setResizeWHScale:(CGFloat)resizeWHScale animated:(BOOL)isAnimated {
    self.isCanResizeWHScale = NO;
    __weak typeof(self)weakSelf = self;
    [self setLineAnimation:0.05 completion:^{
        weakSelf.isCanResizeWHScale = YES;
    }];
    if (resizeWHScale > 0) {
        if (self.rotationDirection == JPImageresizerHorizontalLeftDirection ||
            self.rotationDirection == JPImageresizerHorizontalRightDirection) {
            resizeWHScale = 1.0 / resizeWHScale;
        }
    }
    if (_resizeWHScale == resizeWHScale) return;
    _resizeWHScale = resizeWHScale;
    if (self.superview) {
        [self updateImageOriginFrameWithDirection:_rotationDirection];
        [self recoveryWithDirection:_rotationDirection];
    };
}

#pragma mark -旋转
- (void)rotationWithDirection:(JPImageresizerRotationDirection)direction rotationDuration:(NSTimeInterval)rotationDuration {
    self.isCanRotation = NO;
    __weak typeof(self)weakSelf = self;
    [self setLineAnimation:0.25 completion:^{
        weakSelf.isCanRotation = YES;
    }];
    [self updateImageresizerZoomWithAnimateDuration:rotationDuration];
    [self recoveryWithDirection:direction];
}

- (void)setLineAnimation:(NSTimeInterval)duration completion: (void (^ __nullable)(void))completion {
    for (NSArray *array in self.lines) {
        for (CAShapeLayer *line in array) {
            line.hidden = YES;
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSArray *array in self.lines) {
            for (CAShapeLayer *line in array) {
                line.hidden = NO;
            }
        }
        !completion ? :completion();
    });
}

- (void)updateRotationDirection:(JPImageresizerRotationDirection)rotationDirection {
    [self updateMaxResizeFrameWithDirection:rotationDirection];
    BOOL isVer2Hor = ((_rotationDirection == JPImageresizerVerticalUpDirection ||
                       _rotationDirection == JPImageresizerVerticalDownDirection) &&
                      (rotationDirection == JPImageresizerHorizontalLeftDirection ||
                       rotationDirection == JPImageresizerHorizontalRightDirection));
    BOOL isHor2Ver = ((_rotationDirection == JPImageresizerHorizontalLeftDirection ||
                       _rotationDirection == JPImageresizerHorizontalRightDirection) &&
                      (rotationDirection == JPImageresizerVerticalUpDirection ||
                       rotationDirection == JPImageresizerVerticalDownDirection));
    if (isVer2Hor || isHor2Ver) _resizeWHScale = 1.0 / _resizeWHScale;
    _rotationDirection = rotationDirection;
}

- (void)updateImageresizerZoomWithAnimateDuration:(NSTimeInterval)duration {
    CGRect adjustResizeFrame = [self adjustResizeFrame];
    // contentInset
    UIEdgeInsets contentInset = [self scrollViewContentInsetWithAdjustResizeFrame:adjustResizeFrame];
    
    // contentOffset
    CGPoint contentOffset = CGPointZero;
    CGPoint origin = self.imageresizerFrame.origin;
    CGPoint convertPoint = [self convertPoint:origin toView:self.imageView];
    // 这个convertPoint是相对self.imageView.bounds上的点，所以要✖️zoomScale拿到相对frame实际显示的大小
    contentOffset.x = -contentInset.left + convertPoint.x * self.scrollView.zoomScale;
    contentOffset.y = -contentInset.top + convertPoint.y * self.scrollView.zoomScale;
    
    // minimumZoomScale
    self.scrollView.minimumZoomScale = [self scrollViewMinZoomScaleWithResizeSize:adjustResizeFrame.size];
    
    // zoomFrame
    // 根据裁剪的区域，因为需要有间距，所以拼接成self的尺寸获取缩放的区域zoomFrame
    // 宽高比不变，所以宽度高度的比例是一样，这里就用宽度比例吧
    CGFloat convertScale = self.imageresizerFrame.size.width / adjustResizeFrame.size.width;
    CGFloat diffXSpace = adjustResizeFrame.origin.x * convertScale;
    CGFloat diffYSpace = adjustResizeFrame.origin.y * convertScale;
    CGFloat convertW = self.imageresizerFrame.size.width + 2 * diffXSpace;
    CGFloat convertH = self.imageresizerFrame.size.height + 2 * diffYSpace;
    CGFloat convertX = self.imageresizerFrame.origin.x - diffXSpace;
    CGFloat convertY = self.imageresizerFrame.origin.y - diffYSpace;
    CGRect zoomFrame = [self convertRect:CGRectMake(convertX, convertY, convertW, convertH) toView:self.imageView];
    
    __weak typeof(self) wSelf = self;
    void (^zoomBlock)(void) = ^{
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        [sSelf.scrollView setContentInset:contentInset];
        [sSelf.scrollView setContentOffset:contentOffset animated:NO];
        [sSelf.scrollView zoomToRect:zoomFrame animated:NO];
    };
    
    [self updateImageresizerFrame:adjustResizeFrame];
    if (duration > 0) {
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            zoomBlock();
        } completion:nil];
    } else {
        zoomBlock();
    }
}

- (void)updateMaxResizeFrameWithDirection:(JPImageresizerRotationDirection)direction {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 0;
    CGFloat h = 0;
    if (direction == JPImageresizerVerticalUpDirection ||
        direction == JPImageresizerVerticalDownDirection) {
        _sizeScale = 1;
        CGFloat diffHalfW = (self.bounds.size.width - _contentSize.width) * 0.5;
        x = diffHalfW;
        y = 0;
        w = self.bounds.size.width - 2 * x;
        h = self.bounds.size.height - 2 * y;
    } else {
        _sizeScale = _contentSize.width / self.scrollView.bounds.size.height;
        x = 0 / _sizeScale;
        y = 0 / _sizeScale;
        w = self.bounds.size.width - 2 * x;
        h = self.bounds.size.height - 2 * y;
    }
    self.maxResizeFrame = CGRectMake(x, y, w, h);
}


#pragma mark -网格
- (void)updateImageresizerFrame:(CGRect)imageresizerFrame {
    self.imageresizerFrame = imageresizerFrame;
    CGFloat imageresizerX = imageresizerFrame.origin.x;
    CGFloat imageresizerY = imageresizerFrame.origin.y;
    
    CGFloat imageresizerW = imageresizerFrame.size.width;
    CGFloat imageresizerH = imageresizerFrame.size.height;
    CGFloat oneThirdW = imageresizerW / 3.0;
    CGFloat oneThirdH = imageresizerH / 3.0;
    
    UIBezierPath *horLinePath0 = [self linePathWithLinePosition:JPHorizontalLine location:CGPointMake(imageresizerX, imageresizerY) length:imageresizerW];
    UIBezierPath *horLinePath1 = [self linePathWithLinePosition:JPHorizontalLine location:CGPointMake(imageresizerX, imageresizerY + oneThirdH) length:imageresizerW];
    UIBezierPath *horLinePath2 = [self linePathWithLinePosition:JPHorizontalLine location:CGPointMake(imageresizerX, imageresizerY + oneThirdH * 2) length:imageresizerW];
    UIBezierPath *horLinePath3 = [self linePathWithLinePosition:JPHorizontalLine location:CGPointMake(imageresizerX, imageresizerY + oneThirdH * 3) length:imageresizerW];
    
    UIBezierPath *verLinePath0 = [self linePathWithLinePosition:JPVerticalLine location:CGPointMake(imageresizerX, imageresizerY) length:imageresizerH];
    UIBezierPath *verLinePath1 = [self linePathWithLinePosition:JPVerticalLine location:CGPointMake(imageresizerX + oneThirdW, imageresizerY) length:imageresizerH];
    UIBezierPath *verLinePath2 = [self linePathWithLinePosition:JPVerticalLine location:CGPointMake(imageresizerX + oneThirdW * 2, imageresizerY) length:imageresizerH];
    UIBezierPath *verLinePath3 = [self linePathWithLinePosition:JPVerticalLine location:CGPointMake(imageresizerX + oneThirdW * 3, imageresizerY) length:imageresizerH];
    
    // 遮罩部分延伸放大，避免旋转出现页面漏出
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.bounds.origin.x - 500, self.bounds.origin.y - 500, self.bounds.size.width + 1000, self.bounds.size.height + 1000)];
    UIBezierPath *framePath = [UIBezierPath bezierPathWithRect:imageresizerFrame];
    [bgPath appendPath:framePath];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    self.lines.firstObject[0].path = horLinePath0.CGPath;
    self.lines.firstObject[1].path = horLinePath1.CGPath;
    self.lines.firstObject[2].path = horLinePath2.CGPath;
    self.lines.firstObject[3].path = horLinePath3.CGPath;
    
    self.lines.lastObject[0].path = verLinePath0.CGPath;
    self.lines.lastObject[1].path = verLinePath1.CGPath;
    self.lines.lastObject[2].path = verLinePath2.CGPath;
    self.lines.lastObject[3].path = verLinePath3.CGPath;
    
    self.bgLayer.path = bgPath.CGPath;

    [CATransaction commit];
}

- (UIBezierPath *)linePathWithLinePosition:(JPLinePosition)linePosition location:(CGPoint)location length:(CGFloat)length {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointZero;
    switch (linePosition) {
        case JPHorizontalLine:
        {
            point = CGPointMake(location.x + length, location.y);
            break;
        }
        case JPVerticalLine:
        {
            point = CGPointMake(location.x, location.y + length);
            break;
        }
    }
    [path moveToPoint:location];
    [path addLineToPoint:point];
    return path;
}

#pragma mark - 截图
- (void)imageresizerWithComplete:(void (^)(UIImage *))complete isOriginImageSize:(BOOL)isOriginImageSize referenceWidth:(CGFloat)referenceWidth {
    if (!complete) return;
    
    /**
     * UIImageOrientationUp,            // default orientation
     * UIImageOrientationDown,          // 180 deg rotation
     * UIImageOrientationLeft,          // 90 deg CCW
     * UIImageOrientationRight,         // 90 deg CW
     */
    
    UIImageOrientation orientation;
    switch (self.rotationDirection) {
        case JPImageresizerHorizontalLeftDirection:
            orientation = UIImageOrientationLeft;
            break;
            
        case JPImageresizerVerticalDownDirection:
            orientation = UIImageOrientationDown;
            break;
            
        case JPImageresizerHorizontalRightDirection:
            orientation = UIImageOrientationRight;
            break;
            
        default:
            orientation = UIImageOrientationUp;
            break;
    }
    
    __block UIImage *image = self.imageView.image;
    
    CGFloat imageScale = image.scale;
    CGFloat imageWidth = image.size.width * imageScale;
    CGFloat imageHeight = image.size.height * imageScale;
    
    CGFloat scale = imageWidth / self.imageView.bounds.size.width;
    
    CGRect cropFrame = [self convertRect:self.imageresizerFrame toView:self.imageView];
    
    CGFloat deviceScale = [UIScreen mainScreen].scale;
    
    if (referenceWidth > 0) {
        CGFloat maxWidth = MAX(imageWidth, self.imageView.bounds.size.width);
        CGFloat minWidth = MIN(imageWidth, self.imageView.bounds.size.width);
        if (referenceWidth > maxWidth) referenceWidth = maxWidth;
        if (referenceWidth < minWidth) referenceWidth = minWidth;
    } else {
        referenceWidth = self.imageView.bounds.size.width;
    }
    
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        
        image = [image jp_fixOrientation];
        
        // 宽高比不变，所以宽度高度的比例是一样
        CGFloat orgX = cropFrame.origin.x * scale;
        CGFloat orgY = cropFrame.origin.y * scale;
        CGFloat width = cropFrame.size.width * scale;
        CGFloat height = cropFrame.size.height * scale;
        CGRect cropRect = CGRectMake(orgX, orgY, width, height);
        
        if (orgX < 0) {
            cropRect.origin.x = 0;
            cropRect.size.width += -orgX;
        }
        
        if (orgY < 0) {
            cropRect.origin.y = 0;
            cropRect.size.height += -orgY;
        }
        
        CGFloat cropMaxX = CGRectGetMaxX(cropRect);
        if (cropMaxX > imageWidth) {
            CGFloat diffW = cropMaxX - imageWidth;
            cropRect.size.width -= diffW;
        }
        
        CGFloat cropMaxY = CGRectGetMaxY(cropRect);
        if (cropMaxY > imageHeight) {
            CGFloat diffH = cropMaxY - imageHeight;
            cropRect.size.height -= diffH;
        }
        
        CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
        
        UIImage *resizeImg = [UIImage imageWithCGImage:imgRef];
        resizeImg = [resizeImg jp_rotate:orientation];
        
        CGImageRelease(imgRef);
        
        if (isOriginImageSize) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(resizeImg);
            });
            return;
        }
        
        // 有小数的情况下，边界会多出白线，需要把小数点去掉
        CGFloat cropScale = imageWidth / referenceWidth;
        CGSize cropSize = CGSizeMake(floor(resizeImg.size.width / cropScale), floor(resizeImg.size.height / cropScale));
        if (cropSize.width < 1) cropSize.width = 1;
        if (cropSize.height < 1) cropSize.height = 1;
        
        /**
         * 参考：http://www.jb51.net/article/81318.htm
         * 这里要注意一点CGContextDrawImage这个函数的坐标系和UIKIt的坐标系上下颠倒，需对坐标系处理如下：
            - 1.CGContextTranslateCTM(context, 0, cropSize.height);
            - 2.CGContextScaleCTM(context, 1, -1);
         */
        
        UIGraphicsBeginImageContextWithOptions(cropSize, 0, deviceScale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, cropSize.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextDrawImage(context, CGRectMake(0, 0, cropSize.width, cropSize.height), resizeImg.CGImage);
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        resizeImg = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(newImage);
        });
    });
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat scopeWH = 50.0;
    CGFloat halfScopeWH = scopeWH * 0.5;
    
    CGFloat x = self.imageresizerFrame.origin.x;
    CGFloat y = self.imageresizerFrame.origin.y;
    CGFloat maxX = CGRectGetMaxX(self.imageresizerFrame);
    CGFloat maxY = CGRectGetMaxY(self.imageresizerFrame);
    
    CGRect leftTopRect = CGRectMake(x - halfScopeWH, y - halfScopeWH, scopeWH, scopeWH);
    CGRect leftBotRect = CGRectMake(x - halfScopeWH, maxY - halfScopeWH, scopeWH, scopeWH);
    CGRect rightTopRect = CGRectMake(maxX - halfScopeWH, y - halfScopeWH, scopeWH, scopeWH);
    CGRect rightBotRect = CGRectMake(maxX - halfScopeWH, maxY - halfScopeWH, scopeWH, scopeWH);
    
    if (CGRectContainsPoint(leftTopRect, point) ||
        CGRectContainsPoint(leftBotRect, point) ||
        CGRectContainsPoint(rightTopRect, point) ||
        CGRectContainsPoint(rightBotRect, point)) {
        return YES;
    }
    return NO;
}


@end
