package com.crowdbootstrapapp.models;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/4/2016.
 */
public class StartupsObject {
    String id, startupName;
    String description;

    ArrayList<StartupItemsObject> itemsObjectArrayList;

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getStartupName() {
        return startupName;
    }

    public void setStartupName(String startupName) {
        this.startupName = startupName;
    }

    public ArrayList<StartupItemsObject> getItemsObjectArrayList() {
        return itemsObjectArrayList;
    }

    public void setItemsObjectArrayList(ArrayList<StartupItemsObject> itemsObjectArrayList) {
        this.itemsObjectArrayList = itemsObjectArrayList;
    }
}
