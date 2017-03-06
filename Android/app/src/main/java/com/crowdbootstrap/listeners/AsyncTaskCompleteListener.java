package com.crowdbootstrap.listeners;

public interface AsyncTaskCompleteListener<T> {
    void onTaskComplete(T result, T tag);
}