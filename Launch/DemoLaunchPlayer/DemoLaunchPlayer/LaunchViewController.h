//
//  LaunchViewController.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/9/11.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 自动跳转倒计时样式 秒数、进度、边框
typedef NS_ENUM(NSInteger, AutoSkipType) {
    /// 自动跳转倒计时样式 秒数
    AutoSkipTypeDefault,
    /// 自动跳转倒计时样式 进度
    AutoSkipTypeProgress,
    /// 自动跳转倒计时样式 边框
    AutoSkipTypeBorder,
};

@interface LaunchViewController : AVPlayerViewController

/// 按钮
@property (nonatomic, strong) UIButton *button;

/// 是否自动跳转（默认自动）
@property (nonatomic, assign) BOOL autoSkip;
/// 自动跳转倒进时（默认3秒）
@property (nonatomic, assign) NSTimeInterval autoSkipTime;
/// 自动跳转倒计时样式
@property (nonatomic, assign) AutoSkipType skipTime;

/// 延迟时间
@property (nonatomic, assign) NSTimeInterval delayTime;
/// 默认图片
@property (nonatomic, strong) NSString *defaultImage;

/// 启动静态图（单图，或多图，多图时动画效果）
- (void)launchWithImage:(NSArray <UIImage *>*)images complete:(void (^)(void))complete;
/// 启动视频
- (void)launchWithVideo:(NSString *)fileName complete:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
