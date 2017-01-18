//
//  ApiCrowdBootstrap.h
//  CrowdBootstrap
//
//  Created by OSX on 08/03/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
//#import "Parse.h"


typedef void (^SuccessBlock)(NSDictionary *responseDict);
typedef void (^FailureBlock)(NSError *error);
typedef void (^ProgressBlock)(double progress);

#define CROWDBOOTSTRAP_BASE_URL                    APIPortToBeUsed

#define CROWDBOOTSTRAP_LOGIN                       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/login"]
#define CROWDBOOTSTRAP_LOGOUT                      [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/logout"]
#define CROWDBOOTSTRAP_USER_SECURITY_QUESTIONS     [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/AppuserQuestionList"]
#define CROWDBOOTSTRAP_COUNTRIES                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/AppcountryList"]
#define CROWDBOOTSTRAP_CITIES                      [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/AppstateList"]
#define CROWDBOOTSTRAP_JOB_INDUSTRY_KEYWORDS       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/jobIndustrieLists"]
#define CROWDBOOTSTRAP_SECURITY_QUESTIONS          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/AppquestionList"]
#define CROWDBOOTSTRAP_SIGNUP                      [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/register"]
#define CROWDBOOTSTRAP_CONT_BASIC_PROFILE          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userContractorBasic"]
#define CROWDBOOTSTRAP_CONT_PROFESSIONAL_PROFILE   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userContractorProffesional"]
#define CROWDBOOTSTRAP_ENT_BASIC_PROFILE           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userEntrepreneurBasic"]
#define CROWDBOOTSTRAP_ENT_PROFESSIONAL_PROFILE    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userEntrepreneurProfessional"]
#define CROWDBOOTSTRAP_SQKCCPE                     [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/SQKCCPE"]
#define CROWDBOOTSTRAP_CONT_BASIC_EDIT_PROFILE     [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editContractorBasic"]
#define CROWDBOOTSTRAP_CONT_PROF_EDIT_PROFILE      [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editContractorProffesional"]
#define CROWDBOOTSTRAP_ENT_BASIC_EDIT_PROFILE      [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editEntrepreneurBasic"]
#define CROWDBOOTSTRAP_ENT_PROF_EDIT_PROFILE       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editEntrepreneurProffesional"]
#define CROWDBOOTSTRAP_USER_STARTUPS               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userStartup"]
#define CROWDBOOTSTRAP_ADD_STARTUP                 [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addStartup"]
#define CROWDBOOTSTRAP_PROFILE_SELECTED_STARTUP    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userSelectedStartup"]
#define CROWDBOOTSTRAP_PROFILE_ADD_STARTUPLIST     [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addStartupList"]
#define CROWDBOOTSTRAP_PROFILE_SETTINGS            [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/profileSettings"]
#define CROWDBOOTSTRAP_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/keywords"]
#define CROWDBOOTSTRAP_CAMPAIGNS_LIST              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/campaignsList"]
#define CROWDBOOTSTRAP_TIMEPERIOD_LIST             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/timePeriods"]
#define CROWDBOOTSTRAP_COMMIT_CAMPAIGN             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/commitCampaign"]
#define CROWDBOOTSTRAP_ADD_CAMPAIGN                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addCampaign"]
#define CROWDBOOTSTRAP_CAMPAIGN_DETAIL             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/singleCampaignDetail"]
#define CROWDBOOTSTRAP_FOLLOW_CAMPAIGN             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followCampaign"]
#define CROWDBOOTSTRAP_UNCOMMIT_CAMPAIGN           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/uncommitCampaign"]
#define CROWDBOOTSTRAP_COMMITTED_CONTRACTORS       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/campaignContributorsList"]
#define CROWDBOOTSTRAP_EDIT_CAMPAIGN               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editCampaign"]
#define CROWDBOOTSTRAP_STARTUPS_LIST               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/startupsList"]
#define CROWDBOOTSTRAP_STARTUP_OVERVIEW            [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/startupOverview"]
#define CROWDBOOTSTRAP_STARTUP_TEAM                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/startupTeam"]
#define CROWDBOOTSTRAP_STARTUP_TEAMMEMBER_STATUS   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/teamMemberStatus"]
#define CROWDBOOTSTRAP_STARTUP_TEAM_MESSAGE        [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/sendMessage"]
#define CROWDBOOTSTRAP_STARTUP_WORKORDER_ENT       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/approveWorkorderEntrepreneur"]
#define CROWDBOOTSTRAP_STARTUP_WORKORDER_DETAIL_ENT       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/entrepreneurStartupWorkorders"]
#define CROWDBOOTSTRAP_STARTUP_WORKORDER_ACCEPT    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/acceptWorkorderEntrepreneur"]
#define CROWDBOOTSTRAP_STARTUP_WORKORDER_REJECT    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/rejectWorkorderEntrepreneur"]
#define CROWDBOOTSTRAP_STARTUP_WORKORDER_CONT      [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/startupWorkorders"]
#define CROWDBOOTSTRAP_UPDATE_STARTUP              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/updateStartup"]
#define CROWDBOOTSTRAP_UPDATE_WORKORDER            [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/updateWorkorder"]
#define CROWDBOOTSTRAP_STARTUP_DOCSLIST            [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deliverablesDocsList"]
#define CROWDBOOTSTRAP_RECOMMENDED_CONT            [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/recommendedContractors"]
#define CROWDBOOTSTRAP_SEARCH_CONT                 [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/searchContractors"]
#define CROWDBOOTSTRAP_ROLES                       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/teamMembersRoles"]
#define CROWDBOOTSTRAP_DELIVERABLES                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/allDeliverables"]
#define CROWDBOOTSTRAP_ADD_CONTRACTOR              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addTeamMember"]
#define CROWDBOOTSTRAP_USER_RATINGS                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/allRatings"]
#define CROWDBOOTSTRAP_RATE_CONTRACTOR             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/rateContractor"]
#define CROWDBOOTSTRAP_JOB_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/jobLists"]
#define CROWDBOOTSTRAP_VIEW_JOB                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/viewJob"]
#define CROWDBOOTSTRAP_EXPERIENCE_LIST             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/getUserExperiences"]
#define CROWDBOOTSTRAP_EDIT_EXPERIENCES            [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editExperiences"]
#define CROWDBOOTSTRAP_ADD_EXPERIENCE              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addExperiences"]
#define CROWDBOOTSTRAP_FOLLOW_JOB                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followJob"]
#define CROWDBOOTSTRAP_UNFOLLOW_JOB                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowJob"]
#define CROWDBOOTSTRAP_APPLY_JOB                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/applyForJob"]
#define CROWDBOOTSTRAP_JOB_ROLE_KEYWORDS           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/jobRoleLists"]
#define CROWDBOOTSTRAP_JOB_TYPE_LIST               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/jobTypeLists"]
#define CROWDBOOTSTRAP_HIRED_COMPANY_LIST               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/hiredCompanyList"]

// Recruiter
#define CROWDBOOTSTRAP_MY_JOB_LIST                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myJobLists"]
#define CROWDBOOTSTRAP_ARCHIVED_JOB_LIST                        [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveJobLists"]
#define CROWDBOOTSTRAP_DEACTIVATED_JOB_LIST                     [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivatedJobLists"]
#define CROWDBOOTSTRAP_ARCHIVE_JOB                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveJob"]
#define CROWDBOOTSTRAP_DELETE_JOB                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteJob"]
#define CROWDBOOTSTRAP_DEACTIVATE_JOB                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateJob"]
#define CROWDBOOTSTRAP_ACTIVATE_JOB                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateJob"]
#define CROWDBOOTSTRAP_EDIT_JOB                                 [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editJob"]
#define CROWDBOOTSTRAP_ADD_JOB                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addJobs"]


#define CROWDBOOTSTRAP_SUBMIT_WORKORDER_RATINGS    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/startupWorkorderRatings"]
#define CROWDBOOTSTRAP_DELETE_STARTUP              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteStartup"]
#define CROWDBOOTSTRAP_DELETE_CAMPAIGN             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteCampaign"]
#define CROWDBOOTSTRAP_STARTUP_ROADMAP_DOCS        [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/startupRoadmapsStaus"]
#define CROWDBOOTSTRAP_STARTUP_QUESTIONS           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/startupQuestions"]
#define CROWDBOOTSTRAP_MESSAGES_LIST               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/messagesList"]
#define CROWDBOOTSTRAP_SEARCH_COMPANY              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/searchCompany"]
#define CROWDBOOTSTRAP_VIEW_COMPANY                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/viewCompany"]
#define CROWDBOOTSTRAP_COMPANY_KEYWORD_LIST                 [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/companyKeywordList"]
#define CROWDBOOTSTRAP_ARCHIVED_MESSAGES_LIST      [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/messagesArchiveList"]
#define CROWDBOOTSTRAP_ARCHIVE_DELETE_MESSAGE      [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/messageArchivedDelete"]
#define CROWDBOOTSTRAP_ARCHIVE_DELETE_MESSAGE      [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/messageArchivedDelete"]
#define CROWDBOOTSTRAP_FORUM_STARTUP_LIST          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/forumStartupsList"]
#define CROWDBOOTSTRAP_MY_FORUMS_LIST              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myForums"]
#define CROWDBOOTSTRAP_SEARCH_FORUMS_LIST          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/searchForums"]
#define CROWDBOOTSTRAP_STARTUP_FORUMS_LIST         [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/startupForums"]
#define CROWDBOOTSTRAP_ARCHIVE_DELETE_FORUM        [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/forumArchivedDelete"]
#define CROWDBOOTSTRAP_ADD_FORUM                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addForum"]
#define CROWDBOOTSTRAP_FORUM_DETAIL                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/forumDetail"]
#define CROWDBOOTSTRAP_FORUM_COMMENTS              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/forumcomments"]
#define CROWDBOOTSTRAP_ARCHIVED_FORUMS_LIST        [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archivedForums"]
#define CROWDBOOTSTRAP_FORUMS_DETAIL               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/forumDetail"]
#define CROWDBOOTSTRAP_FORUMS_COMMENTS             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/forumcomments"]
#define CROWDBOOTSTRAP_ADD_FORUM_COMMENT           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addForumComment"]
#define CROWDBOOTSTRAP_FOLLOW_UNFOLLOW_USER        [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userFollow"]
#define CROWDBOOTSTRAP_CONNECT_USER                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addConnection"]
#define CROWDBOOTSTRAP_ACCEPT_CONNECTION           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/acceptConnection"]
#define CROWDBOOTSTRAP_DISCONNECT_USER             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/rejectConnection"]
#define CROWDBOOTSTRAP_MyCONNECTIONS_LIST          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myConnections"]
#define CROWDBOOTSTRAP_SEARCH_CONNECTION           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/searchConnections"]
#define CROWDBOOTSTRAP_MyMESSAGES_LIST             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myMessages"]
#define CROWDBOOTSTRAP_SUGGEST_KEYWORD_LIST          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/suggestKeywordLists"]
#define CROWDBOOTSTRAP_ADD_SUGGEST_KEYWORDS          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addSuggestKeywords"]
#define CROWDBOOTSTRAP_DELETE_SUGGEST_KEYWORDS         [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteSuggestKeywords"]
#define CROWDBOOTSTRAP_KEYWORD_TYPE_LIST          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/keywordTypeList"]
#define CROWDBOOTSTRAP_FORUM_REPORT_ABUSE          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/reportAbuse"]
#define CROWDBOOTSTRAP_REPORT_ABUSE_USERS          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/commentedUsers"]
#define CROWDBOOTSTRAP_CONTACTS_LIST               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/quickBloxId"]
#define CROWDBOOTSTRAP_NOTIFICATIONS_COUNT         [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/notificationsCount"]
#define CROWDBOOTSTRAP_NOTIFICATIONS_UPDATE_COUNT          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/updateNotificationsCount"]
#define CROWDBOOTSTRAP_NOTIFICATIONS_LIST          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/UserNotifications"]
#define CROWDBOOTSTRAP_REJECT_COMMITED_USER        [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteCommitedUser"]
#define CROWDBOOTSTRAP_RESET_PASSWORD_MAIL         [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/sendMailForResetPassword"]
#define CROWDBOOTSTRAP_MAX_LIMIT_RESET_PASSWPRD    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/maxLimitResetPass"]
#define CROWDBOOTSTRAP_STARTUPLIST_NOTES           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/startupListForUser"]
#define CROWDBOOTSTRAP_STARTUP_KEYWORDS            [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/startupKeywords"]
#define CROWDBOOTSTRAP_STARTUP_APP_QUESTIONS       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/submitApplicationQuestions"]

#define CROWDBOOTSTRAP_CAMPAIGN_KEYWORDS           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/campaignKeywords"]

#define CROWDBOOTSTRAP_FORUM_KEYWORDS              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/forumKeywords"]
#define CROWDBOOTSTRAP_SEARCH_CAMPAIGN             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/searchCampaigns"]
#define CROWDBOOTSTRAP_WORKORDER_CONT_SAVED        [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/startupSavedWorkorders"]
#define CROWDBOOTSTRAP_WORKORDER_CONT_SUBMIT       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/saveSubmitWorkorder"]
#define CROWDBOOTSTRAP_LEAN_STARTUP_ROADMAP       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/dynamicRoadmaps"]

@interface ApiCrowdBootstrap : NSObject

+(void)loginWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)logoutWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)sendResetPasswordMailWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)sendMaxLimitResetPasswordWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getUserSecurityQuestionsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getCountries:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getSQKCCPE:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getKeywords:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getCampaignKeywords:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getForumKeywords:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getStartupKeywords:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getTimePeriods:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getMemberRoles:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getDeliverables:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getCitiesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getSecurityuestions:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)registerUserWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getJobIndustryLists:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Profile Api Methods
+(void)getProfileWithType:(int)profileType forUserType:(int)userType withParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)updateProfileWithType:(int)profileType forUserType:(int)userType withParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getUserStartupsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getProfielUserStartupsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)updateProfileSettingsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)addStartupsToProfileWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)addStartupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)followUnfollowUserWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)searchCampaignsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

#pragma mark - Campaigns Api Methods
+(void)getCampaignsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)commitCampaignWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)addCampaignwithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress ;

+(void)editCampaignwithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress ;

+(void)getCampaignDetailwithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)followUnfollowCampaignWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)uncommitCampaignWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getCommittedContractorsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)rejectCommittedUserWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Startups API methods
+(void)getStartupsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getStartupOverviewWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getStartupTeamWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)updateStartupTeamMemberStatusWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)startupTeamMessageWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getStartupWorkOrderEntrepreneurWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getStartupWorkOrderDetailEntrepreneurWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)updateStartupWorkOrderStatusAcceptedWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)updateStartupWorkOrderStatusRejectedWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getStartupWorkOrderContractorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getSavedStartupWorkOrderContractorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)saveSubmitWorkOrderContractorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)updateStartupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)updateStartupWorkOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getStartupDocsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getRecommendedContractorsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)downloadStartupDocsFilesWithPath:(NSString*)filePath success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)searchContractorsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)addContractorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getUserRatingsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)addRatingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)submitWorkorderRatingsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)deleteStartupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)deleteCampaignWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getStartupRoadmapDocsStatusWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)submitStartupQuestionaireWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getMessagesListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getArchivedMessagesListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)archiveDeleteMessageWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getStartupApplicationQuesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

#pragma mark - Job Api Methods
+(void)searchJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getExperienceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)editExperiencesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addExperienceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)followJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)applyJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getJobRoles:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Recruiter Api Methods
+(void)getMyJobListsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchivedJobListsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedJobListsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)editJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addJobWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getJobTypeList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getHiredCompaniesList:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Forums Api Methods
+(void)getForumStartupsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getMyForumsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getSearchForumsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getStartupForumsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)archiveDeleteForumWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)addForumWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getArchivedForumsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getForumDetailWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getForumCommentsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)addForumCommentWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)reportAbuseWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getReportAbuseUsersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getContactsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getNotesStartupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

#pragma mark - Notification Api Methods
+(void)getNotificationsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)getNotificationCountWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)updateNotificationCountWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

#pragma mark - Lean Startup RoadMap Api Methods
+(void)getLeanStartupRoadmap:(SuccessBlock)success failure:(FailureBlock)failure ;

#pragma mark - Connection Api Methods
+(void)connectUserWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure ;

+(void)disconnectUserWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)acceptConnectionWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getMyConnectionsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)searchConnectionWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getMyMessagesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Suggest Keywords Api Methods
+(void)getSuggestKeywordListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)addSuggestKeywordsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)deleteSuggestKeywordsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getKeywordTypeListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Company Api Methods
+(void)searchCompaniesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)viewCompanyWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)getCompanyKeywordList:(SuccessBlock)success failure:(FailureBlock)failure;

@end
