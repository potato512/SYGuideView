//
//  SYGuideView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/8/21.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGuideHeader.h"

@interface SYGuideView : UIScrollView

+ (instancetype)new __attribute__((unavailable("new 方法不可用，请用 initWithImages:")));
- (instancetype)init __attribute__((unavailable("init 方法不可用，请用 initWithImages:")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("initWithFrame 方法不可用，请用 initWithImages:")));
/// 实例化（图片命名格式：guideImage_1_640x960.png）
- (instancetype)initWithImages:(NSArray *)array;


/// 按钮（默认全屏/无标题/无背景色。便于设置相关属性，如标题，位置大小。）
@property (nonatomic, strong, readonly) UIButton *button;
/// 响应回调
@property (nonatomic, copy) void (^buttonClick)(void);

/// 消失动画（直接消失，或向四周放大淡化消失，或向中间缩小淡化消失；默认直接消失）
@property (nonatomic, assign) SYGuideAnimationType animationType;
/// 动画消失时间（默认0.6秒）
@property (nonatomic, assign) NSTimeInterval animationTime;

/// 向左滑动消失（默认NO，YES时，按钮无效）
@property (nonatomic, assign) BOOL isSlide;

/// 计时器消失
@property (nonatomic, assign) BOOL isAutoHidden;
/// 计时器时间（默认3秒）
@property (nonatomic, assign) NSTimeInterval autoTime;


/************************************************************/

/// 是否首次使用
+ (BOOL)readAppStatus;

/// 设置使用状态（非首次）
+ (void)saveAppStatus;

/************************************************************/

@end
