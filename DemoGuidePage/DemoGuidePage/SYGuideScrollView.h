//
//  GuideScrollView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/8/21.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 消失动画（直接消失，或向四周放大淡化消失，或向中间缩小淡化消失；默认直接消失）
typedef NS_ENUM(NSInteger, SYGuideAnimationType)
{
    /// 消失动画-直接消失，默认
    SYGuideAnimationTypeDefault = 0,
    
    /// 消失动画-向四周放大淡化消失
    SYGuideAnimationTypeZoomIn = 1,
    
    /// 消失动画-向中间缩小淡化消失
    SYGuideAnimationTypeZoomOut = 2
};

@interface SYGuideScrollView : UIScrollView

/// 实例化（图片命名格式：guideImage_1_640x960.png）
- (instancetype)initWithImages:(NSArray *)array;

/// 响应回调
@property (nonatomic, copy) void (^buttonClick)(void);

/// 消失动画（直接消失，或向四周放大淡化消失，或向中间缩小淡化消失；默认直接消失）
@property (nonatomic, assign) SYGuideAnimationType animationType;

/************************************************************/

/// 是否首次使用
BOOL SYAppStatusUsingGet(void);

/// 设置使用状态（非首次）
void SYAppStatusUsingSave(void);

/************************************************************/

@end
