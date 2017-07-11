//
//  SYGuideHeader.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/7/11.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#ifndef SYGuideHeader_h
#define SYGuideHeader_h

/// 消失动画（默认直接消失、向四周放大淡化消失、向中间缩小淡化消失）
typedef NS_ENUM(NSInteger, SYGuideAnimationType)
{
    /// 消失动画-直接消失，默认
    SYGuideAnimationTypeDefault = 0,
    
    /// 消失动画-向四周放大淡化消失
    SYGuideAnimationTypeZoomIn = 1,
    
    /// 消失动画-向中间缩小淡化消失
    SYGuideAnimationTypeZoomOut = 2
};

/// 引导页视图类型（默认图片轮播、动图、视频）
typedef NS_ENUM (NSInteger, SYGuideViewType)
{
    /// 引导页视图类型-图片轮播，默认
    SYGuideViewTypeDefault = 0,
    
    /// 引导页视图类型-动图
    SYGuideViewTypeGif = 0,
    
    /// 引导页视图类型-视频
    SYGuideViewTypeVideo = 0,
};

#endif /* SYGuideHeader_h */
