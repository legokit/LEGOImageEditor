//
//  LGImageresizerConfigure.h
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/17.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGImageresizerTypedef.h"
NS_ASSUME_NONNULL_BEGIN

@interface LGImageresizerConfigure : NSObject
+ (instancetype)defaultConfigureWithResizeImage:(UIImage *)resizeImage make:(void(^)(LGImageresizerConfigure *configure))make;

/** 裁剪图片 */
@property (nonatomic, strong) UIImage *resizeImage;

/** 视图区域 */
@property (nonatomic, assign) CGRect viewFrame;

/** 遮罩层 */
@property (nonatomic, strong) UIColor *fillColor;

/** 裁剪线颜色 */
@property (nonatomic, strong) UIColor *strokeColor;

/** 边框颜色 */
@property (nonatomic, strong) UIColor *borderColor;

/** 是否顺时针旋转 */
@property (nonatomic, assign) BOOL isClockwiseRotation;
@end

NS_ASSUME_NONNULL_END
