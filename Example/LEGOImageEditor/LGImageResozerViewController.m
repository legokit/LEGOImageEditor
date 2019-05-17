//
//  LGImageResozerViewController.m
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/15.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LGImageResozerViewController.h"
#import "JPImageresizerConfigure.h"
#import "JPImageresizerView.h"
#import "LGImageEditorViewController.h"
#import "LGIamgeShowViewController.h"

@interface LGImageResozerViewController ()
@property (nonatomic, strong) JPImageresizerView *imageresizerView;
@property (nonatomic, assign) BOOL is2_3;

@end

@implementation LGImageResozerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    JPImageresizerConfigure *configure1 = [JPImageresizerConfigure defaultConfigureWithResizeImage:self.image make:^(JPImageresizerConfigure *configure) {
        
    }];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    
    
    JPImageresizerView *imageresizerView = [JPImageresizerView imageresizerViewWithConfigure:configure1];
    
    CGFloat resizeWHScale;
    if (self.image.size.width > self.image.size.height) {
        resizeWHScale = 3 / 2.0;
        self.is2_3 = NO;
    }
    else {
        resizeWHScale = 2 / 3.0;
        self.is2_3 = YES;
    }
    imageresizerView.resizeWHScale = resizeWHScale;
    
    [self.view insertSubview:imageresizerView atIndex:0];
    self.imageresizerView = imageresizerView;
    

    
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    if (point.y > self.view.bounds.size.height - 100) {
        if (point.x < self.view.bounds.size.width / 3.0) {
            if ([self.imageresizerView isCanResizeWHScale]) {
                if (self.is2_3) {
                    self.imageresizerView.resizeWHScale = 3 / 2.0;
                    self.is2_3 = NO;
                }
                else {
                    self.imageresizerView.resizeWHScale = 2 / 3.0;
                    self.is2_3 = YES;
                }
            }
        }
        else if (point.x < self.view.bounds.size.width / 3.0 * 2) {
            [self rotate:nil];
        }
        else {
            [self resize:nil];
        }
    }
}

- (void)recovery:(id)sender {
    [self.imageresizerView recovery];
}


- (void)rotate:(id)sender {
    if ([self.imageresizerView isCanRotation]) {
        [self.imageresizerView rotation];
    }
}

- (void)resize:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    // 1.默认以imageView的宽度为参照宽度进行裁剪
    [self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        if (!resizeImage) {
            NSLog(@"没有裁剪图片");
            return;
        }
        
        LGIamgeShowViewController *vc = [[LGIamgeShowViewController alloc] init];
        vc.image = resizeImage;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    // 2.自定义参照宽度进行裁剪（例如按屏幕宽度）
    //    [self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
    //        // 裁剪完成，resizeImage为裁剪后的图片
    //        // 注意循环引用
    //    } referenceWidth:[UIScreen mainScreen].bounds.size.width];
    
    // 3.以原图尺寸进行裁剪
    //    [self.imageresizerView originImageresizerWithComplete:^(UIImage *resizeImage) {
    //        // 裁剪完成，resizeImage为裁剪后的图片
    //        // 注意循环引用
    //    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
