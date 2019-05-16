//
//  JPImageresizerTypedef.h
//  Pods
//
//  Created by 周健平 on 2018/4/22.
//
//  JPImageresizerTypedef：公共类型定义

#pragma mark - 枚举

/**
 * 当前方向
 * JPImageresizerVerticalUpDirection：     垂直向上
 * JPImageresizerHorizontalLeftDirection： 水平向左
 * JPImageresizerVerticalDownDirection：   垂直向下
 * JPImageresizerHorizontalRightDirection：水平向右
 */
typedef NS_ENUM(NSUInteger, JPImageresizerRotationDirection) {
    JPImageresizerVerticalUpDirection = 0,  // default
    JPImageresizerHorizontalLeftDirection,
    JPImageresizerVerticalDownDirection,
    JPImageresizerHorizontalRightDirection
};
