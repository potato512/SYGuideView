//
//  LaunchView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/9/9.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LaunchView : UIView

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
