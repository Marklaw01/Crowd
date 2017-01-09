package com.staging.models;

/**
 * Created by sunakshi.gautam on 1/12/2016.
 */
public class NavDrawerItem {
    public int icon;
    public String name;

    public NavDrawerItem(String name, int icon) {
        super();
        this.icon = icon;
        this.name = name;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getIcon() {
        return icon;
    }

    public void setIcon(int icon) {
        this.icon = icon;
    }


}

