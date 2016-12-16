# SYGuideView
APP首次使用时的引导页设置

#效果图
![image.gif](./images/image.gif) 

#使用示例
~~~ javascript

// 引入头文件
#import "SYGuideScrollView.h"

~~~ 

~~~ javascript

// 首次使用，显示引导页：使用默认按钮，且放大淡化
BOOL appStatus = SYAppStatusUsingGet();
if (!appStatus)
{
    SYAppStatusUsingSave();

    NSArray *images = @[@"guideImage_1", @"guideImage_2", @"guideImage_3"];
    SYGuideScrollView *guideView = [[SYGuideScrollView alloc] initWithImages:images];
    // 隐藏动画类型
    guideView.animationType = SYGuideAnimationTypeZoomIn;
    guideView.buttonClick = ^(){

    };
}

~~~

~~~ javascript

// 首次使用，显示引导页：使用自定义按钮，且缩小淡化
BOOL appStatus = SYAppStatusUsingGet();
if (!appStatus)
{
    SYAppStatusUsingSave();

    NSArray *images = @[@"guideImage_1", @"guideImage_2", @"guideImage_3"];
    SYGuideScrollView *guideView = [[SYGuideScrollView alloc] initWithImages:images];
    // 隐藏动画类型
    guideView.animationType = SYGuideAnimationTypeZoomOut;
    // 按钮属性设置
    guideView.button.frame = CGRectMake((self.view.frame.size.width - 100.0) / 2, (self.view.frame.size.height - 40.0), 100.0, 40.0);
    [guideView.button setTitle:@"隐藏" forState:UIControlStateNormal];
    guideView.button.backgroundColor = [UIColor brownColor];
    guideView.button.layer.cornerRadius = 10.0;
    guideView.button.layer.borderWidth = 1.0;
    guideView.button.layer.borderColor = [UIColor redColor].CGColor;
    guideView.buttonClick = ^(){

    };
}

~~~

~~~ javascript

// 首次使用，显示引导页：使用左滑后淡化
BOOL appStatus = SYAppStatusUsingGet();
if (!appStatus)
{
    SYAppStatusUsingSave();

    NSArray *images = @[@"guideImage_1", @"guideImage_2", @"guideImage_3"];
    SYGuideScrollView *guideView = [[SYGuideScrollView alloc] initWithImages:images];
    // 隐藏响应类型
    guideView.isSlide = YES;
}

~~~

#使用示例
![image.png](./images/image.png) 
