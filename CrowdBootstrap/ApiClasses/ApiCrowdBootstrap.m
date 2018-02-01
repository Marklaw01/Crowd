//
//  ApiCrowdBootstrap.m
//  CrowdBootstrap
//
//  Created by OSX on 08/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"


@implementation ApiCrowdBootstrap

+(void)loginWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LOGIN parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
    
    // [self postWithParameters:dictParameters service:CROWDBOOTSTRAP_LOGIN success:success failure:failure];
}

+(void)logoutWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_LOGOUT parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
    }];
    
}

+(void)sendResetPasswordMailWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_RESET_PASSWORD_MAIL parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)resendConfirmationMailWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_RESEND_CONFIRMATION_MAIL parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)sendMaxLimitResetPasswordWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_MAX_LIMIT_RESET_PASSWPRD parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
    
}

+(void)getUserSecurityQuestionsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_USER_SECURITY_QUESTIONS parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getCountries:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_COUNTRIES parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getJobTypeList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_JOB_TYPE_LIST parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)getHiredCompaniesList:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_HIRED_COMPANY_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)getJobIndustryLists:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_JOB_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getSQKCCPE:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_SQKCCPE parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getKeywords:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getCampaignKeywords:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_CAMPAIGN_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getForumKeywords:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_FORUM_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getStartupKeywords:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUP_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getTimePeriods:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_TIMEPERIOD_LIST parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getMemberRoles:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_ROLES parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getDeliverables:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_DELIVERABLES parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getCitiesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_CITIES parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getSecurityuestions:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_SECURITY_QUESTIONS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

#pragma mark - Save Device Token Api Methods
+(void)saveDeviceTokenWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_SAVE_DEVICE_TOKEN parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

#pragma mark - Setting Api Methods
+(void)registerForRoleWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_SETTINGS_REGISTER parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)unregisterForRoleWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_SETTINGS_UNREGISTER parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getRegisteredRoleListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_REGISTER_ROLE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getSettingsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_SETTINGS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

#pragma mark - Profile Api Methods
+(void)getProfileWithType:(int)profileType forUserType:(int)userType withParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSString *strApi ;
    if(userType == CONTRACTOR) {
        if(profileType == PROFILE_BASIC_SELECTED)
            strApi = CROWDBOOTSTRAP_CONT_BASIC_PROFILE ;
        else
            strApi = CROWDBOOTSTRAP_CONT_PROFESSIONAL_PROFILE ;
    }
    else{
        if(profileType == PROFILE_BASIC_SELECTED) strApi = CROWDBOOTSTRAP_ENT_BASIC_PROFILE ;
        else strApi = CROWDBOOTSTRAP_ENT_PROFESSIONAL_PROFILE ;
    }
    
    NSLog(@"userType: %d strApi: %@",userType,strApi) ;
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:strApi parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        // failure(error) ;
    }] ;
    
}

+(void)registerUserWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_SIGNUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)updateProfileWithType:(int)profileType forUserType:(int)userType withParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    NSString *strApi ;
    if(profileType == PROFILE_BASIC_SELECTED){
        
        if(userType == CONTRACTOR) strApi = CROWDBOOTSTRAP_CONT_BASIC_EDIT_PROFILE ;
        else strApi = CROWDBOOTSTRAP_ENT_BASIC_EDIT_PROFILE ;
        
        [operationManager POST:strApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            // Append User ID
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBasicEditProfileAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kBasicEditProfileAPI_UserID];
            // Append Bio
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBasicEditProfileAPI_Bio]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kBasicEditProfileAPI_Bio];
            // Append First Name
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBasicEditProfileAPI_FirstName]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kBasicEditProfileAPI_FirstName];
            // Append Last Name
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBasicEditProfileAPI_LastName]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kBasicEditProfileAPI_LastName];
            // Append Email
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBasicEditProfileAPI_Email]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kBasicEditProfileAPI_Email];
            // Append Dob
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBasicEditProfileAPI_Dob]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kBasicEditProfileAPI_Dob];
            // Append Country ID
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBasicEditProfileAPI_CountryID]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kBasicEditProfileAPI_CountryID];
            // Append City ID
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBasicEditProfileAPI_CityID]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kBasicEditProfileAPI_CityID];
            // Append Phone
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBasicEditProfileAPI_Phone]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kBasicEditProfileAPI_Phone];
            
            if(userType == CONTRACTOR)// Append Price
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBasicEditProfileAPI_Price]] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:kBasicEditProfileAPI_Price];
            else // Append Interests
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBasicEditProfileAPI_Interests]] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:kBasicEditProfileAPI_Interests];
            
            if([dictParameters objectForKey:kBasicEditProfileAPI_Image]){
                NSData *imageData = (NSData*)[dictParameters objectForKey:kBasicEditProfileAPI_Image] ;
//                NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[dictParameters objectForKey:kBasicEditProfileAPI_FirstName]] ;
                // Append Image
                [formData appendPartWithFileData:imageData
                                            name:kBasicEditProfileAPI_Image
                                        fileName:@"image.png"
                                        mimeType:@"image/png"];
            }
            
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            success(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
            failure(error) ;
        }] ;
        
    }
    else{ // Update Professional Profile
        
        if(userType == CONTRACTOR) strApi = CROWDBOOTSTRAP_CONT_PROF_EDIT_PROFILE ;
        else strApi = CROWDBOOTSTRAP_ENT_PROF_EDIT_PROFILE ;
        
        
        [operationManager POST:strApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            // Append User ID
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kProfEditProfileAPI_UserID];
            // Append First Name
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_FirstName]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kProfEditProfileAPI_FirstName];
            // Append Last Name
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_LastName]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kProfEditProfileAPI_LastName];
            // Append Keywords
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kProfEditProfileAPI_Keywords];
            // Append Qualifications
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_Qualifications]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kProfEditProfileAPI_Qualifications];
            // Append Skills
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_Skills]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kProfEditProfileAPI_Skills];
            // Append Industry Focus
            [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_IndustryFocus]] dataUsingEncoding:NSUTF8StringEncoding]
                                        name:kProfEditProfileAPI_IndustryFocus];
            
            if( userType == CONTRACTOR){
                
                // Append Price
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_Price]] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:kProfEditProfileAPI_Price];
                // Append Experience ID
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_ExperienceID]] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:kProfEditProfileAPI_ExperienceID];
                // Append Certifications
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_Certifications]] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:kProfEditProfileAPI_Certifications];
                // Append Startup Stage
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_StartupStage]] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:kProfEditProfileAPI_StartupStage];
                // Append Contractor Type
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_ContributorType]] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:kProfEditProfileAPI_ContributorType];
                // Append Accredited Investor
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_AccreditedInvestor]] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:kProfEditProfileAPI_AccreditedInvestor];
            }
            else{
                
                // Append Company Name
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_CompanyName]] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:kProfEditProfileAPI_CompanyName];
                // Append Website Link
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_WebsiteLink]] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:kProfEditProfileAPI_WebsiteLink];
                // Append Description
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProfEditProfileAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                            name:kProfEditProfileAPI_Description];
            }
            
            if([dictParameters objectForKey:kProfEditProfileAPI_Image]){
                NSData *imageData = (NSData*)[dictParameters objectForKey:kProfEditProfileAPI_Image] ;
//                NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[dictParameters objectForKey:kProfEditProfileAPI_FirstName]] ;
                // Append Image
                [formData appendPartWithFileData:imageData
                                            name:kProfEditProfileAPI_Image
                                        fileName:@"image.png"
                                        mimeType:@"image/png"];
            }
            
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            success(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
            failure(error) ;
        }] ;
        
    }
}

+(void)getUserStartupsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_USER_STARTUPS parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getProfielUserStartupsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_PROFILE_SELECTED_STARTUP parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)updateProfileSettingsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_PROFILE_SETTINGS parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)addStartupsToProfileWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_PROFILE_ADD_STARTUPLIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)addStartupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_ADD_STARTUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)followUnfollowUserWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_UNFOLLOW_USER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

#pragma mark - Campaign Api Methods
+(void)getCampaignsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_CAMPAIGNS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
}

+(void)commitCampaignWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_CAMPAIGN parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)addCampaignwithParametersOld:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress{
    
    // AFNetworking request
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_CAMPAIGN parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_UserID];
        // Append Startup ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_StartupID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_StartupID];
        // Append Campaign Name
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_CampaignName]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_CampaignName];
        // Append Summary
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_Summary]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_Summary];
        // Append Target Amount
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_TargetAmount]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_TargetAmount];
        // Append Fund Raised So Far
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_FundRaisedSoFar]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_FundRaisedSoFar];
        // Append Due Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_DueDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_DueDate];
        // Append Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_Keywords];
        
        
        if([dictParameters objectForKey:kAddCampaignAPI_CampaignImage]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_CampaignImage] ;
            //NSString *imageFileName = [NSString stringWithFormat:@"%@_Image.png",[dictParameters objectForKey:kAddCampaignAPI_CampaignName]] ;
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kAddCampaignAPI_CampaignImage
                                    fileName:@"Campaign_Image.png"
                                    mimeType:@"image/png"];
        }
        //if([dictParameters objectForKey:kAddCampaignAPI_Video]){
        
        
        NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
        NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
        NSString *videoFileName = @"filename.mp4";
        //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
        //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
        [formData appendPartWithFileData:videoData
                                    name:kAddCampaignAPI_Video
                                fileName:videoFileName
                                mimeType:@"video/mp4"];
        
        // }
        
    }
                                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                         
                                                         NSLog(@"Response: %@", responseObject);
                                                         
                                                     }
                                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                         
                                                         NSLog(@"Error: %@", error);
                                                         
                                                     }
                                                ];
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress for Track %f:", percentDone);
        
    }];
    
    //  [requestOperation start];
    
}


+(void)addCampaignwithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    
    // AFNetworking request
    /*AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     
     [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
     
     [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
     [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];*/
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_CAMPAIGN parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_UserID];
        // Append Startup ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_StartupID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_StartupID];
        // Append Campaign Name
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_CampaignName]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_CampaignName];
        // Append Summary
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_Summary]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_Summary];
        // Append Target Amount
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_TargetAmount]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_TargetAmount];
        // Append Fund Raised So Far
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_FundRaisedSoFar]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_FundRaisedSoFar];
        // Append Due Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_DueDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_DueDate];
        // Append Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_Keywords];
        
        // Append Campaign Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCampaignAPI_CampaignKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCampaignAPI_CampaignKeywords];
        
        
        if([dictParameters objectForKey:kAddCampaignAPI_CampaignImage]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_CampaignImage] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@_Image.png",[dictParameters objectForKey:kAddCampaignAPI_CampaignName]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kAddCampaignAPI_CampaignImage
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editCampaignwithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    
    AFHTTPRequestOperation *requestOperation = [operationManager POST:CROWDBOOTSTRAP_EDIT_CAMPAIGN parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // Append Campaign ID
        
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCampaignAPI_CampaignID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCampaignAPI_CampaignID];
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCampaignAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCampaignAPI_UserID];
        // Append Startup ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCampaignAPI_StartupID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCampaignAPI_StartupID];
        // Append Campaign Name
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCampaignAPI_CampaignName]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCampaignAPI_CampaignName];
        // Append Summary
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCampaignAPI_Summary]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCampaignAPI_Summary];
        // Append Target Amount
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCampaignAPI_TargetAmount]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCampaignAPI_TargetAmount];
        // Append Fund Raised So Far
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCampaignAPI_FundRaisedSoFar]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCampaignAPI_FundRaisedSoFar];
        // Append Due Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCampaignAPI_DueDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCampaignAPI_DueDate];
        // Append Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCampaignAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCampaignAPI_Keywords];
        
        // Append Campaign Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCampaignAPI_CampaignKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCampaignAPI_CampaignKeywords];
        
        // Append Deleted Files
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCampaignAPI_DeletedFiles]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCampaignAPI_DeletedFiles];
        
        
        
        if([dictParameters objectForKey:kEditCampaignAPI_CampaignImage]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kEditCampaignAPI_CampaignImage] ;
            NSString *imageFileName = @"Campaign_Image.png" ;
            //NSString *imageFileName = [NSString stringWithFormat:@"%@_Image.png",[dictParameters objectForKey:kEditCampaignAPI_CampaignName]] ;
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kEditCampaignAPI_CampaignImage
                                    fileName:imageFileName
                                    mimeType:@"image/png"];
        }
        /* if([dictParameters objectForKey:kEditCampaignAPI_Video]){
         NSData *videoData = (NSData*)[dictParameters objectForKey:kEditCampaignAPI_Video] ;
         NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kEditCampaignAPI_Video]] ;
         // Append Video
         [formData appendPartWithFileData:videoData
         name:kEditCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/quicktime"];
         
         //[formData appendPartWithFileData:videoData name:@"video_file" fileName:@"testvideo.mov" mimeType:@"video/quicktime"];
         
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        //NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)getCampaignDetailwithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_CAMPAIGN_DETAIL parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)followUnfollowCampaignWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_CAMPAIGN parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)uncommitCampaignWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_UNCOMMIT_CAMPAIGN parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getCommittedContractorsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_COMMITTED_CONTRACTORS parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)rejectCommittedUserWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_REJECT_COMMITED_USER parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)searchCampaignsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_SEARCH_CAMPAIGN parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

#pragma mark - Startups API Methods
+(void)getStartupsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUPS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
}

+(void)getStartupOverviewWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUP_OVERVIEW parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)getStartupTeamWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUP_TEAM parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

+(void)updateStartupTeamMemberStatusWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    /*  operationManager.responseSerializer = [AFJSONResponseSerializer
     serializerWithReadingOptions:NSJSONReadingAllowFragments];*/
    [operationManager GET:CROWDBOOTSTRAP_STARTUP_TEAMMEMBER_STATUS parameters:dictParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
}

+(void)startupTeamMessageWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_STARTUP_TEAM_MESSAGE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getStartupWorkOrderEntrepreneurWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUP_WORKORDER_ENT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
}

+(void)getStartupWorkOrderDetailEntrepreneurWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_STARTUP_WORKORDER_DETAIL_ENT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
}

+(void)updateStartupWorkOrderStatusAcceptedWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUP_WORKORDER_ACCEPT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)updateStartupWorkOrderStatusRejectedWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUP_WORKORDER_REJECT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getStartupWorkOrderContractorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_STARTUP_WORKORDER_CONT parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)getSavedStartupWorkOrderContractorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_WORKORDER_CONT_SAVED parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)saveSubmitWorkOrderContractorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_WORKORDER_CONT_SUBMIT parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}


+(void)updateStartupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_UPDATE_STARTUP parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append Startup ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kUpdateStartupAPI_StartupID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kUpdateStartupAPI_StartupID];
        
        // Append Startup Name
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kUpdateStartupAPI_StartupName]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kUpdateStartupAPI_StartupName];
        
        // Append Startup Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kUpdateStartupAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kUpdateStartupAPI_Description];
        
        // Append Next Step
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kUpdateStartupAPI_NextStep]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kUpdateStartupAPI_NextStep];
        
        // Append Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kUpdateStartupAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kUpdateStartupAPI_Keywords];
        
        // Append Support Required
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kUpdateStartupAPI_SupportRequired]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kUpdateStartupAPI_SupportRequired];
        
        if([dictParameters objectForKey:kUpdateStartupAPI_RoadmapGraphic]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kUpdateStartupAPI_RoadmapGraphic] ;
            NSString *imageFileName = [NSString stringWithFormat:@"Startup%@_Image.png",[dictParameters objectForKey:kUpdateStartupAPI_StartupID]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kUpdateStartupAPI_RoadmapGraphic
                                    fileName:imageFileName
                                    mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        // progress(percentDone) ;
    }];
}

+(void)updateStartupWorkOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UPDATE_WORKORDER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)getStartupDocsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUP_DOCSLIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}


+(void)getRecommendedContractorsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_RECOMMENDED_CONT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
    
}

+(void)downloadStartupDocsFilesWithPath:(NSString*)filePath success:(SuccessBlock)success failure:(FailureBlock)failure;{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if(error) failure(error) ;
        else{
            NSLog(@"File downloaded to: %@", filePath);
            [UtilityClass showNotificationMessgae:@"Download Complete" withResultType:@"1" withDuration:1] ;
        }
        
    }];
    [downloadTask resume];
}

+(void)getStartupRoadmapDocsStatusWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUP_ROADMAP_DOCS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)submitStartupQuestionaireWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_STARTUP_QUESTIONS parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

#pragma mark - Contractor Api Methods
+(void)searchContractorsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_SEARCH_CONT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addContractorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_ADD_CONTRACTOR parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error> %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getUserRatingsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_USER_RATINGS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addRatingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_RATE_CONTRACTOR parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error %@",error) ;
        failure(error) ;
        
    }];
}

+(void)submitWorkorderRatingsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_SUBMIT_WORKORDER_RATINGS parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error %@",error) ;
        failure(error) ;
        
    }];
}

+(void)deleteStartupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_DELETE_STARTUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteCampaignWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_DELETE_CAMPAIGN parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMessagesListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_MESSAGES_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchivedMessagesListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_ARCHIVED_MESSAGES_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveDeleteMessageWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_ARCHIVE_DELETE_MESSAGE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getStartupApplicationQuesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUP_APP_QUESTIONS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

#pragma mark - Funds Api Methods
+(void)getFindFundsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_FUNDS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyFundsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYFUNDS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveFundsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_FUNDS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedFundsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_FUNDS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_FUND parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_FUND parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_FUND parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_FUND parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getFundKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_FUND_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getFundIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_FUND_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getFundSponsorKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_FUND_SPONSOR_KEYWORDS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getFundManagerKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_FUND_MANAGER_KEYWORDS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getFundPortfolioKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_FUND_PORTFOLIO_KEYWORDS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getEditFundPortfolioKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_EDIT_FUND_PORTFOLIO_KEYWORDS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)viewFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FUND_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress  {
    
    // AFNetworking request
    /*AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     
     [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
     
     [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
     [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];*/
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;

    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_FUND parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_UserID];
        // Append Fund Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_Fund_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_Fund_Title];
        // Append Fund Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_Description];
        // Append Fund Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_StarDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_StarDate];
        // Append Fund End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_EndDate];
        // Append Fund Close Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_CloseDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_CloseDate];
        
        // Append Fund Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_Keywords];
        
        // Append Fund Industry Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_IndustryKeywords];

        // Append Fund Manager Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_Managers]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_Managers];

        // Append Fund Sponsor Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_Sponsors]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_Sponsors];

        // Append Fund Portfolio Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_PortfolioKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_PortfolioKeywords];

        if([dictParameters objectForKey:kAddFundAPI_Fund_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kAddFundAPI_Fund_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kAddFundAPI_Fund_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kAddFundAPI_Fund_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress  {
    
    // AFNetworking request
    /*AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     
     [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
     
     [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
     [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];*/
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_FUND parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_UserID];
        
        // Append Fund ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFundDetailAPI_FundID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFundDetailAPI_FundID];

        // Append Fund Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_Fund_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_Fund_Title];
        // Append Fund Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_Description];
        // Append Fund Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_StarDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_StarDate];
        // Append Fund End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_EndDate];
        // Append Fund Close Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_CloseDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_CloseDate];
        
        // Append Fund Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_Keywords];
        
        // Append Fund Industry Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_IndustryKeywords];
        
        // Append Fund Manager Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_Managers]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_Managers];
        
        // Append Fund Sponsor Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_Sponsors]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_Sponsors];
        
        // Append Fund Portfolio Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFundAPI_PortfolioKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFundAPI_PortfolioKeywords];
        
        // Append Fund Deleted Data
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditFundAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditFundAPI_Image_Del];

        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditFundAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditFundAPI_Doc_Del];

        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditFundAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditFundAPI_Audio_Del];

        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditFundAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditFundAPI_Video_Del];

        if([dictParameters objectForKey:kAddFundAPI_Fund_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kAddFundAPI_Fund_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kAddFundAPI_Fund_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;

            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kAddFundAPI_Fund_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_FUND parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_FUND parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_FUND parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_FUND parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeFundListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_LIKE_FUND_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDislikeFundListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_FUND_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

#pragma mark - Beta Tests Api Methods
+(void)getSearchBetaTestsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_BETA_TEST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyBetaTestsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYBETA_TEST_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveBetaTestsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_BETA_TEST_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedBetaTestsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_BETA_TEST_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_BETA_TEST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_BETA_TEST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_BETA_TEST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_BETA_TEST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getBetaTestKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_BETA_TEST_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getBetaTestIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_BETA_TEST_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getBetaTestTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_BETA_TEST_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
        AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
        
        operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
        [operationManager POST:CROWDBOOTSTRAP_BETA_TEST_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            failure(error) ;
        }] ;
}

+(void)commitBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_BETA_TEST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_BETA_TEST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getBetaTestCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_BETA_TEST_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_BETA_TEST parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_UserID];
        // Append BetaTest Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_BetaTest_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_BetaTest_Title];
        // Append BetaTest Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_Description];
        // Append BetaTest Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_StartDate];
        // Append BetaTest End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_EndDate];
        
        // Append BetaTest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBetaTestAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBetaTestAPI_Keywords];
        
        // Append BetaTest Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBetaTestAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBetaTestAPI_IndustryKeywords];
        
        // Append BetaTest Portfolio Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBetaTestAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBetaTestAPI_Target_Market_Keywords];
        
        // Append BetaTest Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_BetaTest_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_BetaTest_Document];
        
        // Append BetaTest Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_BetaTest_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_BetaTest_Audio];
        
        // Append BetaTest Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_BetaTest_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_BetaTest_Video];
        
        if([dictParameters objectForKey:kBetaTestAPI_BetaTest_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kBetaTestAPI_BetaTest_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kBetaTestAPI_BetaTest_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kBetaTestAPI_BetaTest_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_BETA_TEST parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_UserID];
        
        // Append Beta Test ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_BetaID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_BetaID];
        
        // Append Beta Test Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_BetaTest_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_BetaTest_Title];
        // Append Beta Test Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_Description];
        // Append Beta Test Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_StartDate];
        // Append Beta Test End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_EndDate];
        
        // Append Beta Test Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBetaTestAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBetaTestAPI_Keywords];
        
        // Append Beta Test Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBetaTestAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBetaTestAPI_IndustryKeywords];
    
        // Append Beta Test Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBetaTestAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBetaTestAPI_Target_Market_Keywords];
        
        // Append Beta Test Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_BetaTest_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_BetaTest_Document];
        
        // Append Beta Test Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_BetaTest_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_BetaTest_Audio];
        
        // Append Beta Test Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBetaTestAPI_BetaTest_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBetaTestAPI_BetaTest_Video];

        // Append Beta Test Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditBetaTestAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditBetaTestAPI_Image_Del];

        // Append Beta Test Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditBetaTestAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditBetaTestAPI_Doc_Del];
        
        // Append Beta Test Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditBetaTestAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditBetaTestAPI_Audio_Del];
        
        // Append Beta Test Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditBetaTestAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditBetaTestAPI_Video_Del];
        
        // Append Beta Test Image
        if([dictParameters objectForKey:kBetaTestAPI_BetaTest_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kBetaTestAPI_BetaTest_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kBetaTestAPI_BetaTest_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kBetaTestAPI_BetaTest_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_BETA_TEST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_BETA_TEST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_BETA_TEST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_BETA_TEST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeBetaTestListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_BETA_TEST_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeBetaTestListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_BETA_TEST_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Board Members Api Methods
+(void)getSearchBoardMembersWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_BOARD_MEMBER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyBoardMembersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYBOARD_MEMBER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveBoardMembersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_BOARD_MEMBER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedBoardMembersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_BOARD_MEMBER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_BOARD_MEMBER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_BOARD_MEMBER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_BOARD_MEMBER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_BOARD_MEMBER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getBoardMemberKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_BOARD_MEMBER_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getBoardMemberIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_BOARD_MEMBER_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getBoardMemberTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_BOARD_MEMBER_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_BOARD_MEMBER_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_BOARD_MEMBER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_BOARD_MEMBER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getBoardMemberCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_BOARD_MEMBER_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_BOARD_MEMBER parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_UserID];
        // Append BoardMember Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_BoardMember_Title];
        // Append BoardMember Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_Description];
        // Append BoardMember Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_StartDate];
        // Append BoardMember End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_EndDate];
        
        // Append BoardMember Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBoardMemberAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBoardMemberAPI_Keywords];
        
        // Append BoardMember Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBoardMemberAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBoardMemberAPI_IndustryKeywords];
        
        // Append BoardMember Portfolio Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBoardMemberAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBoardMemberAPI_Target_Market_Keywords];
        
        // Append BoardMember Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_BoardMember_Document];
        
        // Append BoardMember Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_BoardMember_Audio];
        
        // Append BoardMember Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_BoardMember_Video];

        if([dictParameters objectForKey:kBoardMemberAPI_BoardMember_Image]) {
            NSData *imageData = (NSData*)[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kBoardMemberAPI_BoardMember_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_BOARD_MEMBER parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_UserID];
        
        // Append Board Member ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_BoardID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_BoardID];
        
        // Append Board Member Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_BoardMember_Title];
        // Append Board Member Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_Description];
        // Append Board Member Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_StartDate];
        // Append Board Member End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_EndDate];
        
        // Append Board Member Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBoardMemberAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBoardMemberAPI_Keywords];
        
        // Append Board Member Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBoardMemberAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBoardMemberAPI_IndustryKeywords];
        
        // Append Board Member Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddBoardMemberAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddBoardMemberAPI_Target_Market_Keywords];
        
        // Append Board Member Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_BoardMember_Document];
        
        // Append Board Member Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_BoardMember_Audio];
        
        // Append Board Membert Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBoardMemberAPI_BoardMember_Video];

        // Append Board Member Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditBoardMemberAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditBoardMemberAPI_Image_Del];
        
        
        // Append Board Member Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditBoardMemberAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditBoardMemberAPI_Doc_Del];
        
        // Append Board Member Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditBoardMemberAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditBoardMemberAPI_Audio_Del];
        
        // Append Board Membert Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditBoardMemberAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditBoardMemberAPI_Video_Del];
        
        // Append Board Member Image
        if([dictParameters objectForKey:kBoardMemberAPI_BoardMember_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kBoardMemberAPI_BoardMember_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kBoardMemberAPI_BoardMember_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_BOARD_MEMBER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_BOARD_MEMBER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_BOARD_MEMBER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_BOARD_MEMBER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeBoardMemberListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_BOARD_MEMBER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeBoardMemberListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_BOARD_MEMBER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Communal Asset Api Methods
+(void)getSearchCommunalAssetsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_COMMUNAL_ASSET parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyCommunalAssetsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYCOMMUNAL_ASSET_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveCommunalAssetsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_COMMUNAL_ASSET_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedCommunalAssetsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_COMMUNAL_ASSET_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_COMMUNAL_ASSET parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_COMMUNAL_ASSET parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_COMMUNAL_ASSET parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_COMMUNAL_ASSET parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getCommunalAssetKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_COMMUNAL_ASSET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getCommunalAssetIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_COMMUNAL_ASSET_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getCommunalAssetTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_COMMUNAL_ASSET_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMUNAL_ASSET_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_COMMUNAL_ASSET parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_COMMUNAL_ASSET parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getCommunalAssetCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_COMMUNAL_ASSET_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_COMMUNAL_ASSET parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_UserID];
        // Append CommunalAsset Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_Title];
        // Append CommunalAsset Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_Description];
        // Append CommunalAsset Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_StartDate];
        // Append CommunalAsset End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_EndDate];
        
        // Append Communal Asset Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCommunalAssetAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCommunalAssetAPI_Keywords];
        
        // Append Industry Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCommunalAssetAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCommunalAssetAPI_IndustryKeywords];
        
        // Append Target Market Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCommunalAssetAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCommunalAssetAPI_Target_Market_Keywords];
        
        // Append Communal Asset Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_Document];
        
        // Append Communal Asset Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_Audio];
        
        // Append Communal Asset Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_Video];

        if([dictParameters objectForKey:kCommunalAssetAPI_Image]) {
            NSData *imageData = (NSData*)[dictParameters objectForKey:kCommunalAssetAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kCommunalAssetAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kCommunalAssetAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_COMMUNAL_ASSET parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_UserID];
        
        // Append Board Member ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_AssetID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_AssetID];
        
        // Append Board Member Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_Title];
        // Append Board Member Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_Description];
        // Append Board Member Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_StartDate];
        // Append Board Member End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_EndDate];
        
        // Append Board Member Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCommunalAssetAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCommunalAssetAPI_Keywords];
        
        // Append Board Member Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCommunalAssetAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCommunalAssetAPI_IndustryKeywords];
        
        // Append Board Member Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCommunalAssetAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCommunalAssetAPI_Target_Market_Keywords];
        
        // Append Board Member Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_Document];
        
        // Append Board Member Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_Audio];
        
        // Append Board Membert Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCommunalAssetAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCommunalAssetAPI_Video];
        
        // Append Board Member Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCommunalAssetAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCommunalAssetAPI_Image_Del];
        
        
        // Append Board Member Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCommunalAssetAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCommunalAssetAPI_Doc_Del];
        
        // Append Board Member Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCommunalAssetAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCommunalAssetAPI_Audio_Del];
        
        // Append Board Membert Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCommunalAssetAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCommunalAssetAPI_Video_Del];
        
        // Append Board Member Image
        if([dictParameters objectForKey:kCommunalAssetAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kCommunalAssetAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kCommunalAssetAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kCommunalAssetAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_COMMUNAL_ASSET parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_COMMUNAL_ASSET parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_COMMUNAL_ASSET parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_COMMUNAL_ASSET parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeCommunalAssetListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_COMMUNAL_ASSET_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeCommunalAssetListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_COMMUNAL_ASSET_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Consulting Api Methods
+(void)getSearchConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_CONSULTING parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYCONSULTING_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_CONSULTING_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getClosedConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_CLOSED_CONSULTING_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getInvitationConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_INVITATION_CONSULTING_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_CONSULTING parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_CONSULTING parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)openConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_OPEN_CONSULTING parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)closeConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_CLOSE_CONSULTING parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getConsultingIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_CONSULTING_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getConsultingTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_CONSULTING_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_CONSULTING_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_CONSULTING parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_CONSULTING parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getConsultingCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_CONSULTING_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)searchConsultingContractorsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_CONSULTING_SEARCH_CONT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)sendConsultingInvitationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_CONSULTING_SEND_INVITATION parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }];
}

+(void)addConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_CONSULTING parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_UserID];
        // Append Consulting Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Title];
        // Append Consulting Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Description];
        // Append Consulting OverView
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Overview]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Overview];

        // Append Consulting Dates
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Project_Overview_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Project_Overview_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Bid_Intent_Deadline_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Bid_Intent_Deadline_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Req_Dist_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Req_Dist_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Bid_Comm_Deadline_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Bid_Comm_Deadline_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Ques_Deadline_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Ques_Deadline_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Answer_Target_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Answer_Target_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Proposal_Submit_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Proposal_Submit_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Bidder_Pres_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Bidder_Pres_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Project_Award_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Project_Award_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Project_Start_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Project_Start_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Project_Complete_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Project_Complete_Date];
        
        // Append Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddConsultingAPI_InterestKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddConsultingAPI_InterestKeywords];
        
        // Append Target User Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddConsultingAPI_Target_User_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddConsultingAPI_Target_User_Keywords];
        
        // Append Consulting Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Document];
        
        // Append Consulting Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Audio];
        
        // Append Consulting Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Video];
        
        // Append Consulting Question
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Question]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Question];

        // Append Consulting Final Bid
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_FinalBid]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_FinalBid];

        // Append Image
        if([dictParameters objectForKey:kConsultingAPI_Image]) {
            NSData *imageData = (NSData*)[dictParameters objectForKey:kConsultingAPI_Image] ;
            //NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kConsultingAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            [formData appendPartWithFileData:imageData
                                        name:kConsultingAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_CONSULTING parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_UserID];
        
        // Append Consulting ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_ConsultingID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_ConsultingID];
        
        // Append Consulting Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Title];
        // Append Consulting Overview
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Overview]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Overview];

        // Append Consulting Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Description];
        // Append Consulting Dates
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Project_Overview_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Project_Overview_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Bid_Intent_Deadline_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Bid_Intent_Deadline_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Req_Dist_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Req_Dist_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Bid_Comm_Deadline_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Bid_Comm_Deadline_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Ques_Deadline_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Ques_Deadline_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Answer_Target_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Answer_Target_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Proposal_Submit_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Proposal_Submit_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Bidder_Pres_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Bidder_Pres_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Project_Award_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Project_Award_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Project_Start_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Project_Start_Date];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Project_Complete_Date]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Project_Complete_Date];
        
        // Append Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddConsultingAPI_InterestKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddConsultingAPI_InterestKeywords];
        
        // Append Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddConsultingAPI_Target_User_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddConsultingAPI_Target_User_Keywords];
        
        // Append Consulting Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Document];
        
        // Append Consulting Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Audio];
        
        // Append Consulting Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Video];
        
        // Append Consulting Question
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_Question]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_Question];
        
        // Append Consulting Final Bid
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConsultingAPI_FinalBid]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConsultingAPI_FinalBid];
        
        // Append Consulting Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditConsultingAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditConsultingAPI_Image_Del];
        
        
        // Append Consulting Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditConsultingAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditConsultingAPI_Doc_Del];
        
        // Append Consulting Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditConsultingAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditConsultingAPI_Audio_Del];
        
        // Append Consulting Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditConsultingAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditConsultingAPI_Video_Del];
        
        // Append Consulting Deleted Question
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditConsultingAPI_Questions_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditConsultingAPI_Questions_Del];
        
        // Append Consulting Deleted Final Bid
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditConsultingAPI_FinalBid_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditConsultingAPI_FinalBid_Del];
        
        // Append Consulting Image
        if([dictParameters objectForKey:kConsultingAPI_Image]) {
            NSData *imageData = (NSData*)[dictParameters objectForKey:kConsultingAPI_Image] ;
            //NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kConsultingAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kConsultingAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_CONSULTING parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_CONSULTING parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_CONSULTING parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_CONSULTING parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_CONSULTING_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_CONSULTING_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)acceptConsultingInvitationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_ACCEPT_INVITATION parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)rejectConsultingInvitationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_REJECT_INVITATION parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Early Adopters Api Methods
+(void)getSearchEarlyAdoptersWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_EARLY_ADOPTER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyEarlyAdoptersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYEARLY_ADOPTER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveEarlyAdoptersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_EARLY_ADOPTER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedEarlyAdoptersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_EARLY_ADOPTER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_EARLY_ADOPTER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_EARLY_ADOPTER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_EARLY_ADOPTER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_EARLY_ADOPTER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getEarlyAdopterKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_EARLY_ADOPTER_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getEarlyAdopterIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_EARLY_ADOPTER_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getEarlyAdopterTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_EARLY_ADOPTER_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_EARLY_ADOPTER_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_EARLY_ADOPTER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_EARLY_ADOPTER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getEarlyAdopterCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_EARLY_ADOPTER_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_EARLY_ADOPTER parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_UserID];
        // Append EarlyAdopter Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_EarlyAdopter_Title];
        // Append EarlyAdopter Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_Description];
        // Append EarlyAdopter Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_StartDate];
        // Append EarlyAdopter End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_EndDate];
        
        // Append EarlyAdopter Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEarlyAdopterAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEarlyAdopterAPI_Keywords];
        
        // Append EarlyAdopter Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEarlyAdopterAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEarlyAdopterAPI_IndustryKeywords];
        
        // Append EarlyAdopter Portfolio Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEarlyAdopterAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEarlyAdopterAPI_Target_Market_Keywords];
        
        // Append Early Adopter Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_EarlyAdopter_Document];
        
        // Append Early Adopter Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_EarlyAdopter_Audio];
        
        // Append Early Adopter Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_EarlyAdopter_Video];

        if([dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kEarlyAdopterAPI_EarlyAdopter_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_EARLY_ADOPTER parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_UserID];
        
        // Append Early Adopter ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopterID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_EarlyAdopterID];
        
        // Append Early Adopter Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_EarlyAdopter_Title];
        // Append Early Adopter Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_Description];
        // Append Early Adopter Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_StartDate];
        // Append Early Adopter End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_EndDate];
        
        // Append Early Adopter Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEarlyAdopterAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEarlyAdopterAPI_Keywords];
        
        // Append Early Adopter Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEarlyAdopterAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEarlyAdopterAPI_IndustryKeywords];
        
        // Append Early Adopter Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEarlyAdopterAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEarlyAdopterAPI_Target_Market_Keywords];
        
        // Append Early Adopter Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_EarlyAdopter_Document];
        
        // Append Early Adopter Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_EarlyAdopter_Audio];
        
        // Append Early Adopter Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEarlyAdopterAPI_EarlyAdopter_Video];
        
        // Append Early Adopter Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditEarlyAdopterAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditEarlyAdopterAPI_Image_Del];
        
        // Append Early Adopter Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditEarlyAdopterAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditEarlyAdopterAPI_Doc_Del];
        
        // Append Early Adopter Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditEarlyAdopterAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditEarlyAdopterAPI_Audio_Del];
        
        // Append Early Adopter Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditEarlyAdopterAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditEarlyAdopterAPI_Video_Del];
        
        // Append Early Adopter Image
        if([dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kEarlyAdopterAPI_EarlyAdopter_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kEarlyAdopterAPI_EarlyAdopter_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_EARLY_ADOPTER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_EARLY_ADOPTER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_EARLY_ADOPTER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_EARLY_ADOPTER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeEarlyAdopterListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_EARLY_ADOPTER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeEarlyAdopterListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_EARLY_ADOPTER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Endorsor Api Methods
+(void)getSearchEndorsorsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_ENDORSOR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyEndorsorsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYENDORSOR_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveEndorsorsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_ENDORSOR_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedEndorsorsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_ENDORSOR_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_ENDORSOR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_ENDORSOR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_ENDORSOR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_ENDORSOR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getEndorsorKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_ENDORSOR_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getEndorsorIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_ENDORSOR_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getEndorsorTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_ENDORSOR_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ENDORSOR_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_ENDORSOR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_ENDORSOR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getEndorsorCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_ENDORSOR_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_ENDORSOR parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_UserID];

        // Append Endorsor Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_Endorsor_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_Endorsor_Title];
        // Append Endorsor Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_Description];
        // Append Endorsor Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_StartDate];
        // Append Endorsor End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_EndDate];
        
        // Append Endorsor Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEndorsorAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEndorsorAPI_Keywords];
        
        // Append Endorsor Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEndorsorAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEndorsorAPI_IndustryKeywords];
        
        // Append Endorsor Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEndorsorAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEndorsorAPI_Target_Market_Keywords];
        
        // Append Endorsor Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_Endorsor_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_Endorsor_Document];
        
        // Append Endorsor Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_Endorsor_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_Endorsor_Audio];
        
        // Append Endorsor Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_Endorsor_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_Endorsor_Audio];
        
        // Append Endorsor Image
        if([dictParameters objectForKey:kEndorsorAPI_Endorsor_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kEndorsorAPI_Endorsor_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kEndorsorAPI_Endorsor_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kEndorsorAPI_Endorsor_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_ENDORSOR parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_UserID];
        
        // Append Endorsor ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_EndorsorID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_EndorsorID];
        
        // Append Endorsor Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_Endorsor_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_Endorsor_Title];
        // Append Endorsor Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_Description];
        // Append Endorsor Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_StartDate];
        // Append Endorsor End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_EndDate];
        
        // Append Endorsor Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEndorsorAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEndorsorAPI_Keywords];
        
        // Append Endorsor Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEndorsorAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEndorsorAPI_IndustryKeywords];
        
        // Append Endorsor Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddEndorsorAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddEndorsorAPI_Target_Market_Keywords];
        
        // Append Endorsor Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_Endorsor_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_Endorsor_Document];
        
        // Append Endorsor Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_Endorsor_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_Endorsor_Audio];
        
        // Append Endorsor Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEndorsorAPI_Endorsor_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEndorsorAPI_Endorsor_Video];
        
        // Append Endorsor Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditEndorsorAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditEndorsorAPI_Image_Del];
        
        // Append Endorsor Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditEndorsorAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditEndorsorAPI_Doc_Del];
        
        // Append Endorsor Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditEndorsorAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditEndorsorAPI_Audio_Del];
        
        // Append Endorsor Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditEndorsorAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditEndorsorAPI_Video_Del];
        
        // Append Endorsor Image
        if([dictParameters objectForKey:kEndorsorAPI_Endorsor_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kEndorsorAPI_Endorsor_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kEndorsorAPI_Endorsor_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kEndorsorAPI_Endorsor_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_ENDORSOR parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_ENDORSOR parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_ENDORSOR parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_ENDORSOR parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeEndorsorListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_ENDORSOR_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeEndorsorListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_ENDORSOR_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Focus Group Api Methods
+(void)getSearchFocusGroupsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_FOCUS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyFocusGroupsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYFOCUS_GROUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveFocusGroupsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_FOCUS_GROUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedFocusGroupsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_FOCUS_GROUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_FOCUS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_FOCUS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_FOCUS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_FOCUS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getFocusGroupKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_FOCUS_GROUP_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getFocusGroupIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_FOCUS_GROUP_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getFocusGroupTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_FOCUS_GROUP_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FOCUS_GROUP_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_FOCUS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_FOCUS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getFocusGroupCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOCUS_GROUP_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_FOCUS_GROUP parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_UserID];
        
        // Append Focus Group Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_FocusGroup_Title];
        // Append Focus Group Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_Description];
        // Append Focus Group Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_StartDate];
        // Append Focus Group End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_EndDate];
        
        // Append Focus Group Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFocusGroupAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFocusGroupAPI_Keywords];
        
        // Append Focus Group Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFocusGroupAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFocusGroupAPI_IndustryKeywords];
        
        // Append Focus Group Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFocusGroupAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFocusGroupAPI_Target_Market_Keywords];
        
        // Append Focus Group Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_FocusGroup_Document];
        
        // Append Focus Group Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_FocusGroup_Audio];
        
        // Append Focus Group Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_FocusGroup_Video];

        // Append Focus Group Image
        if([dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kFocusGroupAPI_FocusGroup_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_FOCUS_GROUP parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_UserID];
        
        // Append Focus Group ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_FocusGroupID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_FocusGroupID];
        
        // Append Focus Group Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_FocusGroup_Title];
        // Append Focus Group Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_Description];
        // Append Focus Group Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_StartDate];
        // Append Focus Group End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_EndDate];
        
        // Append Focus Group Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFocusGroupAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFocusGroupAPI_Keywords];
        
        // Append Focus Group Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFocusGroupAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFocusGroupAPI_IndustryKeywords];
        
        // Append Focus Group Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFocusGroupAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFocusGroupAPI_Target_Market_Keywords];
        
        // Append Focus Group Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_FocusGroup_Document];
        
        // Append Focus Group Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_FocusGroup_Audio];
        
        // Append Focus Group Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kFocusGroupAPI_FocusGroup_Video];
        
        // Append Focus Group Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditFocusGroupAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditFocusGroupAPI_Image_Del];
        
        // Append Focus Group Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditFocusGroupAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditFocusGroupAPI_Doc_Del];
        
        // Append Focus Group Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditFocusGroupAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditFocusGroupAPI_Audio_Del];
        
        // Append Focus Group Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditFocusGroupAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditFocusGroupAPI_Video_Del];
        
        // Append Focus Group Image
        if([dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kFocusGroupAPI_FocusGroup_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kFocusGroupAPI_FocusGroup_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_FOCUS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_FOCUS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_FOCUS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_FOCUS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeFocusGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_FOCUS_GROUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeFocusGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_FOCUS_GROUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Hardware Api Methods
+(void)getSearchHardwaresWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_HARDWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyHardwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYHARDWARE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveHardwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_HARDWARE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedHardwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_HARDWARE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_HARDWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_HARDWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_HARDWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_HARDWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getHardwareKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_HARDWARE_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getHardwareIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_HARDWARE_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getHardwareTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_HARDWARE_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_HARDWARE_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_HARDWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_HARDWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getHardwareCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_HARDWARE_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_HARDWARE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_UserID];
        
        // Append Hardware Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_Hardware_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_Hardware_Title];
        // Append Hardware Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_Description];
        // Append Hardware Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_StartDate];
        // Append Hardware End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_EndDate];
        
        // Append Hardware Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddHardwareAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddHardwareAPI_Keywords];
        
        // Append Hardware Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddHardwareAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddHardwareAPI_IndustryKeywords];
        
        // Append Hardware Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddHardwareAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddHardwareAPI_Target_Market_Keywords];
        
        // Append Hardware Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_Hardware_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_Hardware_Document];
        
        // Append HardwareFocus Group Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_Hardware_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_Hardware_Audio];
        
        // Append Hardware Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_Hardware_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_Hardware_Video];
        
        // Append Hardware Image
        if([dictParameters objectForKey:kHardwareAPI_Hardware_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kHardwareAPI_Hardware_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kHardwareAPI_Hardware_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kHardwareAPI_Hardware_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_HARDWARE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_UserID];
        
        // Append Hardware ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_HardwareID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_HardwareID];
        
        // Append Hardware Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_Hardware_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_Hardware_Title];
        // Append Hardware Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_Description];
        // Append Hardware Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_StartDate];
        // Append Hardware End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_EndDate];
        
        // Append Hardware Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddHardwareAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddHardwareAPI_Keywords];
        
        // Append Hardware Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddHardwareAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddHardwareAPI_IndustryKeywords];
        
        // Append Hardware Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddHardwareAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddHardwareAPI_Target_Market_Keywords];
        
        // Append Hardware Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_Hardware_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_Hardware_Document];
        
        // Append Hardware Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_Hardware_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_Hardware_Audio];
        
        // Append Hardware Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kHardwareAPI_Hardware_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kHardwareAPI_Hardware_Video];
        
        // Append Hardware Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditHardwareAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditHardwareAPI_Image_Del];
        
        // Append Hardware Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditHardwareAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditHardwareAPI_Doc_Del];
        
        // Append Hardware Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditHardwareAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditHardwareAPI_Audio_Del];
        
        // Append Hardware Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditHardwareAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditHardwareAPI_Video_Del];
        
        // Append Hardware Image
        if([dictParameters objectForKey:kHardwareAPI_Hardware_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kHardwareAPI_Hardware_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kHardwareAPI_Hardware_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kHardwareAPI_Hardware_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_HARDWARE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_HARDWARE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_HARDWARE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_HARDWARE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeHardwareListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_HARDWARE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeHardwareListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_HARDWARE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Software Api Methods
+(void)getSearchSoftwaresWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_SOFTWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMySoftwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYSOFTWARE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveSoftwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_SOFTWARE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedSoftwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_SOFTWARE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_SOFTWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_SOFTWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_SOFTWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_SOFTWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getSoftwareKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_SOFTWARE_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getSoftwareIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_SOFTWARE_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getSoftwareTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_SOFTWARE_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_SOFTWARE_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_SOFTWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_SOFTWARE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getSoftwareCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_SOFTWARE_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_SOFTWARE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_UserID];
        
        // Append Software Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_Software_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_Software_Title];
        // Append Software Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_Description];
        // Append Software Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_StartDate];
        // Append Software End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_EndDate];
        
        // Append Software Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddSoftwareAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddSoftwareAPI_Keywords];
        
        // Append Software Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddSoftwareAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddSoftwareAPI_IndustryKeywords];
        
        // Append Software Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddSoftwareAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddSoftwareAPI_Target_Market_Keywords];
        
        // Append Software Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_Software_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_Software_Document];
        
        // Append SoftwareFocus Group Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_Software_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_Software_Audio];
        
        // Append Software Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_Software_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_Software_Video];

        // Append Software Image
        if([dictParameters objectForKey:kSoftwareAPI_Software_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kSoftwareAPI_Software_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kSoftwareAPI_Software_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kSoftwareAPI_Software_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_SOFTWARE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_UserID];
        
        // Append Software ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_SoftwareID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_SoftwareID];
        
        // Append Software Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_Software_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_Software_Title];
        // Append Software Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_Description];
        // Append Software Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_StartDate];
        // Append Software End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_EndDate];
        
        // Append Software Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddSoftwareAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddSoftwareAPI_Keywords];
        
        // Append Software Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddSoftwareAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddSoftwareAPI_IndustryKeywords];
        
        // Append Software Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddSoftwareAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddSoftwareAPI_Target_Market_Keywords];
        
        // Append Software Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_Software_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_Software_Document];
        
        // Append Software Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_Software_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_Software_Audio];
        
        // Append Software Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kSoftwareAPI_Software_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kSoftwareAPI_Software_Video];
        
        // Append Software Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditSoftwareAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditSoftwareAPI_Image_Del];
        
        // Append Software Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditSoftwareAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditSoftwareAPI_Doc_Del];
        
        // Append Software Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditSoftwareAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditSoftwareAPI_Audio_Del];
        
        // Append Software Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditSoftwareAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditSoftwareAPI_Video_Del];
        
        // Append Software Image
        if([dictParameters objectForKey:kSoftwareAPI_Software_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kSoftwareAPI_Software_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kSoftwareAPI_Software_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kSoftwareAPI_Software_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_SOFTWARE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_SOFTWARE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_SOFTWARE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_SOFTWARE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeSoftwareListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_SOFTWARE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeSoftwareListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_SOFTWARE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Service Api Methods
+(void)getSearchServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_SERVICE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyServiceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYSERVICE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveServiceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_SERVICE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedServiceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_SERVICE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_SERVICE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_SERVICE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_SERVICE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_SERVICE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getServiceKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_SERVICE_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getServiceIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_SERVICE_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getServiceTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_SERVICE_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_SERVICE_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_SERVICE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_SERVICE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getServiceCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_SERVICE_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_SERVICE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_UserID];
        
        // Append Audio/Video Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_Service_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_Service_Title];
        // Append Audio/Video Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_Description];
        // Append Audio/Video Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_StartDate];
        // Append Audio/Video End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_EndDate];
        
        // Append Audio/Video Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddServiceAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddServiceAPI_Keywords];
        
        // Append Audio/Video Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddServiceAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddServiceAPI_IndustryKeywords];
        
        // Append Audio/Video Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddServiceAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddServiceAPI_Target_Market_Keywords];
        
        // Append Audio/Video Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_Service_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_Service_Document];
        
        // Append Audio/Video Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_Service_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_Service_Audio];
        
        // Append Audio/Video Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_Service_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_Service_Video];
        
        // Append Audio/Video Image
        if([dictParameters objectForKey:kServiceAPI_Service_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kServiceAPI_Service_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kServiceAPI_Service_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kServiceAPI_Service_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_SERVICE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_UserID];
        
        // Append Service ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_ServiceID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_ServiceID];
        
        // Append Service Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_Service_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_Service_Title];
        // Append Service Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_Description];
        // Append Service Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_StartDate];
        // Append Service End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_EndDate];
        
        // Append Service Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddServiceAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddServiceAPI_Keywords];
        
        // Append Service Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddServiceAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddServiceAPI_IndustryKeywords];
        
        // Append Service Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddServiceAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddServiceAPI_Target_Market_Keywords];
        
        // Append Service Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_Service_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_Service_Document];
        
        // Append Service Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_Service_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_Service_Audio];
        
        // Append Service Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kServiceAPI_Service_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kServiceAPI_Service_Video];
        
        // Append Service Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditServiceAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditServiceAPI_Image_Del];
        
        // Append Service Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditServiceAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditServiceAPI_Doc_Del];
        
        // Append Service Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditServiceAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditServiceAPI_Audio_Del];
        
        // Append Service Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditServiceAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditServiceAPI_Video_Del];
        
        // Append Service Image
        if([dictParameters objectForKey:kServiceAPI_Service_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kServiceAPI_Service_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kServiceAPI_Service_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kServiceAPI_Service_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_SERVICE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_SERVICE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_SERVICE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_SERVICE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeServiceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_SERVICE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeServiceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_SERVICE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Audio/Video Api Methods
+(void)getSearchAudioVideosWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_AUDIOVIDEO parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyAudioVideosListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYAUDIOVIDEO_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveAudioVideosListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_AUDIOVIDEO_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedAudioVideosListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_AUDIOVIDEO_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_AUDIOVIDEO parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_AUDIOVIDEO parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_AUDIOVIDEO parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_AUDIOVIDEO parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getAudioVideoKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_AUDIOVIDEO_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getAudioVideoIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_AUDIOVIDEO_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getAudioVideoTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_AUDIOVIDEO_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_AUDIOVIDEO_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_AUDIOVIDEO parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_AUDIOVIDEO parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getAudioVideoCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_AUDIOVIDEO_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;

    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_AUDIOVIDEO parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_UserID];
        
        // Append Audio/Video Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_Title];
        // Append Audio/Video Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_Description];
        // Append Audio/Video Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_StartDate];
        // Append Audio/Video End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_EndDate];
        
        // Append Audio/Video Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddAudioVideoAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddAudioVideoAPI_Keywords];
        
        // Append Audio/Video Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddAudioVideoAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddAudioVideoAPI_IndustryKeywords];
        
        // Append Audio/Video Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddAudioVideoAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddAudioVideoAPI_Target_Market_Keywords];
        
        // Append Audio/Video Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_Document];
        
        // Append Audio/Video Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_Audio];
        
        // Append Audio/Video Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_Video];
        
        // Append Audio/Video Image
        if([dictParameters objectForKey:kAudioVideoAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kAudioVideoAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kAudioVideoAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kAudioVideoAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_AUDIOVIDEO parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_UserID];
        
        // Append AudioVideo ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_AudioVideoID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_AudioVideoID];
        
        // Append AudioVideo Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_Title];
        // Append AudioVideo Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_Description];
        // Append AudioVideo Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_StartDate];
        // Append AudioVideo End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_EndDate];
        
        // Append AudioVideo Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddAudioVideoAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddAudioVideoAPI_Keywords];
        
        // Append AudioVideo Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddAudioVideoAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddAudioVideoAPI_IndustryKeywords];
        
        // Append AudioVideo Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddAudioVideoAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddAudioVideoAPI_Target_Market_Keywords];
        
        // Append AudioVideo Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_Document];
        
        // Append AudioVideo Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_Audio];
        
        // Append AudioVideo Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAudioVideoAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAudioVideoAPI_Video];
        
        // Append AudioVideo Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditAudioVideoAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditAudioVideoAPI_Image_Del];
        
        // Append AudioVideo Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditAudioVideoAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditAudioVideoAPI_Doc_Del];
        
        // Append AudioVideo Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditAudioVideoAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditAudioVideoAPI_Audio_Del];
        
        // Append AudioVideo Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditAudioVideoAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditAudioVideoAPI_Video_Del];
        
        // Append AudioVideo Image
        if([dictParameters objectForKey:kAudioVideoAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kAudioVideoAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kAudioVideoAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kAudioVideoAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_AUDIOVIDEO parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_AUDIOVIDEO parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_AUDIOVIDEO parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_AUDIOVIDEO parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeAudioVideoListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_AUDIOVIDEO_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeAudioVideoListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_AUDIOVIDEO_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Information Api Methods
+(void)getSearchInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_INFORMATION parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyInformationListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYINFORMATION_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveInformationListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_INFORMATION_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedInformationListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_INFORMATION_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_INFORMATION parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_INFORMATION parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_INFORMATION parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_INFORMATION parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getInformationKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_INFORMATION_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getInformationIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_INFORMATION_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getInformationTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_INFORMATION_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_INFORMATION_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_INFORMATION parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_INFORMATION parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getInformationCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_INFORMATION_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_INFORMATION parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_UserID];
        
        // Append Audio/Video Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_Title];
        // Append Audio/Video Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_Description];
        // Append Audio/Video Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_StartDate];
        // Append Audio/Video End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_EndDate];
        
        // Append Audio/Video Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddInformationAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddInformationAPI_Keywords];
        
        // Append Audio/Video Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddInformationAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddInformationAPI_IndustryKeywords];
        
        // Append Audio/Video Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddInformationAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddInformationAPI_Target_Market_Keywords];
        
        // Append Audio/Video Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_Document];
        
        // Append Audio/Video Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_Audio];
        
        // Append Audio/Video Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_Video];
        
        // Append Audio/Video Image
        if([dictParameters objectForKey:kInformationAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kInformationAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kInformationAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kInformationAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_INFORMATION parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_UserID];
        
        // Append Information ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_InformationID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_InformationID];
        
        // Append Information Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_Title];
        // Append Information Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_Description];
        // Append Information Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_StartDate];
        // Append Information End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_EndDate];
        
        // Append Information Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddInformationAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddInformationAPI_Keywords];
        
        // Append Information Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddInformationAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddInformationAPI_IndustryKeywords];
        
        // Append Information Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddInformationAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddInformationAPI_Target_Market_Keywords];
        
        // Append Information Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_Document];
        
        // Append Information Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_Audio];
        
        // Append Information Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kInformationAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kInformationAPI_Video];
        
        // Append Information Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditInformationAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditInformationAPI_Image_Del];
        
        // Append Information Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditInformationAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditInformationAPI_Doc_Del];
        
        // Append Information Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditInformationAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditInformationAPI_Audio_Del];
        
        // Append Information Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditInformationAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditInformationAPI_Video_Del];
        
        // Append Information Image
        if([dictParameters objectForKey:kInformationAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kInformationAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kInformationAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kInformationAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_INFORMATION parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_INFORMATION parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_INFORMATION parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_INFORMATION parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeInformationListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_INFORMATION_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeInformationListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_INFORMATION_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Productivity Api Methods
+(void)getSearchProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_PRODUCTIVITY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyProductivityListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYPRODUCTIVITY_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveProductivityListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_PRODUCTIVITY_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedProductivityListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_PRODUCTIVITY_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_PRODUCTIVITY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_PRODUCTIVITY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_PRODUCTIVITY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_PRODUCTIVITY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getProductivityKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_PRODUCTIVITY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getProductivityIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_PRODUCTIVITY_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getProductivityTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_PRODUCTIVITY_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_PRODUCTIVITY_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_PRODUCTIVITY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_PRODUCTIVITY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getProductivityCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_PRODUCTIVITY_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_PRODUCTIVITY parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_UserID];
        
        // Append Audio/Video Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_Title];
        // Append Audio/Video Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_Description];
        // Append Audio/Video Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_StartDate];
        // Append Audio/Video End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_EndDate];
        
        // Append Audio/Video Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddProductivityAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddProductivityAPI_Keywords];
        
        // Append Audio/Video Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddProductivityAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddProductivityAPI_IndustryKeywords];
        
        // Append Audio/Video Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddProductivityAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddProductivityAPI_Target_Market_Keywords];
        
        // Append Audio/Video Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_Document];
        
        // Append Audio/Video Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_Audio];
        
        // Append Audio/Video Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_Video];
        
        // Append Audio/Video Image
        if([dictParameters objectForKey:kProductivityAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kProductivityAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kProductivityAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kProductivityAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_PRODUCTIVITY parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_UserID];
        
        // Append Productivity ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_ProductivityID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_ProductivityID];
        
        // Append Productivity Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_Title];
        // Append Productivity Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_Description];
        // Append Productivity Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_StartDate];
        // Append Productivity End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_EndDate];
        
        // Append Productivity Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddProductivityAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddProductivityAPI_Keywords];
        
        // Append Productivity Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddProductivityAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddProductivityAPI_IndustryKeywords];
        
        // Append Productivity Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddProductivityAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddProductivityAPI_Target_Market_Keywords];
        
        // Append Productivity Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_Document];
        
        // Append Productivity Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_Audio];
        
        // Append Productivity Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kProductivityAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kProductivityAPI_Video];
        
        // Append Productivity Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditProductivityAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditProductivityAPI_Image_Del];
        
        // Append Productivity Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditProductivityAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditProductivityAPI_Doc_Del];
        
        // Append Productivity Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditProductivityAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditProductivityAPI_Audio_Del];
        
        // Append Productivity Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditProductivityAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditProductivityAPI_Video_Del];
        
        // Append Productivity Image
        if([dictParameters objectForKey:kProductivityAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kProductivityAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kProductivityAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kProductivityAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_PRODUCTIVITY parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_PRODUCTIVITY parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_PRODUCTIVITY parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_PRODUCTIVITY parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeProductivityListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_PRODUCTIVITY_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeProductivityListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_PRODUCTIVITY_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Job Api Methods
+(void)searchJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_JOB_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)viewJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_VIEW_JOB parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getExperienceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_EXPERIENCE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)editExperiencesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_EDIT_EXPERIENCES parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addExperienceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ADD_EXPERIENCE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)followJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_JOB parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_JOB parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)applyJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_APPLY_JOB parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)getJobRoles:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_JOB_ROLE_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error) ;
    }] ;
}

#pragma mark - Recruiter Api Methods
+(void)getMyJobListsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_MY_JOB_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchivedJobListsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_ARCHIVED_JOB_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedJobListsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_DEACTIVATED_JOB_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_ARCHIVE_JOB parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_DELETE_JOB parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_ACTIVATE_JOB parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_DEACTIVATE_JOB parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)editJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_EDIT_JOB parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ADD_JOB parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

#pragma mark - Forums
+(void)getForumStartupsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_FORUM_STARTUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyForumsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_MY_FORUMS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getSearchForumsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_SEARCH_FORUMS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getStartupForumsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUP_FORUMS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveDeleteForumWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_ARCHIVE_DELETE_FORUM parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addForumWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_FORUM parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddForumAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddForumAPI_UserID];
        
        // Append Startup ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddForumAPI_StartupID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddForumAPI_StartupID];
        
        // Append Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddForumAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddForumAPI_Title];
        
        // Append Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddForumAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddForumAPI_Description];
        
        // Append Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddForumAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddForumAPI_Keywords];
        
        if([dictParameters objectForKey:kAddForumAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kAddForumAPI_Image] ;
            NSString *imageFileName = [NSString stringWithFormat:@"Forum%@_Image.png",[dictParameters objectForKey:kAddForumAPI_UserID]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kAddForumAPI_Image
                                    fileName:imageFileName
                                    mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        // progress(percentDone) ;
    }];
}

+(void)getArchivedForumsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_ARCHIVED_FORUMS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getForumDetailWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_FORUM_DETAIL parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getForumCommentsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_FORUM_COMMENTS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addForumCommentWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_ADD_FORUM_COMMENT parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)reportAbuseWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FORUM_REPORT_ABUSE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)getReportAbuseUsersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_REPORT_ABUSE_USERS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getContactsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_CONTACTS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getNotesStartupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_STARTUPLIST_NOTES parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

#pragma mark - Notification Api Methods
+(void)getNotificationsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_NOTIFICATIONS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getNotificationCountWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_NOTIFICATIONS_COUNT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)updateNotificationCountWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_NOTIFICATIONS_UPDATE_COUNT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

#pragma mark - News/Blog Post Api Methods
+(void)getNewsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_NEWS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

#pragma mark - Feeds Api Methods
+(void)getFeedsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FEEDS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addFeedWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress  {

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_FEED parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFeedAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFeedAPI_UserID];

        // Append Feed Message
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFeedAPI_Message]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFeedAPI_Message];
        
        // Append Feed Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFeedAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFeedAPI_Document];
        
        // Append Feed Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFeedAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFeedAPI_Audio];
        
        // Append Feed Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddFeedAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddFeedAPI_Video];

        if([dictParameters objectForKey:kAddFeedAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kAddFeedAPI_Image] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kAddFeedAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

#pragma mark - Group Api Methods
+(void)getSearchGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYGROUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_GROUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_GROUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getGroupKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_GROUP_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getGroupIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_GROUP_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getGroupTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_GROUP_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_GROUP_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getGroupCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_GROUP_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_GROUP parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_UserID];
        
        // Append Group Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_Title];
        // Append Group Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_Description];
        // Append Group Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_StartDate];
        // Append Group End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_EndDate];
        
        // Append Group Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddGroupAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddGroupAPI_Keywords];
        
        // Append Group Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddGroupAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddGroupAPI_IndustryKeywords];
        
        // Append Group Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddGroupAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddGroupAPI_Target_Market_Keywords];
        
        // Append Group Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_Document];
        
        // Append Group Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_Audio];
        
        // Append Group Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_Video];
        
        // Append Group Image
        if([dictParameters objectForKey:kGroupAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kGroupAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kGroupAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kGroupAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_GROUP parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_UserID];
        
        // Append Group ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_GroupID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_GroupID];
        
        // Append Group Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_Title];
        
        // Append Group Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_Description];
        
        // Append Group Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_StartDate];
        
        // Append Group End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_EndDate];
        
        // Append Group Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddGroupAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddGroupAPI_Keywords];
        
        // Append Group Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddGroupAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddGroupAPI_IndustryKeywords];
        
        // Append Group Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddGroupAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddGroupAPI_Target_Market_Keywords];
        
        // Append Group Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_Document];
        
        // Append Group Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_Audio];
        
        // Append Group Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kGroupAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kGroupAPI_Video];
        
        // Append Group Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditGroupAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditGroupAPI_Image_Del];
        
        // Append Group Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditGroupAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditGroupAPI_Doc_Del];
        
        // Append Group Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditGroupAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditGroupAPI_Audio_Del];
        
        // Append Group Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditGroupAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditGroupAPI_Video_Del];
        
        // Append Group Image
        if([dictParameters objectForKey:kGroupAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kGroupAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kGroupAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kGroupAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_GROUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_GROUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Webinar Api Methods
+(void)getSearchWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_WEBINAR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyWebinarListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYWEBINAR_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveWebinarListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_WEBINAR_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedWebinarListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_WEBINAR_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_WEBINAR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_WEBINAR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_WEBINAR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_WEBINAR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getWebinarKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_WEBINAR_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getWebinarIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_WEBINAR_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getWebinarTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_WEBINAR_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_WEBINAR_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_WEBINAR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_WEBINAR parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getWebinarCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_WEBINAR_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_WEBINAR parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_UserID];
        
        // Append Webinar Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_Title];
        // Append Webinar Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_Description];
        // Append Webinar Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_StartDate];
        // Append Webinar End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_EndDate];
        
        // Append Webinar Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddWebinarAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddWebinarAPI_Keywords];
        
        // Append Webinar Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddWebinarAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddWebinarAPI_IndustryKeywords];
        
        // Append Webinar Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddWebinarAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddWebinarAPI_Target_Market_Keywords];
        
        // Append Webinar Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_Document];
        
        // Append Webinar Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_Audio];
        
        // Append Webinar Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_Video];
        
        // Append Webinar Image
        if([dictParameters objectForKey:kWebinarAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kWebinarAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kWebinarAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kWebinarAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_WEBINAR parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_UserID];
        
        // Append Webinar ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_WebinarID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_WebinarID];
        
        // Append Webinar Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_Title];
        // Append Webinar Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_Description];
        // Append Webinar Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_StartDate];
        // Append Webinar End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_EndDate];
        
        // Append Webinar Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddWebinarAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddWebinarAPI_Keywords];
        
        // Append Webinar Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddWebinarAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddWebinarAPI_IndustryKeywords];
        
        // Append Webinar Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddWebinarAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddWebinarAPI_Target_Market_Keywords];
        
        // Append Webinar Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_Document];
        
        // Append Webinar Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_Audio];
        
        // Append Webinar Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kWebinarAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kWebinarAPI_Video];
        
        // Append Webinar Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditWebinarAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditWebinarAPI_Image_Del];
        
        // Append Webinar Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditWebinarAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditWebinarAPI_Doc_Del];
        
        // Append Webinar Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditWebinarAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditWebinarAPI_Audio_Del];
        
        // Append Webinar Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditWebinarAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditWebinarAPI_Video_Del];
        
        // Append Webinar Image
        if([dictParameters objectForKey:kWebinarAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kWebinarAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kWebinarAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kWebinarAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_WEBINAR parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_WEBINAR parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_WEBINAR parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_WEBINAR parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeWebinarListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_WEBINAR_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeWebinarListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_WEBINAR_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - MeetUp Api Methods
+(void)getSearchMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_MEETUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyMeetUpListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYMEETUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveMeetUpListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_MEETUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedMeetUpListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_MEETUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_MEETUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_MEETUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_MEETUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_MEETUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMeetUpForums:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_MEETUP_FORUMS parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getMeetUpKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_MEETUP_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getMeetUpIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_MEETUP_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getMeetUpTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_MEETUP_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MEETUP_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_MEETUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_MEETUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMeetUpCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_MEETUP_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_MEETUP parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_UserID];
        
        // Append MeetUp Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_Title];
        // Append MeetUp Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_Description];
        // Append MeetUp Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_StartDate];
        // Append MeetUp End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_EndDate];
        
        // Append MeetUp Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddMeetUpAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddMeetUpAPI_Keywords];
        
        // Append MeetUp Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddMeetUpAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddMeetUpAPI_IndustryKeywords];
        
        // Append MeetUp Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddMeetUpAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddMeetUpAPI_Target_Market_Keywords];
        
        // Append MeetUp Forum
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddMeetUpAPI_ForumId]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddMeetUpAPI_ForumId];

        // Append MeetUp Access
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddMeetUpAPI_AccessLevel]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddMeetUpAPI_AccessLevel];

        // Append MeetUp Notification
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddMeetUpAPI_Notification]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddMeetUpAPI_Notification];

        // Append MeetUp Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_Document];
        
        // Append MeetUp Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_Audio];
        
        // Append MeetUp Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_Video];
        
        // Append MeetUp Image
        if([dictParameters objectForKey:kMeetUpAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kMeetUpAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kMeetUpAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kMeetUpAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_MEETUP parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_UserID];
        
        // Append MeetUp ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_MeetUpID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_MeetUpID];
        
        // Append MeetUp Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_Title];
        // Append MeetUp Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_Description];
        // Append MeetUp Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_StartDate];
        // Append MeetUp End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_EndDate];
        
        // Append MeetUp Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddMeetUpAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddMeetUpAPI_Keywords];
        
        // Append MeetUp Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddMeetUpAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddMeetUpAPI_IndustryKeywords];
        
        // Append MeetUp Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddMeetUpAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddMeetUpAPI_Target_Market_Keywords];
        
        // Append MeetUp Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_Document];
        
        // Append MeetUp Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_Audio];
        
        // Append MeetUp Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kMeetUpAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kMeetUpAPI_Video];
        
        // Append MeetUp Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditMeetUpAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditMeetUpAPI_Image_Del];
        
        // Append MeetUp Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditMeetUpAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditMeetUpAPI_Doc_Del];
        
        // Append MeetUp Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditMeetUpAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditMeetUpAPI_Audio_Del];
        
        // Append MeetUp Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditMeetUpAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditMeetUpAPI_Video_Del];
        
        // Append MeetUp Image
        if([dictParameters objectForKey:kMeetUpAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kMeetUpAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kMeetUpAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kMeetUpAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_MEETUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_MEETUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_MEETUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_MEETUP parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeMeetUpListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_MEETUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeMeetUpListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_MEETUP_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Demo Day Api Methods
+(void)getSearchDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_DEMODAY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyDemoDayListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYDEMODAY_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveDemoDayListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_DEMODAY_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedDemoDayListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_DEMODAY_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_DEMODAY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_DEMODAY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_DEMODAY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_DEMODAY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDemoDayKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_DEMODAY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getDemoDayIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_DEMODAY_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getDemoDayTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_DEMODAY_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEMODAY_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_DEMODAY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_DEMODAY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDemoDayCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DEMODAY_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_DEMODAY parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_UserID];
        
        // Append DemoDay Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_Title];
        // Append DemoDay Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_Description];
        // Append DemoDay Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_StartDate];
        // Append DemoDay End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_EndDate];
        
        // Append DemoDay Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddDemoDayAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddDemoDayAPI_Keywords];
        
        // Append DemoDay Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddDemoDayAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddDemoDayAPI_IndustryKeywords];
        
        // Append DemoDay Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddDemoDayAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddDemoDayAPI_Target_Market_Keywords];
        
        // Append DemoDay Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_Document];
        
        // Append DemoDay Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_Audio];
        
        // Append DemoDay Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_Video];
        
        // Append DemoDay Image
        if([dictParameters objectForKey:kDemoDayAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kDemoDayAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kDemoDayAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kDemoDayAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_DEMODAY parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_UserID];
        
        // Append DemoDay ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_DemoDayID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_DemoDayID];
        
        // Append DemoDay Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_Title];
        // Append DemoDay Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_Description];
        // Append DemoDay Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_StartDate];
        // Append DemoDay End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_EndDate];
        
        // Append DemoDay Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddDemoDayAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddDemoDayAPI_Keywords];
        
        // Append DemoDay Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddDemoDayAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddDemoDayAPI_IndustryKeywords];
        
        // Append DemoDay Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddDemoDayAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddDemoDayAPI_Target_Market_Keywords];
        
        // Append DemoDay Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_Document];
        
        // Append DemoDay Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_Audio];
        
        // Append DemoDay Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kDemoDayAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kDemoDayAPI_Video];
        
        // Append DemoDay Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditDemoDayAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditDemoDayAPI_Image_Del];
        
        // Append DemoDay Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditDemoDayAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditDemoDayAPI_Doc_Del];
        
        // Append DemoDay Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditDemoDayAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditDemoDayAPI_Audio_Del];
        
        // Append DemoDay Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditDemoDayAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditDemoDayAPI_Video_Del];
        
        // Append DemoDay Image
        if([dictParameters objectForKey:kDemoDayAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kDemoDayAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kDemoDayAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kDemoDayAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_DEMODAY parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_DEMODAY parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_DEMODAY parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_DEMODAY parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeDemoDayListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_DEMODAY_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeDemoDayListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_DEMODAY_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Conference Api Methods
+(void)getSearchConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_CONFERENCE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyConferenceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYCONFERENCE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveConferenceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_CONFERENCE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedConferenceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_CONFERENCE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_CONFERENCE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_CONFERENCE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_CONFERENCE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_CONFERENCE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getConferenceKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_CONFERENCE_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getConferenceIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_CONFERENCE_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getConferenceTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_CONFERENCE_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_CONFERENCE_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_CONFERENCE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_CONFERENCE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getConferenceCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_CONFERENCE_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_CONFERENCE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_UserID];
        
        // Append Conference Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_Title];
        // Append Conference Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_Description];
        // Append Conference Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_StartDate];
        // Append Conference End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_EndDate];
        
        // Append Conference Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddConferenceAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddConferenceAPI_Keywords];
        
        // Append Conference Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddConferenceAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddConferenceAPI_IndustryKeywords];
        
        // Append Conference Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddConferenceAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddConferenceAPI_Target_Market_Keywords];
        
        // Append Conference Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_Document];
        
        // Append Conference Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_Audio];
        
        // Append Conference Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_Video];
        
        // Append Conference Image
        if([dictParameters objectForKey:kConferenceAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kConferenceAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kConferenceAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kConferenceAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_CONFERENCE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_UserID];
        
        // Append Conference ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_ConferenceID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_ConferenceID];
        
        // Append Conference Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_Title];
        // Append Conference Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_Description];
        // Append Conference Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_StartDate];
        // Append Conference End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_EndDate];
        
        // Append Conference Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddConferenceAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddConferenceAPI_Keywords];
        
        // Append Conference Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddConferenceAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddConferenceAPI_IndustryKeywords];
        
        // Append Conference Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddConferenceAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddConferenceAPI_Target_Market_Keywords];
        
        // Append Conference Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_Document];
        
        // Append Conference Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_Audio];
        
        // Append Conference Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kConferenceAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kConferenceAPI_Video];
        
        // Append Conference Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditConferenceAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditConferenceAPI_Image_Del];
        
        // Append Conference Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditConferenceAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditConferenceAPI_Doc_Del];
        
        // Append Conference Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditConferenceAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditConferenceAPI_Audio_Del];
        
        // Append Conference Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditConferenceAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditConferenceAPI_Video_Del];
        
        // Append Conference Image
        if([dictParameters objectForKey:kConferenceAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kConferenceAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kConferenceAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kConferenceAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_CONFERENCE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_CONFERENCE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_CONFERENCE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_CONFERENCE parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeConferenceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_CONFERENCE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeConferenceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_CONFERENCE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Career Api Methods
+(void)getSearchCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_CAREER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyCareerListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYCAREER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveCareerListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_CAREER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedCareerListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_CAREER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_CAREER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_CAREER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_CAREER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_CAREER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getCareerKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_CAREER_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getCareerIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_CAREER_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getCareerTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_CAREER_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_CAREER_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_CAREER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_CAREER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getCareerCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_CAREER_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_CAREER parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_UserID];
        
        // Append Career Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_Title];
        // Append Career Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_Description];
        // Append Career Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_StartDate];
        // Append Career End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_EndDate];
        
        // Append Career Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCareerAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCareerAPI_Keywords];
        
        // Append Career Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCareerAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCareerAPI_IndustryKeywords];
        
        // Append Career Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCareerAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCareerAPI_Target_Market_Keywords];
        
        // Append Career Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_Document];
        
        // Append Career Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_Audio];
        
        // Append Career Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_Video];
        
        // Append Career Image
        if([dictParameters objectForKey:kCareerAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kCareerAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kCareerAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kCareerAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_CAREER parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_UserID];
        
        // Append Career ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_CareerID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_CareerID];
        
        // Append Career Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_Title];
        // Append Career Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_Description];
        // Append Career Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_StartDate];
        // Append Career End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_EndDate];
        
        // Append Career Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCareerAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCareerAPI_Keywords];
        
        // Append Career Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCareerAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCareerAPI_IndustryKeywords];
        
        // Append Career Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddCareerAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddCareerAPI_Target_Market_Keywords];
        
        // Append Career Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_Document];
        
        // Append Career Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_Audio];
        
        // Append Career Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kCareerAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kCareerAPI_Video];
        
        // Append Career Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCareerAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCareerAPI_Image_Del];
        
        // Append Career Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCareerAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCareerAPI_Doc_Del];
        
        // Append Career Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCareerAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCareerAPI_Audio_Del];
        
        // Append Career Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditCareerAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditCareerAPI_Video_Del];
        
        // Append Career Image
        if([dictParameters objectForKey:kCareerAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kCareerAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kCareerAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kCareerAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_CAREER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_CAREER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_CAREER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_CAREER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeCareerListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_CAREER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeCareerListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_CAREER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Self Improvement Tool Api Methods
+(void)getSearchImprovementsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_IMPROVEMENT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyImprovementsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYIMPROVEMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveImprovementsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_IMPROVEMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedImprovementsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_IMPROVEMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_IMPROVEMENT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_IMPROVEMENT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_IMPROVEMENT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_IMPROVEMENT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getImprovementKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_IMPROVEMENT_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getImprovementIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_IMPROVEMENT_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getImprovementTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_IMPROVEMENT_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_IMPROVEMENT_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_IMPROVEMENT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_IMPROVEMENT parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getImprovementCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_IMPROVEMENT_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_IMPROVEMENT parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_UserID];
        
        // Append Improvement Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_Title];
        // Append Improvement Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_Description];
        // Append Improvement Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_StartDate];
        // Append Improvement End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_EndDate];
        
        // Append Improvement Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddImprovementToolAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddImprovementToolAPI_Keywords];
        
        // Append Improvement Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddImprovementToolAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddImprovementToolAPI_IndustryKeywords];
        
        // Append Improvement Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddImprovementToolAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddImprovementToolAPI_Target_Market_Keywords];
        
        // Append Improvement Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_Document];
        
        // Append Improvement Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_Audio];
        
        // Append Improvement Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_Video];
        
        // Append Improvement Image
        if([dictParameters objectForKey:kImprovementToolAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kImprovementToolAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kImprovementToolAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kImprovementToolAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_IMPROVEMENT parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_UserID];
        
        // Append Improvement ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_ImprovementID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_ImprovementID];
        
        // Append Improvement Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_Title];
        
        // Append Improvement Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_Description];
        
        // Append Improvement Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_StartDate];
        
        // Append Improvement End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_EndDate];
        
        // Append Improvement Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddImprovementToolAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddImprovementToolAPI_Keywords];
        
        // Append Improvement Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddImprovementToolAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddImprovementToolAPI_IndustryKeywords];
        
        // Append Improvement Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddImprovementToolAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddImprovementToolAPI_Target_Market_Keywords];
        
        // Append Improvement Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_Document];
        
        // Append Improvement Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_Audio];
        
        // Append Improvement Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kImprovementToolAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kImprovementToolAPI_Video];
        
        // Append Improvement Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditImprovementToolAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditImprovementToolAPI_Image_Del];
        
        // Append Improvement Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditImprovementToolAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditImprovementToolAPI_Doc_Del];
        
        // Append Improvement Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditImprovementToolAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditImprovementToolAPI_Audio_Del];
        
        // Append Improvement Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditImprovementToolAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditImprovementToolAPI_Video_Del];
        
        // Append Improvement Image
        if([dictParameters objectForKey:kImprovementToolAPI_Image]) {
            NSData *imageData = (NSData*)[dictParameters objectForKey:kImprovementToolAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kImprovementToolAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kImprovementToolAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_IMPROVEMENT parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_IMPROVEMENT parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_IMPROVEMENT parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_IMPROVEMENT parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeImprovementListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_IMPROVEMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeImprovementListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_IMPROVEMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Launch Deals Api Methods
+(void)getSearchLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_LAUNCHDEAL parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyLaunchDealListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYLAUNCHDEAL_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getArchiveLaunchDealListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_LAUNCHDEAL_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getDeactivatedLaunchDealListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATED_LAUNCHDEAL_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)archiveLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ARCHIVE_LAUNCHDEAL parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_LAUNCHDEAL parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_LAUNCHDEAL parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deActivateLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DEACTIVATE_LAUNCHDEAL parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getLaunchDealKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_LAUNCHDEAL_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getLaunchDealIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_LAUNCHDEAL_INDUSTRY_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getLaunchDealTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_LAUNCHDEAL_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_LAUNCHDEAL_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_LAUNCHDEAL parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_LAUNCHDEAL parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getLaunchDealCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LAUNCHDEAL_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_LAUNCHDEAL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_UserID];
        
        // Append Audio/Video Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_Title];
        // Append Audio/Video Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_Description];
        // Append Audio/Video Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_StartDate];
        // Append Audio/Video End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_EndDate];
        
        // Append Audio/Video Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddLaunchDealAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddLaunchDealAPI_Keywords];
        
        // Append Audio/Video Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddLaunchDealAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddLaunchDealAPI_IndustryKeywords];
        
        // Append Audio/Video Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddLaunchDealAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddLaunchDealAPI_Target_Market_Keywords];
        
        // Append Audio/Video Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_Document];
        
        // Append Audio/Video Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_Audio];
        
        // Append Audio/Video Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_Video];
        
        // Append Audio/Video Image
        if([dictParameters objectForKey:kLaunchDealAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kLaunchDealAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kLaunchDealAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kLaunchDealAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_LAUNCHDEAL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_UserID];
        
        // Append LaunchDeal ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_LaunchDealID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_LaunchDealID];
        
        // Append LaunchDeal Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_Title];
        // Append LaunchDeal Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_Description];
        // Append LaunchDeal Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_StartDate];
        // Append LaunchDeal End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_EndDate];
        
        // Append LaunchDeal Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddLaunchDealAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddLaunchDealAPI_Keywords];
        
        // Append LaunchDeal Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddLaunchDealAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddLaunchDealAPI_IndustryKeywords];
        
        // Append LaunchDeal Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddLaunchDealAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddLaunchDealAPI_Target_Market_Keywords];
        
        // Append LaunchDeal Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_Document];
        
        // Append LaunchDeal Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_Audio];
        
        // Append LaunchDeal Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kLaunchDealAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kLaunchDealAPI_Video];
        
        // Append LaunchDeal Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditLaunchDealAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditLaunchDealAPI_Image_Del];
        
        // Append LaunchDeal Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditLaunchDealAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditLaunchDealAPI_Doc_Del];
        
        // Append LaunchDeal Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditLaunchDealAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditLaunchDealAPI_Audio_Del];
        
        // Append LaunchDeal Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditLaunchDealAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditLaunchDealAPI_Video_Del];
        
        // Append LaunchDeal Image
        if([dictParameters objectForKey:kLaunchDealAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kLaunchDealAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kLaunchDealAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kLaunchDealAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_LAUNCHDEAL parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_LAUNCHDEAL parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likeLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_LAUNCHDEAL parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikeLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_LAUNCHDEAL parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikeLaunchDealListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_LAUNCHDEAL_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikeLaunchDealListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_LAUNCHDEAL_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Group Buying/Puchase Order Api Methods
+(void)getSearchPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_FIND_PURCHASEORDER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyPurchaseOrderListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_MYPURCHASEORDER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getPurchaseOrderKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_PURCHASEORDER_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getPurchaseOrderInterestKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_PURCHASEORDER_INTEREST_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)getPurchaseOrderTargetKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_PURCHASEORDER_TARGET_KEYWORDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error) ;
        
    }];
}

+(void)viewPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_PURCHASEORDER_DETAILS parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)commitPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_COMMIT_PURCHASEORDER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)uncommitPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_UNCOMMIT_PURCHASEORDER parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getPurchaseOrderCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_PURCHASEORDER_COMMITMENT_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)addPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_PURCHASEORDER parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_UserID];
        
        // Append PurchaseOrder Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_Title];
        // Append PurchaseOrder Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_Description];

        // Append Audio/Video Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_StartDate];
        // Append Audio/Video End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_EndDate];

        // Append PurchaseOrder Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddPurchaseOrderAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddPurchaseOrderAPI_Keywords];
        
        // Append Audio/Video Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddPurchaseOrderAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddPurchaseOrderAPI_IndustryKeywords];
        
        // Append Audio/Video Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddPurchaseOrderAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddPurchaseOrderAPI_Target_Market_Keywords];

        // Append PurchaseOrder Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_Document];
        
        // Append Audio/Video Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_Audio];
        
        // Append Audio/Video Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_Video];

        // Append PurchaseOrder Image
        if([dictParameters objectForKey:kPurchaseOrderAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kPurchaseOrderAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kPurchaseOrderAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kPurchaseOrderAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)editPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_PURCHASEORDER parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_UserID];
        
        // Append PurchaseOrder ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_GroupBuyingID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_GroupBuyingID];
        
        // Append PurchaseOrder Title
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_Title]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_Title];
        // Append PurchaseOrder Description
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_Description]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_Description];
        // Append Audio/Video Start Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_StartDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_StartDate];
        // Append Audio/Video End Date
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_EndDate]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_EndDate];

        // Append PurchaseOrder Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddPurchaseOrderAPI_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddPurchaseOrderAPI_Keywords];
        
        // Append Audio/Video Interest Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddPurchaseOrderAPI_IndustryKeywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddPurchaseOrderAPI_IndustryKeywords];
        
        // Append Audio/Video Target Keywords
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kAddPurchaseOrderAPI_Target_Market_Keywords]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kAddPurchaseOrderAPI_Target_Market_Keywords];

        // Append PurchaseOrder Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_Document]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_Document];
        
        // Append Audio/Video Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_Audio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_Audio];
        
        // Append Audio/Video Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kPurchaseOrderAPI_Video]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kPurchaseOrderAPI_Video];
        
        // Append PurchaseOrder Deleted Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditPurchaseOrderAPI_Image_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditPurchaseOrderAPI_Image_Del];
        
        // Append PurchaseOrder Deleted Document
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditPurchaseOrderAPI_Doc_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditPurchaseOrderAPI_Doc_Del];
        
        // Append PurchaseOrder Deleted Audio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditPurchaseOrderAPI_Audio_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditPurchaseOrderAPI_Audio_Del];

        // Append PurchaseOrder Deleted Video
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kEditPurchaseOrderAPI_Video_Del]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kEditPurchaseOrderAPI_Video_Del];

        // Append PurchaseOrder Image
        if([dictParameters objectForKey:kPurchaseOrderAPI_Image]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kPurchaseOrderAPI_Image] ;
//            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kPurchaseOrderAPI_Title]stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kPurchaseOrderAPI_Image
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        /*if([dictParameters objectForKey:kAddCampaignAPI_Video]){
         
         
         NSString *vidURL = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
         NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:vidURL]];
         NSString *videoFileName = @"filename.mp4";
         //NSData *videoData = (NSData*)[dictParameters objectForKey:kAddCampaignAPI_Video] ;
         //NSString *videoFileName = [NSString stringWithFormat:@"%@_Video.mov",[dictParameters objectForKey:kAddCampaignAPI_Video]] ;
         [formData appendPartWithFileData:videoData
         name:kAddCampaignAPI_Video
         fileName:videoFileName
         mimeType:@"video/mp4"];
         
         }*/
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)followPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_FOLLOW_PURCHASEORDER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)unfollowPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNFOLLOW_PURCHASEORDER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)likePurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_PURCHASEORDER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)dislikePurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_UNLIKE_PURCHASEORDER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getLikePurchaseOrderListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LIKE_PURCHASEORDER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

+(void)getDislikePurchaseOrderListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_DISLIKE_PURCHASEORDER_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
        
    }];
}

#pragma mark - Lean Startup RoadMap Api Methods
+(void)getLeanStartupRoadmap:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_LEAN_STARTUP_ROADMAP parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

#pragma mark - Connection Api Methods
+(void)connectUserWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_CONNECT_USER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)disconnectUserWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_DISCONNECT_USER parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)acceptConnectionWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_ACCEPT_CONNECTION parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)getMyConnectionsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_MyCONNECTIONS_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)searchConnectionWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_SEARCH_CONNECTION parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getMyMessagesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_MyMESSAGES_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

#pragma mark - Suggest Keywords Api Methods
+(void)getSuggestKeywordListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_SUGGEST_KEYWORD_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)addSuggestKeywordsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager POST:CROWDBOOTSTRAP_ADD_SUGGEST_KEYWORDS parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)deleteSuggestKeywordsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_DELETE_SUGGEST_KEYWORDS parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

+(void)getKeywordTypeListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    [operationManager GET:CROWDBOOTSTRAP_KEYWORD_TYPE_LIST parameters:dictParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        success(responseObject);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error) ;
        
    }];
}

#pragma mark - Company Api Methods
+(void)searchCompaniesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_SEARCH_COMPANY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)viewCompanyWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_VIEW_COMPANY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getCompanyKeywordList:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_COMPANY_KEYWORD_LIST parameters:nil success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

#pragma mark - Networking Options Api Methods
+(void)setUserAvailabilityStatusWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_USER_AVAILABILITY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)setUserVisibilityStatusWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_USER_VISIBILITY parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getUserListWithinMilesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_USERLIST_WITHINMILES parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getUserListWithSameLatLongWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_USERLIST_WITHSAMELATLONG parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getBusinessCardListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_BUSINESS_CARD_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)activateBusinessCardWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ACTIVATE_BUSINESS_CARD parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)deleteBusinessCardWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_DELETE_BUSINESS_CARD parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addBusinessCardWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_BUSINESS_CARD parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_UserID]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_UserID];
        // Append User Bio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_UserBio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_UserBio];
        // Append User Interest
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_UserInterest]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_UserInterest];
        
        // Append User Statement
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_Statement]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_Statement];

        // Append LinkedIn User Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_LinkedIn_UserImage]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_LinkedIn_UserImage];

        // Append LinkedIn User Name
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_LinkedIn_UserName]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_LinkedIn_UserName];

        // Append Business Card Image
        if([dictParameters objectForKey:kBusinessAPI_CardImage]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kBusinessAPI_CardImage] ;
            //            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kGroupAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kBusinessAPI_CardImage
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)viewBusinessCardDetailsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_VIEW_BUSINESS_CARD parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)editBusinessCardWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_EDIT_BUSINESS_CARD parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append Card ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_Id]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_Id];
        // Append User Bio
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_UserBio]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_UserBio];
        // Append User Interest
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_UserInterest]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_UserInterest];
        
        // Append User Statement
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_Statement]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_Statement];
        
        // Append LinkedIn User Image
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_LinkedIn_UserImage]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_LinkedIn_UserImage];
        
        // Append LinkedIn User Name
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_LinkedIn_UserName]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_LinkedIn_UserName];

        // Append Business Card Image
        if([dictParameters objectForKey:kBusinessAPI_CardImage]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kBusinessAPI_CardImage] ;
            //            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kGroupAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kBusinessAPI_CardImage
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

+(void)getBusinessConnectionTypeListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_BUSINESS_CONNECTION_TYPE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)searchBusinessConnectionWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_SEARCH_BUSINESS_CONNECTION parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)getBusinessCardNotesListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager GET:CROWDBOOTSTRAP_BUSINESS_CARD_NOTES_LIST parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addBusinessCardNoteWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ADD_BUSINESS_CARD_NOTE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)editBusinessCardNoteWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_EDIT_BUSINESS_CARD_NOTE parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addBusinessNetworkWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ADD_BUSINESS_NETWORK parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addBusinessUserGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    [operationManager POST:CROWDBOOTSTRAP_ADD_BUSINESS_GROUP parameters:dictParameters success:^(AFHTTPRequestOperation * operation, id  responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error) ;
    }] ;
}

+(void)addBusinessContactWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    AFHTTPRequestOperation *requestOperation = [manager POST:CROWDBOOTSTRAP_ADD_BUSINESS_CONTACT parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // Append User ID
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_CreatedBy]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_CreatedBy];
        // Append User Name
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_Name]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_Name];
        
        // Append User Phone
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_Phone]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_Phone];

        // Append User Email
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_Email]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_Email];

        // Append Note
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_Note]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_Note];

        // Append Connection Type
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[dictParameters objectForKey:kBusinessAPI_ConnectionId]] dataUsingEncoding:NSUTF8StringEncoding]
                                    name:kBusinessAPI_ConnectionId];

        // Append Business Card Image
        if([dictParameters objectForKey:kBusinessAPI_CardImage]){
            NSData *imageData = (NSData*)[dictParameters objectForKey:kBusinessAPI_CardImage] ;
            //            NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[[dictParameters objectForKey:kGroupAPI_Title] stringByReplacingOccurrencesOfString:@" " withString:@"" ]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kBusinessAPI_CardImage
                                    fileName:@"image.png"
                                    mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"responseObject: %@",responseObject) ;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error: %@",error) ;
        failure(error) ;
    }] ;
    
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"Upload Progress: %f", percentDone);
        progress(percentDone) ;
    }];
}

#pragma mark - AFNetworking Methods -

+(AFHTTPRequestOperationManager *)getOperationManager {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    // Not HTTPS - provide credentials for basic auth
    if (![APIPortToBeUsed containsString:@"https"])
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:kAPIBasicAuthUser password:kAPIBasicAuthPassword];
    [manager.requestSerializer setTimeoutInterval:150];
    
    return manager;
}

+(AFHTTPRequestOperationManager *)getOperationManagerForJSON {
    //Trace();
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // Not HTTPS - provide credentials for basic auth
    if (![APIPortToBeUsed containsString:@"https"])
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:kAPIBasicAuthUser password:kAPIBasicAuthPassword];
    [manager.requestSerializer setTimeoutInterval:150];
    
    return manager;
}


//generalized post request
+(void)postWithParameters:(id)parameters service:(NSString*)strService success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [self getOperationManager];
    
    AFSecurityPolicy* policy;
    if ([APIPortToBeUsed containsString:@"https"])
        policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    else
        policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    //[policy setValidatesCertificateChain:NO];
    [manager setSecurityPolicy:policy];
    
    [manager POST:strService parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
        NSLog(@"Json Response:%@", jsonString);
        
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (error) {
            //  NSLog(@"Error while parsing data - %@", error.description);
#ifdef DEBUG
            if (error.code == 3840) {
                NSLog(@"API not working properly :%@",error.description);
                //[[[UIAlertView alloc] initWithTitle:@"Debug Message" message:@"Decrypted data is not a proper json" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
#endif
            success(nil);
        }
        else {
            success(dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //TraceF(@"Failed : %@", error);
        
        switch (error.code) {
            case kCFURLErrorTimedOut:
            {
                //TraceF(@"Request timed out");
                //[Utils showPopup:@"Request timed out" withDelay:1.8 onView:APP_DELEGATE.window];
            }
                break;
                
            case kCFURLErrorNetworkConnectionLost:
            {
                // TraceF(@"You are not connected to the Internet");
                //[Utils showPopup:@"You are not connected to the Internet" withDelay:1.8 onView:APP_DELEGATE.window];
            }
                break;
            case kCFURLErrorNotConnectedToInternet:
            {
                // TraceF(@"You are not connected to the Internet");
                //[Utils showPopup:@"You are not connected to the Internet" withDelay:1.8 onView:APP_DELEGATE.window];
            }
                break;
                //add more cases if required for more error codes
            default:
                break;
        }
        
        failure(error);
    }];
}

+ (void)getWithParameters:(id)parameters service:(NSString*)strService success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    
    AFHTTPRequestOperationManager *manager = [self getOperationManager];
    
    AFSecurityPolicy* policy;
    if ([APIPortToBeUsed containsString:@"https"])
        policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    else
        policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    //[policy setValidatesCertificateChain:NO];
    [manager setSecurityPolicy:policy];
    
    [manager GET:strService parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
        NSLog(@"Json Response:%@", jsonString);
        
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (error) {
            // TraceF(@"Error while parsing data - %@", error.description);
#ifdef DEBUG
            if (error.code == 3840) {
                // TraceF(@"API not working properly :%@",error.description);
                //[[[UIAlertView alloc] initWithTitle:@"Debug Message" message:@"Decrypted data is not a proper json" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
#endif
            success(nil);
        }
        else {
            success(dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TraceF(@"Failed : %@", error);
        
        switch (error.code) {
            case kCFURLErrorTimedOut:
            {
                //TraceF(@"Request timed out");
                //[Utils showPopup:@"Request timed out" withDelay:1.8 onView:APP_DELEGATE.window];
            }
                break;
                
            case kCFURLErrorNetworkConnectionLost:
            {
                // TraceF(@"You are not connected to the Internet");
                //[Utils showPopup:@"You are not connected to the Internet" withDelay:1.8 onView:APP_DELEGATE.window];
            }
                break;
            case kCFURLErrorNotConnectedToInternet:
            {
                // TraceF(@"You are not connected to the Internet");
                //[Utils showPopup:@"You are not connected to the Internet" withDelay:1.8 onView:APP_DELEGATE.window];
            }
                break;
                //add more cases if required for more error codes
            default:
                break;
        }
        
        failure(error);
    }];
}

@end
