package com.vitorventurin.echo;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.util.Log;

import com.phonegap.helloworld.HelloWorld;

public class Echo extends CordovaPlugin {
    private static final String TAG = "DebugLogger";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("escrever")) {
//            String message = args.getString(0);
            
            JSONArray obj = new JSONArray();
            obj.put(HelloWorld.LAT);
            obj.put(HelloWorld.LNG);
            
            if (obj != null && obj.length() > 0) {
                Log.d(TAG, obj.toString());
                callbackContext.success(obj);
            } else {
                callbackContext.error("Expected one non-empty string argument.");
            }
            
            return true;
        }
        return false;
    }
}