//
//  LGImageEditorViewController.m
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/14.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LGImageEditorViewController.h"
#import <Masonry/Masonry.h>
#import "LGImagePickerAlbumModel.h"
#import "UIView+HYDView.h"

#define item_h(w,size) (w / size.width * size.height)


@interface LGImageEditorViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) CGRect maskRect;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign)  NSInteger rotateIndex;


@end

@implementation LGImageEditorViewController

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
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"done" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)]];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    [self.view addSubview:self.imageView];
    self.imageView.frame = CGRectMake(0, 0, bounds.size.width, item_h(bounds.size.width, self.image.size));
    self.imageView.center = self.view.center;
    
    CGFloat mask_w = bounds.size.width;
    CGFloat mask_h = mask_w / 3.0 * 2.0;
    self.maskRect = CGRectMake(0, CGRectGetMidY(self.view.frame) - mask_h / 2.0, mask_w, mask_h);
    self.scale = self.image.size.width / [UIScreen mainScreen].bounds.size.width;
    [self addMaskByMaskRect:self.maskRect cornerRadii:CGSizeMake(0, 0)];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imageView addGestureRecognizer:pan];
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    rotation.delegate = self;
    [self.imageView addGestureRecognizer:rotation];
    UIPinchGestureRecognizer *zoom = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
    zoom.delegate = self;
    [self.imageView addGestureRecognizer:zoom];
    
    // Do any additional setup after loading the view.
}

#pragma mark rotateBtn target
-(void)clickRotateBtn:(UIButton *)sender{
    CGSize rotateSize;
//    sender.enabled = NO;
    
    self.rotateIndex ++;
    if (self.rotateIndex == 4) {
        self.rotateIndex = 0;
    }
    
//    if (self.rotateIndex%2 != 0) {
//        rotateSize = CGSizeMake(self.imageView.size.height, self.imageView.size.width);
//    }else{
//        rotateSize = CGSizeMake(self.imageView.size.width, self.imageView.size.height);
//    }
    rotateSize = CGSizeMake(self.imageView.size.width, self.imageView.size.height);
    static CGFloat scale;
    static CGRect oldRect;
    oldRect = self.imageView.frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.imageView.transform= CGAffineTransformMakeRotation(M_PI_2*self.rotateIndex);
        CGRect rect = [self calculateRect:rotateSize];
        self.imageView.frame = rect;
        
        scale = rect.size.height/oldRect.size.width;
        
    } completion:^(BOOL finished) {
//        [self.cropOverlayView rotatingImage:self.imageView.frame andscale:scale];
//        [UIView animateWithDuration:0.3 animations:^{
//            self.cropOverlayView.alpha = 1;
//        }completion:^(BOOL finished) {
//            sender.enabled = YES;
//        }];
        
        
    }];
}

-(CGRect)calculateRect:(CGSize)size{
    CGFloat scale,scaleW,scaleH;
    CGFloat imageViewW,imageViewH;
    
    scaleW = size.width / self.view.size.width;
    scaleH = size.height / self.view.size.height;
    
    scale = fmax(scaleW, scaleH);
    imageViewW = size.width / scale;
    imageViewH = size.height / scale;
    
    self.scale = scale;
    
    CGFloat x = (self.view.size.width - imageViewW)/2;
    CGFloat y = (self.view.size.height - imageViewH)/2;
    
    CGRect lastRect = CGRectMake(x, y, imageViewW, imageViewH);
    return lastRect;
}


- (void)rightAction:(id)sender {
    CGRect maskRect = self.maskRect;
    
    UIImage *image = self.imageView.image;
    
    // mask相对于imageView的区域
//    maskRect = CGRectMake((maskRect.origin.x - self.imageView.frame.origin.x)  * self.scale, (maskRect.origin.y - self.imageView.frame.origin.y) * self.scale, maskRect.size.width * self.scale, maskRect.size.height * self.scale);
     CGRect cropFrame = [self.view convertRect:maskRect toView:self.imageView];
    
    CGFloat imageScale = image.scale;
    CGFloat imageWidth = image.size.width * imageScale;
    CGFloat imageHeight = image.size.height * imageScale;
    
    CGFloat scale = imageWidth / self.imageView.bounds.size.width;
    
    // 宽高比不变，所以宽度高度的比例是一样
    CGFloat orgX = cropFrame.origin.x * scale;
    CGFloat orgY = cropFrame.origin.y * scale;
    CGFloat width = cropFrame.size.width * scale;
    CGFloat height = cropFrame.size.height * scale;
    CGRect cropRect = CGRectMake(orgX, orgY, width, height);
    
    image = [self maskRect:cropRect scale:scale rotation:0 image:self.imageView.image angle:self.rotateIndex];
    LGImageEditorViewController *vc = [[LGImageEditorViewController alloc] init];
    vc.image = image;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIImage *)maskRect:(CGRect)maskRect scale:(CGFloat)scale rotation:(CGFloat)rotation image:(UIImage *)image angle:(NSInteger)angle {
    
    UIImage *croppedImage = nil;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(maskRect.size.width, maskRect.size.height), YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    

//    UIGraphicsBeginImageContextWithOptions(cropSize, 0, deviceScale);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(context, 0, cropSize.height);
//    CGContextScaleCTM(context, 1, -1);
//    CGContextDrawImage(context, CGRectMake(0, 0, cropSize.width, cropSize.height), resizeImg.CGImage);
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    if (angle != 0) {
        //            UIImageView *imageView = [[UIImageView alloc] initWithImage:self];
        //            imageView.layer.minificationFilter = @"nearest";
        //            imageView.layer.magnificationFilter = @"neareset";
        //            imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2*angle);
        //            CGRect rotatedRect = CGRectApplyAffineTransform(imageView.bounds, imageView.transform);
        //            UIView *containerView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, rotatedRect.size}];
        //            [containerView addSubview:imageView];
        //            imageView.center = containerView.center;
        //            CGContextTranslateCTM(context, -cropRect.origin.x, -cropRect.origin.y);
        //            [imageView.layer renderInContext:context];
        
        CGContextRotateCTM(context, M_PI_2*angle);
        if (angle == 1) {
            CGContextScaleCTM(context, 1, -1);
            CGContextTranslateCTM(context, -maskRect.origin.y, -maskRect.origin.x);
        }else if (angle == 2){
            CGContextScaleCTM(context, 1, -1);
            CGContextTranslateCTM(context, -image.size.width, 0);
            CGContextTranslateCTM(context, maskRect.origin.x, -maskRect.origin.y);
        }else if (angle == 3){
            CGContextScaleCTM(context, 1, -1);
            CGContextTranslateCTM(context, -image.size.width, -image.size.height);
            CGContextTranslateCTM(context, maskRect.origin.y, maskRect.origin.x);
        }
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    }
    else {
        //            CGContextTranslateCTM(context, -cropRect.origin.x, -cropRect.origin.y);
        //            [self drawAtPoint:drawPoint];
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -image.size.height);
        CGContextTranslateCTM(context, -maskRect.origin.x, maskRect.origin.y);
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    }
    
//    CGContextScaleCTM(context, 1, -1);
//    CGContextTranslateCTM(context, 0, -image.size.height);
//    CGContextTranslateCTM(context, -maskRect.origin.x, maskRect.origin.y);

//    CGContextScaleCTM(context, scale, scale);
//    CGContextRotateCTM(context, rotation);

//    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);

    croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

- (void)addMaskByMaskRect:(CGRect)maskRect cornerRadii:(CGSize)cornerRadii {
    UIView *guideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    guideView.userInteractionEnabled = NO;
    guideView.backgroundColor = [UIColor blackColor];
    guideView.alpha = 0.6;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    path.usesEvenOddFillRule = YES;
    UIBezierPath *tempPath = [UIBezierPath bezierPathWithRoundedRect:maskRect byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight |UIRectCornerBottomRight|UIRectCornerBottomLeft) cornerRadii:cornerRadii];
    [path appendPath:tempPath];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor blackColor].CGColor;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    guideView.layer.mask = shapeLayer;
    [self.view addSubview:guideView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    // 拖动
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:self.imageView];
        self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, translation.x, translation.y);
        [pan setTranslation:CGPointZero inView:self.imageView];
    }
    
    NSLog(@"==============================");
    
    NSLog(@"rotation=%f",self.imageView.rotation);
    NSLog(@"xscale=%f",self.imageView.xscale);
    NSLog(@"yscale=%f",self.imageView.yscale);
    NSLog(@"tx=%f",self.imageView.tx);
    NSLog(@"ty=%f",self.imageView.ty);

    NSLog(@"==============================");
}

- (void)rotation:(UIRotationGestureRecognizer *)rotation {
    // 旋转
//    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, rotation.rotation);
//    rotation.rotation = 0.f;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (point.y > self.view.bounds.size.height - 300) {
        [self clickRotateBtn:nil];
    }
}

- (void)zoom:(UIPinchGestureRecognizer *)zoom {
    // 缩放
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, zoom.scale, zoom.scale);
    zoom.scale = 1;
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
