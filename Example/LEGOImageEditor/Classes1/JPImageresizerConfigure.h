//
//  JPImageresizerConfigure.h
//  JPImageresizerView
//
//  Created by 周健平 on 2018/4/22.
//
//  JPImageresizerConfigure：用于配置初始化参数

#import <Foundation/Foundation.h>
#import "JPImageresizerTypedef.h"

@interface JPImageresizerConfigure : NSObject

+ (instancetype)defaultConfigureWithResizeImage:(UIImage *)resizeImage make:(void(^)(JPImageresizerConfigure *configure))make;

/** 裁剪图片 */
@property (nonatomic, strong) UIImage *resizeImage;

/** 视图区域 */
@property (nonatomic, assign) CGRect viewFrame;

/** 遮罩层 */
@property (nonatomic, strong) UIColor *fillColor;

/** 裁剪线颜色 */
@property (nonatomic, strong) UIColor *strokeColor;

/** 裁剪宽高比 */
@property (nonatomic, assign) CGFloat resizeWHScale;

/** 是否顺时针旋转 */
@property (nonatomic, assign) BOOL isClockwiseRotation;

@end
