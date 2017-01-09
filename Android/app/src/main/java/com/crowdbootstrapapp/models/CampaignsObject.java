package com.crowdbootstrapapp.models;

import java.util.ArrayList;

/**
 * Created by neelmani.karn on 1/12/2016.
 */
public class CampaignsObject {

    String id;
    String name;
    String startUpName;
    String startupId;
    String description;
    String targetAmount;
    String dueDate;
    String fundRaiseFor;
    boolean isFollowed;
    ArrayList<GenericObject> keywordsList;
    String roadmapGrapicImageUrl;
    ArrayList<AudioObject> audioList, videoList, documentList;

    public String getStartupId() {
        return startupId;
    }

    public void setStartupId(String startupId) {
        this.startupId = startupId;
    }

    public boolean isFollowed() {
        return isFollowed;
    }

    public void setIsFollowed(boolean isFollowed) {
        this.isFollowed = isFollowed;
    }

    public ArrayList<GenericObject> getKeywordsList() {
        return keywordsList;
    }

    public void setKeywordsList(ArrayList<GenericObject> keywordsList) {
        this.keywordsList = keywordsList;
    }

    public String getRoadmapGrapicImageUrl() {
        return roadmapGrapicImageUrl;
    }

    public void setRoadmapGrapicImageUrl(String roadmapGrapicImageUrl) {
        this.roadmapGrapicImageUrl = roadmapGrapicImageUrl;
    }

    public ArrayList<AudioObject> getAudioList() {
        return audioList;
    }

    public void setAudioList(ArrayList<AudioObject> audioList) {
        this.audioList = audioList;
    }

    public ArrayList<AudioObject> getVideoList() {
        return videoList;
    }

    public void setVideoList(ArrayList<AudioObject> videoList) {
        this.videoList = videoList;
    }

    public ArrayList<AudioObject> getDocumentList() {
        return documentList;
    }

    public void setDocumentList(ArrayList<AudioObject> documentList) {
        this.documentList = documentList;
    }

    public String getFundRaiseFor() {
        return fundRaiseFor;
    }

    public void setFundRaiseFor(String fundRaiseFor) {
        this.fundRaiseFor = fundRaiseFor;
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

    public String getStartUpName() {
        return startUpName;
    }

    public void setStartUpName(String startUpName) {
        this.startUpName = startUpName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTargetAmount() {
        return targetAmount;
    }

    public void setTargetAmount(String targetAmount) {
        this.targetAmount = targetAmount;
    }

    public String getDueDate() {
        return dueDate;
    }

    public void setDueDate(String dueDate) {
        this.dueDate = dueDate;
    }
}
