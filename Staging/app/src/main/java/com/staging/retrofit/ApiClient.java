package com.staging.retrofit;



/**
 * Created by Neelmani.Karn on 11/29/2016.
 */

public class ApiClient {

   /* private static Retrofit retrofit = null;


    public static Retrofit getClient() {
        if (retrofit == null) {
            HttpLoggingInterceptor logging = new HttpLoggingInterceptor();
//          set your desired log level
            logging.setLevel(HttpLoggingInterceptor.Level.BODY);

            OkHttpClient.Builder httpClient = new OkHttpClient.Builder()
                    .readTimeout(30, TimeUnit.SECONDS)
                    .writeTimeout(30, TimeUnit.SECONDS)
                    .connectTimeout(30, TimeUnit.SECONDS);
//          add your other interceptors …

//          add logging as last interceptor
            if (BuildConfig.DEBUG)
                httpClient.addInterceptor(logging);
            retrofit = new Retrofit.Builder()
                    .baseUrl(Constants.APP_BASE_URL)
                    .addConverterFactory(GsonConverterFactory.create())
                    .client(httpClient.build())
                    .build();
            *//*retrofit.client().interceptors().add(new LoggingInterceptor());*//*
        }
        return retrofit;
    }
*/

}