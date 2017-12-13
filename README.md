# WyhChannelManager
**新闻类app的福音 可实现今日头条频道管理页面**

### 详情移步至简书: 

[简书传送门](http://www.jianshu.com/p/de044b88393d)

## 效果示例

![含热门的普通频道样式.gif](http://upload-images.jianshu.io/upload_images/4097230-be16152ef495dfdb.gif?imageMogr2/auto-orient/strip)

## 支持自定义频道样式

![自定义频道样式.gif](http://upload-images.jianshu.io/upload_images/4097230-ae6d8366681048d3.gif?imageMogr2/auto-orient/strip)

## 支持火热频道

![含热门的普通频道样式.gif](http://upload-images.jianshu.io/upload_images/4097230-be16152ef495dfdb.gif?imageMogr2/auto-orient/strip)

## 支持置顶不可编辑频道处理

![前两个频道固定不可编辑.gif](http://upload-images.jianshu.io/upload_images/4097230-159368f45f4d15a4.gif?imageMogr2/auto-orient/strip)

## 在项目中的搭配使用

![模拟实际频道运用.gif](http://upload-images.jianshu.io/upload_images/4097230-88ffe212e0f284af.gif?imageMogr2/auto-orient/strip)


## 代码示例

```objc
    //定义频道管理器WyhChannelManager

    self.manager = [WyhChannelManager updateWithTopArr:self.topChannelArr BottomArr:self.bottomChannelArr InitialIndex:self.contentView.currentIndex newStyle:nil];

    //定义频道视图WyhChannelManagerView

    -(WyhChannelManagerView *)managerView{
    if (!_managerView) {

    WyhChannelManagerView *channelView = [WyhChannelManagerView channelViewWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64.0) Manager:self.manager];
        _managerView = channelView;

        [channelView chooseChannelCallBack:^{
        [WyhChannelManager setUpdateIfNeeds];
        [self dismissViewControllerAnimated:YES completion:^{

        }];
    }];

    }
    return _managerView;
    }

```

## Contact me

- JianShu: [被帅醒的小吴同志](http://www.jianshu.com/u/b76e3853ae0b)
- Email:  609223770@qq.com
- QQ：609223770


