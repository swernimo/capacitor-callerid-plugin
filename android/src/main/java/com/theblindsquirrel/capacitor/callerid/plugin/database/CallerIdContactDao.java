package com.theblindsquirrel.capacitor.callerid.plugin.database;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

@Dao
public interface CallerIdContactDao {
    @Query("SELECT * FROM CallerIdContact")
    List<CallerIdContact> getAll();

    @Query("SELECT * FROM CallerIdContact WHERE phoneNumber = :phNumber")
    CallerIdContact getContactByPhonenumber(String phNumber);

    @Insert
    void insertAll(CallerIdContact... contacts);

    @Delete
    void delete(CallerIdContact contact);

    @Insert
    void insertContact(CallerIdContact contact);

    @Query("delete from CallerIdContact")
    void deleteAllContacts();
}