package com.crowdbootstrap.models;

/**
 * Created by sunakshi.gautam on 1/27/2016.
 */
public class DocumentObject {

    private String id;
    private String date;
    private String doc_name;
    private String download_link;
    private String roadmap_name;
    private String user_name;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getDoc_name() {
        return doc_name;
    }

    public void setDoc_name(String doc_name) {
        this.doc_name = doc_name;
    }

    public String getDownload_link() {
        return download_link;
    }

    public void setDownload_link(String download_link) {
        this.download_link = download_link;
    }

    public String getRoadmap_name() {
        return roadmap_name;
    }

    public void setRoadmap_name(String roadmap_name) {
        this.roadmap_name = roadmap_name;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }
}
