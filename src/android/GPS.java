package com.vitorventurin.gps;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.widget.Toast;

public class GPS extends CordovaPlugin implements LocationListener {
    private LocationManager locationManager;
    private double lat;
    private double lng;
    private boolean isGPSEnabled = false;
    private boolean isNetworkEnabled = false;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("escrever")) {
            locationManager = (LocationManager) this.webView.getContext().getSystemService(Context.LOCATION_SERVICE);
            
            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,
                    3000, 5, this);
            
            JSONArray obj = new JSONArray();
            obj.put(lat);
            obj.put(lng);
            
            if (obj != null && obj.length() > 0) {
                callbackContext.success(obj);
            } else {
                callbackContext.error("Expected one non-empty string argument.");
            }
            
            return true;
        }
        if (action.equals("locationservice")) {
            locationManager = (LocationManager) this.webView.getContext().getSystemService(Context.LOCATION_SERVICE);
            isGPSEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
            isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
            
            JSONArray obj = new JSONArray();
            obj.put(isGPSEnabled);
            obj.put(isNetworkEnabled);
            
            if (obj != null && obj.length() > 0) {
                callbackContext.success(obj);
            } else {
                callbackContext.error("Expected one non-empty string argument.");
            }
            
            return true;
        }
        return false;
    }

    @Override
    public void onLocationChanged(Location location) {
        this.lat = location.getLatitude();
        this.lng = location.getLongitude();
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {
    }

    @Override
    public void onProviderEnabled(String provider) {
    }

    @Override
    public void onProviderDisabled(String provider) {
    }
}
