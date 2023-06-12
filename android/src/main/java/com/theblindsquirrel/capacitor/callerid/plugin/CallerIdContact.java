package com.theblindsquirrel.capacitor.callerid.plugin;

import java.util.Date;

public class CallerIdContact {
    public String displayName;
    public Date lastUpdated;
    public String phoneNumber;
    public String companyName;

    public CallerIdContact(String displayName, Date lastUpdated, String phoneNumber, String companyName) {
        this.displayName = displayName;
        this.lastUpdated = lastUpdated;
        this.phoneNumber = phoneNumber;
        this.companyName = companyName;
    }

    public CallerIdContact(){}
}
