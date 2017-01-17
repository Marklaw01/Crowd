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

#pragma mark - Profile Api Methods
+(void)getProfileWithType:(int)profileType forUserType:(int)userType withParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSString *strApi ;
    if(userType == CONTRACTOR) {
        if(profileType == PROFILE_BASIC_SELECTED) strApi = CROWDBOOTSTRAP_CONT_BASIC_PROFILE ;
        else strApi = CROWDBOOTSTRAP_CONT_PROFESSIONAL_PROFILE ;
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
                NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[dictParameters objectForKey:kBasicEditProfileAPI_FirstName]] ;
                // Append Image
                [formData appendPartWithFileData:imageData
                                            name:kBasicEditProfileAPI_Image
                                        fileName:imageFileName
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
                NSString *imageFileName = [NSString stringWithFormat:@"%@.png",[dictParameters objectForKey:kProfEditProfileAPI_FirstName]] ;
                // Append Image
                [formData appendPartWithFileData:imageData
                                            name:kProfEditProfileAPI_Image
                                        fileName:imageFileName
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


+(void)addCampaignwithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress{
    
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
            NSString *imageFileName = [NSString stringWithFormat:@"%@_Image.png",[dictParameters objectForKey:kAddCampaignAPI_CampaignName]] ;
            
            // Append Image
            [formData appendPartWithFileData:imageData
                                        name:kAddCampaignAPI_CampaignImage
                                    fileName:imageFileName
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
