//
//  LGImagePickerViewController.m
//  LEGOImageEditor_Example
//
//  Created by 杨庆人 on 2019/5/13.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LGImagePickerViewController.h"
#import <Photos/Photos.h>
#import <Masonry/Masonry.h>
#import "LGImagePickerAlbumModel.h"
#import "LGImagePickerAlbumCell.h"
#import "LGImageEditorViewController.h"
#import "LGImageResozerViewController.h"

@interface LGImagePickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray <LGImagePickerAlbumModel *> *albumList;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) LGImagePickerAlbumModel *selectedAlbum;
@end

@implementation LGImagePickerViewController

- (LGImagePickerAlbumModel *)selectedAlbum {
    if (!_selectedAlbum) {
        _selectedAlbum = [[LGImagePickerAlbumModel alloc] init];
    }
    return _selectedAlbum;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 0;  // 列距
        _flowLayout.minimumLineSpacing = 25;  // 行距
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        CGRect bounds = [UIScreen mainScreen].bounds;
        CGFloat item_w = bounds.size.width / 5.0;
        CGFloat item_h = bounds.size.width / 5.0;
        _flowLayout.itemSize = CGSizeMake(item_w , item_h);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LGImagePickerAlbumCell class] forCellWithReuseIdentifier:@"LGImagePickerAlbumCell"];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    __weak typeof(self)weakSelf = self;
    [self.class authorityCheckUpWithController:self  completionHandler:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
            PHFetchResult<PHAssetCollection *> *regularAssetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            NSArray <PHFetchResult<PHAssetCollection *> *> *array = @[assetCollections, regularAssetCollections];
            [weakSelf setAssetData:array];
        });
    } cancelHandler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewController];
    }];
    
//    [self changeAlbumList];

    // Do any additional setup after loading the view.
}

- (void)changeAlbumList {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.albumList containsObject:self.selectedAlbum]) {
            NSInteger index = [self.albumList indexOfObject:self.selectedAlbum];
            if (index >= self.albumList.count - 1) {
                index = 0;
            }
            else {
                index ++;
            }
            self.selectedAlbum = [self.albumList objectAtIndex:index];
            [self.collectionView reloadData];
            self.title = self.selectedAlbum.albumTitle;
        }
        [self changeAlbumList];
    });
}

- (void)setAssetData:(NSArray <PHFetchResult<PHAssetCollection *> *> *)assetCollections {
    self.albumList = [LGImagePickerAlbumModel albumModelFromAssetCollections:assetCollections];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf loadAssetDataFinish];
    });
}

- (void)loadAssetDataFinish {
    self.selectedAlbum = self.albumList.firstObject;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedAlbum.assetList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LGImagePickerAlbumCell *cell = (LGImagePickerAlbumCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LGImagePickerAlbumCell" forIndexPath:indexPath];
    LBImagePickerItemModel *item = [self.selectedAlbum.assetList objectAtIndex:indexPath.row];
    cell.item = item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    LGImageEditorViewController *vc = [[LGImageEditorViewController alloc] init];
//    LBImagePickerItemModel *item = [self.selectedAlbum.assetList objectAtIndex:indexPath.row];
//    vc.image = item.thumb;
//    vc.finish = self.finish;
//    [self.navigationController pushViewController:vc animated:YES];
    
    LGImageResozerViewController *vc = [[LGImageResozerViewController alloc] init];
    LBImagePickerItemModel *item = [self.selectedAlbum.assetList objectAtIndex:indexPath.row];
    vc.image = item.thumb;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)dismissViewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

+ (void)authorityCheckUpWithController:(UIViewController *)controller  completionHandler:(void(^)(void))completionHandler cancelHandler:(void (^)(UIAlertAction *action))cancelHandler {
    if (controller != nil && completionHandler != nil) {
        void(^authorization)(PHAuthorizationStatus) = ^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                    completionHandler();
                    break;
                case PHAuthorizationStatusDenied:
                    [self authorityAlertWithController:controller name:@"照片" cancelHandler:cancelHandler];
                    break;
                default:
                    break;
            }
        };
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined)
            [PHPhotoLibrary requestAuthorization:authorization];
        else authorization(status);
    }
}


+ (void)authorityAlertWithController:(UIViewController *)controller name:(NSString*)name cancelHandler:(void (^)(UIAlertAction *action))cancelHandler {
    if (controller != nil && name != nil) {
        NSBundle *bundle = NSBundle.mainBundle;
        NSString *appName = NSLocalizedStringFromTableInBundle(@"CFBundleDisplayName", @"InfoPlist", bundle, nil);
        NSString *title = [NSString stringWithFormat:@"没有打开“%@”访问权限", name];
        NSString *message = [NSString stringWithFormat:@"请进入“设置”-“%@”打开%@开关", appName, name];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *go = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([application canOpenURL:url]) {
                if (@available(iOS 10.0, *)) {
                    [application openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:nil];
                } else {
                    [application openURL:url];
                }
            }
            if (cancelHandler != nil) {
                cancelHandler(action);
            }
        }];
        [alert addAction:go];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelHandler];
        [alert addAction:cancel];
        [controller presentViewController:alert animated:YES completion:nil];
    }
}

@end
