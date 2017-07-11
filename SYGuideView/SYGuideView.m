//
//  SYGuideView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/8/21.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "SYGuideView.h"

/********************************************************/

// 图片名称命名示例：guideImage_1_640x960.png，即" guideImage_1 "、" _640x960.png "
static NSString *const image4  = @"_640x960";
static NSString *const image5  = @"_640x1136";
static NSString *const image6  = @"_750x1334";
static NSString *const image6P = @"_1242x2208";

#define isiPhone4  ([[UIScreen mainScreen] bounds].size.height < 568.0)
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568.0)
#define isiPhone6  ([[UIScreen mainScreen] bounds].size.height == 667.0)
#define isiPhone6P ([[UIScreen mainScreen] bounds].size.height > 667.0)

/********************************************************/

@interface SYGuideView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageviewArray;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, assign, readonly) NSInteger imageCount;
@property (nonatomic, assign, readonly) CGFloat imageWidth;

@end

@implementation SYGuideView

@synthesize isSlide = _isSlide;

- (instancetype)initWithImages:(NSArray *)array
{
    self = [super init];
    if (self)
    {
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.animationTime = 0.6;
        
        UIView *bgView = [UIApplication sharedApplication].delegate.window;
        [bgView addSubview:self];
        self.frame = bgView.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.userInteractionEnabled = YES;
        
        [self setUIWithImages:array];
    }
    
    return self;
}

#pragma mark - 创建视图

- (void)setUIWithImages:(NSArray *)array
{
    if (array)
    {
        NSInteger count = array.count;
        self.imageviewArray = [[NSMutableArray alloc] initWithCapacity:count];
        for (NSInteger i = 0; i < count; i++)
        {
            CGRect rect = CGRectMake((i * self.frame.size.width), 0.0, self.frame.size.width, self.frame.size.height);
            NSString *imageName = array[i];
            imageName = [[NSString alloc] initWithFormat:@"%@%@", imageName, typeName()];
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
            [self addSubview:imageview];
            imageview.backgroundColor = [UIColor clearColor];
            imageview.contentMode = UIViewContentModeScaleAspectFill;
            imageview.image = [UIImage imageNamed:imageName];
            
            [self.imageviewArray addObject:imageview];
            
            if (i == count - 1)
            {
                imageview.userInteractionEnabled = YES;
                
                self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [imageview addSubview:self.actionButton];
                self.actionButton.frame = imageview.bounds;
                self.actionButton.backgroundColor = [UIColor clearColor];
                [self.actionButton addTarget:self action:@selector(buttonActionClick) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        self.contentSize = CGSizeMake(count * self.frame.size.width, self.frame.size.height);
    }
}

#pragma mark - 响应事件

- (void)buttonActionClick
{
    if (self.buttonClick)
    {
        self.buttonClick();
    }
    
    [self hiddenImageView];
}

#pragma mark - 方法

- (void)hiddenImageView
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    if (self.isSlide)
    {
        // 向左滑动消失
        UIImageView *imageview = self.imageviewArray.lastObject;

        [UIView animateWithDuration:self.animationTime animations:^{
            CGRect rect = imageview.frame;
            rect.origin.x -= self.imageWidth;
            imageview.frame = rect;
            imageview.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else
    {
        if (SYGuideAnimationTypeDefault == self.animationType)
        {
            // 直接消失
            [self removeFromSuperview];
        }
        else if (SYGuideAnimationTypeZoomIn == self.animationType)
        {
            // 放大淡化再消失
            UIImageView *imageview = self.imageviewArray.lastObject;
            
            [UIView animateWithDuration:self.animationTime animations:^{
                imageview.transform = CGAffineTransformMakeScale(1.6, 1.6);
                imageview.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
        else if (SYGuideAnimationTypeZoomOut == self.animationType)
        {
            // 缩小淡化再消失
            UIImageView *imageview = self.imageviewArray.lastObject;
            
            [UIView animateWithDuration:self.animationTime animations:^{
                imageview.transform = CGAffineTransformMakeScale(0.3, 0.3);
                imageview.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }
}

NSString *typeName(void)
{
    if (isiPhone4)
    {
        return image4;
    }
    else if (isiPhone5)
    {
        return image5;
    }
    else if (isiPhone6)
    {
        return image6;
    }
    else if (isiPhone6P)
    {
        return image6P;
    }
    
    return image4;
}

#pragma mark - setter/getter

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
    if (_isSlide)
    {
        self.delegate = self;
        self.actionButton.hidden = YES;
    }
    else
    {
        self.actionButton.hidden = NO;
    }
}

- (BOOL)isSlide
{
    return _isSlide;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isSlide)
    {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger page = offsetX / self.imageWidth;
        
        if (page >= self.imageCount - 1)
        {
            self.bounces = YES;
            
            CGFloat hiddenOffsetX = ((self.imageCount - 1) * self.imageWidth + self.imageWidth / 5);
            if (offsetX >= hiddenOffsetX)
            {
                [self hiddenImageView];
            }
        }
        else
        {
            self.bounces = NO;
        }
    }
}

/************************************************************/

#pragma mark - 状态设置

/// 是否首次使用
+ (BOOL)readAppStatus
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"SaveAppStatusUsing"];
    return number.boolValue;
}

/// 设置使用状态（非首次）
+ (void)saveAppStatus
{
    NSNumber *number = [NSNumber numberWithBool:1];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"SaveAppStatusUsing"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/************************************************************/


@end
