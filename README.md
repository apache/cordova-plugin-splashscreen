<!--
# license: Licensed to the Apache Software Foundation (ASF) under one
#         or more contributor license agreements.  See the NOTICE file
#         distributed with this work for additional information
#         regarding copyright ownership.  The ASF licenses this file
#         to you under the Apache License, Version 2.0 (the
#         "License"); you may not use this file except in compliance
#         with the License.  You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
#         Unless required by applicable law or agreed to in writing,
#         software distributed under the License is distributed on an
#         "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#         KIND, either express or implied.  See the License for the
#         specific language governing permissions and limitations
#         under the License.
-->

[![Build Status](https://travis-ci.org/apache/cordova-plugin-splashscreen.svg?branch=master)](https://travis-ci.org/apache/cordova-plugin-splashscreen)

# cordova-plugin-splashscreen

This plugin is required to allow your application to work with splash screens. This plugin displays and hides a splash screen during application launch.

Report issues with this plugin on the [Apache Cordova issue tracker][Apache Cordova issue tracker].

## Installation

    // npm hosted (new) id
    cordova plugin add cordova-plugin-splashscreen

    // you may also install directly from this repo
    cordova plugin add https://github.com/apache/cordova-plugin-splashscreen.git

## Supported Platforms

- Amazon Fire OS
- Android
- BlackBerry 10
- iOS
- Windows Phone 7 and 8
- Windows 8
- Windows
- Browser

## Example Configuration
In the top-level `config.xml` file (not the one in `platforms`), add configuration elements like those specified here.

The value of the "src" attribute is relative to the project directory and NOT to the www directory. You can name the source image file whatever you like. The internal name in the application is automatically determined by Cordova.

```xml
<platform name="android">
    <!-- you can use any density that exists in the Android project -->
    <splash src="res/screen/android/splash-land-hdpi.png" density="land-hdpi"/>
    <splash src="res/screen/android/splash-land-ldpi.png" density="land-ldpi"/>
    <splash src="res/screen/android/splash-land-mdpi.png" density="land-mdpi"/>
    <splash src="res/screen/android/splash-land-xhdpi.png" density="land-xhdpi"/>
    <splash src="res/screen/android/splash-land-xxhdpi.png" density="land-xxhdpi"/>

    <splash src="res/screen/android/splash-port-hdpi.png" density="port-hdpi"/>
    <splash src="res/screen/android/splash-port-ldpi.png" density="port-ldpi"/>
    <splash src="res/screen/android/splash-port-mdpi.png" density="port-mdpi"/>
    <splash src="res/screen/android/splash-port-xhdpi.png" density="port-xhdpi"/>
    <splash src="res/screen/android/splash-port-xxhdpi.png" density="port-xxhdpi"/>
</platform>

<platform name="ios">
    <!-- images are determined by width and height. The following are supported -->
    <splash src="res/screen/ios/Default~iphone.png" width="320" height="480"/>
    <splash src="res/screen/ios/Default@2x~iphone.png" width="640" height="960"/>
    <splash src="res/screen/ios/Default-Portrait~ipad.png" width="768" height="1024"/>
    <splash src="res/screen/ios/Default-Portrait@2x~ipad.png" width="1536" height="2048"/>
    <splash src="res/screen/ios/Default-Landscape~ipad.png" width="1024" height="768"/>
    <splash src="res/screen/ios/Default-Landscape@2x~ipad.png" width="2048" height="1536"/>
    <splash src="res/screen/ios/Default-568h@2x~iphone.png" width="640" height="1136"/>
    <splash src="res/screen/ios/Default-667h.png" width="750" height="1334"/>
    <splash src="res/screen/ios/Default-736h.png" width="1242" height="2208"/>
    <splash src="res/screen/ios/Default-Landscape-736h.png" width="2208" height="1242"/>
</platform>

<platform name="windows">
    <!-- images are determined by width and height. The following are supported -->
    <splash src="res/screen/windows/splashscreen.png" width="620" height="300"/>
    <splash src="res/screen/windows/splashscreenphone.png" width="1152" height="1920"/>
</platform>

<platform name="blackberry10">
    <!-- Add a rim:splash element for each resolution and locale you wish -->
    <!-- http://developer.blackberry.com/html5/documentation/rim_splash_element.html -->
    <rim:splash src="res/screen/blackberry/splashscreen.png"/>
</platform>

<preference name="SplashScreenDelay" value="10000" />
```

## Preferences

#### config.xml

-  __AutoHideSplashScreen__ (boolean, default to `true`). Indicates whether to hide the splash screen automatically or not. The splash screen is hidden after the amount of time specified in the `SplashScreenDelay` preference.

```xml
    <preference name="AutoHideSplashScreen" value="true" />
```

-  __SplashScreenDelay__ (number, default to 3000). Amount of time in milliseconds to wait before automatically hide splash screen.

```xml
    <preference name="SplashScreenDelay" value="3000" />
```

### Android Quirks

In your `config.xml`, you need to add the following preferences:

```xml
<preference name="SplashScreenDelay" value="3000" />
<preference name="SplashMaintainAspectRatio" value="true|false" />
<preference name="SplashShowOnlyFirstTime" value="true|false" />
```

"SplashScreenDelay" preference is optional and defaults to 3000 milliseconds.  It represents how long the splashscreen will appear in milliseconds.

"SplashMaintainAspectRatio" preference is optional. If set to "true", the splash screen is not stretched to fit the full screen, but instead simply "covers" the screen, like CSS "background-size:cover". This is very useful when splash screen images cannot be distorted in any way, for example when they contain scenery or text. This setting works best with images that have large margins (safe areas) that can be safely cropped on screens with different aspect ratios.

The splash screen plugin reloads the splash screen whenever the orientation changes so that you can specify different splash screen images for portrait and landscape orientations.

"SplashShowOnlyFirstTime" preference is optional and defaults to `true`. When set to `true` the splash screen will only appear on application launch. However, if you plan to use `navigator.app.exitApp()` to close the application and force the splash screen appear on the application's next launch, you should set this property to `false` (this also applies to closing the application with the Back button).

### Browser Quirks

You can use the following preferences in your `config.xml`:

```xml
<platform name="browser">
    <preference name="SplashScreen" value="/images/browser/splashscreen.jpg" /> <!-- defaults to "/img/logo.png" -->
    <preference name="SplashScreenDelay" value="3000" /> <!-- defaults to "3000" -->
    <preference name="SplashScreenBackgroundColor" value="green" /> <!-- defaults to "#464646" -->
    <preference name="ShowSplashScreen" value="false" /> <!-- defaults to "true" -->
    <preference name="SplashScreenWidth" value="600" /> <!-- defaults to "170" -->
    <preference name="SplashScreenHeight" value="300" /> <!-- defaults to "200" -->
</platform>
```

__Note__: `SplashScreen` value should be absolute in order to work in a sub-page. The `SplashScreen` value is used only for the browser platform. The value will be ignored for other platforms.

### Android and iOS Quirks

- In iOS, the splash screen images are called launch images. These images are mandatory on iOS.

- `FadeSplashScreen` (boolean, defaults to `true`): Set to `false` to
  prevent the splash screen from fading in and out when its display
  state changes.

```xml
    <preference name="FadeSplashScreen" value="false"/>
```

- `FadeSplashScreenDuration` (float, defaults to `3000`): Specifies the
  number of milliseconds for the splash screen fade effect to execute.  1500 seems to be a better values for an improved user experience.

```xml
    <preference name="FadeSplashScreenDuration" value="3000"/>
```

This value used to be in seconds (but is now milliseconds) so values less than 30 will continue to be treated as seconds. ( Consider this a deprecated temporary measure that will disapear in some future version. )

_Note_: `FadeSplashScreenDuration` is included into `SplashScreenDelay`, for example if you have `<preference name="SplashScreenDelay" value="3000" />` and `<preference name="FadeSplashScreenDuration" value="1000"/>` defined in `config.xml`:

- 00:00 - splashscreen is shown
- 00:02 - fading has started
- 00:03 - splashscreen is hidden

Turning the fading off via `<preference name="FadeSplashScreen" value="false"/>` technically means fading duration to be `0` so that in this example the overall splash screen delay will still be 3 seconds.

_Note_: This only applies to the application startup - you need to take the fading timeout into account when manually showing/hiding the splash screen in your application's code:

```javascript
navigator.splashscreen.show();
window.setTimeout(function () {
    navigator.splashscreen.hide();
}, splashDuration - fadeDuration);
```

- `ShowSplashScreenSpinner` (boolean, defaults to `true`): Set to `false`
  to hide the splash screen spinner.  Does not work on Browser or Windows platforms.

```xml
    <preference name="ShowSplashScreenSpinner" value="false"/>
```

## Methods

- splashscreen.show
- splashscreen.hide

## splashscreen.hide

Dismiss the splash screen.

```js
navigator.splashscreen.hide();
```


### BlackBerry 10, WP8, iOS Quirk

The `config.xml` file's `AutoHideSplashScreen` setting must be
`false`. To delay hiding the splash screen for two seconds, add a
timer such as the following in the `deviceready` event handler:

```js
setTimeout(function() {
    navigator.splashscreen.hide();
}, 2000);
```

## splashscreen.show

Displays the splash screen.

```js
navigator.splashscreen.show();
```

Your application cannot call `navigator.splashscreen.show()` until the application has
started and the `deviceready` event has fired. But since typically the splash
screen is meant to be visible before your application has started, that would seem to
defeat the purpose of the splash screen.  Providing any parameters in
`config.xml` will automatically `show` the splash screen immediately after your
application is launched and before it has fully started and received the `deviceready`
event. For this reason, it is unlikely you will need to call `navigator.splashscreen.show()` to make the splash
screen visible for application startup.

[Apache Cordova issue tracker]: https://issues.apache.org/jira/issues/?jql=project%20%3D%20CB%20AND%20status%20in%20%28Open%2C%20%22In%20Progress%22%2C%20Reopened%29%20AND%20resolution%20%3D%20Unresolved%20AND%20component%20%3D%20%22Plugin%20Splashscreen%22%20ORDER%20BY%20priority%20DESC%2C%20summary%20ASC%2C%20updatedDate%20DESC
