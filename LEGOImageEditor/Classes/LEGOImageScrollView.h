//
//  LEGOImageScrollView.h
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/22.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEGOImageScrollView : UIScrollView

@property (nonatomic, strong, nullable) UIImageView *zoomView;

@property (nonatomic, assign) BOOL aspectFill;

/** 开始缩放 */
@property (nonatomic, copy) void (^beginZooming)(void);

/** 结束缩放 */
@property (nonatomic, copy) void (^didEndZooming)(CGFloat scale);

/** 开始拖动 */
@property (nonatomic, copy) void (^beginDragging)(void);

/** 结束拖动 */
@property (nonatomic, copy) void (^didEndDragging)(BOOL decelerate);


- (void)displayImage:(UIImage *)image;

- (void)notDisplaySize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
