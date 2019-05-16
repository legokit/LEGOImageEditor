//
//  LGImageEditorViewController.h
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/14.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGImagePickerAlbumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGImageEditorViewController : UIViewController
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^finish)(UIImage *image);
@end

NS_ASSUME_NONNULL_END
