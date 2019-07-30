
//
//  LEGOImageEditorViewController.m
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/19.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LEGOImageEditorViewController.h"
#import "LEGOImageCropperView.h"
#import <Masonry/Masonry.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UISliderControl.h"

@interface LEGOImageEditorViewController ()
@property (nonatomic, strong) LEGOImageCropperView *cropperView;
@property (nonatomic, assign) CGFloat currRatio;
@property (nonatomic, copy) NSString *currValue;
@property (nonatomic, assign) BOOL shockEnable;

@property (nonatomic, strong) UISliderControl *sliderControl;

@end

@implementation LEGOImageEditorViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat w = [UIScreen mainScreen].bounds.size.width - 60;
    LEGOImageCropperView *view = [[LEGOImageCropperView alloc] initWithImage:[UIImage imageNamed:@"image_xxxxxxxx"] frame:CGRectMake(30, 0, w, w / 2 * 3)];
    view.maskColor = [UIColor colorWithWhite:0 alpha:0.3];
    view.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
    view.shapeLayerColor = [UIColor colorWithWhite:1 alpha:0.3];
    view.resizeWHRatio = CGSizeMake(2, 3);
    view.rotationEnabled = NO;
    view.doubleResetEnabled = NO;
    view.didEndZooming = ^(CGFloat scale) {
        NSLog(@"scale=%f",scale);
    };
    view.minZoomScale = 200;
    view.maxZoomScale = MAXFLOAT;
    [self.view addSubview:view];

    self.cropperView = view;
    
    UIButton *rotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotationButton setTitle:@"旋转" forState:UIControlStateNormal];
    [rotationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rotationButton addTarget:self action:@selector(rotationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotationButton];
    [rotationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.safeAreaInsets).offset(-25);
        } else {
            make.bottom.offset(-25);
            // Fallback on earlier versions
        }
    }];
    
    UIButton *cropButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cropButton setTitle:@"裁剪" forState:UIControlStateNormal];
    [cropButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cropButton addTarget:self action:@selector(cropButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cropButton];
    [cropButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(50, 30));
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.safeAreaInsets).offset(-25);
        } else {
            make.bottom.offset(-25);
            // Fallback on earlier versions
        }
    }];
    
    UIButton *resetWHButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetWHButton setTitle:@"宽高" forState:UIControlStateNormal];
    [resetWHButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetWHButton addTarget:self action:@selector(resetWHButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetWHButton];
    [resetWHButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.safeAreaInsets).offset(-25);
        } else {
            make.bottom.offset(-25);
            // Fallback on earlier versions
        }
    }];
    
//    UISlider *slider = [[UISlider alloc] init];
//    slider.minimumValue = -1.0f;
//    slider.maximumValue = 1.0f;
//    slider.value = 0.0f;
//    [self.view addSubview:slider];
//    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(50);
//        make.right.offset(-50);
//        make.top.mas_equalTo(self.cropperView.mas_bottom).offset(50);
//    }];
//    [slider addTarget:self action:@selector(sliderValueDidBegin:) forControlEvents:UIControlEventTouchDown];
//    [slider addTarget:self action:@selector(sliderValueDidEnd:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
//    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    UISliderControl *sliderControl = [[UISliderControl alloc] init];
    sliderControl.backgroundColor = [UIColor yellowColor];
    sliderControl.delegate = (id <UISliderControlDelegate>)self;
    sliderControl.minimumValue = -1.0f;
    sliderControl.maximumValue = 1.0f;
    sliderControl.value = 0.0f;
    [self.view addSubview:sliderControl];
    [sliderControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 2);
        make.top.mas_equalTo(self.cropperView.mas_bottom).offset(50);
    }];

    self.currValue = @"0.0";
    // Do any additional setup after loading the view.
}

- (void)beginTrackingWithTouch {
    self.shockEnable = YES;
    [self.cropperView setLineHidden:YES];
}
- (void)continueTrackingWithTouch:(CGFloat)value {
    [self playSystemSound:value * 30];
    CGFloat rotationAngle = M_PI / 180 * 30 * (value - self.currRatio);
    [self.cropperView setRotationAngle:-rotationAngle];
    self.currRatio = value;
}
- (void)endTrackingWithTouch {
    self.shockEnable = NO;
    [self.cropperView setLineHidden:NO];
}

//- (void)sliderValueDidBegin:(UISlider *)slider {
//    [self.cropperView setLineHidden:YES];
//
//}

//- (void)sliderValueDidEnd:(UISlider *)slider {
//    [self.cropperView setLineHidden:NO];
//}

//- (void)sliderValueChanged:(UISlider *)slider {
//    [self playSystemSound:slider.value];
//    CGFloat rotationAngle = M_PI / 2.0 * (slider.value - self.currRatio);
//    [self.cropperView setRotationAngle:-rotationAngle];
//    self.currRatio = slider.value;
//}

- (void)playSystemSound:(CGFloat)value {
    NSString *valueStr = [NSString stringWithFormat:@"%.2f",value];
    NSLog(@"valueStr=%@",valueStr);
    if (fabs([self.currValue floatValue] - [valueStr floatValue]) < 0.01) {
        return;
    }
    if (self.shockEnable) {
        AudioServicesPlaySystemSound(1519);
        AudioServicesDisposeSystemSoundID(1519);
    }
    self.currValue = valueStr;
}

- (void)rotationButtonClick:(id)sender {
    [self.cropperView rotation:YES];
}

- (void)resetWHButtonClick:(id)sender {
    if ([[NSValue valueWithCGSize:self.cropperView.resizeWHRatio] isEqualToValue:[NSValue valueWithCGSize:CGSizeMake(2, 3)]]) {
        [UIView animateWithDuration:0.15 animations:^{
            CGFloat w = [UIScreen mainScreen].bounds.size.width - 30;
            self.cropperView.frame = CGRectMake(15, 0, w, self.cropperView.frame.size.height);
        }];
        [self.cropperView setResizeWHRatio:CGSizeMake(3, 2) animated:YES];
    }
    else {
        [UIView animateWithDuration:0.15 animations:^{
            CGFloat w = [UIScreen mainScreen].bounds.size.width - 60;
            self.cropperView.frame = CGRectMake(30, 0, w, self.cropperView.frame.size.height);
        }];
        [self.cropperView setResizeWHRatio:CGSizeMake(2, 3) animated:YES];
    }
}

- (void)cropButtonClick:(id)sender {
    [self.cropperView cropImageWithComplete:^(UIImage *resizeImage) {
        !self.resizeImageBlock ? :self.resizeImageBlock(resizeImage);
        [self.navigationController popViewControllerAnimated:YES];
    }];
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
