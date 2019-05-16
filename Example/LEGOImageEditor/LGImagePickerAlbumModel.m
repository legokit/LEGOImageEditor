//
//  LGImagePickerAlbumModel.m
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/13.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LGImagePickerAlbumModel.h"

@interface LGImagePickerAlbumModel ()
@end

@implementation LGImagePickerAlbumModel

- (NSMutableArray <LBImagePickerItemModel *> *)assetList {
    if (!_assetList) {
        _assetList = [[NSMutableArray <LBImagePickerItemModel *> alloc] init];
    }
    return _assetList;
}

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection {
    NSAssert(assetCollection != nil, @"assetCollection不可以为nil");
    if (self = [super init]) {
        _assetCollection = assetCollection;
        _albumTitle = assetCollection.localizedTitle;
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        NSMutableArray <LBImagePickerItemModel *> *assetList = [NSMutableArray arrayWithCapacity:assets.count + 1];
        BOOL isCameraRoll = assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
        if (isCameraRoll) {
            LBImagePickerItemModel *itemModel = [[LBImagePickerItemModel alloc] init];
            itemModel.cameraCell = YES;
            [assetList addObject:itemModel];
        }
        for (NSInteger i = assets.count - 1; i >= 0; i--) {
            PHAsset *asset = [assets objectAtIndex:i];
            PHAssetMediaType type = asset.mediaType;
            if ((PHAssetMediaType)PHAssetMediaTypeImage != type) continue;
            LBImagePickerItemModel *itemModel = [[LBImagePickerItemModel alloc] initWithAsset:asset];
            [assetList addObject:itemModel];
        }
        _assetList = assetList;
    }
    return self;
}

+ (NSArray <LGImagePickerAlbumModel *> *)albumModelFromAssetCollections:(NSArray <PHFetchResult<PHAssetCollection *> *> *)assetCollections {
    NSMutableArray <LGImagePickerAlbumModel *> *array = [NSMutableArray array];
    for (PHFetchResult<PHAssetCollection *> *result in assetCollections) {
        for (PHAssetCollection *assetCollection in result) {
            BOOL isCameraRoll = assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
            LGImagePickerAlbumModel *albumModel = [[LGImagePickerAlbumModel alloc] initWithAssetCollection:assetCollection];
            if (isCameraRoll) {
                [array insertObject:albumModel atIndex:0];
            } else if (albumModel.assetList.count > 0) {
                [array addObject:albumModel];
            }
        }
    }
    return array;
}

@end

@implementation LBImagePickerItemModel

static CGSize k_thumbSize = {0.f, 0.f};
+ (CGSize)thumbSize {
    if (k_thumbSize.width == 0.f) {
        UIScreen *screen = [UIScreen mainScreen];
        CGFloat width = screen.bounds.size.width*screen.scale/4.f;
        k_thumbSize = (CGSize){width, width};
    }
    return k_thumbSize;
}

+ (PHImageRequestOptions *)pictureOptions {
    static PHImageRequestOptions *k_pictureOptions = nil;
    if (k_pictureOptions == nil) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeNone;
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        k_pictureOptions = options;
    }
    return k_pictureOptions;
}

+ (PHImageRequestOptions *)pictureViewerOptions {
    static PHImageRequestOptions *k_pictureViewerOptions = nil;
    if (k_pictureViewerOptions == nil) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeNone;
        // 同步获得图片, 只会返回1张图片
        options.synchronous = NO;
        k_pictureViewerOptions = options;
    }
    return k_pictureViewerOptions;
}

+ (PHVideoRequestOptions *)videoOptions {
    static PHVideoRequestOptions *k_videoOptions = nil;
    if (k_videoOptions == nil) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        k_videoOptions = options;
    }
    return k_videoOptions;
}

- (instancetype)initWithAsset:(PHAsset *)asset {
    if (self = [super init]) {
        _asset = asset;
    }
    return self;
}

@end

