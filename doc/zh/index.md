<!---
    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.
-->

# org.apache.cordova.splashscreen

这个插件显示和隐藏在应用程序启动期间的初始屏幕。

## 安装

    cordova plugin add org.apache.cordova.splashscreen
    

## 支持的平台

*   亚马逊火 OS
*   Android 系统
*   黑莓 10
*   iOS
*   Windows Phone 7 和 8
*   Windows 8

## 方法

*   splashscreen.show
*   splashscreen.hide

### Android 的怪癖

您需要在您的 config.xml 中添加下列优先选项

`<preference name="splashscreen" value="foo" />`

美孚在哪里的闪屏文件的名称。最好是 9 修补程序文件。请确保您的 splashcreen 文件添加到相应的文件夹下的 res/xml 目录。

Android 系统，也可以编辑您的项目主要的 java 文件。您必须添加第二个参数表示一个时间延迟到你 super.loadUrl。

`super.loadUrl(Config.getStartUrl(), 10000);`

## splashscreen.hide

搁置的splash屏幕。

    navigator.splashscreen.hide();
    

### 黑莓 10 怪癖

`config.xml`文件的 `AutoHideSplashScreen` 设置必须为`false`.

### iOS 怪癖

`config.xml`文件的 `AutoHideSplashScreen`必须设置为`false` 。 若要延迟两秒钟隐藏的闪屏，在`deviceready` 事件处理程序中添加一个如下所示的计时器 ：

        setTimeout(function() {
            navigator.splashscreen.hide();
        }, 2000);
    

## splashscreen.show

显示splash屏幕。

    navigator.splashscreen.show();
    

您的应用程序不能调用 `navigator.splashscreen.show()` 直到应用程序已启动和 `deviceready` 触发了事件。 但因为通常的闪屏为了是可见的在您的应用程序启动之前，似乎要打败闪屏的目的。 提供一些配置在 `config.xml` 自动将 `show` 的初始屏幕，您的应用程序启动后立即和它在之前已完全开始收到 `deviceready` 事件。 做这种配置的详细信息，请参阅[图标和闪屏][1]。 出于此原因，它是不太可能你需要调用 `navigator.splashscreen.show()` ，使初始屏幕可见为应用程序启动。

 [1]: http://cordova.apache.org/docs/en/edge/config_ref_images.md.html