package com.staging.models;

/**
 * Created by neelmani.karn on 2/5/2016.
 */
public class ExcellenceAwardObject {

    String givenby_id, givenby_name, givenby_image, description;
    String rating, date;

    public String getGivenby_id() {
        return givenby_id;
    }

    public void setGivenby_id(String givenby_id) {
        this.givenby_id = givenby_id;
    }

    public String getGivenby_name() {
        return givenby_name;
    }

    public void setGivenby_name(String givenby_name) {
        this.givenby_name = givenby_name;
    }

    public String getGivenby_image() {
        return givenby_image;
    }

    public void setGivenby_image(String givenby_image) {
        this.givenby_image = givenby_image;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}
