# TransitioningAnimationDemo1

> 转场，从一个场景转换到另一个场景。

![TransitioningAnimationDemo1.gif](https://github.com/JiongXing/TransitioningAnimationDemo1/raw/master/screenshots/TransitioningAnimationDemo1.gif)

# modal动画
通过`- (void)presentViewController:animated:completion:`方法跳转到另一个页面时，可以自定义modal动画。
> 从代码的角度看，启用动画的入口是这样的：

```objc
vc.transitioningDelegate = self;
[self presentViewController:vc animated:YES completion:nil];
```
给vc的transitioningDelegate属性赋值，为即将跳转的vc指定转场动画代理。简单起见，在这里，当前controller自己充当了代理。而作为代理需要实现`<UIViewControllerTransitioningDelegate>`协议。
```objc
@interface ViewController () <UIViewControllerTransitioningDelegate>
```

协议中有两个基础方法，分别要求代理返回present时的动画以及dismiss时的动画。
```objc
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
```
剩下的事情，就需要代理去考虑怎么搞出两个实现了`<UIViewControllerAnimatedTransitioning>`协议的动画对象来。

> 我们可以写一个类专门来实现`<UIViewControllerAnimatedTransitioning>`动画协议，作为动画的实现类。然后代理就可以轻松搞出两个动画对象，实现`<UIViewControllerTransitioningDelegate>`转场代理协议。

```objc
@interface PictureBroswerTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
```
在`<UIViewControllerAnimatedTransitioning>`动画协议中，有两个必须实现的方法：
```objc
/// 返回动画持续时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;
/// 动画实现过程
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
```
可以看到，其中的关键方法就是`-(void)animateTransition:`，系统会向此方法传入一个参数`transitionContext`，它代表了整个转场环境，包含了转场过程中的关键信息，比如从哪里转到哪里。

> 实现动画的关键方法
`- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext`

获取转场过程的三个视图：containerView、fromView、toView。
containerView是动画过程中提供的暂时容器。
fromView是转场开始页的视图。
toView是转场结束页的视图。
```objc
UIView *fromView;
UIView *toView;
if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
    // iOS8以上用此方法准确获取
    fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    toView = [transitionContext viewForKey:UITransitionContextToViewKey];
}
else {
    fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
}
UIView *container = [transitionContext containerView];
```
转场的过程，大多数情况下我们都是对toView作各种变换操作，例如改变toView的alpha，size，旋转等等。 在对它进行操作前，需要先把它放到container上才能显示出来。
`[container addSubview:toView];`

最后需要我们自己弄出个动画来~囧
```objc
pictureView.transform = startTransform;
pictureView.center = startCenter;
[UIView animateWithDuration:self.duration animations:^{
    pictureView.transform = endTransform;
    pictureView.center = endCenter;
} completion:^(BOOL finished) {
    BOOL wasCancelled = [transitionContext transitionWasCancelled];
    [transitionContext completeTransition:!wasCancelled];
}];
```
这里注意一下，在我们自己写的动画完结时，一定要告诉所在的转场环境对象`transitionContext`，我们的动画完成了，它才会进行动画结束后的收尾工作：
```objc
[transitionContext completeTransition:YES];
```
在转场的过程中，动画有可能被各种原因打断，通过`transitionWasCancelled`方法可以知道是否被打断：
```objc
BOOL wasCancelled = [transitionContext transitionWasCancelled];
[transitionContext completeTransition:!wasCancelled];
```

项目源码：https://github.com/JiongXing/TransitioningAnimationDemo1
下载：https://github.com/JiongXing/TransitioningAnimationDemo1/archive/master.zip
