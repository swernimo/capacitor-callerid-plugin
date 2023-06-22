package com.theblindsquirrel.capacitor.callerid.plugin;

import static android.app.Activity.RESULT_OK;
import static android.content.ContentValues.TAG;
import static android.content.Context.ROLE_SERVICE;

import android.Manifest;
import android.app.Activity;
import android.app.role.RoleManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.util.Log;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.room.Room;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.ActivityCallback;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.theblindsquirrel.capacitor.callerid.plugin.database.AppDatabase;
import com.theblindsquirrel.capacitor.callerid.plugin.database.CallerIdContact;

@CapacitorPlugin(name = "CallerId")
public class CallerIdPlugin extends Plugin {

    private Context context;
    private Activity activity;
    private int REQUEST_ID = 1;

    @PluginMethod
    public void checkStatus(PluginCall call) {
        JSObject ret = new JSObject();
        if(context == null) {
            context = getContext();
        }
        if(context != null) {
            activity = getActivity();
            var roleManager = (RoleManager) context.getSystemService(ROLE_SERVICE);
            var intent = roleManager.createRequestRoleIntent(RoleManager.ROLE_CALL_SCREENING);
            startActivityForResult(call, intent, "callScreenResult");
        } else {
            ret.put("value", false);
            call.resolve(ret);
        }
    }

    @ActivityCallback
    private void callScreenResult(PluginCall call, ActivityResult result) {
        JSObject ret = new JSObject();
        if (result.getResultCode() == RESULT_OK) {
            ActivityCompat.requestPermissions(activity, new String[] { Manifest.permission.READ_PHONE_STATE}, 3);
            var phonePerms = ContextCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE);
            // if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU){
            //     ActivityCompat.requestPermissions(activity, new String[] { Manifest.permission.POST_NOTIFICATIONS}, 101);
            //     var notificationPerms = ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS);
            //     ret.put("value", (notificationPerms == PackageManager.PERMISSION_GRANTED && phonePerms == PackageManager.PERMISSION_GRANTED));
            // } else {
                ret.put("value", phonePerms == PackageManager.PERMISSION_GRANTED);
            // }
        } else {
            ret.put("value", false);
        }
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
