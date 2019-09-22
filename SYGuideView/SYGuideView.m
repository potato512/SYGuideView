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

/********************************************************/

static CGFloat const widthButton = 60.0;
static CGFloat const heightButton = 35.0;

// 图片名称命名示例：guideImage_1_640x960.png，即" guideImage_1 "、" _640x960.png "
static NSString *const image4  = @"_640x960";
static NSString *const image5  = @"_640x1136";
static NSString *const image6  = @"_750x1334";
static NSString *const image6P = @"_1242x2208";

#define isiPhone4  ([[UIScreen mainScreen] bounds].size.height < 568.0)
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568.0)
#define isiPhone6  ([[UIScreen mainScreen] bounds].size.height == 667.0)
#define isiPhone6P ([[UIScreen mainScreen] bounds].size.height > 667.0)

#define safeTop (self.hasSafeArea ? 54.0 : 30.0)

/********************************************************/

@interface SYGuideView () <UIScrollViewDelegate, CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray *imageviewArray;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, assign, readonly) NSInteger imageCount;
@property (nonatomic, assign, readonly) CGFloat imageWidth;
//
@property (nonatomic, strong) AVPlayer *player;
//
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL hasSafeArea;


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger pages;

@end

@implementation SYGuideView

@synthesize isSlide = _isSlide;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.backgroundColor = UIColor.clearColor;
        [self initialize];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"释放了 %@", self.class);
}

- (void)initialize
{
//    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:_scrollView];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.userInteractionEnabled = YES;
    //
    self.autoLayout = NO;
    self.animationTime = 0.6;
    self.autoTime = 3.0;
}

- (void)reloadData
{
    if (self.superview) {
        self.frame = self.superview.bounds;
    }
    if (self.guideType == UIGuideViewTypeDefault) {
        [self reloadUIWithImages:self.images];
    } else if (self.guideType == UIGuideViewTypeGif) {
        
    } else if (self.guideType == UIGuideViewTypeVideo) {
        [self reloadUIWithVideo:self.filePath];
    }
    [self reloadUICountdown];
}

#pragma mark - 创建视图

#pragma mark 图片数组或广告

- (void)reloadUIWithImages:(NSArray *)array
{
    if (array) {
        NSInteger count = array.count;
        self.imageviewArray = [[NSMutableArray alloc] initWithCapacity:count];
        for (NSInteger i = 0; i < count; i++) {
            CGRect rect = CGRectMake((i * self.frame.size.width), 0.0, self.frame.size.width, self.frame.size.height);
            NSString *imageName = array[i];
            if (self.autoLayout) {
                imageName = [[NSString alloc] initWithFormat:@"%@%@", imageName, self.class.iPhoneTypeName];
            }
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
            [self addSubview:imageview];
            imageview.layer.masksToBounds = YES;
            imageview.backgroundColor = [UIColor clearColor];
            imageview.contentMode = UIViewContentModeScaleAspectFill;
            imageview.image = [UIImage imageNamed:imageName];
            
            [self.imageviewArray addObject:imageview];
            
            if (i == count - 1) {
                imageview.userInteractionEnabled = YES;
                if (self.actionButton.superview == nil) {
                    [imageview addSubview:self.actionButton];
                }
            }
        }
        
        self.contentSize = CGSizeMake(count * self.frame.size.width, self.frame.size.height);
    }
}

#pragma mark 动图

- (void)reloadUIWithGif:(NSString *)image
{
    
}

#pragma mark 视频播放

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
    if (self.guideComplete) {
        self.guideComplete();
    }
}

#pragma mark 倒计时

- (void)reloadUICountdown
{
    if (self.guideType == UIGuideViewTypeDefault) {
        
    } else if (self.guideType == UIGuideViewTypeGif) {
        
    } else if (self.guideType == UIGuideViewTypeVideo) {
        return;
    }
    
    self.actionButton.enabled = NO;
    switch (self.hideType) {
        case UIGuideHideTypeCountdown:
        case UIGuideHideTypeCountdownShould:
        case UIGuideHideTypeCountdownDid:
            self.actionButton.frame = CGRectMake((self.actionButton.superview.frame.size.width - widthButton - 20), safeTop, widthButton, heightButton);
            self.actionButton.layer.borderColor = UIColor.redColor.CGColor;
            self.actionButton.layer.borderWidth = 1.0;
            self.actionButton.layer.cornerRadius = heightButton / 2;
            [self timerStart];
            break;
            
        default:
            self.actionButton.enabled = YES;
            break;
    }
}

#pragma mark - 响应事件

- (void)buttonActionClick
{
    [self hiddenImageView];
    [self timerStop];
}

#pragma mark - 方法

- (void)hiddenImageView
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    if (self.isSlide) {
        // 向左滑动消失
        UIImageView *imageview = self.imageviewArray.lastObject;
        
        [UIView animateWithDuration:self.animationTime animations:^{
            CGRect rect = imageview.frame;
            rect.origin.x -= self.imageWidth;
            imageview.frame = rect;
            imageview.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (self.superview) {
                [self removeFromSuperview];
            }
            if (self.guideComplete) {
                self.guideComplete();
            }
        }];
    } else {
        if (UIGuideAnimationTypeDefault == self.animationType) {
            // 直接消失
            if (self.superview) {
                [self removeFromSuperview];
            }
            if (self.guideComplete) {
                self.guideComplete();
            }
        } else if (UIGuideAnimationTypeZoomIn == self.animationType) {
            // 放大淡化再消失
            UIImageView *imageview = self.imageviewArray.lastObject;
            
            [UIView animateWithDuration:self.animationTime animations:^{
                imageview.transform = CGAffineTransformMakeScale(1.6, 1.6);
                imageview.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (self.superview) {
                    [self removeFromSuperview];
                }
                if (self.guideComplete) {
                    self.guideComplete();
                }
            }];
        } else if (UIGuideAnimationTypeZoomOut == self.animationType) {
            // 缩小淡化再消失
            UIImageView *imageview = self.imageviewArray.lastObject;
            
            [UIView animateWithDuration:self.animationTime animations:^{
                imageview.transform = CGAffineTransformMakeScale(0.6, 0.6);
                imageview.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (self.superview) {
                    [self removeFromSuperview];
                }
                if (self.guideComplete) {
                    self.guideComplete();
                }
            }];
        } else if (UIGuideAnimationTypeDown == self.animationType) {
            // 向下淡化再消失
            UIImageView *imageview = self.imageviewArray.lastObject;
            
            [UIView animateWithDuration:self.animationTime animations:^{
                imageview.frame = CGRectMake(imageview.frame.origin.x, imageview.frame.size.height, imageview.frame.size.width, imageview.frame.size.height);
                imageview.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (self.superview) {
                    [self removeFromSuperview];
                }
                if (self.guideComplete) {
                    self.guideComplete();
                }
            }];
        }
    }
}

+ (NSString *)iPhoneTypeName
{
    if (isiPhone4) {
        return image4;
    } else if (isiPhone5) {
        return image5;
    } else if (isiPhone6) {
        return image6;
    } else if (isiPhone6P) {
        return image6P;
    }
    
    return image4;
}

#pragma mark - setter/getter

- (UIButton *)actionButton
{
    if (_actionButton == nil) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *imageView = self.imageviewArray.lastObject;
        [imageView addSubview:_actionButton];
        _actionButton.frame = imageView.bounds;
        _actionButton.backgroundColor = UIColor.clearColor;
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_actionButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(buttonActionClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

- (UIButton *)button
{
    return self.actionButton;
}

- (NSInteger)imageCount
{
    return self.imageviewArray.count;
}

- (CGFloat)imageWidth
{
    return self.frame.size.width;
}

- (void)setIsSlide:(BOOL)isSlide
{
    _isSlide = isSlide;
    if (_isSlide) {
        self.delegate = self;
        self.actionButton.hidden = YES;
    } else {
        self.actionButton.hidden = NO;
    }
}

- (BOOL)isSlide
{
    return _isSlide;
}

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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isSlide) {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger page = offsetX / self.imageWidth;
        
        if (page >= self.imageCount - 1) {
            self.bounces = YES;
            
            CGFloat hiddenOffsetX = ((self.imageCount - 1) * self.imageWidth + self.imageWidth / 5);
            if (offsetX >= hiddenOffsetX) {
                [self hiddenImageView];
            }
        } else {
            self.bounces = NO;
        }
    }
}

#pragma mark - 定时器

- (void)timerStart
{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction) userInfo:nil repeats:YES];
        [NSRunLoop.currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.timer.fireDate = NSDate.distantPast;
    }
}

- (void)timerStop
{
    NSLog(@"1 timer: %@", self.timer);
    if (self.timer) {
        self.timer.fireDate = NSDate.distantFuture;
        [self.timer invalidate];
        self.timer = nil;
    }
    NSLog(@"2 timer：%@", self.timer);
}

- (void)timerFunction
{
    NSLog(@"1 %.0fs", self.autoTime);
    NSString *title = [NSString stringWithFormat:@"%.0fs", self.autoTime];
    NSLog(@"2 %.0fs", self.autoTime);
    if (self.hideType == UIGuideHideTypeCountdown) {
        if (self.autoTime <= 0.0) {
            [self timerStop];
            title = @"跳过";
            sleep(1.0);
            [self hiddenImageView];
        }
    } else if (self.hideType == UIGuideHideTypeCountdownShould) {
        self.actionButton.enabled = YES;
        title = [NSString stringWithFormat:@"%.0fs 跳过", self.autoTime];
        if (self.autoTime <= 0.0) {
            [self timerStop];
            title = @"跳过";
        }
    } else if (self.hideType == UIGuideHideTypeCountdownDid) {
        if (self.autoTime <= 0.0) {
            [self timerStop];
            title = @"跳过";
            self.actionButton.enabled = YES;
        }
    }
    [self.actionButton setTitle:title forState:UIControlStateNormal];
    self.autoTime--;
    NSLog(@"3 %.0fs", self.autoTime);
}


#pragma mark - delegate

- (void)reloadDataDelegate
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(guideViewPages:)]) {
            self.pages = [self.delegate guideViewPages:self];
            if (self.pages <= 0) {
                self.pages = 1;
            }
        }
        if ([self.delegate respondsToSelector:@selector(guideView:page:)]) {
            for (NSInteger page = 0; page < self.pages; page++) {
                UIView *view = [self.delegate guideView:self page:page];
            }
        }
        if ([self.delegate respondsToSelector:@selector(guideView:didClickPage:)]) {
            for (NSInteger page = 0; page < self.pages; page++) {
                [self.delegate guideView:self didClickPage:page];
            }
        }
    }
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:nil];
    }
    return _collectionView;
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
