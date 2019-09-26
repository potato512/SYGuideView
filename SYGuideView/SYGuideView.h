//
//  SYGuideView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/9/18.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//  https://github.com/potato512/SYGuideView

#import <UIKit/UIKit.h>
#import "SYGuideViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// 引导页视图类型（默认图片、视频）
typedef NS_ENUM (NSInteger, UIGuideViewType) {
    /// 引导页视图类型-图片，默认
    UIGuideViewTypeDefault,
    /// 引导页视图类型-视频
    UIGuideViewTypeVideo
};

/// 引导页导航方向（默认水平，垂直）
typedef NS_ENUM(NSInteger, UIGuideViewDirection) {
    /// 引导页导航方向 默认水平
    UIGuideViewDirectionHorizontal,
    /// 引导页导航方向 垂直
    UIGuideViewDirectionVertical
};

@interface SYGuideView : UIView

- (void)reloadData;

@property (nonatomic, weak) id<SYGuideViewDelegate> delegate;

/// 视频
@property (nonatomic, strong) NSString *filePath;
/// 引导页视图类型（默认图片、视频）
@property (nonatomic, assign) UIGuideViewType guideType;
/// 引导页导航方向（默认水平，垂直）
@property (nonatomic, assign) UIGuideViewDirection guideDirection;
/// 响应回调（UIGuideViewTypeVideo有效）
@property (nonatomic, copy) void (^complete)(void);

/************************************************************/

- (void)timerStart:(NSTimeInterval)time complete:(void (^)(SYGuideView *guideView, NSTimeInterval time))complete;
- (void)timerStop;

/************************************************************/

/// 是否首次使用
BOOL GuideViewAppStatus(void);

/// 设置使用状态（非首次）
void GuideViewSaveAppStatus(void);

/************************************************************/

@end

NS_ASSUME_NONNULL_END
