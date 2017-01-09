package com.crowdbootstrapapp.models;

/**
 * Created by neelmani.karn on 1/27/2016.
 */
public class AudioObject {
    String audioUrl, id, name, orignalName;

    public String getOrignalName() {
        return orignalName;
    }

    public void setOrignalName(String orignalName) {
        this.orignalName = orignalName;
    }

    public String getAudioUrl() {
        return audioUrl;
    }

    public void setAudioUrl(String audioUrl) {
        this.audioUrl = audioUrl;
    }

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
}
