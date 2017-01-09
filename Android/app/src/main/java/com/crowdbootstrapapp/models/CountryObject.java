package com.crowdbootstrapapp.models;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 2/24/2016.
 */
public class CountryObject {
    String id, name;
    ArrayList<StatesObject> statesObjects;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public ArrayList<StatesObject> getStatesObjects() {
        return statesObjects;
    }

    public void setStatesObjects(ArrayList<StatesObject> statesObjects) {
        this.statesObjects = statesObjects;
    }
}
