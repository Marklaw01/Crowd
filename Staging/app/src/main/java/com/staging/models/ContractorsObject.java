package com.staging.models;

/**
 * Created by neelmani.karn on 2/1/2016.
 */
public class ContractorsObject {

    private String image;
    private String id, contractorName, contractorRate, contractorSkills, bio;
    private int isContributorType;
    private String isPublicProfile;
    private String invitationSent;
    private String isNetwork;
    private String businessConnectionTypeId;
    private String cardId;

    public String getIsPublicProfile() {
        return isPublicProfile;
    }

    public void setIsPublicProfile(String isPublicProfile) {
        this.isPublicProfile = isPublicProfile;
    }

    public String getIsNetwork() {
        return isNetwork;
    }

    public void setIsNetwork(String isNetwork) {
        this.isNetwork = isNetwork;
    }

    public String getBusinessConnectionTypeId() {
        return businessConnectionTypeId;
    }

    public void setBusinessConnectionTypeId(String businessConnectionTypeId) {
        this.businessConnectionTypeId = businessConnectionTypeId;
    }

    public String getCardId() {
        return cardId;
    }

    public void setCardId(String cardId) {
        this.cardId = cardId;
    }

    public String getInvitationSent() {
        return invitationSent;
    }

    public void setInvitationSent(String invitationSent) {
        this.invitationSent = invitationSent;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public int getIsContributorType() {
        return isContributorType;
    }

    public int isContributorType() {
        return isContributorType;
    }

    public void setIsContributorType(int isContributorType) {
        this.isContributorType = isContributorType;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getContractorName() {
        return contractorName;
    }

    public void setContractorName(String contractorName) {
        this.contractorName = contractorName;
    }

    public String getContractorRate() {
        return contractorRate;
    }

    public void setContractorRate(String contractorRate) {
        this.contractorRate = contractorRate;
    }

    public String getContractorSkills() {
        return contractorSkills;
    }

    public void setContractorSkills(String contractorSkills) {
        this.contractorSkills = contractorSkills;
    }
}
