package com.theblindsquirrel.capacitor.callerid.plugin;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "CallerId")
public class CallerIdPlugin extends Plugin {

    private CallerId implementation = new CallerId();

    @PluginMethod
    public void addContacts(PluginCall call) {
        //TODO: 
        implementation.addContacts();
    }

    @PluginMethod
    public void checkStatus(PluginCall call) {
        implementation.checkStatus();
        call.resolve('true');
    }
}
