package com.staging.models;

/**
 * Created by sunakshi.gautam on 1/19/2016.
 */
public class CurrentStartUpObject {
    private String startUpName;
    private String startUpDiscription;
    private String nextStep;
    private String id;
    private String entrenprenuer_id;
    private String entrenprenuerName;
    private boolean is_entrepreneur;
    private boolean is_contractor;
    private String startup_teamID;

    public String getStartup_teamID() {
        return startup_teamID;
    }

    public void setStartup_teamID(String startup_teamID) {
        this.startup_teamID = startup_teamID;
    }

    public String getEntrenprenuer_id() {
        return entrenprenuer_id;
    }

    public void setEntrenprenuer_id(String entrenprenuer_id) {
        this.entrenprenuer_id = entrenprenuer_id;
    }

    public boolean is_entrepreneur() {
        return is_entrepreneur;
    }

    public void setIs_entrepreneur(boolean is_entrepreneur) {
        this.is_entrepreneur = is_entrepreneur;
    }

    public boolean is_contractor() {
        return is_contractor;
    }

    public void setIs_contractor(boolean is_contractor) {
        this.is_contractor = is_contractor;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEntrenprenuerName() {
        return entrenprenuerName;
    }

    public void setEntrenprenuerName(String entrenprenuerName) {
        this.entrenprenuerName = entrenprenuerName;
    }

    public String getStartUpName() {
        return startUpName;
    }

    public void setStartUpName(String startUpName) {
        this.startUpName = startUpName;
    }

    public String getStartUpDiscription() {
        return startUpDiscription;
    }

    public void setStartUpDiscription(String startUpDiscription) {
        this.startUpDiscription = startUpDiscription;
    }

    public String getNextStep() {
        return nextStep;
    }

    public void setNextStep(String nextStep) {
        this.nextStep = nextStep;
    }
}
