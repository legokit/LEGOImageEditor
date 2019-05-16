//
//  LGImageEditorView.h
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/15.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//
//  CameraCutView.h
//  ImageCut
//
//  Created by huizai on 2018/7/3.
//  Copyright © 2018年 huizai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGImageEditorView : UIView
@property (nonatomic)  UIImage * mTargetImage;
@property (nonatomic)  UIImage * mResultImage;
@property (nonatomic,assign) CGFloat ImgCutHeight;
@property (nonatomic,assign) CGSize originalImageViewSize;

-(void) showCoverViewWithTargetImg;
//frame 相对于当前屏幕坐标 当前屏幕当中的裁剪范围
-(UIImage*) cutImageWithSpecificRect:(CGRect)frame;

@end

