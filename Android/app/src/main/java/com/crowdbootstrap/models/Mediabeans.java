package com.crowdbootstrap.models;

public class Mediabeans {

    String Type, Path, filesize, fileName;
    int tagno;

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilesize() {
        return filesize;
    }

    public void setFilesize(String filesize) {
        this.filesize = filesize;
    }

    public Mediabeans(String path, String type, String filesize, String fileName) {
        this.Path = path;
        this.Type = type;
        this.filesize = filesize;
        this.fileName = fileName;
        this.tagno=tagno;
    }
    public Mediabeans(String path, String type, String filesize, String fileName,int tagno) {
        this.Path = path;
        this.Type = type;
        this.filesize = filesize;
        this.fileName = fileName;
        this.tagno=tagno;
    }


    public String getType() {
        return Type;
    }


    public int getTag() {
        return tagno;
    }


    public void setType(String type) {
        Type = type;
    }

    public String getPath() {
        return Path;
    }

    public void setPath(String path) {
        Path = path;
    }
}