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

###Add to config.xml:
####Common:
Duration in seconds

`<preference name="AnimatedSplashScreenAnimationDuration" value="5" />`

Repeat count

0 - no repeat

`<preference name="AnimatedSplashScreenAnimationRepeatCount" value="0" />`

####iOS

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
####Android

Android Images Order:

`<preference name="AnimatedSplashScreenAndroidImages" value="animated-1.png,animated-2.png,animated-3.png,animated-4.png,animated-5.png" />`

`...`

Android Images paths:

`<platform name="ios">`

`...`

`<custom-resource catalog="animated-1" idiom="universal" scale="1x" src="resources/ios/splash/animated-1.png" type="image" />`

`<custom-resource catalog="animated-2" idiom="universal" scale="1x" src="resources/ios/splash/animated-2.png" type="image" />`

`...</platform>`

not ready yet


## What's new
 - 1.0.0 - initial code, added iOS support