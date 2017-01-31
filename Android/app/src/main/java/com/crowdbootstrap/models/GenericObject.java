package com.crowdbootstrap.models;

/**
 * Created by neelmani.karn on 1/6/2016.
 */
public class GenericObject<T> {

    String id, title, answer;
    boolean ischecked;
    int position;

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

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

    @Override
    public String toString() {
        return title;
    }

    public boolean equals(Object o) {
        if (!(o instanceof GenericObject)) {
            return false;
        }
        GenericObject other = (GenericObject) o;
        return title.equalsIgnoreCase(other.getTitle());
    }

    public int hashCode() {
        return title.hashCode();
    }
}
