package com.staging.utilities;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class TimeUtils {


    private TimeUtils() {
    }

    public static String getTime(long milliseconds) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(Constants.TIME_FORMAT);
        return dateFormat.format(new Date(milliseconds));
    }

    public static String getDate(long milliseconds) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(Constants.DATE_FORMAT);
        return dateFormat.format(new Date(milliseconds));
    }

    public static long getDateAsHeaderId(long milliseconds) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("ddMMyyyy");
        return Long.parseLong(dateFormat.format(new Date(milliseconds)));
    }

    public static String getDateOrTime(long miliseconds) {
        miliseconds = miliseconds * 1000L;

        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(miliseconds);
        SimpleDateFormat dateFormatter = new SimpleDateFormat(Constants.DATE_FORMAT);
        SimpleDateFormat timeFormatter = new SimpleDateFormat(Constants.TIME_FORMAT);

        String date = DateTimeFormatClass.convertDateObjectToMMDDYYYFormat(calendar.getTime());
        if (!date.equalsIgnoreCase(DateTimeFormatClass.convertDateObjectToMMDDYYYFormat(new Date()))) {
            return dateFormatter.format(calendar.getTime());
        }else {
            return timeFormatter.format(calendar.getTime());
        }
    }
}