//
//  LEGOImageCropperView.h
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/19.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEGOImageScrollView.h"

@interface LEGOImageCropperView : UIView

/**
 初始化方式

 @param originalImage 原图
 */
- (instancetype)initWithImage:(UIImage *)originalImage frame:(CGRect)frame;

- (instancetype)initWithSize:(CGSize)size frame:(CGRect)frame;


/** 容器 */
@property (nonatomic, strong) LEGOImageScrollView *imageScrollView;

/** 原图 */
@property (nonatomic, strong, readonly) UIImage *originalImage;

/** 缩小图像滤波器 */
@property (nonatomic, strong) CALayerContentsFilter minificationFilter;

/** 放大图像滤波器 */
@property (nonatomic, strong) CALayerContentsFilter magnificationFilter;

/** 最小裁剪分辨率，默认为 1.0f */
@property (nonatomic, assign) CGFloat minZoomScale;

/** 最大裁剪分辨率，默认为 MAXFLOAT */
@property (nonatomic, assign) CGFloat maxZoomScale;

/** 开始缩放 */
@property (nonatomic, copy) void (^beginZooming)(void);

/** 结束缩放 */
@property (nonatomic, copy) void (^didEndZooming)(CGFloat scale);

/** 开始拖动 */
@property (nonatomic, copy) void (^beginDragging)(void);

/** 结束拖动，decelerate 减速状态 */
@property (nonatomic, copy) void (^didEndDragging)(BOOL decelerate);

/** 裁剪框范围 */
@property (nonatomic, assign, readonly) CGRect maskRect;

/** 裁剪框尺寸 */
@property (nonatomic, assign, readonly) CGRect cropRect;

/** 裁剪框路径 */
@property (nonatomic, copy, readonly) UIBezierPath *maskPath;

/** 裁剪网格是否隐藏 */
- (void)setLineHidden:(BOOL)hidden;

/** 裁剪框颜色 */
@property (nonatomic, strong) UIColor *maskColor;

/** 裁剪框阴影 */
@property (nonatomic, strong) UIColor *shadowColor;

/** 网格线颜色 */
@property (nonatomic, strong) UIColor *shapeLayerColor;

/** 是否允许双指自由旋转，默认为 YES */
@property (nonatomic, assign, getter=isRotationEnabled) BOOL rotationEnabled;

/** 是否允许双击重置，默认为 YES */
@property (nonatomic, assign, getter=isDoubleResetEnabled) BOOL doubleResetEnabled;

/** 是否为顺势转旋转，默认为 NO */
@property (nonatomic, assign, getter=isClockwiseRotation) BOOL clockwiseRotation;

/** 是否为外圈适应，默认为 YES */
@property (nonatomic, assign) BOOL isOuterBoundary;
 
/** 重置 */
- (void)reset:(BOOL)animated;

/** 设置【裁剪比例】 */
@property (nonatomic, assign) CGSize resizeWHRatio;

- (void)setResizeWHRatio:(CGSize)resizeWHRatio;

- (void)setResizeWHRatio:(CGSize)resizeWHRatio animated:(BOOL)animated;

/** 设置【旋转角度】 */
@property (nonatomic, assign) CGFloat rotationAngle;

- (void)rotation:(BOOL)animated;

- (void)setRotationAngle:(CGFloat)rotationAngle;

- (void)setRotationAngle:(CGFloat)rotationAngle animated:(BOOL)animated;

/**
 裁剪
 */
- (void)cropImageWithComplete:(void(^)(UIImage *resizeImage))complete;

- (void)cropImageWithComplete:(void(^)(UIImage *resizeImage))complete originalImage:(UIImage *)originalImage;


@end


