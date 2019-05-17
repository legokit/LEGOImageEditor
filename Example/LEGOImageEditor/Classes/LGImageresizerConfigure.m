//
//  LGImageresizerConfigure.m
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/17.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LGImageresizerConfigure.h"

@implementation LGImageresizerConfigure

+ (instancetype)defaultConfigureWithResizeImage:(UIImage *)resizeImage make:(void (^)(LGImageresizerConfigure *))make {
    LGImageresizerConfigure *configure = [[self alloc] init];
    configure.resizeImage = resizeImage;
    configure.viewFrame = CGRectMake(50, 50, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - 200);
    configure.strokeColor = [UIColor whiteColor];
    configure.fillColor = [UIColor colorWithWhite:0 alpha:1];
    configure.resizeWHScale = 0;
    !make ? : make(configure);
    return configure;
}

@end
