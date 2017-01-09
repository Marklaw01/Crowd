package com.crowdbootstrapapp.listeners;

public interface AsyncTaskCompleteListener<T> {
    void onTaskComplete(T result, T tag);
}