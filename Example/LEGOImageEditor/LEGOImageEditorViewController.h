//
//  LEGOImageEditorViewController.h
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/19.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEGOImageEditorViewController : UIViewController
@property (nonatomic, copy) void (^resizeImageBlock) (UIImage *image);
@end

NS_ASSUME_NONNULL_END
