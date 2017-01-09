package com.crowdbootstrapapp.models;

/**
 * Created by neelmani.karn on 1/6/2016.
 */
public class GenericObject<T> {

    String id, title, answer;
    boolean ischecked;


    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public boolean ischecked() {
        return ischecked;
    }

    public void setIschecked(boolean ischecked) {
        this.ischecked = ischecked;
    }

    public String getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setId(String id) {
        this.id = id;

    }
}
