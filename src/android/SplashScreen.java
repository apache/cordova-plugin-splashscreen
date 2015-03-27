/*
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
*/

package org.apache.cordova.splashscreen;

import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Color;
import android.os.Handler;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * Splash Screen plugin. Uses the following preferences:
 * <ul>
 * <li>SplashScreen: Splash screen resource name.</li>
 * <li>SplashScreenDelay: How long splash screen should be shown in milliseconds.</li>
 * <li>SplashMaintainAspectRatio: Maintain aspect ratio of the drawable, like CSS
 *	background-size:cover. Defaults to false for backward compatibility.</li>
 * <li>SplashReloadOnOrientationChange: Reload splash drawable when orientation changes.
 * 	Defaults to false for performance reasons because there is no need to look up and
 *  reload the drawable if it does not change. App developer knows if they have different
 *  drawables per orientation and can set this to true in that case.</li>
 * </ul>
 */
public class SplashScreen extends CordovaPlugin {
    private static final String LOG_TAG = "SplashScreen";
    // Cordova 3.x.x has a copy of this plugin bundled with it (SplashScreenInternal.java).
    // Enable functionality only if running on 4.x.x.
    private static final boolean HAS_BUILT_IN_SPLASH_SCREEN = Integer.valueOf(CordovaWebView.CORDOVA_VERSION.split("\\.")[0]) < 4;
    private static Dialog splashDialog;
    private static ProgressDialog spinnerDialog;
    private static boolean firstShow = true;
    
    /**
     * Displays the splash drawable.
     */
    private ImageView splashImageView;
    
    /**
     * Remember last device orientation to detect orientation changes.
     */
    private int orientation;

    // Helper to be compile-time compatible with both Cordova 3.x and 4.x.
    private View getView() {
        try {
            return (View)webView.getClass().getMethod("getView").invoke(webView);
        } catch (Exception e) {
            return (View)webView;
        }
    }

    @Override
    protected void pluginInitialize() {
        if (HAS_BUILT_IN_SPLASH_SCREEN || !firstShow) {
            return;
        }
        // Make WebView invisible while loading URL
        // getView().setVisibility(View.INVISIBLE);
        int drawableId = preferences.getInteger("SplashDrawableId", 0);
        if (drawableId == 0) {
            String splashResource = preferences.getString("SplashScreen", "splash");
            if (splashResource != null) {
                drawableId = cordova.getActivity().getResources().getIdentifier(splashResource, "drawable", cordova.getActivity().getClass().getPackage().getName());
                if (drawableId == 0) {
                    drawableId = cordova.getActivity().getResources().getIdentifier(splashResource, "drawable", cordova.getActivity().getPackageName());
                }
                preferences.set("SplashDrawableId", drawableId);
            }
        }
        
        // Save initial orientation.
        orientation = cordova.getActivity().getResources().getConfiguration().orientation;

        firstShow = false;
        loadSpinner();
        showSplashScreen(true);
    }
    
    /**
     * Shorter way to check value of "SplashMaintainAspectRatio" preference.
     */
    private boolean isMaintainAspectRatio () {
        return preferences.getBoolean("SplashMaintainAspectRatio", false);
    }
    
    /**
     * Shorter way to check value of "SplashReloadOnOrientationChange" preference.
     */
    private boolean isReloadOnOrientationChange () {
        return preferences.getBoolean("SplashReloadOnOrientationChange", false);
    }

    @Override
    public void onPause(boolean multitasking) {
        if (HAS_BUILT_IN_SPLASH_SCREEN) {
            return;
        }
        // hide the splash screen to avoid leaking a window
        this.removeSplashScreen();
    }

    @Override
    public void onDestroy() {
        if (HAS_BUILT_IN_SPLASH_SCREEN) {
            return;
        }
        // hide the splash screen to avoid leaking a window
        this.removeSplashScreen();
        firstShow = true;
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("hide")) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    webView.postMessage("splashscreen", "hide");
                }
            });
        } else if (action.equals("show")) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    webView.postMessage("splashscreen", "show");
                }
            });
        } else if (action.equals("spinnerStart")) {
            if (!HAS_BUILT_IN_SPLASH_SCREEN) {
                final String title = args.getString(0);
                final String message = args.getString(1);
                cordova.getActivity().runOnUiThread(new Runnable() {
                    public void run() {
                        spinnerStart(title, message);
                    }
                });
            }
        } else {
            return false;
        }

        callbackContext.success();
        return true;
    }

    @Override
    public Object onMessage(String id, Object data) {
        if (HAS_BUILT_IN_SPLASH_SCREEN) {
            return null;
        }
        if ("splashscreen".equals(id)) {
            if ("hide".equals(data.toString())) {
                this.removeSplashScreen();
            } else {
                this.showSplashScreen(false);
            }
        } else if ("spinner".equals(id)) {
            if ("stop".equals(data.toString())) {
                this.spinnerStop();
                getView().setVisibility(View.VISIBLE);
            }
        } else if ("onReceivedError".equals(id)) {
            spinnerStop();
        }
        return null;
    }
    
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);

        // Reload splash drawable when orientation changes if so configured.
        if (newConfig.orientation != orientation) {
            orientation = newConfig.orientation;
            reloadDrawable();
        }
    }

    private void reloadDrawable() {
        if (isReloadOnOrientationChange() && splashImageView != null) {
            final int drawableId = preferences.getInteger("SplashDrawableId", 0);
            if (drawableId != 0) {
                cordova.getActivity().runOnUiThread(new Runnable() {
                    public void run() {
                        if (splashImageView != null) {
                            splashImageView.setImageDrawable(cordova.getActivity().getResources().getDrawable(drawableId));
                        }
                    }
                });
            }
        }
    }

	private void removeSplashScreen() {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                if (splashDialog != null && splashDialog.isShowing()) {
                    splashDialog.dismiss();
                    splashDialog = null;
                    splashImageView = null;
                }
            }
        });
    }

    /**
     * Shows the splash screen over the full Activity
     */
    @SuppressWarnings("deprecation")
    private void showSplashScreen(final boolean hideAfterDelay) {
        final int splashscreenTime = preferences.getInteger("SplashScreenDelay", 3000);
        final int drawableId = preferences.getInteger("SplashDrawableId", 0);

        // If the splash dialog is showing don't try to show it again
        if (splashDialog != null && splashDialog.isShowing()) {
            return;
        }
        if (drawableId == 0 || (splashscreenTime <= 0 && hideAfterDelay)) {
            return;
        }

        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                // Get reference to display
                Display display = cordova.getActivity().getWindowManager().getDefaultDisplay();
                Context context = webView.getContext();

                // Create the layout for the dialog
                LinearLayout root = new LinearLayout(context);
                root.setMinimumHeight(display.getHeight());
                root.setMinimumWidth(display.getWidth());
                root.setOrientation(LinearLayout.VERTICAL);

                // TODO: Use the background color of the webView's parent instead of using the
                // preference.
                root.setBackgroundColor(preferences.getInteger("backgroundColor", Color.BLACK));
                
                root.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.MATCH_PARENT, 0.0F));
                
                // Use an ImageView to render the image because of its flexible scaling options.
                splashImageView = new ImageView(context);
                splashImageView.setImageResource(drawableId);
                LayoutParams layoutParams = new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
                splashImageView.setLayoutParams(layoutParams);

                if (isMaintainAspectRatio()) {
                    // CENTER_CROP scale mode is equivalent to CSS "background-size:cover"
                    splashImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
                }
                else {
                    // FIT_XY scales image non-uniformly to fit into image view.
                    splashImageView.setScaleType(ImageView.ScaleType.FIT_XY);
                }
                root.addView(splashImageView);

                // Create and show the dialog
                splashDialog = new Dialog(context, android.R.style.Theme_Translucent_NoTitleBar);
                // check to see if the splash screen should be full screen
                if ((cordova.getActivity().getWindow().getAttributes().flags & WindowManager.LayoutParams.FLAG_FULLSCREEN)
                        == WindowManager.LayoutParams.FLAG_FULLSCREEN) {
                    splashDialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                            WindowManager.LayoutParams.FLAG_FULLSCREEN);
                }
                splashDialog.setContentView(root);
                splashDialog.setCancelable(false);
                splashDialog.show();

                // Set Runnable to remove splash screen just in case
                if (hideAfterDelay) {
                    final Handler handler = new Handler();
                    handler.postDelayed(new Runnable() {
                        public void run() {
                            removeSplashScreen();
                        }
                    }, splashscreenTime);
                }
            }
        });
    }

    /*
     * Load the spinner
     */
    private void loadSpinner() {
        // If loadingDialog property, then show the App loading dialog for first page of app
        String loading = null;
        if (webView.canGoBack()) {
            loading = preferences.getString("LoadingDialog", null);
        }
        else {
            loading = preferences.getString("LoadingPageDialog", null);
        }
        if (loading != null) {
            String title = "";
            String message = "Loading Application...";

            if (loading.length() > 0) {
                int comma = loading.indexOf(',');
                if (comma > 0) {
                    title = loading.substring(0, comma);
                    message = loading.substring(comma + 1);
                }
                else {
                    title = "";
                    message = loading;
                }
            }
            spinnerStart(title, message);
        }
    }

    private void spinnerStart(final String title, final String message) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                spinnerStop();
                /*spinnerDialog = ProgressDialog.show(webView.getContext(), title, message, true, true,
                        new DialogInterface.OnCancelListener() {
                            public void onCancel(DialogInterface dialog) {
                                spinnerDialog = null;
                            }
                        });*/
            }
        });
    }

    private void spinnerStop() {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                if (spinnerDialog != null && spinnerDialog.isShowing()) {
                    spinnerDialog.dismiss();
                    spinnerDialog = null;
                }
            }
        });
    }
}
