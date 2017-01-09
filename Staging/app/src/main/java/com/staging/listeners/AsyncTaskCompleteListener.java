package com.staging.listeners;

public interface AsyncTaskCompleteListener<T> {
    void onTaskComplete(T result, T tag);
}