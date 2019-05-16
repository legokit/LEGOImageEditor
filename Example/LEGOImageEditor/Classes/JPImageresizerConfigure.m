//
//  JPImageresizerConfigure.m
//  JPImageresizerView
//
//  Created by 周健平 on 2018/4/22.
//

#import "JPImageresizerConfigure.h"

@implementation JPImageresizerConfigure

+ (instancetype)defaultConfigureWithResizeImage:(UIImage *)resizeImage make:(void (^)(JPImageresizerConfigure *))make {
    JPImageresizerConfigure *configure = [[self alloc] init];
    configure.resizeImage = resizeImage;
    configure.viewFrame = CGRectMake(50, 50, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - 200);
    configure.strokeColor = [UIColor whiteColor];
    configure.fillColor = [UIColor colorWithWhite:0 alpha:1];
    configure.resizeWHScale = 0;
    !make ? : make(configure);
    return configure;
}

@end
