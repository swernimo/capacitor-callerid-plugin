package com.theblindsquirrel.capacitor.callerid.plugin;

import static androidx.core.content.ContextCompat.getSystemService;
import android.app.role.RoleManager;
import android.content.Intent;
import android.util.Log;

public class CallerId {
    private static final String TAG = MainActivity.class.getSimpleName();
    private static final int REQUEST_ID = 1;

    public void addContacts() {

    }

    public boolean checkStatus() {
        this.requestRole();
        return false;
    }

    public void requestRole() {
        Log.d(TAG, "requestRole: ");
        RoleManager roleManager = (RoleManager) getSystemService(ROLE_SERVICE);
        Intent intent = roleManager.createRequestRoleIntent(RoleManager.ROLE_CALL_SCREENING);
        startActivityForResult(intent, REQUEST_ID);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_ID) {
            if (resultCode == android.app.Activity.RESULT_OK) {
                Log.d(TAG, "onActivityResult: user allowed caller id");
                // Your app is now the call screening app
            } else {
                Log.d(TAG, "onActivityResult: user denied caller id");
                // Your app is not the call screening app
            }
        }
    }
}
