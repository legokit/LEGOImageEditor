//
//  LGImagePickerViewController.h
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/13.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGImagePickerViewController : UIViewController
@property (nonatomic, copy) void (^finish)(UIImage *image);
@end

NS_ASSUME_NONNULL_END
