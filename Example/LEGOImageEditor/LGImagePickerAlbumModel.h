//
//  LGImagePickerAlbumModel.h
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/13.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@class LBImagePickerItemModel;
NS_ASSUME_NONNULL_BEGIN

@interface LGImagePickerAlbumModel : NSObject
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, strong) NSMutableArray <LBImagePickerItemModel *> *assetList;

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection;

+ (NSArray <LGImagePickerAlbumModel *> *)albumModelFromAssetCollections:(NSArray <PHFetchResult<PHAssetCollection *> *> *)assetCollections;

@end

@interface LBImagePickerItemModel : NSObject
@property (nonatomic, class) CGSize thumbSize;
@property (nonatomic, class) PHImageRequestOptions *pictureViewerOptions;
@property (nonatomic, class) PHImageRequestOptions *pictureOptions;
@property (nonatomic, class) PHVideoRequestOptions *videoOptions;
@property (nonatomic, assign, getter=isCameraCell) BOOL cameraCell;
@property (nonatomic, assign, getter=isLoseFocus) BOOL loseFocus;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *thumb;

- (instancetype)initWithAsset:(PHAsset *)asset;
@end

NS_ASSUME_NONNULL_END
