//
//  UIImage+LGExtension.h
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/17.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LGExtension)
/** 修正图片的方向 */
- (UIImage *)jp_fixOrientation;

/** 按指定方向旋转图片 */
- (UIImage*)jp_rotate:(UIImageOrientation)orientation;

/** 沿Y轴翻转 */
- (UIImage *)jp_verticalityMirror;

/** 沿X轴翻转 */
- (UIImage *)jp_horizontalMirror;
@end

NS_ASSUME_NONNULL_END
