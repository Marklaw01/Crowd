package com.staging.models;

/**
 * Created by sunakshi.gautam on 2/8/2016.
 */
public class WorkOrderEntrepreneur {

    private String team_memberid;
    private String work_orderid;
    private String contractorName;
    private String roadmap_name;
    private String dateEntered;
    private String workUnitEntered;
    private String contactor_id;
    private String week_no;
    private String startup_id;
    private String startup_teamid;

    public String getContactor_id() {
        return contactor_id;
    }

    public void setContactor_id(String contactor_id) {
        this.contactor_id = contactor_id;
    }

    public String getWeek_no() {
        return week_no;
    }

    public void setWeek_no(String week_no) {
        this.week_no = week_no;
    }

    public String getStartup_id() {
        return startup_id;
    }

    public void setStartup_id(String startup_id) {
        this.startup_id = startup_id;
    }

    public String getStartup_teamid() {
        return startup_teamid;
    }

    public void setStartup_teamid(String startup_teamid) {
        this.startup_teamid = startup_teamid;
    }

    public String getTeam_memberid() {
        return team_memberid;
    }

    public void setTeam_memberid(String team_memberid) {
        this.team_memberid = team_memberid;
    }

    public String getWork_orderid() {
        return work_orderid;
    }

    public void setWork_orderid(String work_orderid) {
        this.work_orderid = work_orderid;
    }

    public String getRoadmap_name() {
        return roadmap_name;
    }

    public void setRoadmap_name(String roadmap_name) {
        this.roadmap_name = roadmap_name;
    }

    public String getContractorName() {
        return contractorName;
    }

    public void setContractorName(String contractorName) {
        this.contractorName = contractorName;
    }

    public String getDateEntered() {
        return dateEntered;
    }

    public void setDateEntered(String dateEntered) {
        this.dateEntered = dateEntered;
    }

    public String getWorkUnitEntered() {
        return workUnitEntered;
    }

    public void setWorkUnitEntered(String workUnitEntered) {
        this.workUnitEntered = workUnitEntered;
    }
}
