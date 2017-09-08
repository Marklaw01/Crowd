package com.crowdbootstrap.models;

/**
 * Created by sunakshi.gautam on 1/22/2016.
 */
public class TeamMemberObject {

    private String memberName;
    private String memberDesignation;
    private String memberBio;
    private String memberId;
    private int memberStatus;
    private String memberEmail;
    private String memberRoleId;
    private int quickbloxid;
    private String isPublicProfile;

    public String getStartup_teamID() {
        return startup_teamID;
    }

    public void setStartup_teamID(String startup_teamID) {
        this.startup_teamID = startup_teamID;
    }

    private String startup_teamID;

    public String getIsPublicProfile() {
        return isPublicProfile;
    }

    public void setIsPublicProfile(String isPublicProfile) {
        this.isPublicProfile = isPublicProfile;
    }

    public int getQuickbloxid() {
        return quickbloxid;
    }

    public void setQuickbloxid(int quickbloxid) {
        this.quickbloxid = quickbloxid;
    }

    public String getMemberRoleId() {
        return memberRoleId;
    }

    public void setMemberRoleId(String memberRoleId) {
        this.memberRoleId = memberRoleId;
    }

    public int getMemberStatus() {

        if (memberStatus == 1)
            return 0;
        else
            return 1;

    }

    public void setMemberStatus(int memberStatus) {
        this.memberStatus = memberStatus;
    }

    public String getMemberEmail() {
        return memberEmail;
    }

    public void setMemberEmail(String memberEmail) {
        this.memberEmail = memberEmail;
    }

    public String getMemberId() {

        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public String getMemberBio() {
        return memberBio;
    }

    public void setMemberBio(String memberBio) {
        this.memberBio = memberBio;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }

    public String getMemberDesignation() {
        return memberDesignation;
    }

    public void setMemberDesignation(String memberDesignation) {
        this.memberDesignation = memberDesignation;
    }
}
