//
//  SYGuideViewDelegate.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/9/22.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//

#ifndef SYGuideViewDelegate_h
#define SYGuideViewDelegate_h
@class SYGuideView;

@protocol SYGuideViewDelegate <NSObject>

/// 页数（默认1）
- (NSInteger)guideViewPages:(SYGuideView *)guideView;
/// 自定义视图
- (UIView *)guideView:(SYGuideView *)guideView page:(NSInteger)index;
/// 点击页面
- (void)guideView:(SYGuideView *)guideView didClickPage:(NSInteger)index;
/// 页面是否可点击（默认YES）
- (BOOL)guideView:(SYGuideView *)guideView shouldClickPage:(NSInteger)index;
/// 完成时
- (void)guideViewComplete:(SYGuideView *)guideView;

@end

#endif /* SYGuideViewDelegate_h */
