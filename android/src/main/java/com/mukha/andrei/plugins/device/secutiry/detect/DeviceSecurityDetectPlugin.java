package com.mukha.andrei.plugins.device.secutiry.detect;

import android.util.Log;
import android.os.Build;
import android.content.Context;
import android.app.KeyguardManager;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "DeviceSecurityDetect")
public class DeviceSecurityDetectPlugin extends Plugin {
    private DeviceSecurityDetect implementation = new DeviceSecurityDetect();

    @PluginMethod
    public void isJailBreakOrRooted(PluginCall call) {
        boolean isDeviceRooted = implementation.isDeviceRooted();

        JSObject ret = new JSObject();
        ret.put("value", isDeviceRooted);
        call.resolve(ret);
    }

    @PluginMethod
    public void pinCheck(PluginCall call) {
        try {
            KeyguardManager keyguardManager = (KeyguardManager) this.getContext().getSystemService(Context.KEYGUARD_SERVICE);
            JSObject ret = new JSObject();
            ret.put("value", keyguardManager.isKeyguardSecure());
            call.resolve(ret);
        } catch (Exception ex) {
            call.reject(ex.getLocalizedMessage());
        }
    }
}
