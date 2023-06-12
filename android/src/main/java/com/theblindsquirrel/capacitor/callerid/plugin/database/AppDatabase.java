package com.theblindsquirrel.capacitor.callerid.plugin.database;

import androidx.room.Database;
import androidx.room.RoomDatabase;

@Database(entities = {CallerIdContact.class}, version = 1)
public abstract class AppDatabase extends RoomDatabase {
    public abstract CallerIdContactDao contactDao();
}
