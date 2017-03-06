package com.staging.listeners;

public interface AsyncTaskCompleteListener<T> {
    /**
     * When network give response in this.
     * @param result
     * @param tag
     */
    void onTaskComplete(T result, T tag);
}