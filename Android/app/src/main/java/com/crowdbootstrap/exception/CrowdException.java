package com.crowdbootstrap.exception;

/**
 * Created by Neelmani.Karn on 1/23/2017.
 */

public class CrowdException extends Exception {
    /**
     * Constructs a new {@code Exception} with the current stack trace and the
     * specified detail message.
     *
     * @param detailMessage the detail message for this exception.
     */
    public CrowdException(String detailMessage) {
        super(detailMessage);
    }
}
