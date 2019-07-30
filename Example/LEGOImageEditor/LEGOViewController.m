//
//  LEGOViewController.h
//  LEGOImageCropper
//
//  Created by 564008993@qq.com on 07/19/2019.
//  Copyright (c) 2019 564008993@qq.com. All rights reserved.
//


#import "LEGOViewController.h"
#import <Masonry/Masonry.h>
#import "LEGOImageEditorViewController.h"

@interface LEGOViewController ()
@property (strong, nonatomic) UIButton *addPhotoButton;
@property (assign, nonatomic) BOOL didSetupConstraints;

@end

@implementation LEGOViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = @"LEGOImageCropper";
    
    self.addPhotoButton = [[UIButton alloc] init];
    self.addPhotoButton.backgroundColor = [UIColor whiteColor];
    self.addPhotoButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addPhotoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.addPhotoButton setTitle:@"add\nphoto" forState:UIControlStateNormal];
    [self.addPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addPhotoButton addTarget:self action:@selector(onAddPhotoButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addPhotoButton];
    
    [self.addPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200 ,120));
    }];
}

- (void)onAddPhotoButtonTouch:(UIButton *)sender {
    LEGOImageEditorViewController *vc = [[LEGOImageEditorViewController alloc] init];
    vc.resizeImageBlock = ^(UIImage * _Nonnull image) {
        [self.addPhotoButton setImage:image forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end

