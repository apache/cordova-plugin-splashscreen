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

# iOS Configuration

The `config.xml` file controls an app's basic settings that apply
across each application and CordovaWebView instance. This section
details preferences that only apply to iOS builds. See The config.xml
File for information on global configuration options.

- `FadeSplashScreen` (boolean, defaults to `true`): Set to `false` to
  prevent the splash screen from fading in and out when its display
  state changes.

        <preference name="FadeSplashScreen" value="false"/>

- `FadeSplashScreenDuration` (float, defaults to `2`): Specifies the
  number of seconds for the splash screen fade effect to execute.

        <preference name="FadeSplashScreenDuration" value="4"/>

- `ShowSplashScreenSpinner` (boolean, defaults to `true`): Set to `false`
  to hide the splash-screen spinner.

        <preference name="ShowSplashScreenSpinner" value="false"/>

- `KeyboardDisplayRequiresUserAction` (boolean, defaults to `true`):
  Set to `false` to allow the keyboard to appear when calling
  `focus()` on form inputs.

        <preference name="KeyboardDisplayRequiresUserAction" value="false"/>

- `AutoHideSplashScreen` (boolean, defaults to `true`):
   Set to `false` to control when the splashscreen is hidden through the plugin's JavaScript API.

        <preference name="AutoHideSplashScreen" value="false"/>

