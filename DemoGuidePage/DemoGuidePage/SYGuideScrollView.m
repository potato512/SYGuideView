//
//  GuideScrollView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/8/21.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "SYGuideScrollView.h"

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

@interface SYGuideScrollView ()

@property (nonatomic, strong) NSMutableArray *imageviewArray;

@end

@implementation SYGuideScrollView

- (instancetype)initWithImages:(NSArray *)array
{
    self = [super init];
    if (self)
    {
        [UIApplication sharedApplication].statusBarHidden = YES;
        
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
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
//                button.backgroundColor = [UIColor clearColor];
                [imageview addSubview:button];
                imageview.userInteractionEnabled = YES;
                button.frame = CGRectMake((imageview.frame.size.width - buttonWidth()) / 2, (imageview.frame.size.height - buttonHeight() - typeHeight()), buttonWidth(), buttonHeight());
                [button addTarget:self action:@selector(buttonActionClick) forControlEvents:UIControlEventTouchUpInside];
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
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    if (SYGuideAnimationTypeDefault == self.animationType)
    {
        // 直接消失
        [self removeFromSuperview];
    }
    else if (SYGuideAnimationTypeZoomIn == self.animationType)
    {
        // 放大淡化再消失
        UIImageView *imageview = self.imageviewArray.lastObject;
        
        [UIView animateWithDuration:0.5 animations:^{
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
        
        [UIView animateWithDuration:0.5 animations:^{
            imageview.transform = CGAffineTransformMakeScale(0.3, 0.3);
            imageview.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 信息处理

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

// 按钮frame设置根据实际情况处理

CGFloat buttonWidth(void)
{
    if (isiPhone4)
    {
        return 140.0;
    }
    else if (isiPhone5)
    {
        return 140.0;
    }
    else if (isiPhone6)
    {
        return 180.0;
    }
    else if (isiPhone6P)
    {
        return 200.0;
    }
    
    return 140.0;
}

CGFloat buttonHeight(void)
{
    if (isiPhone4)
    {
        return 35.0;
    }
    else if (isiPhone5)
    {
        return 35.0;
    }
    else if (isiPhone6)
    {
        return 45.0;
    }
    else if (isiPhone6P)
    {
        return 50.0;
    }
    
    return 35.0;
}

CGFloat typeHeight(void)
{
    if (isiPhone4)
    {
        return 40.0;
    }
    else if (isiPhone5)
    {
        return 72.0;
    }
    else if (isiPhone6)
    {
        return 62.0;
    }
    else if (isiPhone6P)
    {
        return 87.0;
    }
    
    return 40.0;
}

#pragma mark - 状态设置

/************************************************************/

/// 是否首次使用
BOOL SYAppStatusUsingGet(void)
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"SaveAppStatusUsing"];
    return number.boolValue;
}

/// 设置使用状态（非首次）
void SYAppStatusUsingSave(void)
{
    NSNumber *number = [NSNumber numberWithBool:1];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"SaveAppStatusUsing"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/************************************************************/


@end
