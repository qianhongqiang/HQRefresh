# HQRefresh

#代码参照了https://github.com/CoderMJLee/MJRefresh,特别感谢！

##本人将着重处理动画效果，当前版本还未支持

```
        testTable.addRefreshHeaderWithCallBack { () -> Void in
                //do things here
                testTable.headerEndRefreshing()
        }
        
        testTable.addRefreshFooterWithCallBack { () -> Void in
                //do things here
                testTable.footerEndRefreshing()
        }
```
###设置上述回调即可
