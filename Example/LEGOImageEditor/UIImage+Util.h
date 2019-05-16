//
//  UIImage+Util.h
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/15.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)
//设置的外围不变形内部平铺拉伸
- (UIImage*)resizeImageWithTop:(CGFloat)top andLeft:(CGFloat)left andBottom:(CGFloat)bottom andRight:(CGFloat)right;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
