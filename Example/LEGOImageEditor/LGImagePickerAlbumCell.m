//
//  LGImagePickerAlbumCell.m
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/13.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LGImagePickerAlbumCell.h"
#import <Masonry/Masonry.h>

@interface LGImagePickerAlbumCell ()
@property (nonatomic, strong) UIImageView *preview;
@end
@implementation LGImagePickerAlbumCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setImagePickerAlbumCell];
    }
    return self;
}

- (UIImageView *)preview {
    if (!_preview) {
        _preview = [[UIImageView alloc] init];
        _preview.contentMode = UIViewContentModeScaleAspectFill;
        _preview.layer.masksToBounds = YES;
    }
    return _preview;
}

- (void)setImagePickerAlbumCell {
    [self addSubview:self.preview];
    [self.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setItem:(LBImagePickerItemModel *)item {
    _item = item;
    if (item.thumb == nil) {
        __weak typeof(self) weakSelf = self;
        [[PHImageManager defaultManager] requestImageForAsset:item.asset targetSize:LBImagePickerItemModel.thumbSize contentMode:PHImageContentModeAspectFit options:LBImagePickerItemModel.pictureViewerOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [weakSelf updateThumb:result];
        }];
    }
    else {
        self.preview.image = item.thumb;
    }
}

- (void)updateThumb:(UIImage *)thumb {
    self.item.thumb = thumb;
    self.preview.image = thumb;
}

@end
