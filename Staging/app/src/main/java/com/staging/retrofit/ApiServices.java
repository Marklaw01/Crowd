package com.staging.retrofit;


/**
 * Created by neelmani.karn on 7/25/2016.
 */

public interface ApiServices {

    /*@POST(Constants.LOGIN_URL)
    Call<LoginResponseModel> login(@Body LoginRequestModel loginModel);*/

    /*@Headers({
            "Accept: application/json",
            "Content-Type: application/json",
            "App-version: " + BuildConfig.VERSION_NAME
    })
    @POST(Constants.LOGIN_URL)
    Call<LoginResponse> login(@Body LoginModel loginModel);


    @Headers({
            "Accept: application/json",
            "Content-Type: application/json",
            "App-version: " + BuildConfig.VERSION_NAME
    })
    @POST(Constants.GET_COUNTRIES_LIST_WITH_STATES)
    Call<CountryStateListResponse> countryWithStates();


    @Headers({
            "Accept: application/json",
            "Content-Type: application/json",
            "App-version: " + BuildConfig.VERSION_NAME
    })
    @GET
    Call<ArrayList<Image>> listOfImages(@Url String url);

    @Headers({
            "Accept: application/json",
            "Content-Type: application/json",
            "App-version: " + BuildConfig.VERSION_NAME
    })
    @GET(Constants.ENTREPRENEUR_BASIC_PROFILE_URL)
    Call<ViewUserBasicEntrepreneurResponse> userBasicEntrepreneur(@Query("user_id") String user_id, @Query("logged_in_user") String logged_in_user);


    @Headers({
            "Accept: application/json",
            "Content-Type: application/json"
    })
    @GET(Constants.CONTRACTOR_BASIC_PROFILE_URL)
    Call<ViewUserBasicContractorResponse> userContractorBasic(@Query("user_id") String user_id, @Query("logged_in_user") String logged_in_user);

    @Multipart
    @POST(Constants.CONTRACTOR_EDIT_BASIC_PROFILE_URL)
    Call<AfterEditedUserContractorBasicResponse> editContractorBasic(@Part("phoneno") RequestBody phoneno,
                                                                     @Part("state_id") RequestBody state_id,
                                                                     @Part("first_name") RequestBody first_name,
                                                                     @Part("price") RequestBody price,
                                                                     @Part("bio") RequestBody bio,
                                                                     @Part("email") RequestBody email,
                                                                     @Part("country_id") RequestBody country_id,
                                                                     @Part("date_of_birth") RequestBody date_of_birth,
                                                                     @Part("last_name") RequestBody last_name,
                                                                     @Part("user_id") RequestBody user_id,
                                                                     @Part MultipartBody.Part file);
*/
}