package com.crowdbootstrap.models;

/**
 * Created by sunakshi.gautam on 9/8/2016.
 */
public class LeanRoadmapObject {
    String deliverableid;
    String deliverableName;
    String description;
    String sampleLink;
    String colorBG;
    String templateLink;

    public String getTemplateLink() {
        return templateLink;
    }

    public void setTemplateLink(String templateLink) {
        this.templateLink = templateLink;
    }

    public String getColorBG() {
        return colorBG;
    }

    public void setColorBG(String colorBG) {
        this.colorBG = colorBG;
    }

    public String getSampleLink() {
        return sampleLink;
    }

    public void setSampleLink(String sampleLink) {
        this.sampleLink = sampleLink;
    }

    public String getDeliverableid() {
        return deliverableid;
    }

    public void setDeliverableid(String deliverableid) {
        this.deliverableid = deliverableid;
    }

    public String getDeliverableName() {
        return deliverableName;
    }

    public void setDeliverableName(String deliverableName) {
        this.deliverableName = deliverableName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
