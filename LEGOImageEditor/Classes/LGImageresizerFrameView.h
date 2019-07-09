//
//  LGImageresizerFrameView.h
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/17.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGImageresizerConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGImageresizerFrameView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  contentSize:(CGSize)contentSize
                    fillColor:(UIColor *)fillColor
                  strokeColor:(UIColor *)strokeColor
                resizeWHScale:(CGFloat)resizeWHScale
                   scrollView:(UIScrollView *)scrollView
                    imageView:(UIImageView *)imageView;

@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, strong) UIColor *strokeColor;

@property (nonatomic, assign, readonly) CGRect imageresizerFrame;

@property (nonatomic, copy) void (^imageresizerFrameChange)(CGRect imageresizerFrame);

@property (nonatomic, assign) CGFloat minZoomScale;
- (CGFloat)getCurrMaxmumZoomScale;

@property (nonatomic, assign) CGFloat resizeWHScale;
- (void)setResizeWHScale:(CGFloat)resizeWHScale animated:(BOOL)isAnimated;

@property (nonatomic, assign, readonly) BOOL isCanRotation;
@property (nonatomic, assign, readonly) BOOL isCanResizeWHScale;

@property (nonatomic, assign, readonly) LGImageresizerRotationDirection rotationDirection;

@property (nonatomic, assign, readonly) CGFloat sizeScale;

- (void)recovery;
- (void)recoveryWithDirection:(LGImageresizerRotationDirection)direction;

- (void)rotationWithDirection:(LGImageresizerRotationDirection)direction rotationDuration:(NSTimeInterval)rotationDuration;

- (void)imageresizerWithComplete:(void(^)(UIImage *resizeImage))complete isOriginImageSize:(BOOL)isOriginImageSize referenceWidth:(CGFloat)referenceWidth;

@end

NS_ASSUME_NONNULL_END
