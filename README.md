cordova-plugin-animated-splashscreen
============================
Animated Splash Screen Plugin

Based on 
[cordova-custom-config plugin](https://github.com/dpa99c/cordova-custom-config)
and 
[cordova-plugin-splashscreen](https://github.com/apache/cordova-plugin-splashscreen)

1. Animation based on changing images one-by-one. Created animation slides and place to the resourses directory
2. Update config.xml file (listed below)
3. API is the same as in [cordova-plugin-splashscreen](https://github.com/apache/cordova-plugin-splashscreen)

### Installation
// npm hosted (new) id
cordova plugin add cordova-plugin-animated-splashscreen

// you may also install directly from this repo
cordova plugin add https://github.com/kitolog/cordova-plugin-animated-splashscreen
 

### Setup:
#### Add to config.xml:
#### Common:
Duration in seconds

`<preference name="AnimatedSplashScreenAnimationDuration" value="5" />`

Disable original splashscreen plugin, it's not needed

`<preference name="SplashScreen" value="false" />`

Repeat count

0 - no repeat

`<preference name="AnimatedSplashScreenAnimationRepeatCount" value="0" />`

#### iOS

IOS Images Order:

`<preference name="AnimatedSplashScreenIosImages" value="animated-1.png,animated-2.png,animated-3.png,animated-4.png,animated-5.png" />`

`...`

IOS Images paths:

`<platform name="ios">`

`...`

`<custom-resource catalog="animated-1" idiom="universal" scale="1x" src="resources/ios/splash/animated-1.png" type="image" />`

`<custom-resource catalog="animated-2" idiom="universal" scale="1x" src="resources/ios/splash/animated-2.png" type="image" />`

`...</platform>`
`
#### Android

Android Images Order:

`<preference name="AnimatedSplashScreenAndroidImages" value="animated1,animated2,animated3,animated4,animated5" />`

`...`

Android Images paths:


`<platform name="android">`

`...`

`<resource-file src="resources/android/splash/animated-1.png" target="app/src/main/res/drawable-land-xxxhdpi/animated1.png" />`
`<resource-file src="resources/android/splash/animated-2.png" target="app/src/main/res/drawable-land-xxxhdpi/animated2.png" />`

`...</platform>`

##### NOTE: Android screen sizes:
(in example code, image has 1920 x 1280 px size, so it should be placed to drawable-land-xxxhdpi)

LDPI:
* Portrait: 200 x 320 px
* Landscape: 320 x 200 px

MDPI:
* Portrait: 320 x 480 px
* Landscape: 480 x 320 px

HDPI:
* Portrait: 480 x 800 px
* Landscape: 800 x 480 px

XHDPI:
* Portrait: 720 x 1280 px
* Landscape: 1280 x 720 px

XXHDPI:
* Portrait: 960 x 1600 px
* Landscape: 1600 x 960 px

XXXHDPI:
* Portrait: 1280 x 1920 px
* Landscape: 1920 x 1280 px

## What's new
 - 1.0.0 - initial code, added iOS support
 - 1.0.1 - added config params, updated iOS platform
 - 1.0.2 - added Android source
 - 1.0.4 - optimized Android source
 - 1.0.8 - updated Android theme
 - 1.1.0 - stable version with iOS and Android support
 - 1.1.2 - Android image paths fixes