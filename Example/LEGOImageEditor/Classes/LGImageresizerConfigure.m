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
    configure.strokeColor = [UIColor colorWithWhite:1 alpha:0.3];
    configure.borderColor = [UIColor colorWithWhite:1 alpha:0.2];
    configure.fillColor = [UIColor colorWithWhite:0 alpha:0.5];
    configure.resizeWHScale = 0;
    !make ? :make(configure);
    return configure;
}

@end
