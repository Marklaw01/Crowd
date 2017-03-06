package com.crowdbootstrap.models;

/**
 * Created by neelmani.karn on 2/19/2016.
 */
public class ContactsObject {
    String id, name, image, status;
    Integer quickbloxid;

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

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getQuickbloxid() {
        return quickbloxid;
    }

    public void setQuickbloxid(Integer quickbloxid) {
        this.quickbloxid = quickbloxid;
    }
}
