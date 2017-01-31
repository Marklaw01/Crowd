package com.crowdbootstrap.models;

/**
 * Created by Neelmani.Karn on 1/19/2017.
 */

public class FundsObject {
    /*{"code":200,"TotalItems":1,"my_funds_list":[{"id":1,"fund_title":"Test fund updated","fund_start_date":"Feb 01, 2017","fund_end_date":"Mar 01, 2017","fund_close_date":"Apr 01, 2017","fund_created_by":"Vijay Kumar"}]}*/

    private String id, fund_title, fund_start_date, fund_end_date, fund_close_date, fund_created_by, fund_description, fund_image;
    private int fund_likes, fund_dislike;

    public String getFund_description() {
        return fund_description;
    }

    public void setFund_description(String fund_description) {
        this.fund_description = fund_description;
    }

    public String getFund_image() {
        return fund_image;
    }

    public void setFund_image(String fund_image) {
        this.fund_image = fund_image;
    }

    public int getFund_likes() {
        return fund_likes;
    }

    public void setFund_likes(int fund_likes) {
        this.fund_likes = fund_likes;
    }

    public int getFund_dislike() {
        return fund_dislike;
    }

    public void setFund_dislike(int fund_dislike) {
        this.fund_dislike = fund_dislike;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFund_title() {
        return fund_title;
    }

    public void setFund_title(String fund_title) {
        this.fund_title = fund_title;
    }

    public String getFund_start_date() {
        return fund_start_date;
    }

    public void setFund_start_date(String fund_start_date) {
        this.fund_start_date = fund_start_date;
    }

    public String getFund_end_date() {
        return fund_end_date;
    }

    public void setFund_end_date(String fund_end_date) {
        this.fund_end_date = fund_end_date;
    }

    public String getFund_close_date() {
        return fund_close_date;
    }

    public void setFund_close_date(String fund_close_date) {
        this.fund_close_date = fund_close_date;
    }

    public String getFund_created_by() {
        return fund_created_by;
    }

    public void setFund_created_by(String fund_created_by) {
        this.fund_created_by = fund_created_by;
    }
}
