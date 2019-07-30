//
//  UIImage+LEGOFixOrientation.h
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/22.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LEGOFixOrientation)

- (UIImage *)fixOrientation;

- (UIImage *)rotateByAngle:(CGFloat)angleInRadians;

- (UIImage *)cropBySize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
