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

hide
===============

Dismiss the splash screen.

    navigator.splashscreen.hide();

Description
-----------

navigator.splashscreen.hide() dismisses the applications splash screen.

Supported Platforms
-------------------

- Android
- iOS

Quick Example
-------------

    navigator.splashscreen.hide();

Full Example
------------

    <!DOCTYPE html>
    <html>
      <head>
        <title>Splashscreen Example</title>

        <script type="text/javascript" charset="utf-8" src="cordova-x.x.x.js"></script>
        <script type="text/javascript" charset="utf-8">

        // Wait for Cordova to load
        //
        document.addEventListener("deviceready", onDeviceReady, false);

        // Cordova is ready
        //
        function onDeviceReady() {
			navigator.splashscreen.hide();
        }
		
        </script>
      </head>
      <body>
        <h1>Example</h1>
      </body>
    </html>

iOS Quirk
------------

1. In your **config.xml**, you need to [modify the value](guide_project-settings_index.md.html#Project%20Settings) for **"AutoHideSplashScreen”** to false

2. Then, if you want to delay hiding the splash screen for 2 seconds, you can do this in your **deviceready** event handler:

        setTimeout(function() {
            navigator.splashscreen.hide();
        }, 2000);
