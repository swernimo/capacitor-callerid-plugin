package com.theblindsquirrel.capacitor.callerid.plugin.database;

import androidx.annotation.NonNull;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import java.util.Date;

@Entity
public class CallerIdContact {
    @PrimaryKey
    @NonNull
    public String phoneNumber;

    @ColumnInfo(name = "displayName")
    public String displayName;

    //TODO: circle back when we are only updating contacts
//    @ColumnInfo(name = "lastUpdated")
//    public Date lastUpdated;

    @ColumnInfo(name = "companyName")
    public String companyName;
}