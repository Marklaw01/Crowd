package com.crowdbootstrapapp.models;

/**
 * Created by neelmani.karn on 1/20/2016.
 */
public class NotesObject {
    private String noteId;
    private String noteName;
    private String noteCreatedDate;
    private String noteStartupId;
    private String noteStartupName;
    private String noteDescription;

    public String getNoteDescription() {
        return noteDescription;
    }

    public void setNoteDescription(String noteDescription) {
        this.noteDescription = noteDescription;
    }

    public String getNoteId() {
        return noteId;
    }

    public void setNoteId(String noteId) {
        this.noteId = noteId;
    }

    public String getNoteName() {
        return noteName;
    }

    public void setNoteName(String noteName) {
        this.noteName = noteName;
    }

    public String getNoteCreatedDate() {
        return noteCreatedDate;
    }

    public void setNoteCreatedDate(String noteCreatedDate) {
        this.noteCreatedDate = noteCreatedDate;
    }

    public String getNoteStartupId() {
        return noteStartupId;
    }

    public void setNoteStartupId(String noteStartupId) {
        this.noteStartupId = noteStartupId;
    }

    public String getNoteStartupName() {
        return noteStartupName;
    }

    public void setNoteStartupName(String noteStartupName) {
        this.noteStartupName = noteStartupName;
    }

}
