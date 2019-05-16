//
//  LGIamgeShowViewController.m
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/15.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LGIamgeShowViewController.h"
#define item_h(w,size) (w / size.width * size.height)

@interface LGIamgeShowViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation LGIamgeShowViewController

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = self.image;
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
    CGFloat h = item_h(self.view.bounds.size.width, self.image.size);
    self.imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, h);
    
    // Do any additional setup after loading the view.
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
