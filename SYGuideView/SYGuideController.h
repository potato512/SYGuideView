//
//  SYGuideController.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/9/18.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//  https://github.com/potato512/SYGuideView

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 消失动画（默认直接消失、向四周放大淡化消失、向中间缩小淡化消失）
typedef NS_ENUM(NSInteger, UIGuideAnimationType) {
    /// 消失动画-直接消失，默认
    UIGuideAnimationTypeDefault,
    /// 消失动画-向四周放大淡化消失
    UIGuideAnimationTypeZoomIn,
    /// 消失动画-向中间缩小淡化消失
    UIGuideAnimationTypeZoomOut,
    /// 消失动画-向下隐藏淡化消失
    UIGuideAnimationTypeDown
};

/// 引导页视图类型（默认图片轮播、动图、视频）
typedef NS_ENUM (NSInteger, UIGuideViewType) {
    /// 引导页视图类型-图片轮播，默认
    UIGuideViewTypeDefault,
    /// 引导页视图类型-动图
    UIGuideViewTypeGif,
    /// 引导页视图类型-视频
    UIGuideViewTypeVideo
};

/// 引导页引藏类型（默认无倒计时手动隐藏，倒计时隐藏，倒计时过程中手动隐藏，倒计时后手动隐藏）
typedef NS_ENUM (NSInteger, UIGuideHideType) {
    /// 引导页引藏类型-默认无倒计时手动隐藏
    UIGuideHideTypeDefault,
    /// 引导页引藏类型-倒计时隐藏
    UIGuideHideTypeCountdown,
    /// 引导页引藏类型-倒计时过程中手动隐藏
    UIGuideHideTypeCountdownShould,
    /// 引导页引藏类型-倒计时后手动隐藏
    UIGuideHideTypeCountdownDid
};

@interface SYGuideController : UIViewController

- (void)reloadData;

/// 引导图组（图片命名格式：guideImage_1_640x960.png，或图片命名格式：guideImage_1.png）
@property (nonatomic, strong) NSArray *images;
/// 引导图
@property (nonatomic, strong) NSArray *animationImages;
/// 视频
@property (nonatomic, strong) NSString *filePath;
/// 完成后回调
@property (nonatomic, copy) void (^guideComplete)(void);

/// 按钮（默认全屏/无标题/无背景色。便于设置相关属性，如标题，位置大小。）
@property (nonatomic, strong, readonly) UIButton *button;

/// 引导页视图类型（默认图片轮播、动图、视频）
@property (nonatomic, assign) UIGuideViewType guideType;

/// 是否自适配机型（默认NO，文件命名规则：xxx_1_640X960.png，使用时：xxx_1）
@property (nonatomic, assign) BOOL autoLayout;

/// 消失动画（直接消失，或向四周放大淡化消失，或向中间缩小淡化消失；默认直接消失）
@property (nonatomic, assign) UIGuideAnimationType animationType;
/// 动画消失时间（默认0.6秒）
@property (nonatomic, assign) NSTimeInterval animationTime;

/// 向左滑动消失（默认NO，YES时，按钮无效）
@property (nonatomic, assign) BOOL isSlide;

/// 引导页引藏类型（默认无倒计时手动隐藏，倒计时隐藏，倒计时过程中手动隐藏，倒计时后手动隐藏）
@property (nonatomic, assign) UIGuideHideType hideType;
/// 计时器时间（默认3秒）
@property (nonatomic, assign) NSTimeInterval autoTime;


/************************************************************/

/// 是否首次使用
BOOL GuideViewAppStatus(void);

/// 设置使用状态（非首次）
void GuideViewSaveAppStatus(void);

/************************************************************/

@end

NS_ASSUME_NONNULL_END
