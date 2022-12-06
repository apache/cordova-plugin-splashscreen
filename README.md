---
title: Splashscreen
description: Control the splash screen for your app.
---
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

# cordova-plugin-splashscreen

[![Chrome Testsuite](https://github.com/apache/cordova-plugin-splashscreen/actions/workflows/chrome.yml/badge.svg)](https://github.com/apache/cordova-plugin-splashscreen/actions/workflows/chrome.yml) [![Lint Test](https://github.com/apache/cordova-plugin-splashscreen/actions/workflows/lint.yml/badge.svg)](https://github.com/apache/cordova-plugin-splashscreen/actions/workflows/lint.yml)

This plugin displays and hides a splash screen while your web application is launching. Using its methods you can also show and hide the splash screen manually.

- [cordova-plugin-splashscreen](#cordova-plugin-splashscreen)
  - [Installation](#installation)
  - [Supported Platforms](#supported-platforms)
  - [Platform Splash Screen Image Configuration](#platform-splash-screen-image-configuration)
    - [Example Configuration](#example-configuration)
  - [Preferences](#preferences)
    - [config.xml](#configxml)
    - [Quirks](#quirks)
  - [Methods](#methods)
    - [splashscreen.hide](#splashscreenhide)
    - [splashscreen.show](#splashscreenshow)

## Installation

    // npm hosted (new) id
    cordova plugin add cordova-plugin-splashscreen

    // you may also install directly from this repo
    cordova plugin add https://github.com/apache/cordova-plugin-splashscreen.git

## Supported Platforms

- Browser

## Platform Splash Screen Image Configuration

### Example Configuration

In the top-level `config.xml` file (not the one in `platforms`), add configuration elements like those specified here.

The value of the "src" attribute is relative to the project root directory and NOT to the `www` directory (see `Directory structure` below). You can name the source image file whatever you like. The internal name in the application is automatically determined by Cordova.

Directory structure:

```
projectRoot
    hooks
    platforms
    plugins
    www
        css
        img
        js
    res
        screen
```

```xml
<preference name="SplashScreenDelay" value="10000" />
```

## Preferences

### config.xml

- `AutoHideSplashScreen` (boolean, default to `true`). Indicates whether to hide splash screen automatically or not. The splash screen is hidden after the amount of time specified in the `SplashScreenDelay` preference.

    ```xml
    <preference name="AutoHideSplashScreen" value="true" />
    ```

- `SplashScreenDelay` (number, default to 3000). Amount of time in milliseconds to wait before automatically hide splash screen.

    ```xml
    <preference name="SplashScreenDelay" value="3000" />
    ```

    This value used to be in seconds (but is now milliseconds) so values less than 30 will continue to be treated as seconds. (Consider this a deprecated patch that will disapear in some future version.)

    To disable the splashscreen add the following preference to `config.xml`:
    ```xml
    <preference name="SplashScreenDelay" value="0"/>
    ```

- `FadeSplashScreen` (boolean, defaults to `true`): Set to `false` to
  prevent the splash screen from fading in and out when its display
  state changes.

    ```xml
    <preference name="FadeSplashScreen" value="false"/>
    ```

- `FadeSplashScreenDuration` (float, defaults to `500`): Specifies the
  number of milliseconds for the splash screen fade effect to execute.

    ```xml
    <preference name="FadeSplashScreenDuration" value="750"/>
    ```

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

### Quirks

You can use the following preferences in your `config.xml`:

```xml
<platform name="browser">
    <preference name="SplashScreen" value="/images/browser/splashscreen.jpg" /> <!-- defaults to "/img/logo.png" -->
    <preference name="AutoHideSplashScreen" value="true" /> <!-- defaults to "true" -->
    <preference name="SplashScreenDelay" value="3000" /> <!-- defaults to "3000" -->
    <preference name="SplashScreenBackgroundColor" value="green" /> <!-- defaults to "#464646" -->
    <preference name="ShowSplashScreen" value="false" /> <!-- defaults to "true" -->
    <preference name="SplashScreenWidth" value="600" /> <!-- defaults to "170" -->
    <preference name="SplashScreenHeight" value="300" /> <!-- defaults to "200" -->
</platform>
```

__Note__: `SplashScreen` value should be absolute in order to work in a sub-page.

## Methods

- splashscreen.show
- splashscreen.hide

### splashscreen.hide

Dismiss the splash screen.

```js
navigator.splashscreen.hide();
```

### splashscreen.show

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
