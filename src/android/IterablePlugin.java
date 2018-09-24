package org.apache.cordova.iterable;

import android.content.Context;
import android.content.Intent;
import android.content.res.AssetManager;
import android.os.Bundle;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import com.iterable.iterableapi.IterableApi;
import com.iterable.iterableapi.IterableConfig;
import com.iterable.iterableapi.IterableHelper;

import static org.apache.cordova.Whitelist.TAG;

public class IterablePlugin extends CordovaPlugin {

    private static boolean inBackground = true;

    @Override
    protected void pluginInitialize() {
        final Context context = this.cordova.getActivity().getApplicationContext();
        final Bundle extras = this.cordova.getActivity().getIntent().getExtras();
        this.cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                  Log.d(TAG, "Starting Firebase plugin");
                   iterableInit(context);
                }
        });
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("deviceTokenIDRegister")) {
             this.deviceTokenIDRegister(callbackContext, args.getString(0));
             return true;
        }else if (action.equals("loadInAppMessage")) {
            this.loadInAppMessage(callbackContext);
            return true;
        }
        return false;
    }

    private void iterableInit(Context context) {
        try {
            JSONObject obj = new JSONObject(loadJSONFromAsset(context,"www/iterableconfig.json"));
            String appname = obj.getJSONObject("android").getString("pushIntegrationName");
            String apikey = obj.getJSONObject("android").getString("initializeWithApiKey");
            IterableConfig config = new IterableConfig.Builder()
                    .setPushIntegrationName(appname)
                    .build();
            IterableApi.initialize(context, apikey, config);
         } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void deviceTokenIDRegister(final CallbackContext callbackContext,final String setEmail) {
         IterableApi.getInstance().setEmail(setEmail);
         IterableApi.getInstance().registerForPush();
    }

    private void loadInAppMessage(final CallbackContext callbackContext) {
        final Context context = this.cordova.getActivity();
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                try {
                    /*iterable implementation*/
                    IterableApi.getInstance().spawnInAppNotification(context, new IterableHelper.IterableActionHandler() {
                        @Override
                        public void execute(String data) {
                            Log.e("HandleInApp", "Redirected to: " + data);
                        }
                    });
                    Log.d(TAG, "Starting Firebase plugin");
                } catch (Exception e) {
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    public String loadJSONFromAsset(Context context,String filename) {
        String json = null;
        try {
            InputStream is = context.getAssets().open(filename);
            int size = is.available();
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();
            json = new String(buffer, "UTF-8");
        } catch (IOException ex) {
            ex.printStackTrace();
            return null;
        }
        return json;
    }


}
