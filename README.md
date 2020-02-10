# LEGOImageEditor

LEGOImageEditor, crop image, Picture cropper, support to resizeWHScale, set size, rotate angle, fine adjust angle, image crop. 图片裁剪，支持大小缩放，设置大小，旋转角度，微调角度，裁剪图片。。

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LEGOPhotosManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/legokit/Specs.git'
pod 'LEGOImageEditor'
```

**LEGOImageEditor** is the image crop tool, you can crop image, Picture cropper, support to resizeWHScale, set size, rotate angle, fine adjust angle, image crop. 图片裁剪，支持大小缩放，设置大小，旋转角度，微调角度，裁剪图片

## Features

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Features

- [x] Resize WH Scale.  缩放尺寸
- [x] Allow two fingers rotate angle freely.  双指调整缩放旋转
- [x] rotate angle by control.  角度外部控制
- [x] Angle fine tuning.  角度微调  
- [x] Double click to reset picture.  双击重置

## Requirements

- iOS 8.0+
- Xcode 10.0+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate LEGOImageCropper into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/legokit/Specs.git'
pod 'LEGOImageEditor'
```

### Manually

If you prefer not to use any of the dependency mentioned above, you can integrate LEGOImageCropper into your project manually. Just drag & drop the `Sources` folder to your project.

## Usage

```
/** crop picture 裁剪方法实例 */

    [self.imageCropperView cropImageWithComplete:^(UIImage *resizeImage) {
        NSLog(@"resizeImage=%@",resizeImage);
    }];
    
```


For details, see example for LEGOImageCropper.

## Author

564008993@qq.com, yangqingren@yy.com

## License

LEGOImageEditor is available under the MIT license. See the LICENSE file for more info.



