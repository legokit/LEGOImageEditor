//
//  LGImageresizerView.h
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/17.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGImageresizerConfigure.h"
NS_ASSUME_NONNULL_BEGIN

@interface LGImageresizerView : UIView
/*!
 @method
 @brief 类方法（推荐）
 @param configure --- 包含了所有初始化参数
 @discussion 使用LGImageresizerConfigure配置好参数
 */
+ (instancetype)imageresizerViewWithConfigure:(LGImageresizerConfigure *)configure;


- (instancetype)initWithResizeImage:(UIImage *)resizeImage
                              frame:(CGRect)frame
                          fillColor:(UIColor *)fillColor
                        strokeColor:(UIColor *)strokeColor
                        borderColor:(UIColor *)borderColor
                      resizeWHScale:(CGFloat)resizeWHScale;

@property (nonatomic, strong) UIScrollView *scrollView;

/** 裁剪的图片 */
@property (nonatomic, strong) UIImage *resizeImage;

/** 裁剪线颜色 */
@property (nonatomic) UIColor *strokeColor;

/** 裁剪宽高比（0则为任意比例，可控8个方向，固定比例为4个方向） */
@property (nonatomic) CGFloat resizeWHScale;
- (void)setResizeWHScale:(CGFloat)resizeWHScale animated:(BOOL)isAnimated;

/** 是否顺时针旋转（默认逆时针） */
@property (nonatomic, assign) BOOL isClockwiseRotation;

/** 当前旋转的下标系数 */
@property (nonatomic, assign) NSInteger directionIndex;

@property (nonatomic, assign, readonly) BOOL isCanRotation;

@property (nonatomic, assign, readonly) BOOL isCanResizeWHScale;

/*!
 @method
 @brief 旋转图片
 @discussion 旋转90度，支持4个方向，分别是垂直向上、水平向左、垂直向下、水平向右
 */
- (void)rotation;

/*!
 @method
 @brief 重置
 @discussion 回到最初状态
 */
- (void)recovery;

/*!
 @method
 @brief 原图尺寸裁剪
 @param complete --- 裁剪完成的回调
 @discussion 裁剪过程在子线程，回调已切回到主线程，可调用该方法前加上状态提示
 */
- (void)originImageresizerWithComplete:(void(^)(UIImage *resizeImage))complete;

/*!
 @method
 @brief 压缩尺寸裁剪
 @param complete --- 裁剪完成的回调
 @param referenceWidth --- 裁剪的图片的参照宽度，例如设置为2000，则宽度固定为2000，高度按比例适配
 @discussion 裁剪过程在子线程，回调已切回到主线程，可调用该方法前加上状态提示
 */
- (void)imageresizerWithComplete:(void(^)(UIImage *resizeImage))complete referenceWidth:(CGFloat)referenceWidth;

/*!
 @method
 @brief 压缩尺寸裁剪（referenceWidth为0，为imageView的宽度）
 @param complete --- 裁剪完成的回调
 @discussion 裁剪过程在子线程，回调已切回到主线程，可调用该方法前加上状态提示
 */
- (void)imageresizerWithComplete:(void(^)(UIImage *resizeImage))complete;

@end

NS_ASSUME_NONNULL_END
