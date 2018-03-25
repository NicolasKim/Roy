# Roy

[![CI Status](http://img.shields.io/travis/jinqiucheng1006@live.cn/Roy.svg?style=flat)](https://travis-ci.org/jinqiucheng1006@live.cn/Roy)
[![Version](https://img.shields.io/cocoapods/v/Roy.svg?style=flat)](http://cocoapods.org/pods/Roy)
[![License](https://img.shields.io/cocoapods/l/Roy.svg?style=flat)](http://cocoapods.org/pods/Roy)
[![Platform](https://img.shields.io/cocoapods/p/Roy.svg?style=flat)](http://cocoapods.org/pods/Roy)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Roy is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Roy"
```
## Usage

### Add route

```Objective-C
_ = RoyR.global.addRouter(url: "test://testhost/testpath?param1=<number?>", paramValidator: nil, task: { (param) -> Any? in
//task
return any value
})
```
### Route
```Objective-C
//run task in current queue
_ = RoyR.global.route(url: URL(string: "test://testhost/testpath?param1=<number?>")!, param: [param1:123123])

//run task in roy queue
_ = RoyR.global.route(url: URL(string: "test://testhost/testpath?param1=<number?>")!, param: nil) { (result) in
            //do something
        }

```

**URL have to have scheme,host,path   but the param is optional**
**ex:**

```
qqqq://wwwww/eeee
qqqq://wwwww/eeee?param1=<number>&param2=<text>
qqqq://wwwww/eeee?param1=<number>&param2=<text?>
```
the `?` means optional

## Module support


* Set app scheme

```
RoyModuleConfig.sharedInstance.scheme = "test"
```

* Regist module to RoyAppDelegate ,the host will mapping to module

```
RoyAppDelegate.sharedInstance.addModuleClass(UserPluginDelegate.self, host: "testmodule")
```


The module have to subclassing the `RoyModule` like,

```
public required init(host: String) {
        super.init(host: host)
        _ = self.addRouter(path: "initializeviewcontroller", viewController: TMViewController.self,paramValidator:nil)
        _ = self.addRouter(path: "hahaha?c=<number>", viewController: FirstViewController.self, paramValidator: nil)
        _ = self.addRouter(path: "test1", task: { (params) -> Any? in
            print("current thread is \(Thread.current)")
            return nil
        }, paramValidator: nil)
    }
```




## Author

jinqiucheng1006@live.cn, jinqiucheng@autohome.com.cn

## License

Roy is available under the MIT license. See the LICENSE file for more info.



