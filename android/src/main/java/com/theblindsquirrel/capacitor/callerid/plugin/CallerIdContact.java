package com.theblindsquirrel.capacitor.callerid.plugin;

import java.util.Date;

public class CallerIdContact {
    public String displayName;
    public Date lastUpdated;
    public Number phoneNumber;
    public String companyName;

    public CallerIdContact(String displayName, Date lastUpdated, Number phoneNumber, String companyName) {
        this.displayName = displayName;
        this.lastUpdated = lastUpdated;
        this.phoneNumber = phoneNumber;
        this.companyName = companyName;
    }
}
