//
//  ConstantsServer.h
//  CrowdBootstrap
//
//  Created by OSX on 08/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#ifndef ConstantsServer_h
#define ConstantsServer_h

//#define APIPortToBeUsed                           @"http://crowdbootstrap.trantorinc.com"
//#define APIPortToBeUsed                          @"http://crowdbootstrap.com"
#define APIPortToBeUsed                          @"http://stage.crowdbootstrap.com/"

#define kSuccessCode                              200
#define kErrorCode                                404

#pragma mark - Sign Up API Keys
#define kSignUpAPI_FirstName                      @"first_name"
#define kSignUpAPI_LastName                       @"last_name"
#define kSignUpAPI_Username                       @"username"
#define kSignUpAPI_Email                          @"email"
#define kSignUpAPI_DateOfBirth                    @"date_of_birth"
#define kSignUpAPI_Phone                          @"phoneno"
#define kSignUpAPI_Country                        @"country"
#define kSignUpAPI_State                          @"state"
#define kSignUpAPI_City                           @"city"
#define kSignUpAPI_BestAvailability               @"best_availablity"
#define kSignUpAPI_Password                       @"password"
#define kSignUpAPI_ConfirmPassword                @"confirm_password"
#define kSignUpAPI_ChooseSeurityQues              @"predefined_questions"
#define kSignUpAPI_EnterSecurityQues              @"own_questions"
#define kSignUpAPI_QuickBloxID                    @"quickbloxid"
#define kSignUpAPI_Terms                          @"terms"

#pragma mark - Login In API Keys
#define kLogInAPI_Email                           @"email"
#define kLogInAPI_Password                        @"password"
#define kLogInAPI_AccessToken                     @"access_token"
#define kLogInAPI_DeviceToken                     @"device_token"
#define kLogInAPI_DeviceType                      @"device_type"
#define kLogInAPI_FirstName                       @"first_name"
#define kLogInAPI_LastName                        @"last_name"
#define kLogInAPI_UserImage                       @"user_image"
#define kLogInAPI_Quickblox_Password              @"quickblox_password"


#pragma mark - Logout API Keys
#define kLogOutAPI_UserID                         @"user_id"
#define kLogOutAPI_AccessToken                    @"access_token"
#define kLogOutAPI_DeviceToken                    @"device_token"
#define kLogOutAPI_DeviceType                     @"device_type"

#pragma mark - Forgot Password API Keys
#define kForgotPasswordAPI_Email                  @"user_email"

#pragma mark - Get Cities API Keys
#define kCitiesAPI_CountryID                      @"country_id"

#pragma mark - Profile API Keys
#define kProfileAPI_UserID                        @"user_id"
#define kProfileAPI_LoggedIn_UserID               @"logged_in_user"
#define kProfileAPI_UserType                      @"user_type"
#define kProfileAPI_BasicInformation              @"basic_information"
#define kProfileAPI_ProfessionalInformation       @"professional_information"
#define kProfileAPI_StartupInformation            @"startup"
#define kProfileAPI_Complete                      @"profile_completeness"
#define kProfileAPI_Image                         @"profile_image"
#define kProfileAPI_Rating                        @"rating"
#define kProfileAPI_Name                          @"name"
#define kProfileAPI_PerHourRate                   @"perhour_rate"
#define kProfileAPI_isFollowing                   @"isFollowing"
#define kProfileAPI_QuickbloxID                   @"quickbloxid"
#define kProfileAPI_connectionSent                @"connection_sent"
#define kProfileAPI_connectionReceived                @"connection_received"
#define kProfileAPI_connectionStatus              @"connection_status"
#define kProfileAPI_connectionID                  @"connection_id"

#pragma mark - Follow User API Keys
#define kFollowUserAPI_FollowedBy                 @"followed_by"
#define kFollowUserAPI_UserID                     @"user_id"
#define kFollowUserAPI_Status                     @"status"

#pragma mark - Connect/Disconnect User API Keys
#define kConnectUserAPI_ConnectionBy               @"connection_by"
#define kConnectUserAPI_ConnectionTo               @"connection_to"
#define kConnectUserAPI_Status                     @"status"
#define kConnectUserAPI_UserID                     @"user_id"
#define kConnectUserAPI_ConnectionID               @"connection_id"

#define kBasicProfileAPI_Biodata                  @"biodata"
#define kBasicProfileAPI_City                     @"city"
#define kBasicProfileAPI_CityID                   @"city_id"
#define kBasicProfileAPI_Country                  @"country"
#define kBasicProfileAPI_CountryID                @"country_id"
#define kBasicProfileAPI_Dob                      @"dob"
#define kBasicProfileAPI_Email                    @"email"
#define kBasicProfileAPI_Interest                 @"interest"
#define kBasicProfileAPI_Name                     @"name"
#define kBasicProfileAPI_Phone                    @"phone"
#define kBasicProfileAPI_State                    @"state"

#define kProfProfileAPI_AccreditedInvestor        @"accredited_investor"
#define kProfProfileAPI_Certifications            @"certifications"
#define kProfProfileAPI_CompnayName               @"compnay_name"
#define kProfProfileAPI_ContractorType            @"contractor_type"
#define kProfProfileAPI_ContractorTypeID          @"contractor_type_id"
#define kProfProfileAPI_Description               @"description"
#define kProfProfileAPI_Experience                @"experience"
#define kProfProfileAPI_ExperienceID              @"experience_id"
#define kProfProfileAPI_IndustryFocus             @"industry_focus"
#define kProfProfileAPI_Keywords                  @"keywords"
#define kProfProfileAPI_Qualifications            @"qualifications"
#define kProfProfileAPI_Skills                    @"skills"
#define kProfProfileAPI_WebsiteLink               @"website_link"
#define kProfProfileAPI_PreferredStartup          @"preferred_startup"
#define kProfProfileAPI_PreferredStartupID        @"preferred_startup_id"
#define kProfProfileAPI_CertificationsList        @"certifications"
#define kProfProfileAPI_ContractorTypesList       @"contractorTypes"
#define kProfProfileAPI_ExperiencesList           @"experiences"
#define kProfProfileAPI_KeywordsList              @"keywords"
#define kProfProfileAPI_PrefferedStartupsList     @"prefferStartups"
#define kProfProfileAPI_QualificationsList        @"qualifications"
#define kProfProfileAPI_SkillsList                @"skills"

#pragma mark - Edit Profile API Keys
#define kBasicEditProfileAPI_UserID               @"user_id"
#define kBasicEditProfileAPI_Price                @"price"
#define kBasicEditProfileAPI_Bio                  @"bio"
#define kBasicEditProfileAPI_FirstName            @"first_name"
#define kBasicEditProfileAPI_LastName             @"last_name"
#define kBasicEditProfileAPI_Email                @"email"
#define kBasicEditProfileAPI_Dob                  @"date_of_birth"
#define kBasicEditProfileAPI_CountryID            @"country_id"
#define kBasicEditProfileAPI_CityID               @"state_id"
#define kBasicEditProfileAPI_Phone                @"phoneno"
#define kBasicEditProfileAPI_Image                @"image"
#define kBasicEditProfileAPI_Interests            @"my_interests"

#define kProfEditProfileAPI_UserID                @"user_id"
#define kProfEditProfileAPI_Image                 @"image"
#define kProfEditProfileAPI_Price                 @"rate"
#define kProfEditProfileAPI_ExperienceID          @"experience_id"
#define kProfEditProfileAPI_Keywords              @"keywords"
#define kProfEditProfileAPI_Qualifications        @"qualifications"
#define kProfEditProfileAPI_Certifications        @"certifications"
#define kProfEditProfileAPI_Skills                @"skills"
#define kProfEditProfileAPI_IndustryFocus         @"industry_focus"
#define kProfEditProfileAPI_FirstName             @"first_name"
#define kProfEditProfileAPI_LastName              @"last_name"
#define kProfEditProfileAPI_StartupStage          @"startup_stage"
#define kProfEditProfileAPI_ContributorType       @"contributor_type"
#define kProfEditProfileAPI_AccreditedInvestor    @"accredited_investor"
#define kProfEditProfileAPI_CompanyName           @"company_name"
#define kProfEditProfileAPI_WebsiteLink           @"website_link"
#define kProfEditProfileAPI_Description           @"description"

#pragma mark - Profile User Startup
#define kProfileUserStartupApi_UserID             @"user_id"
#define kProfileUserStartupApi_UserType           @"user_type"
#define kProfileUserStartupApi_StartupData        @"startup"
#define kProfileUserStartupApi_StartupID          @"id"
#define kProfileUserStartupApi_StartupName        @"name"
#define kProfileUserStartupApi_StartupDesc        @"description"
#define kProfileUserStartupApi_StartupIsSelected  @"isSelected"
#define kProfileAddStartupApi_StartupID           @"startup_id"

#pragma mark - Profile Settings
#define kProfileSetting_UserID                    @"user_id"
#define kProfileSetting_PublicProfile             @"public_profile"

#pragma mark - Add Startup API Keys
#define kAddStartupAPI_UserID                     @"user_id"
#define kAddStartupAPI_Name                       @"name"
#define kAddStartupAPI_Description                @"description"
#define kAddStartupAPI_Keywords                   @"keywords"
#define kAddStartupAPI_SupportRequired            @"support_required"

#pragma mark - Campaigns List API Keys
#define kCampaignsAPI_UserID                     @"user_id"
#define kCampaignsAPI_PageNo                     @"page_no"
#define kCampaignsAPI_CampaignType               @"campaign_type"
#define kCampaignsAPI_Campaigns                  @"campaigns"
#define kCampaignsAPI_CampaignName               @"campaign_name"
#define kCampaignsAPI_Description                @"description"
#define kCampaignsAPI_DueDate                    @"due_date"
#define kCampaignsAPI_FundRaised                 @"fund_raised"
#define kCampaignsAPI_StartupID                  @"startup_id"
#define kCampaignsAPI_StartupName                @"startup_name"
#define kCampaignsAPI_TargetAmount               @"target_amount"
#define kCampaignsAPI_CampaignID                 @"campaign_id"
#define kCampaignsAPI_TotalItems                 @"TotalItems"

#pragma mark - Commit Campaign API Keys
#define kCommitAPI_UserID                        @"user_id"
#define kCommitAPI_campaignID                    @"campaign_id"
#define kCommitAPI_targetAmount                  @"target_amount"
#define kCommitAPI_timePeriod                    @"time_period"
#define kCommitAPI_contributionPublic            @"contribution_public"

#pragma mark - Add Campaign API Keys
#define kAddCampaignAPI_UserID                   @"user_id"
#define kAddCampaignAPI_StartupID                @"startup_id"
#define kAddCampaignAPI_CampaignName             @"campaigns_name"
#define kAddCampaignAPI_Summary                  @"summary"
#define kAddCampaignAPI_TargetAmount             @"target_amount"
#define kAddCampaignAPI_FundRaisedSoFar          @"fund_raised_so_far"
#define kAddCampaignAPI_DueDate                  @"due_date"
#define kAddCampaignAPI_Keywords                 @"keywords"
#define kAddCampaignAPI_CampaignKeywords         @"campaign_keywords"
#define kAddCampaignAPI_CampaignImage            @"campaign_image"
#define kAddCampaignAPI_Docs                     @"docs"
#define kAddCampaignAPI_Audio                    @"mp3"
#define kAddCampaignAPI_Video                    @"mp4"

#pragma mark - Edit Campaign API Keys
#define kEditCampaignAPI_CampaignID              @"id"
#define kEditCampaignAPI_UserID                  @"user_id"
#define kEditCampaignAPI_StartupID               @"startup_id"
#define kEditCampaignAPI_Summary                 @"summary"
#define kEditCampaignAPI_TargetAmount            @"target_amount"
#define kEditCampaignAPI_FundRaisedSoFar         @"fund_raised_so_far"
#define kEditCampaignAPI_DueDate                 @"due_date"
#define kEditCampaignAPI_Keywords                @"keywords"
#define kEditCampaignAPI_CampaignKeywords        @"campaign_keywords"
#define kEditCampaignAPI_CampaignImage           @"campaign_image"
#define kEditCampaignAPI_Docs                    @"docs"
#define kEditCampaignAPI_Audio                   @"mp3"
#define kEditCampaignAPI_Video                   @"mp4"
#define kEditCampaignAPI_DeletedFiles            @"deleted_files"
#define kEditCampaignAPI_CampaignName            @"campaigns_name"

#pragma mark - Campaign Detail API Keys
#define kCampaignDetailAPI_UserID                @"user_id"
#define kCampaignDetailAPI_CampaignID            @"campaign_id"
#define kCampaignDetailAPI_CampaignDetail        @"campaigndetail"
#define kCampaignDetailAPI_CampaignImage         @"campaign_image"
#define kCampaignDetailAPI_CampaignName          @"campaigns_name"
#define kCampaignDetailAPI_DocumentsList         @"documents_list"
#define kCampaignDetailAPI_DueDate               @"due_date"
#define kCampaignDetailAPI_FundRaisedSoFar       @"fund_raised_so_far"
#define kCampaignDetailAPI_IsCommitted           @"is_commited_by_user"
#define kCampaignDetailAPI_IsFollowed            @"is_follwed_by_user"
#define kCampaignDetailAPI_Keywords              @"keywords"
#define kCampaignDetailAPI_CampaignKeywords      @"campaign_keywords"
#define kCampaignDetailAPI_StartupID             @"startup_id"
#define kCampaignDetailAPI_StartupName           @"startup_name"
#define kCampaignDetailAPI_Summary               @"summary"
#define kCampaignDetailAPI_TargetAmount          @"target_amount"
#define kCampaignDetailAPI_VideosList            @"videos_list"
#define kCampaignDetailAPI_AudiosList            @"audios_list"

#pragma mark - Follow/Unfollow Campaign API Keys
#define kFollowCampaignAPI_UserID                @"user_id"
#define kFollowCampaignAPI_CampaignID            @"campaign_id"
#define kFollowCampaignAPI_Status                @"status"

#pragma mark - Uncommit Campaign API Keys
#define kUncommitCampaignAPI_UserID              @"user_id"
#define kUncommitCampaignAPI_CampaignID          @"campaign_id"

#pragma mark - Campaign Contractors API Keys
#define kCampaignContractorAPI_UserID            @"user_id"
#define kCampaignContractorAPI_CampaignID        @"campaign_id"
#define kCampaignContractorAPI_Status            @"status"
#define kCampaignContractorAPI_ContractorsList   @"campaignContributorsList"
#define kCampaignContractorAPI_Contribution      @"contractor_contribution"
#define kCampaignContractorAPI_ContractorID      @"contractor_id"
#define kCampaignContractorAPI_ContractorsList   @"campaignContributorsList"
#define kCampaignContractorAPI_ContractorImage   @"contractor_image"
#define kCampaignContractorAPI_ContractorName    @"contractor_name"
#define kCampaignContractorAPI_Status            @"status"

#pragma mark - Startups List API Keys
#define kStartupsAPI_UserID                      @"user_id"
#define kStartupsAPI_StartupType                 @"startup_type"
#define kStartupsAPI_PageNo                      @"page_no"
#define kStartupsAPI_TotalItems                  @"TotalItems"
#define kStartupsAPI_StartupID                   @"startup_id"
#define kStartupsAPI_EntrepreneurID              @"entrepreneur_id"
#define kStartupsAPI_EntrepreneurName            @"entrepreneur_name"
#define kStartupsAPI_StartupName                 @"startup_name"
#define kStartupsAPI_StartupDesc                 @"startup_desc"
#define kStartupsAPI_isEntrepreneur              @"is_entrepreneur"
#define kStartupsAPI_isContractor                @"is_contractor"
#define kStartupsAPI_Startups                    @"startups"
#define kStartupsAPI_SearchText                  @"search_text"
#define kStartupsAPI_Startup_TeamID              @"startup_team_id"

#pragma mark - Startup Overview API Keys
#define kStartupOverviewAPI_UserID               @"user_id"
#define kStartupOverviewAPI_StartupID            @"startup_id"
#define kStartupOverviewAPI_EntrepreneurID       @"entrepreneur_id"
#define kStartupOverviewAPI_EntrepreneurName     @"entrepreneur_name"
#define kStartupOverviewAPI_Keywords             @"keywords"
#define kStartupOverviewAPI_NextStep             @"next_step"
#define kStartupOverviewAPI_RoadmapDeliverable   @"roadmap_deliverable_list"
#define kStartupOverviewAPI_DeliverableID        @"deliverable_id"
#define kStartupOverviewAPI_DeliverableLink      @"deliverable_link"
#define kStartupOverviewAPI_DeliverableName      @"deliverable_name"
#define kStartupOverviewAPI_RoadmapGraphic       @"roadmap_grapic"
#define kStartupOverviewAPI_StartupDesc          @"startup_desc"
#define kStartupOverviewAPI_StartupName          @"startup_name"
#define kStartupOverviewAPI_SupportRequired      @"support_required"

#pragma mark - Startup Team API Keys
#define kStartupTeamAPI_UserID                   @"user_id"
#define kStartupTeamAPI_StartupID                @"startup_id"
#define kStartupTeamAPI_TeamMember               @"team_member"
#define kStartupTeamAPI_MemberBio                @"member_bio"
#define kStartupTeamAPI_MemberEmail              @"member_email"
#define kStartupTeamAPI_MemberName               @"member_name"
#define kStartupTeamAPI_MemberRole               @"member_role"
#define kStartupTeamAPI_MemberStatus             @"member_status"
#define kStartupTeamAPI_TeamMemberID             @"team_memberid"
#define kStartupTeamAPI_Startup_TeamID           @"startup_team_id"
#define kStartupTeamAPI_Entrepreneur             @"entrepreneur"
#define kStartupTeamAPI_LoggedInRoleID           @"loggedin_role_id"
#define kStartupTeamAPI_EntrepreneurID           @"id"
#define kStartupTeamAPI_EntrepreneurBio          @"bio"
#define kStartupTeamAPI_EntrepreneurEmail        @"email"
#define kStartupTeamAPI_EntrepreneurName         @"name"
#define kStartupTeamAPI_QuickbloxID              @"quickbloxid"

#define kStartupTeamMemberStatusAPI_Status       @"status"
#define kStartupTeamMemberStatusAPI_LoginUserID  @"loggedin_user_id"

#pragma mark - Startup Team Message API Keys
#define kStartupTeamMesageAPI_FromID             @"from_team_memberid"
#define kStartupTeamMesageAPI_ToID               @"to_team_memberid"
#define kStartupTeamMesageAPI_Subject            @"subject"
#define kStartupTeamMesageAPI_Message            @"message_text"
#define kStartupTeamMesageAPI_RoleID             @"sender_role_id"
#define kStartupTeamMesageAPI_Msg_Type           @"msg_type"

#pragma mark - Startup Work Order Ent API Keys
#define kStartupWorkOrderAPI_UserID              @"user_id"
#define kStartupWorkOrderAPI_StartupID           @"startup_id"
#define kStartupWorkOrderAPI_WorkOrders          @"workOrders"
#define kStartupWorkOrderAPI_TeamMemberID        @"team_memberid"
#define kStartupWorkOrderAPI_WorkOrderID         @"work_orderid"
#define kStartupWorkOrderAPI_Date                @"start_date"
#define kStartupWorkOrderAPI_WorkUnits           @"total_work_units"
#define kStartupWorkOrderAPI_MemberFirstName     @"first_name"
#define kStartupWorkOrderAPI_MemberLastName      @"last_name"
#define kStartupWorkorderAPI_WeekNo              @"week_no"
#define kStartupWorkOrderAPI_RoadmapName         @"deliverable_name"
#define kStartupWorkOrderAPI_StartupTeamID       @"startup_team_id"
#define kStartupWorkOrderAPI_ContractorID        @"contractor_id"
#define kStartupWorkOrderAPI_EntrepreneurID      @"entrepreneur_id"
#define kStartupWorkOrderStatusAPI_WorkorderID   @"workorder_id"

#pragma mark - Startup Work Order Cont API Keys
#define kStartupWorkOrderContAPI_UserID          @"user_id"
#define kStartupWorkOrderContAPI_StartupID       @"startup_id"
#define kStartupWorkOrderContAPI_Date            @"date"
#define kStartupWorkOrderContAPI_Day             @"day"
#define kStartupWorkOrderContAPI_AllocatedHours  @"Allocated_hours"
#define kStartupWorkOrderContAPI_ApprovedHours   @"Approved_hours"
#define kStartupWorkOrderContAPI_ConsumedHours   @"consumedHours"
#define kStartupWorkOrderContAPI_TeammemberID    @"teammember_id"
#define kStartupWorkOrderContAPI_Startup_TeamID  @"startup_team_id"
#define kStartupWorkOrderContAPI_WeeklyUpdate    @"weekly_update"
#define kStartupWorkOrderContAPI_Deliverables    @"deliverables"
#define kStartupWorkOrderContAPI_DeliverableName @"deliverable_name"
#define kStartupWorkOrderContAPI_DeliverableID   @"deliverable_id"
#define kStartupWorkOrderContAPI_WorkOrderID     @"work_orderid"
#define kStartupWorkOrderContAPI_WorkUnits       @"work_units"
#define kStartupWorkOrderContAPI_MainDeliverable @"Maindeliverables"
#define kStartupWorkOrderContAPI_EnterpreneurID  @"entrepreneur_id"
#define kStartupWorkOrderContAPI_ContractorID    @"contractor_id"
#define kStartupWorkOrderContAPI_IsEnterpreneur  @"is_enterpreneur"
#define kStartupWorkOrderContAPI_RatingStars     @"rating_star"
#define kStartupWorkOrderContAPI_WeekNumber      @"week_no"

#pragma mark - Update Startup API Keys
#define kUpdateStartupAPI_StartupID              @"id"
#define kUpdateStartupAPI_StartupName            @"name"
#define kUpdateStartupAPI_Description            @"description"
#define kUpdateStartupAPI_NextStep               @"next_step"
#define kUpdateStartupAPI_Keywords               @"keywords"
#define kUpdateStartupAPI_SupportRequired        @"support_required"
#define kUpdateStartupAPI_RoadmapGraphic         @"roadmap_graphic"
#define kUpdateStartupAPI_UserID                 @"user_id"


#pragma mark - Update WorkOrder API Keys
#define kUpdateWorkOrderAPI_UserID               @"user_id"
#define kUpdateWorkOrderAPI_StartupID            @"startup_id"
#define kUpdateWorkOrderAPI_RoadmapID            @"roadmap_id"
#define kUpdateWorkOrderAPI_Date                 @"work_date"
#define kUpdateWorkOrderAPI_WorkUnits            @"workunit"
#define kUpdateWorkOrderAPI_Approved             @"Approved"
#define kUpdateWorkOrderAPI_Pending              @"Pending"

#pragma mark - Startup Docs API Keys
#define kStartupDocsAPI_StartupID                @"startup_id"
#define kStartupDocsAPI_FilesList                @"filesList"
#define kStartupDocsAPI_DocID                    @"id"
#define kStartupDocsAPI_Date                     @"date"
#define kStartupDocsAPI_DocName                  @"doc_name"
#define kStartupDocsAPI_DownloadLink             @"download_link"
#define kStartupDocsAPI_RoadmapName              @"roadmap_name"
#define kStartupDocsAPI_UserName                 @"user_name"

#pragma mark - Startup Roadmap Docs API Keys
#define kRoadmapDocsAPI_StartupID                @"startup_id"
#define kRoadmapDocsAPI_CompletedRoadmaps        @"CompletedRoadmaps"
#define kRoadmapDocsAPI_RoadmapID                @"roadmap_id"
#define kRoadmapDocsAPI_RoadmapName              @"roadmap_name"

#pragma mark - Search Job API Keys
#define kSearchJobAPI_UserID                    @"user_id"
#define kSearchJobAPI_SearchText                @"search_text"
#define kSearchJobAPI_PageNo                    @"page_no"
#define kSearchJobAPI_CountryID                 @"country_id"
#define kSearchJobAPI_StateID                   @"state_id"
#define kSearchJobAPI_JobList                   @"job_list"
#define kSearchJobAPI_TotalItems                @"TotalItems"
#define kSearchJobAPI_JobID                     @"job_id"
#define kSearchJobAPI_Job_Title                 @"job_title"
#define kSearchJobAPI_Company_Image             @"company_image"
#define kSearchJobAPI_Company_Name              @"company_name"
#define kSearchJobAPI_Country                   @"country"
#define kSearchJobAPI_State                     @"state"
#define kSearchJobAPI_Location                  @"location"
#define kSearchJobAPI_StarDate                  @"start_date"
#define kSearchJobAPI_Followers                 @"followers"
#define kSearchJobAPI_PostedBy                  @"posted_by"

#pragma mark - Job Detail API Keys
#define kJobDetailAPI_UserID               @"user_id"
#define kJobDetailAPI_JobDetail            @"job_details"
#define kJobDetailAPI_JobID                @"job_id"
#define kJobDetailAPI_JobTitle             @"job_title"
#define kJobDetailAPI_JobRole              @"role"
#define kJobDetailAPI_JobDuties            @"job_duty_id"
#define kJobDetailAPI_IsFollowed           @"is_follwed_by_user"
#define kJobDetailAPI_CompanyID            @"company_id"
#define kJobDetailAPI_CompanyName          @"company_name"
#define kJobDetailAPI_CompanyImage         @"company_image"
#define kJobDetailAPI_CompanyUrl           @"company_url"
#define kJobDetailAPI_Achievments          @"job_achievement_id"
#define kJobDetailAPI_JobRoleID            @"job_role_id"
#define kJobDetailAPI_CountryID            @"country_id"
#define kJobDetailAPI_StateID              @"state_id"
#define kJobDetailAPI_Country              @"country"
#define kJobDetailAPI_State                @"state"
#define kJobDetailAPI_Location             @"location"
#define kJobDetailAPI_JobTypeID            @"job_type_id"
#define kJobDetailAPI_JobType              @"job_type"
#define kJobDetailAPI_MINWORK_NPS          @"min_work_nps"
#define kJobDetailAPI_Travel               @"travel"
#define kJobDetailAPI_PostedBy             @"posted_by"
#define kJobDetailAPI_PostedBy_UserID      @"posted_by_userid"
#define kJobDetailAPI_PostingKeywords      @"posting_keywords"
#define kJobDetailAPI_IndustryKeywords     @"job_industry"
#define kJobDetailAPI_Skills               @"skills"
#define kJobDetailAPI_Requirement          @"requirements"
#define kJobDetailAPI_StartDate            @"start_date"
#define kJobDetailAPI_EndDate              @"end_date"
#define kJobDetailAPI_Summary              @"description"
#define kJobDetailAPI_Document             @"document"
#define kJobDetailAPI_Video                @"video"
#define kJobDetailAPI_Audio                @"audio"

#pragma mark - Follow/Unfollow Job API Keys
#define kFollowJobAPI_UserID                @"user_id"
#define kFollowJobAPI_JobID                 @"job_id"
#define kFollowJobAPI_Status                @"status"

#pragma mark - Apply Job API Keys
#define kApplyJob_JobTitle                @"job_title"
#define kApplyJob_JobID                   @"job_id"
#define kApplyJob_PostedBy                @"postedBy"
#define kApplyJob_Summary                 @"summary"
#define kApplyJob_CoverLetter             @"cover_letter"
#define kApplyJob_Experience              @"experience"
#define kApplyJob_Name                    @"name"
#define kApplyJob_JobExperienceID         @"job_experience_id"
#define kApplyJob_CoverLetterText         @"coverletter_text"
#define kApplyJob_CoverLetterDoc          @"coverletter_doc"
#define kApplyJob_Resume                  @"resume"

#pragma mark - User Experiences List Keys
#define kUserExperienceAPI_ExperienceID            @"job_experience_id"
#define kUserExperienceAPI_UserID                  @"user_id"
#define kUserExperienceAPI_UserExperienceList      @"user_experience_list"
#define kUserExperienceAPI_CompanyName             @"company_name"
#define kUserExperienceAPI_JobTitle                @"job_title"
#define kUserExperienceAPI_StartDate               @"start_date"
#define kUserExperienceAPI_EndDate                 @"end_date"
#define kUserExperienceAPI_CompanyUrl              @"company_url"
#define kUserExperienceAPI_JobDutyID               @"job_duty_id"
#define kUserExperienceAPI_JobRoleID               @"job_role_id"
#define kUserExperienceAPI_JobAchievmentID         @"job_achievement_id"
#define kAddExperienceAPI_ExperienceDetails        @"experience_details"

#pragma mark - Add/Edit Job API Keys
#define kAddJobAPI_ChooseCompany                 @"company_name"
#define kAddJobAPI_UserID               @"user_id"
#define kAddJobAPI_JobID                @"job_id"
#define kAddJobAPI_JobTitle             @"job_title"
#define kAddJobAPI_JobRole              @"role"
#define kAddJobAPI_CompanyID            @"company_id"
#define kAddJobAPI_CompanyUrl           @"company_url"
#define kAddJobAPI_CountryID            @"country_id"
#define kAddJobAPI_StateID              @"state_id"
#define kAddJobAPI_Location             @"location"
#define kAddJobAPI_JobTypeID            @"job_type"
#define kAddJobAPI_MINWORK_NPS          @"min_work_nps"
#define kAddJobAPI_Travel               @"travel"
#define kAddJobAPI_PostingKeywords      @"posting_keywords"
#define kAddJobAPI_IndustryKeywords     @"industry_id"
#define kAddJobAPI_Skills               @"skills"
#define kAddJobAPI_Requirement          @"requirements"
#define kAddJobAPI_StartDate            @"start_date"
#define kAddJobAPI_EndDate              @"end_date"
#define kAddJobAPI_Summary              @"description"


#pragma mark - Recommended Contractors API Keys
#define kRecommendedContAPI_UserID               @"user_id"
#define kRecommendedContAPI_StartupID            @"startup_id"
#define kRecommendedContAPI_TotalItems           @"TotalItems"
#define kRecommendedContAPI_PageNo               @"page_no"
#define kRecommendedContAPI_Contractors          @"Contractors"
#define kRecommendedContAPI_ContractorID         @"id"
#define kRecommendedContAPI_Contractor_Name      @"name"
#define kRecommendedContAPI_Image                @"image"
#define kRecommendedContAPI_Rate                 @"rate"
#define kRecommendedContAPI_Skills               @"skills"
#define kRecommendedContAPI_Keywords             @"keywords"
#define kRecommendedContAPI_Bio                  @"bio"
#define kRecommendedContAPI_Is_Profile_Pubilc    @"is_profile_public"

#pragma mark - Search Contractors API Keys
#define kSearchContAPI_UserID                    @"user_id"
#define kSearchContAPI_SearchText                @"search_text"
#define kSearchContAPI_PageNo                    @"page_no"

#pragma mark - Add Contractor Api Keys
#define kAddContractorAPI_Roles                  @"Roles"
#define kAddContractorAPI_StartupID              @"startup_id"
#define kAddContractorAPI_UserID                 @"user_id"
#define kAddContractorAPI_ContractorRoleID       @"contractor_role_id"
#define kAddContractorAPI_HourlyPrice            @"hourly_price"
#define kAddContractorAPI_RoadmapID              @"roadmap_id"
#define kAddContractorAPI_WorkUnitsAllocated     @"work_units_allocated"
#define kAddContractorAPI_WorkUnitsApproved      @"work_units_approved"
#define kAddContractorAPI_TargetCompletionDate   @"target_date"
#define kAddContractorAPI_HiredBy                @"hired_by"


#define kDeliverablesAPI_Deliverables            @"Deliverables"

#pragma mark - Contractor Ratings Api Keys
#define kRatingsAPI_UserID                       @"user_id"
#define kRatingsAPI_UserType                     @"user_type"
#define kRatingsAPI_Ratings                      @"Ratings"
#define kRatingsAPI_GivenbyID                    @"givenby_id"
#define kRatingsAPI_GivenbyName                  @"givenby_name"
#define kRatingsAPI_GivenbyImage                 @"givenby_image"
#define kRatingsAPI_Description                  @"description"
#define kRatingsAPI_Rating                       @"rating"
#define kRatingsAPI_Date                         @"date"

#pragma mark - Add Ratings Api Keys
#define kAddRatingsAPI_GivenBy                   @"given_by"
#define kAddRatingsAPI_GivenTo                   @"given_to"
#define kAddRatingsAPI_Description               @"description"
#define kAddRatingsAPI_RatingStar                @"rating_star"
#define kAddRatingsAPI_Deliverable               @"deliverable"
#define kAddRatingsAPI_UserType                  @"user_type"

#pragma mark - Connection List API Keys
#define kConnectionAPI_LoggedIn_UserID           @"loggedin_user_id"
#define kConnectionAPI_PageNo                    @"page_no"
#define kConnectionAPI_Connection_List           @"connection_list"
#define kConnectionAPI_ContractorID              @"contractor_id"
#define kConnectionAPI_Contractor_Image          @"contractor_image"
#define kConnectionAPI_Contractor_Name           @"contractor_name"
#define kConnectionAPI_TotalItems                @"TotalItems"
#define kConnectionAPI_SearchText                @"search_text"

#pragma mark - Messages List Api Keys
#define kMessagesAPI_UserID                      @"user_id"
#define kMessagesAPI_PageNo                      @"page_no"
#define kMessagesAPI_Messages                    @"Messages"
#define kMessagesAPI_TotalItems                  @"TotalItems"
#define kMessagesAPI_MessageID                   @"id"
#define kMessagesAPI_MessageTitle                @"title"
#define kMessagesAPI_MessageDesc                 @"description"
#define kMessagesAPI_MessageSender               @"sender"
#define kMessagesAPI_MessageTime                 @"time"

#pragma mark - Suggest Keywords API Keys
#define kSuggestKeywordsAPI_UserID                @"user_id"
#define kSuggestKeywordsAPI_KeywordID             @"keyword_id"
#define kSuggestKeywordsAPI_keyword_name          @"keyword_name"
#define kSuggestKeywordsAPI_keyword_type_id       @"keyword_type_id"
#define kSuggestKeywordsAPI_keyword_type_name     @"keyword_type_name"
#define kSuggestKeywordsAPI_keyword_type_list     @"keyword_type_list"
#define kSuggestKeywordsAPI_TotalItems            @"TotalItems"
#define kSuggestKeywordsAPI_keyword_status        @"status"
#define kSuggestKeywordsAPI_suggest_keyword_list  @"suggest_keyword_list"

#pragma mark - Search Company API Keys
#define kSearchCompanyAPI_UserID                    @"user_id"
#define kSearchCompanyAPI_SearchText                @"search_text"
#define kSearchCompanyAPI_PageNo                    @"page_no"
#define kSearchCompanyAPI_Company_list              @"company_list"
#define kSearchCompanyAPI_TotalItems                @"TotalItems"
#define kSearchCompanyAPI_CompanyID                 @"company_id"
#define kSearchCompanyAPI_Company_Name              @"company_name"
#define kSearchCompanyAPI_Company_Desc              @"company_description"
#define kSearchCompanyAPI_Company_keywords          @"company_keywords"
#define kSearchCompanyAPI_Company_Image             @"company_image"

#pragma mark - Company Detail API Keys
#define kCompanyDetailAPI_UserID               @"user_id"
#define kCompanyDetailAPI_CompanyID            @"company_id"
#define kCompanyDetailAPI_CompanyDetail        @"company_details"
#define kCompanyDetailAPI_CompanyImage         @"company_image"
#define kCompanyDetailAPI_CompanyName          @"company_name"
#define kCompanyDetailAPI_DocumentsList        @"company_document"
#define kCompanyDetailAPI_CompanyKeywords      @"company_keywords"
#define kCompanyDetailAPI_Summary              @"company_description"
#define kCompanyDetailAPI_VideosList           @"company_video"
#define kCompanyDetailAPI_AudiosList           @"company_audio"

#pragma mark - Archive/Delete Message List Api Keys
#define kArchiveMessageAPI_MessageID             @"message_id"
#define kArchiveMessageAPI_Status                @"status"

#pragma mark - Forum List Api Keys
#define kForumsAPI_UserID                        @"user_id"
#define kForumsAPI_PageNo                        @"page_no"
#define kForumsAPI_StartupID                     @"startup_id"

#pragma mark - Forum Startups List Api Keys
#define kForumStartupsAPI_TotalItems             @"TotalItems"
#define kForumStartupsAPI_Startups               @"startups"
#define kForumStartupsAPI_StartupID              @"startup_id"
#define kForumStartupsAPI_StartupName            @"startup_name"
#define kForumStartupsAPI_Description            @"description"
#define kForumStartupsAPI_CreatedTime            @"createdtime"

#pragma mark - My Forums List Api Keys
#define kMyForumAPI_TotalItems                   @"TotalItems"
#define kMyForumAPI_Forums                       @"Forums"
#define kMyForumAPI_ForumID                      @"id"
#define kMyForumAPI_ForumTitle                   @"forum_title"
#define kMyForumAPI_ForumDesc                    @"description"
#define kMyForumAPI_ForumCreatedBy               @"forumCreatedBy"
#define kMyForumAPI_ForumCreatedTime             @"createdTime"
#define kForumSearchAPI_SearchText               @"search_text"
#define kForumSearchAPI_UserID                   @"user_id"

#pragma mark - Archive/Delete Forum List Api Keys
#define kArchiveForumAPI_ForumID                 @"forum_id"
#define kArchiveForumAPI_Status                  @"status"

#pragma mark - Add Forum List Api Keys
#define kAddForumAPI_UserID                      @"user_id"
#define kAddForumAPI_StartupID                   @"startup_id"
#define kAddForumAPI_Title                       @"title"
#define kAddForumAPI_Keywords                    @"keywords"
#define kAddForumAPI_Image                       @"image"
#define kAddForumAPI_Description                 @"description"

#pragma mark - Forum Detail Api Keys
#define kForumDetailAPI_ForumID                  @"forum_id"
#define kForumDetailAPI_Forums                   @"Forums"
#define kForumDetailAPI_ForumTitle               @"forum_title"
#define kForumDetailAPI_ForumCreatedBy           @"forum_createdBy"
#define kForumDetailAPI_ForumDesc                @"forum_description"
#define kForumDetailAPI_ForumImage               @"forum_image"
#define kForumDetailAPI_ArchivedClosedStatus     @"archivedClosedStatus"
#define kForumDetailAPI_ForumComments            @"forum_comments"
#define kForumDetailAPI_CommenterID              @"commenter_id"
#define kForumDetailAPI_CommentedBy              @"commentedBy"
#define kForumDetailAPI_CommentText              @"CommentText"
#define kForumDetailAPI_CommentedTime            @"commentedTime"


#pragma mark - Forum Comments Api Keys
#define kForumCommentAPI_ForumID                 @"forum_id"
#define kForumCommentAPI_PageNo                  @"page_no"
#define kForumCommentAPI_TotalItems              @"TotalItems"
#define kForumCommentAPI_Comments                @"Comments"
#define kForumCommentAPI_CommenterID             @"commenter_id"
#define kForumCommentAPI_CommentedBy             @"commentedBy"
#define kForumCommentAPI_CommentText             @"CommentText"
#define kForumCommentAPI_UserImage               @"userImage"
#define kForumCommentAPI_CommentedTime           @"commentedTime"

#pragma mark - Forum Report Abuse Api Keys
#define kReportAbuseAPI_UserID                   @"user_id"
#define kReportAbuseAPI_ForumID                  @"forum_id"
#define kReportAbuseAPI_isForumReported          @"is_form_reported"
#define kReportAbuseAPI_Comment                  @"comment"
#define kReportAbuseAPI_ReportedUsers            @"reported_users"


#pragma mark - Report Abuse Users Api Keys
#define kReportAbuseUsersAPI_ForumID             @"forum_id"
#define kReportAbuseUsersAPI_Users               @"users"
#define kReportAbuseUsersAPI_UserID              @"user_id"
#define kReportAbuseUsersAPI_UserImage           @"user_image"
#define kReportAbuseUsersAPI_UserName            @"user_name"

#pragma mark - Add Comment Api Keys
#define kAddCommentAPI_ForumID                   @"forum_id"
#define kAddCommentAPI_UserID                    @"user_id"
#define kAddCommentAPI_Comment                   @"comment"

#pragma mark - Get Contacts List Api Keys
#define kGetContactsAPI_UserID                   @"user_id"
#define kGetContactsAPI_Users                    @"users"
#define kGetContactsAPI_QuickbloxID              @"quickbloxid"
#define kGetContactsAPI_UserName                 @"username"
#define kGetContactsAPI_UserImage                @"userimage"

#pragma mark - Search Campaign Api Keys
#define kSearchCampaignAPI_UserID                @"user_id"
#define kSearchCampaignAPI_SearchText            @"search"
#define kSearchCampaignAPI_PageNo                @"page_no"

#pragma mark - Add Enterpreneur/Contractor Comment/Rating Api Keys
#define kAddCommentAPI_GivenBy                   @"given_by"
#define kAddCommentAPI_GivenTo                   @"given_to"
#define kAddCommentAPI_WorkComment               @"work_comment"
#define kAddCommentAPI_RatingStar                @"rating_star"
#define kAddCommentAPI_WeekNo                    @"week_no"
#define kAddCommentAPI_StartupId                 @"startup_id"
#define kAddCommentAPI_Status                    @"status"
#define kAddCommentAPI_IsEnterpreneur            @"is_entrepreneur"
#define kAddCommentAPI_Startup_team_id           @"startup_team_id"

#pragma mark - Notifications List Api Keys
#define kNotificationsAPI_UserID                 @"user_id"
#define kNotificationsAPI_PageNo                 @"page_no"
#define kNotificationsAPI_Notifications          @"notification"
#define kNotificationsAPI_TotalItems             @"TotalItems"
#define kNotificationsAPI_NotificationID         @"id"
#define kNotificationsAPI_Tags                   @"tags"
#define kNotificationsAPI_Values                 @"values"
#define kNotificationsAPI_CampaignID             @"campaign_id"
#define kNotificationsAPI_CampaignName           @"campaign_name"
#define kNotificationsAPI_Time                   @"time"
#define kNotificationsAPI_Message                @"message"
#define kNotificationsAPI_ForumID                @"forum_id"
#define kNotificationsAPI_ForumName              @"forum_name"
#define kNotificationsAPI_OwnForum               @"own_forum"

#pragma mark - Reset Password Mail Api Keys
#define kResetPasswordMailAPI_Email              @"user_email"

#define kMaxLimitResetPaswordAPI_Email           @"email_id"

#pragma mark - Basic Auth Creds
#define kAPIBasicAuthUser                         @"richa.walia@trantorinc.com"
#define kAPIBasicAuthPassword                     @"123@Rricha"





#endif /* ConstantsServer_h */
