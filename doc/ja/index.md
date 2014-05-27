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

This plugin displays and hides a splash screen during application launch.

## インストール

    cordova plugin add org.apache.cordova.splashscreen
    

## サポートされているプラットフォーム

*   アマゾン火 OS
*   アンドロイド
*   ブラックベリー 10
*   iOS
*   Windows Phone 7 と 8
*   Windows 8

## メソッド

*   splashscreen.show
*   splashscreen.hide

### Android の癖

In your config.xml, you need to add the following preference

`<preference name="splashscreen" value="foo" />`

Where foo is the name of the splashscreen file. Preferably a 9 patch file. Make sure to add your splashcreen files to your res/xml directory under the appropriate folders.

For Android, you also have to edit your projects main java file. You must add a second parameter representing a time delay to your super.loadUrl.

`super.loadUrl(Config.getStartUrl(), 10000);`

## splashscreen.hide

スプラッシュ スクリーンを閉じます。

    navigator.splashscreen.hide();
    

### BlackBerry 10 Quirk

The `config.xml` file's `AutoHideSplashScreen` setting must be `false`.

### iOS の気まぐれ

`config.xml`ファイルの `AutoHideSplashScreen` 設定する必要があります `false` 。 遅延を 2 秒間スプラッシュ スクリーンを非表示、する、タイマーを追加しますで次のように `deviceready` イベント ハンドラー。

        setTimeout(function() {
            navigator.splashscreen.hide();
        }, 2000);
    

## splashscreen.show

スプラッシュ画面が表示されます。

    navigator.splashscreen.show();
    

Your application cannot call `navigator.splashscreen.show()` until the app has started and the `deviceready` event has fired. But since typically the splash screen is meant to be visible before your app has started, that would seem to defeat the purpose of the splash screen. Providing some configuration in `config.xml` will automatically `show` the splash screen immediately after your app launch and before it has fully started and received the `deviceready` event. See [Icons and Splash Screens][1] for more information on doing this configuration. For this reason, it is unlikely you need to call `navigator.splashscreen.show()` to make the splash screen visible for app startup.

 [1]: http://cordova.apache.org/docs/en/edge/config_ref_images.md.html