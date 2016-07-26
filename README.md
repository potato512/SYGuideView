# SYGuideView
APP首次使用时的引导页设置

#使用示例
~~~ javascript
// 引入头文件
#import "SYGuideScrollView.h"
// 首次使用，显示引导页
BOOL appStatus = SYAppStatusUsingGet();
if (!appStatus)
{
    SYAppStatusUsingSave();

    NSArray *images = @[@"guideImage_1", @"guideImage_2", @"guideImage_3"];
    SYGuideScrollView *guideView = [[SYGuideScrollView alloc] initWithImages:images];
    guideView.animationType = SYGuideAnimationTypeZoomIn;
    guideView.buttonClick = ^(){

    };
}
~~~

#效果图
* 使用示例

![image](image.png) 
