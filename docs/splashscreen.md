---
license: Licensed to the Apache Software Foundation (ASF) under one
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
---

Splashscreen
==========

> Enables developers to show/hide the application's splash screen.


Methods
-------

- show
- hide

Permissions
-----------

### Android

#### app/res/xml/config.xml

    <plugin name="SplashScreen" value="org.apache.cordova.SplashScreen"/>

### iOS

#### config.xml

    <plugin name="SplashScreen" value="CDVSplashScreen" />
    
Setup
-----

### Android

1. Copy your splash screen image into the res/drawable directories of your Android project. The sizes of each image should be:

   - xlarge (xhdpi): at least 960 x 720
   - large (hdpi): at least 640 x 480
   - medium (mdpi): at least 470 x 320
   - small (ldpi): at least 426 x 320
   
   It is highly recommended that you use a [9-patch image](https://developer.android.com/tools/help/draw9patch.html) for your splash screen.

2. In the onCreate method of the class that extends DroidGap add the following two lines:

        super.setIntegerProperty("splashscreen", R.drawable.splash);
        super.loadUrl(Config.getStartUrl(), 10000);

    The first line 'super.setIntegerProperty' sets the image to be displayed as the splashscreen. If you have named your image anything other than splash.png you will have to modify this line.
    The second line is the normal 'super.loadUrl' line but it has a second parameter which is the timeout value for the splash screen. In this example the splash screen will display for 10 seconds. If you want to dismiss the splash screen once you get the "deviceready" event you should call the navigator.splashscreen.hide() method.

### iOS

1. Copy your splash screen images into the **Resources/splash** directory of your iOS project. Only add the images for the devices you want to support (iPad screen size or iPhone screen size). The sizes of each image should be:

   - Default-568h@2x~iphone.png (640x1136 pixels)
   - Default-Landscape@2x~ipad.png (2048x1496 pixels)
   - Default-Landscape~ipad.png (1024x748 pixels)
   - Default-Portrait@2x~ipad.png (1536x2008 pixels)
   - Default-Portrait~ipad.png (768x1004 pixels)
   - Default@2x~iphone.png (640x960 pixels)
   - Default~iphone.png (320x480 pixels)
        
### BlackBerry10

## Quirks

The SplashScreen BlackBerry10 plugin implements hide(), but show() is not possible using the built in OS mechanism. The advantage to using this is the splash screen is displayed before WebKit boots and issupports multiple images for various device resolutions and orientations.
We also implemented the AutoHideSplashScreen config.xml value, similar to iOS.


   

