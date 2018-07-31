# SYGuideView
APP首次使用时的引导页设置

# 效果图
![image.gif](./images/image.gif) 



* 使用介绍
  * 自动导入：使用命令`pod 'SYGuideView'`导入到项目中
  * 手动导入：或下载源码后，将源码添加到项目中


# 使用示例
~~~ javascript
// 引入头文件
#import "SYGuideView.h"
~~~ 

~~~ javascript
// 首次使用，显示引导页：使用默认按钮，且放大淡化
// 判断是否首次使用
BOOL isFirstUsing = SYGuideView.readAppStatus;
if (!isFirstUsing)
{
    // 非首次使用

    // 保存首次使用的状态
    [SYGuideView saveAppStatus];

    // 实例化引导页
    NSArray *images = @[@"guideImage_1", @"guideImage_2", @"guideImage_3", @"guideImage_4"];
    SYGuideView *guideView = [[SYGuideView alloc] initWithImages:images];
    guideView.buttonClick = ^(){

    };
}
~~~

~~~ javascript
// 首次使用，显示引导页：使用自定义按钮，且缩小淡化
BOOL isFirstUsing = SYGuideView.readAppStatus;
if (!isFirstUsing)
{
    // 保存首次使用的状态
    [SYGuideView saveAppStatus];

    NSArray *images = @[@"guideImage_1", @"guideImage_2", @"guideImage_3"];
    SYGuideView *guideView = [[SYGuideView alloc] initWithImages:images];
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
BOOL isFirstUsing = SYGuideView.readAppStatus;
if (!isFirstUsing)
{
    // 保存首次使用的状态
    [SYGuideView saveAppStatus];

    NSArray *images = @[@"guideImage_1", @"guideImage_2", @"guideImage_3"];
    SYGuideView *guideView = [[SYGuideView alloc] initWithImages:images];
    // 隐藏响应类型
    guideView.isSlide = YES;
}
~~~

# 使用示例
![image.png](./images/image.png) 

## 修改完善
* 20170711
  * 修改名称：SYGuideScrollView改成SYGuideView
  * 枚举值抽离：SYGuideHeader
  * 添加引导页类型SYGuideViewType：图片轮播、动图、视频——待完善
  * 添加引导页操作类型：手动消失、计时器消失——待完善

~~~javascript
/// 引导页视图类型（默认图片轮播、动图、视频）
typedef NS_ENUM (NSInteger, SYGuideViewType)
{
/// 引导页视图类型-图片轮播，默认
SYGuideViewTypeDefault = 0,

/// 引导页视图类型-动图
SYGuideViewTypeGif = 0,

/// 引导页视图类型-视频
SYGuideViewTypeVideo = 0,
};
~~~
~~~ javascript
/// 计时器消失
@property (nonatomic, assign) BOOL isAutoHidden;
/// 计时器时间（默认3秒）
@property (nonatomic, assign) NSTimeInterval autoTime;
~~~



