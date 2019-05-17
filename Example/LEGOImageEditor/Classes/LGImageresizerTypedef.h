//
//  LGImageresizerTypedef.h
//  LEGOImageEditor
//
//  Created by 杨庆人 on 2019/5/17.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#ifndef LGImageresizerTypedef_h
#define LGImageresizerTypedef_h
/**
 * 当前方向
 * LGImageresizerVerticalUpDirection：     垂直向上
 * LGImageresizerHorizontalLeftDirection： 水平向左
 * LGImageresizerVerticalDownDirection：   垂直向下
 * LGImageresizerHorizontalRightDirection：水平向右
 */
typedef NS_ENUM(NSUInteger, LGImageresizerRotationDirection) {
    LGImageresizerVerticalUpDirection = 0,  // default
    LGImageresizerHorizontalLeftDirection,
    LGImageresizerVerticalDownDirection,
    LGImageresizerHorizontalRightDirection
};

#endif /* LGImageresizerTypedef_h */
