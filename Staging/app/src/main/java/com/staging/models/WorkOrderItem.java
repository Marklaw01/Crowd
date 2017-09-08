package com.staging.models;

/**
 * Created by sunakshi.gautam on 4/19/2016.
 */
public class WorkOrderItem {

    private String deliverableName;
    private String date;
    private String workUnit;
    private String workorderID;
    private String deliverableID;
    private String startupID;

    public String getStartupID() {
        return startupID;
    }

    public void setStartupID(String startupID) {
        this.startupID = startupID;
    }

    public String getDeliverableID() {
        return deliverableID;
    }

    public void setDeliverableID(String deliverableID) {
        this.deliverableID = deliverableID;
    }

    public String getDeliverableName() {
        return deliverableName;
    }

    public void setDeliverableName(String deliverableName) {
        this.deliverableName = deliverableName;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getWorkUnit() {
        return workUnit;
    }

    public void setWorkUnit(String workUnit) {
        this.workUnit = workUnit;
    }

    public String getWorkorderID() {
        return workorderID;
    }

    public void setWorkorderID(String workorderID) {
        this.workorderID = workorderID;
    }
}
