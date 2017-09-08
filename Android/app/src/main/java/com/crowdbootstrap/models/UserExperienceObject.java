package com.crowdbootstrap.models;

/**
 * Created by Sunakshi.Gautam on 12/12/2016.
 */
public class UserExperienceObject {

    private String jobTitle;
    private String companyURL;
    private String startDAte;
    private String endDate;


    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getStartDAte() {
        return startDAte;
    }

    public void setStartDAte(String startDAte) {
        this.startDAte = startDAte;
    }

    public String getCompanyURL() {
        return companyURL;
    }

    public void setCompanyURL(String companyURL) {
        this.companyURL = companyURL;
    }
}
