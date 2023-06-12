package com.theblindsquirrel.capacitor.callerid.plugin;

import android.util.Log;

import androidx.room.Room;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.theblindsquirrel.capacitor.callerid.plugin.database.AppDatabase;
import com.theblindsquirrel.capacitor.callerid.plugin.database.CallerIdContact;

@CapacitorPlugin(name = "CallerId")
public class CallerIdPlugin extends Plugin {

    @PluginMethod
    public void checkStatus(PluginCall call) {
        JSObject ret = new JSObject();
        ret.put("value", true);
        call.resolve(ret);
    }

    @PluginMethod
    public void addContacts(PluginCall call) {
        var contacts = call.getArray("contacts");
        AppDatabase db = Room.databaseBuilder(this.getContext(),
                AppDatabase.class, "Unanet-CRM").allowMainThreadQueries().build();
        db.contactDao().deleteAllContacts();
        for(var i = 0; i < contacts.length(); i++) {
            try {
                var jsonContact = contacts.getJSONObject(i);
                CallerIdContact calleridContact = new CallerIdContact();
                calleridContact.phoneNumber = jsonContact.getString("phonenumber");
                calleridContact.displayName = jsonContact.getString("displayname");
                calleridContact.companyName = jsonContact.getString("companyname");
                db.contactDao().insertContact(calleridContact);
            } catch (Exception ex) {
                Log.e("add contacts", "error getting contact");
            }
        }

        JSObject ret = new JSObject();
        ret.put("value", true);
        call.resolve(ret);
    }
}
