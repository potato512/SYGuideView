//
//  SYGuideView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/9/18.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//

#import "SYGuideView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#define safeTop (self.hasSafeArea ? 54.0 : 30.0)

@interface SYGuideView () <CAAnimationDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, copy) void (^timeComplete)(NSTimeInterval time);

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) BOOL hasSafeArea;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, strong) NSArray *viewArray;
@property (nonatomic, strong) NSArray *clickArray;

@end

@implementation SYGuideView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"释放了 %@", self.class);
}

- (void)reloadData
{
    if (CGRectEqualToRect(self.frame, CGRectZero) && self.superview) {
        self.frame = self.superview.bounds;
    }
    if (UIGuideViewTypeDefault == self.guideType) {
        [self reloadDataImage];
    } else if (UIGuideViewTypeVideo == self.guideType) {
        [self reloadDataVideo];
    }
    [self timerStart];
}

#pragma mark - 创建视图

#pragma mark 图片

- (void)reloadDataImage
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(guideViewPages:)]) {
            self.pages = [self.delegate guideViewPages:self];
            if (self.pages <= 0) {
                self.pages = 1;
            }
        }
        if ([self.delegate respondsToSelector:@selector(guideView:page:)]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSInteger page = 0; page < self.pages; page++) {
                UIView *view = [self.delegate guideView:self page:page];
                [array addObject:view];
            }
            self.viewArray = [NSArray arrayWithArray:array];
        }
        if ([self.delegate respondsToSelector:@selector(guideView:shouldClickPage:)]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSInteger page = 0; page < self.pages; page++) {
                BOOL shouldClick = [self.delegate guideView:self shouldClickPage:page];
                NSNumber *number = [NSNumber numberWithBool:shouldClick];
                [array addObject:number];
            }
            self.clickArray = [NSArray arrayWithArray:array];
        }
        [self.collectionView reloadData];
    }
}

#pragma mark 视频

- (void)reloadDataVideo
{
    [self reloadUIWithVideo:self.filePath];
}

- (void)reloadUIWithVideo:(NSString *)filePath
{
    if (![NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        return;
    }
    
    [self addNotification];
    [self videoPlay:filePath];
}

- (void)addNotification
{
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    // [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(videoPlay:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(videoStop) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(videoPlay:) name:AVPlayerItemTimeJumpedNotification object:nil];
}

- (void)removeNotification
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)videoPlay:(NSString *)filePath
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.duration = 0.3f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.delegate = self;
    //
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:fileUrl];
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    AVPlayerLayer *playerlayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [playerlayer addAnimation:scaleAnimation forKey:nil];
    [self.layer addSublayer:playerlayer];
    playerlayer.frame = self.bounds;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.player play];
}

- (void)videoStop
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self removeNotification];
    if (self.player) {
        [self.player pause];
        self.player = nil;
    }
    NSLog(@"停止播放视频");
    [self timerStop];
    if (self.complete) {
        self.complete();
    }
    if ([self.delegate respondsToSelector:@selector(guideViewComplete:)]) {
        [self.delegate guideViewComplete:self];
    }
}

#pragma mark - getter

- (BOOL)hasSafeArea
{
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        if (window.safeAreaInsets.bottom > 0.0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - collectionView

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:(self.guideDirection == UIGuideViewDirectionVertical ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal)];
        //
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [self addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.allowsSelection = YES;
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.userInteractionEnabled = YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}

#pragma mark 代理

// 定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pages;
}

// 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    UIView *view = self.viewArray[indexPath.row];
    if (![cell.contentView.subviews containsObject:view]) {
        [cell.contentView addSubview:view];
    }
    
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout

// 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

// 定义每个UICollectionView的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

// 最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

// 最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

#pragma mark UICollectionViewDelegate

// UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //
    if ([self.delegate respondsToSelector:@selector(guideView:didClickPage:)]) {
        [self.delegate guideView:self didClickPage:indexPath.row];
    }
}

// 返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickArray && [self.clickArray isKindOfClass:NSArray.class] && self.clickArray.count > 0) {
        NSNumber *number = self.clickArray[indexPath.row];
        return number.boolValue;
    }
    return YES;
}

#pragma mark - 倒计时

- (void)timerStart:(NSTimeInterval)time complete:(void (^)(NSTimeInterval time))complete;
{
    self.time = time;
    self.timeComplete = [complete copy];
    
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction) userInfo:nil repeats:YES];
        [NSRunLoop.currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.timer.fireDate = NSDate.distantFuture;
    }
}

- (void)timerStart
{
    if (self.timer) {
        self.timer.fireDate = NSDate.distantPast;
    }
}

- (void)timerStop
{
    if (self.timer) {
        self.timer.fireDate = NSDate.distantFuture;
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerFunction
{
    if (self.timeComplete) {
        self.timeComplete(self.time);
    }
    if (self.time <= 0.0) {
        [self timerStop];
    }
    self.time--;
}

/************************************************************/

#pragma mark - 状态设置

/// 是否首次使用
BOOL GuideViewAppStatus(void)
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"GuideViewAppStatus"];
    return number.boolValue;
}

/// 设置使用状态（非首次）
void GuideViewSaveAppStatus(void)
{
    NSNumber *number = [NSNumber numberWithBool:1];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"GuideViewAppStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/************************************************************/


@end
