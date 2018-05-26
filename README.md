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
####iOS
`<platform name="ios">
...
<custom-resource type="image" src="resources/ios/splash/animated-1.png" catalog="animated-splashscreen" scale="1x" idiom="universal" />
        <custom-resource type="image" src="resources/ios/splash/animated-2.png" catalog="animated-splashscreen" scale="1x" idiom="universal" />
        ...</platform>
`
####Android
not ready yet


## What's new
 - 1.0.0 - initial code, added iOS support