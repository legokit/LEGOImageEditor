//
//  UISliderControl.h
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/23.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UISliderView;
@protocol UISliderControlDelegate <NSObject>
@optional
- (void)beginTrackingWithTouch;
- (void)continueTrackingWithTouch:(CGFloat)value;
- (void)endTrackingWithTouch;
@end

@interface UISliderControl : UIControl
@property (nonatomic, weak) id <UISliderControlDelegate> delegate;
@property(nonatomic, assign) float value;
@property(nonatomic, assign) float minimumValue;
@property(nonatomic, assign) float maximumValue;
@end


@interface UISliderView : UIView

@end
