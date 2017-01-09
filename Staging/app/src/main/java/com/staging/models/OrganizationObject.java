package com.staging.models;

/**
 * Created by sunakshi.gautam on 11/22/2016.
 */
public class OrganizationObject {

    private String companyImage;
    private String companyName;
    private String companyDescription;
    private String companyID;
    private String companySkills;

    public String getCompanySkills() {
        return companySkills;
    }

    public void setCompanySkills(String companySkills) {
        this.companySkills = companySkills;
    }

    public String getCompanyImage() {
        return companyImage;
    }

    public void setCompanyImage(String companyImage) {
        this.companyImage = companyImage;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyDescription() {
        return companyDescription;
    }

    public void setCompanyDescription(String companyDescription) {
        this.companyDescription = companyDescription;
    }

    public String getCompanyID() {
        return companyID;
    }

    public void setCompanyID(String companyID) {
        this.companyID = companyID;
    }
}
