cordova-plugin-splashscreen
----------------------------

For Android,

In your config.xml, you need to add the following preference

`<preference name="splashscreen" value="foo" />`

Where foo is the name of the splashscreen file. Preferably a 9 patch file. Make sure to add your splashcreen files to your res/xml directory under the appropriate folders.

For Android, you also have to edit your projects main java file. You must add a second parameter representing a time delay to your super.loadUrl. 

`super.loadUrl(Config.getStartUrl(), 10000);`
