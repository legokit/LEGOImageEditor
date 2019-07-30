# LEGOImageEditor

[![CI Status](https://img.shields.io/travis/564008993@qq.com/LEGOImageEditor.svg?style=flat)](https://travis-ci.org/564008993@qq.com/LEGOImageEditor)
[![Version](https://img.shields.io/cocoapods/v/LEGOImageEditor.svg?style=flat)](https://cocoapods.org/pods/LEGOImageEditor)
[![License](https://img.shields.io/cocoapods/l/LEGOImageEditor.svg?style=flat)](https://cocoapods.org/pods/LEGOImageEditor)
[![Platform](https://img.shields.io/cocoapods/p/LEGOImageEditor.svg?style=flat)](https://cocoapods.org/pods/LEGOImageEditor)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LEGOImageEditor is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/legokit/Specs.git'
pod 'LEGOImageEditor'
```
## Usage

```

/**
 初始化方式

 @param originalImage 原图
 */
- (instancetype)initWithImage:(UIImage *)originalImage frame:(CGRect)frame;

/** 原图 */
@property (nonatomic, strong, readonly) UIImage *originalImage;

/** 最小裁剪分辨率，默认为 1.0f */
@property (nonatomic, assign) CGFloat minZoomScale;

/** 最大裁剪分辨率，默认为 MAXFLOAT */
@property (nonatomic, assign) CGFloat maxZoomScale;

/** 缩放 */
@property (nonatomic, copy) void (^didEndZooming)(CGFloat scale);

/** 裁剪框范围 */
@property (nonatomic, assign, readonly) CGRect maskRect;

/** 裁剪框尺寸 */
@property (nonatomic, assign, readonly) CGRect cropRect;

/** 裁剪框路径 */
@property (nonatomic, copy, readonly) UIBezierPath *maskPath;

/** 裁剪网格是否隐藏 */
- (void)setLineHidden:(BOOL)hidden;

/** 裁剪框颜色 */
@property (nonatomic, strong) UIColor *maskColor;

/** 裁剪框阴影 */
@property (nonatomic, strong) UIColor *shadowColor;

/** 网格线颜色 */
@property (nonatomic, strong) UIColor *shapeLayerColor;

/** 是否允许双指自由旋转，默认为 YES */
@property (nonatomic, assign, getter=isRotationEnabled) BOOL rotationEnabled;

/** 是否允许双击重置，默认为 YES */
@property (nonatomic, assign, getter=isDoubleResetEnabled) BOOL doubleResetEnabled;

/** 是否为顺势转旋转，默认为 NO */
@property (nonatomic, assign, getter=isClockwiseRotation) BOOL clockwiseRotation;

/** 是否允许旋转，当视图正在变化时，改值为 NO */
@property (nonatomic, assign, readonly) BOOL isCanRotation;

/** 是否允许修改尺寸，当视图正在变化时，改值为 NO */
@property (nonatomic, assign, readonly) BOOL isCanResizeWHScale;

/** 重置 */
- (void)reset:(BOOL)animated;

/** 设置【裁剪比例】 */
@property (nonatomic, assign) CGSize resizeWHRatio;

- (void)setResizeWHRatio:(CGSize)resizeWHRatio;

- (void)setResizeWHRatio:(CGSize)resizeWHRatio animated:(BOOL)animated;

/** 设置【旋转角度】 */
@property (nonatomic, assign) CGFloat rotationAngle;

- (void)rotation:(BOOL)animated;

- (void)setRotationAngle:(CGFloat)rotationAngle;

- (void)setRotationAngle:(CGFloat)rotationAngle animated:(BOOL)animated;

/**
 裁剪
 */
- (void)cropImageWithComplete:(void(^)(UIImage *resizeImage))complete;

```

## Author

564008993@qq.com, 564008993@qq.com

## License

LEGOImageEditor is available under the MIT license. See the LICENSE file for more info.
