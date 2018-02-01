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
#define CROWDBOOTSTRAP_SAVE_DEVICE_TOKEN           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/saveDeviceToken"]
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

//News/Blog Posts List
#define CROWDBOOTSTRAP_NEWS_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/api/getBlogPosts"]

//Feeds List
#define CROWDBOOTSTRAP_FEEDS_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userFeedList"]
#define CROWDBOOTSTRAP_ADD_FEED                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addFeed"]

// Register Roles
#define CROWDBOOTSTRAP_SETTINGS_REGISTER                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/registerForRole"]
#define CROWDBOOTSTRAP_SETTINGS_UNREGISTER                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unRegisterForRole"]
#define CROWDBOOTSTRAP_REGISTER_ROLE_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/registerRoleList"]
#define CROWDBOOTSTRAP_SETTINGS_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/settingList"]

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

// Funds
#define CROWDBOOTSTRAP_FIND_FUNDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findFunds"]
#define CROWDBOOTSTRAP_MYFUNDS_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myFunds"]
#define CROWDBOOTSTRAP_ARCHIVE_FUNDS_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveFundList"]
#define CROWDBOOTSTRAP_DEACTIVATED_FUNDS_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateFundList"]
#define CROWDBOOTSTRAP_ARCHIVE_FUND                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveFund"]
#define CROWDBOOTSTRAP_DELETE_FUND                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteFund"]
#define CROWDBOOTSTRAP_DEACTIVATE_FUND                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateFund"]
#define CROWDBOOTSTRAP_ACTIVATE_FUND                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateFund"]
#define CROWDBOOTSTRAP_FUND_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/fundsKeywordList"]
#define CROWDBOOTSTRAP_FUND_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/fundIndustryLists"]
#define CROWDBOOTSTRAP_FUND_SPONSOR_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/sponsorsList"]
#define CROWDBOOTSTRAP_FUND_MANAGER_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/fundsManagerLists"]
#define CROWDBOOTSTRAP_FUND_PORTFOLIO_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/fundPortfolioList"]
#define CROWDBOOTSTRAP_EDIT_FUND_PORTFOLIO_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/fundEditPortfolioList"]
#define CROWDBOOTSTRAP_FUND_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/fundDetails"]
#define CROWDBOOTSTRAP_ADD_FUND                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addFunds"]
#define CROWDBOOTSTRAP_EDIT_FUND                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editFunds"]
#define CROWDBOOTSTRAP_FOLLOW_FUND                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followFund"]
#define CROWDBOOTSTRAP_UNFOLLOW_FUND                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowFund"]
#define CROWDBOOTSTRAP_LIKE_FUND                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeFund"]
#define CROWDBOOTSTRAP_UNLIKE_FUND                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeFund"]
#define CROWDBOOTSTRAP_LIKE_FUND_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/fundLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_FUND_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/fundDislikeList"]

// Beta Testing
#define CROWDBOOTSTRAP_FIND_BETA_TEST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findBetaTests"]
#define CROWDBOOTSTRAP_MYBETA_TEST_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myBetaTest"]
#define CROWDBOOTSTRAP_ARCHIVE_BETA_TEST_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveBetaTestList"]
#define CROWDBOOTSTRAP_DEACTIVATED_BETA_TEST_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateBetaTestList"]
#define CROWDBOOTSTRAP_ARCHIVE_BETA_TEST                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveBetaTest"]
#define CROWDBOOTSTRAP_DELETE_BETA_TEST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteBetaTest"]
#define CROWDBOOTSTRAP_DEACTIVATE_BETA_TEST                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateBetaTest"]
#define CROWDBOOTSTRAP_ACTIVATE_BETA_TEST                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateBetaTest"]
#define CROWDBOOTSTRAP_BETA_TEST_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/betaTestKeywordsList"]
#define CROWDBOOTSTRAP_BETA_TEST_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/betaInterestKeywordLists"]
#define CROWDBOOTSTRAP_BETA_TEST_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/betaTestTargetMarketsList"]
#define CROWDBOOTSTRAP_BETA_TEST_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/betaTestDetails"]
#define CROWDBOOTSTRAP_ADD_BETA_TEST                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addBetaTest"]
#define CROWDBOOTSTRAP_EDIT_BETA_TEST                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editBetaTest"]
#define CROWDBOOTSTRAP_FOLLOW_BETA_TEST                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followBetaTest"]
#define CROWDBOOTSTRAP_UNFOLLOW_BETA_TEST                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowBetaTest"]
#define CROWDBOOTSTRAP_LIKE_BETA_TEST                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeBetaTest"]
#define CROWDBOOTSTRAP_UNLIKE_BETA_TEST                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeBetaTest"]
#define CROWDBOOTSTRAP_LIKE_BETA_TEST_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/betaTestLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_BETA_TEST_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/betaTestDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_BETA_TEST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/betaCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_BETA_TEST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/betaUncommitment"]
#define CROWDBOOTSTRAP_BETA_TEST_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/betaTestCommitmentList"]

// Board Member
#define CROWDBOOTSTRAP_FIND_BOARD_MEMBER                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findBoardMembers"]
#define CROWDBOOTSTRAP_MYBOARD_MEMBER_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myBoardMember"]
#define CROWDBOOTSTRAP_ARCHIVE_BOARD_MEMBER_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveBoardMemberList"]
#define CROWDBOOTSTRAP_DEACTIVATED_BOARD_MEMBER_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateBoardMemberList"]
#define CROWDBOOTSTRAP_ARCHIVE_BOARD_MEMBER                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveBoardMember"]
#define CROWDBOOTSTRAP_DELETE_BOARD_MEMBER                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteBoardMember"]
#define CROWDBOOTSTRAP_DEACTIVATE_BOARD_MEMBER                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateBoardMember"]
#define CROWDBOOTSTRAP_ACTIVATE_BOARD_MEMBER                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateBoardMember"]
#define CROWDBOOTSTRAP_BOARD_MEMBER_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/boardOppertunityKeywordsList"]
#define CROWDBOOTSTRAP_BOARD_MEMBER_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/boardInterestKeywordLists"]
#define CROWDBOOTSTRAP_BOARD_MEMBER_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/boardMemberTargetMarketsList"]
#define CROWDBOOTSTRAP_BOARD_MEMBER_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/boardMemberDetails"]
#define CROWDBOOTSTRAP_ADD_BOARD_MEMBER                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addBoardMember"]
#define CROWDBOOTSTRAP_EDIT_BOARD_MEMBER                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editBoardMember"]
#define CROWDBOOTSTRAP_FOLLOW_BOARD_MEMBER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followBoardMember"]
#define CROWDBOOTSTRAP_UNFOLLOW_BOARD_MEMBER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowBoardMember"]
#define CROWDBOOTSTRAP_LIKE_BOARD_MEMBER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeBoardMember"]
#define CROWDBOOTSTRAP_UNLIKE_BOARD_MEMBER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeBoardMember"]
#define CROWDBOOTSTRAP_LIKE_BOARD_MEMBER_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/boardMemberLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_BOARD_MEMBER_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/boardMemberDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_BOARD_MEMBER                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/boardCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_BOARD_MEMBER                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/boardUncommitment"]
#define CROWDBOOTSTRAP_BOARD_MEMBER_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/boardCommitmentList"]

// Communal Asset
#define CROWDBOOTSTRAP_FIND_COMMUNAL_ASSET                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findCommunalasset"]
#define CROWDBOOTSTRAP_MYCOMMUNAL_ASSET_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myCommunalasset"]
#define CROWDBOOTSTRAP_ARCHIVE_COMMUNAL_ASSET_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveCommunalassetList"]
#define CROWDBOOTSTRAP_DEACTIVATED_COMMUNAL_ASSET_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateCommunalassetList"]
#define CROWDBOOTSTRAP_ARCHIVE_COMMUNAL_ASSET                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveCommunalasset"]
#define CROWDBOOTSTRAP_DELETE_COMMUNAL_ASSET                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteCommunalasset"]
#define CROWDBOOTSTRAP_DEACTIVATE_COMMUNAL_ASSET                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateCommunalasset"]
#define CROWDBOOTSTRAP_ACTIVATE_COMMUNAL_ASSET                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateCommunalasset"]
#define CROWDBOOTSTRAP_COMMUNAL_ASSET_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/communalassetKeywordsList"]
#define CROWDBOOTSTRAP_COMMUNAL_ASSET_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/communalassetInterestKeywordLists"]
#define CROWDBOOTSTRAP_COMMUNAL_ASSET_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/communalassetTargetMarketsList"]
#define CROWDBOOTSTRAP_COMMUNAL_ASSET_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/communalassetDetails"]
#define CROWDBOOTSTRAP_ADD_COMMUNAL_ASSET                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addCommunalasset"]
#define CROWDBOOTSTRAP_EDIT_COMMUNAL_ASSET                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editCommunalasset"]
#define CROWDBOOTSTRAP_FOLLOW_COMMUNAL_ASSET                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followCommunalasset"]
#define CROWDBOOTSTRAP_UNFOLLOW_COMMUNAL_ASSET                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowCommunalasset"]
#define CROWDBOOTSTRAP_LIKE_COMMUNAL_ASSET                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeCommunalasset"]
#define CROWDBOOTSTRAP_UNLIKE_COMMUNAL_ASSET                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeCommunalasset"]
#define CROWDBOOTSTRAP_LIKE_COMMUNAL_ASSET_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/communalassetLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_COMMUNAL_ASSET_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/communalassetDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_COMMUNAL_ASSET                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/communalassetCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_COMMUNAL_ASSET                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/communalassetUncommitment"]
#define CROWDBOOTSTRAP_COMMUNAL_ASSET_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/communalassetCommitmentList"]

// Consulting Project
#define CROWDBOOTSTRAP_FIND_CONSULTING                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findConsulting"]
#define CROWDBOOTSTRAP_MYCONSULTING_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myConsulting"]
#define CROWDBOOTSTRAP_ARCHIVE_CONSULTING_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveConsultingList"]
#define CROWDBOOTSTRAP_CLOSED_CONSULTING_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/closeConsultingList"]
#define CROWDBOOTSTRAP_INVITATION_CONSULTING_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/consultingInvitationList"]
#define CROWDBOOTSTRAP_ARCHIVE_CONSULTING                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveConsulting"]
#define CROWDBOOTSTRAP_DELETE_CONSULTING                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteConsulting"]
#define CROWDBOOTSTRAP_CLOSE_CONSULTING                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/closeConsulting"]
#define CROWDBOOTSTRAP_OPEN_CONSULTING                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/openConsulting"]
#define CROWDBOOTSTRAP_CONSULTING_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/consultingInterestKeywordsList"]
#define CROWDBOOTSTRAP_CONSULTING_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/consultingTargetKeywordLists"]
#define CROWDBOOTSTRAP_CONSULTING_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/consultingDetails"]
#define CROWDBOOTSTRAP_ADD_CONSULTING                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addConsulting"]
#define CROWDBOOTSTRAP_EDIT_CONSULTING                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editConsulting"]
#define CROWDBOOTSTRAP_FOLLOW_CONSULTING                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followConsulting"]
#define CROWDBOOTSTRAP_UNFOLLOW_CONSULTING                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowConsulting"]
#define CROWDBOOTSTRAP_LIKE_CONSULTING                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeConsulting"]
#define CROWDBOOTSTRAP_UNLIKE_CONSULTING                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeConsulting"]
#define CROWDBOOTSTRAP_LIKE_CONSULTING_LIST                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/consultingLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_CONSULTING_LIST                          [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/consultingDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_CONSULTING                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/consultingCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_CONSULTING                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/consultingUncommitment"]
#define CROWDBOOTSTRAP_CONSULTING_COMMITMENT_LIST                       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/consultingCommitmentList"]
#define CROWDBOOTSTRAP_CONSULTING_SEARCH_CONT                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/invitationContractorList"]
#define CROWDBOOTSTRAP_CONSULTING_SEND_INVITATION                       [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/sendConsultingInvitation"]
#define CROWDBOOTSTRAP_ACCEPT_INVITATION                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/acceptConsultingInvitation"]
#define CROWDBOOTSTRAP_REJECT_INVITATION                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/rejectConsultingInvitation"]

// Early Adopter
#define CROWDBOOTSTRAP_FIND_EARLY_ADOPTER                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findEarlyAdopters"]
#define CROWDBOOTSTRAP_MYEARLY_ADOPTER_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myEarlyAdopter"]
#define CROWDBOOTSTRAP_ARCHIVE_EARLY_ADOPTER_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveEarlyAdopterList"]
#define CROWDBOOTSTRAP_DEACTIVATED_EARLY_ADOPTER_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateEarlyAdopterList"]
#define CROWDBOOTSTRAP_ARCHIVE_EARLY_ADOPTER                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveEarlyAdopter"]
#define CROWDBOOTSTRAP_DELETE_EARLY_ADOPTER                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteEarlyAdopter"]
#define CROWDBOOTSTRAP_DEACTIVATE_EARLY_ADOPTER                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateEarlyAdopter"]
#define CROWDBOOTSTRAP_ACTIVATE_EARLY_ADOPTER                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateEarlyAdopter"]
#define CROWDBOOTSTRAP_EARLY_ADOPTER_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/earlyAdopterKeywordsKeywordsList"]
#define CROWDBOOTSTRAP_EARLY_ADOPTER_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/earlyAdopterInterestKeywordLists"]
#define CROWDBOOTSTRAP_EARLY_ADOPTER_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/earlyAdopterTargetMarketsList"]
#define CROWDBOOTSTRAP_EARLY_ADOPTER_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/earlyAdopterDetails"]
#define CROWDBOOTSTRAP_ADD_EARLY_ADOPTER                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addEarlyAdopter"]
#define CROWDBOOTSTRAP_EDIT_EARLY_ADOPTER                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editEarlyAdopter"]
#define CROWDBOOTSTRAP_FOLLOW_EARLY_ADOPTER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followEarlyAdopter"]
#define CROWDBOOTSTRAP_UNFOLLOW_EARLY_ADOPTER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowEarlyAdopter"]
#define CROWDBOOTSTRAP_LIKE_EARLY_ADOPTER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeEarlyAdopter"]
#define CROWDBOOTSTRAP_UNLIKE_EARLY_ADOPTER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeEarlyAdopter"]
#define CROWDBOOTSTRAP_LIKE_EARLY_ADOPTER_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/earlyAdopterLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_EARLY_ADOPTER_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/earlyAdopterDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_EARLY_ADOPTER                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/earlyCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_EARLY_ADOPTER                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/earlyUncommitment"]
#define CROWDBOOTSTRAP_EARLY_ADOPTER_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/earlyCommitmentList"]

// Endorsors
#define CROWDBOOTSTRAP_FIND_ENDORSOR                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findEndorsors"]
#define CROWDBOOTSTRAP_MYENDORSOR_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myEndorsor"]
#define CROWDBOOTSTRAP_ARCHIVE_ENDORSOR_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveEndorsorList"]
#define CROWDBOOTSTRAP_DEACTIVATED_ENDORSOR_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateEndorsorList"]
#define CROWDBOOTSTRAP_ARCHIVE_ENDORSOR                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveEndorsor"]
#define CROWDBOOTSTRAP_DELETE_ENDORSOR                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteEndorsor"]
#define CROWDBOOTSTRAP_DEACTIVATE_ENDORSOR                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateEndorsor"]
#define CROWDBOOTSTRAP_ACTIVATE_ENDORSOR                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateEndorsor"]
#define CROWDBOOTSTRAP_ENDORSOR_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/endorsorKeywordsList"]
#define CROWDBOOTSTRAP_ENDORSOR_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/endorsorInterestKeywordLists"]
#define CROWDBOOTSTRAP_ENDORSOR_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/endorsorTargetMarketsList"]
#define CROWDBOOTSTRAP_ENDORSOR_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/endorsorDetails"]
#define CROWDBOOTSTRAP_ADD_ENDORSOR                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addEndorsor"]
#define CROWDBOOTSTRAP_EDIT_ENDORSOR                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editEndorsor"]
#define CROWDBOOTSTRAP_FOLLOW_ENDORSOR                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followEndorsor"]
#define CROWDBOOTSTRAP_UNFOLLOW_ENDORSOR                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowEndorsor"]
#define CROWDBOOTSTRAP_LIKE_ENDORSOR                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeEndorsor"]
#define CROWDBOOTSTRAP_UNLIKE_ENDORSOR                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeendorsor"]
#define CROWDBOOTSTRAP_LIKE_ENDORSOR_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/endorsorLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_ENDORSOR_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/endorsorDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_ENDORSOR                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/endorsorCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_ENDORSOR                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/endorsorUncommitment"]
#define CROWDBOOTSTRAP_ENDORSOR_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/endorsorCommitmentList"]

// Focus Groups
#define CROWDBOOTSTRAP_FIND_FOCUS_GROUP                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findFocusGroups"]
#define CROWDBOOTSTRAP_MYFOCUS_GROUP_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myFocusGroup"]
#define CROWDBOOTSTRAP_ARCHIVE_FOCUS_GROUP_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveFocusGroupList"]
#define CROWDBOOTSTRAP_DEACTIVATED_FOCUS_GROUP_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateFocusGroupList"]
#define CROWDBOOTSTRAP_ARCHIVE_FOCUS_GROUP                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveFocusGroup"]
#define CROWDBOOTSTRAP_DELETE_FOCUS_GROUP                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteFocusGroup"]
#define CROWDBOOTSTRAP_DEACTIVATE_FOCUS_GROUP                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateFocusGroup"]
#define CROWDBOOTSTRAP_ACTIVATE_FOCUS_GROUP                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateFocusGroup"]
#define CROWDBOOTSTRAP_FOCUS_GROUP_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/focusGroupKeywordsList"]
#define CROWDBOOTSTRAP_FOCUS_GROUP_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/focusGroupInterestKeywordLists"]
#define CROWDBOOTSTRAP_FOCUS_GROUP_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/focusGroupTargetMarketsList"]
#define CROWDBOOTSTRAP_FOCUS_GROUP_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/focusGroupDetails"]
#define CROWDBOOTSTRAP_ADD_FOCUS_GROUP                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addFocusGroup"]
#define CROWDBOOTSTRAP_EDIT_FOCUS_GROUP                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editFocusGroup"]
#define CROWDBOOTSTRAP_FOLLOW_FOCUS_GROUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followFocusGroup"]
#define CROWDBOOTSTRAP_UNFOLLOW_FOCUS_GROUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowFocusGroup"]
#define CROWDBOOTSTRAP_LIKE_FOCUS_GROUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeFocusGroup"]
#define CROWDBOOTSTRAP_UNLIKE_FOCUS_GROUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeFocusGroup"]
#define CROWDBOOTSTRAP_LIKE_FOCUS_GROUP_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/focusGroupLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_FOCUS_GROUP_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/focusGroupDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_FOCUS_GROUP                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/focusCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_FOCUS_GROUP                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/focusUncommitment"]
#define CROWDBOOTSTRAP_FOCUS_GROUP_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/focusCommitmentList"]

// Hardware
#define CROWDBOOTSTRAP_FIND_HARDWARE                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findHardware"]
#define CROWDBOOTSTRAP_MYHARDWARE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myHardware"]
#define CROWDBOOTSTRAP_ARCHIVE_HARDWARE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveHardwareList"]
#define CROWDBOOTSTRAP_DEACTIVATED_HARDWARE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateHardwareList"]
#define CROWDBOOTSTRAP_ARCHIVE_HARDWARE                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveHardware"]
#define CROWDBOOTSTRAP_DELETE_HARDWARE                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteHardware"]
#define CROWDBOOTSTRAP_DEACTIVATE_HARDWARE                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateHardware"]
#define CROWDBOOTSTRAP_ACTIVATE_HARDWARE                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateHardware"]
#define CROWDBOOTSTRAP_HARDWARE_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/hardwareKeywordsList"]
#define CROWDBOOTSTRAP_HARDWARE_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/hardwareInterestKeywordLists"]
#define CROWDBOOTSTRAP_HARDWARE_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/hardwareTargetMarketsList"]
#define CROWDBOOTSTRAP_HARDWARE_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/hardwareDetails"]
#define CROWDBOOTSTRAP_ADD_HARDWARE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addHardware"]
#define CROWDBOOTSTRAP_EDIT_HARDWARE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editHardware"]
#define CROWDBOOTSTRAP_FOLLOW_HARDWARE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followHardware"]
#define CROWDBOOTSTRAP_UNFOLLOW_HARDWARE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowHardware"]
#define CROWDBOOTSTRAP_LIKE_HARDWARE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeHardware"]
#define CROWDBOOTSTRAP_UNLIKE_HARDWARE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeHardware"]
#define CROWDBOOTSTRAP_LIKE_HARDWARE_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/hardwareLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_HARDWARE_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/hardwareDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_HARDWARE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/hardwareCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_HARDWARE                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/hardwareUncommitment"]
#define CROWDBOOTSTRAP_HARDWARE_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/hardwareCommitmentList"]

// Softwares
#define CROWDBOOTSTRAP_FIND_SOFTWARE                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findSoftware"]
#define CROWDBOOTSTRAP_MYSOFTWARE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/mySoftware"]
#define CROWDBOOTSTRAP_ARCHIVE_SOFTWARE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveSoftwareList"]
#define CROWDBOOTSTRAP_DEACTIVATED_SOFTWARE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateSoftwareList"]
#define CROWDBOOTSTRAP_ARCHIVE_SOFTWARE                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveSoftware"]
#define CROWDBOOTSTRAP_DELETE_SOFTWARE                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteSoftware"]
#define CROWDBOOTSTRAP_DEACTIVATE_SOFTWARE                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateSoftware"]
#define CROWDBOOTSTRAP_ACTIVATE_SOFTWARE                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateSoftware"]
#define CROWDBOOTSTRAP_SOFTWARE_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/softwareKeywordsList"]
#define CROWDBOOTSTRAP_SOFTWARE_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/softwareInterestKeywordLists"]
#define CROWDBOOTSTRAP_SOFTWARE_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/softwareTargetMarketsList"]
#define CROWDBOOTSTRAP_SOFTWARE_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/softwareDetails"]
#define CROWDBOOTSTRAP_ADD_SOFTWARE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addSoftware"]
#define CROWDBOOTSTRAP_EDIT_SOFTWARE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editSoftware"]
#define CROWDBOOTSTRAP_FOLLOW_SOFTWARE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followSoftware"]
#define CROWDBOOTSTRAP_UNFOLLOW_SOFTWARE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowSoftware"]
#define CROWDBOOTSTRAP_LIKE_SOFTWARE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeSoftware"]
#define CROWDBOOTSTRAP_UNLIKE_SOFTWARE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeSoftware"]
#define CROWDBOOTSTRAP_LIKE_SOFTWARE_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/softwareLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_SOFTWARE_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/softwareDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_SOFTWARE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/softwareCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_SOFTWARE                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/softwareUncommitment"]
#define CROWDBOOTSTRAP_SOFTWARE_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/softwareCommitmentList"]

// Service
#define CROWDBOOTSTRAP_FIND_SERVICE                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findService"]
#define CROWDBOOTSTRAP_MYSERVICE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myService"]
#define CROWDBOOTSTRAP_ARCHIVE_SERVICE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveServiceList"]
#define CROWDBOOTSTRAP_DEACTIVATED_SERVICE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateServiceList"]
#define CROWDBOOTSTRAP_ARCHIVE_SERVICE                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveService"]
#define CROWDBOOTSTRAP_DELETE_SERVICE                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteService"]
#define CROWDBOOTSTRAP_DEACTIVATE_SERVICE                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateService"]
#define CROWDBOOTSTRAP_ACTIVATE_SERVICE                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateService"]
#define CROWDBOOTSTRAP_SERVICE_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/serviceKeywordsList"]
#define CROWDBOOTSTRAP_SERVICE_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/serviceInterestKeywordLists"]
#define CROWDBOOTSTRAP_SERVICE_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/serviceTargetMarketsList"]
#define CROWDBOOTSTRAP_SERVICE_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/serviceDetails"]
#define CROWDBOOTSTRAP_ADD_SERVICE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addService"]
#define CROWDBOOTSTRAP_EDIT_SERVICE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editService"]
#define CROWDBOOTSTRAP_FOLLOW_SERVICE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followService"]
#define CROWDBOOTSTRAP_UNFOLLOW_SERVICE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowService"]
#define CROWDBOOTSTRAP_LIKE_SERVICE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeService"]
#define CROWDBOOTSTRAP_UNLIKE_SERVICE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeService"]
#define CROWDBOOTSTRAP_LIKE_SERVICE_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/serviceLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_SERVICE_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/serviceDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_SERVICE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/serviceCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_SERVICE                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/serviceUncommitment"]
#define CROWDBOOTSTRAP_SERVICE_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/serviceCommitmentList"]

// Audio/Video
#define CROWDBOOTSTRAP_FIND_AUDIOVIDEO                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findAudioVideo"]
#define CROWDBOOTSTRAP_MYAUDIOVIDEO_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myAudioVideo"]
#define CROWDBOOTSTRAP_ARCHIVE_AUDIOVIDEO_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveAudioList"]
#define CROWDBOOTSTRAP_DEACTIVATED_AUDIOVIDEO_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateAudioList"]
#define CROWDBOOTSTRAP_ARCHIVE_AUDIOVIDEO                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveAudio"]
#define CROWDBOOTSTRAP_DELETE_AUDIOVIDEO                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteAudio"]
#define CROWDBOOTSTRAP_DEACTIVATE_AUDIOVIDEO                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateAudio"]
#define CROWDBOOTSTRAP_ACTIVATE_AUDIOVIDEO                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateAudio"]
#define CROWDBOOTSTRAP_AUDIOVIDEO_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/audiorKeywordsList"]
#define CROWDBOOTSTRAP_AUDIOVIDEO_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/audioInterestKeywordLists"]
#define CROWDBOOTSTRAP_AUDIOVIDEO_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/audioTargetMarketsList"]
#define CROWDBOOTSTRAP_AUDIOVIDEO_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/audioDetails"]
#define CROWDBOOTSTRAP_ADD_AUDIOVIDEO                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addAudioVideo"]
#define CROWDBOOTSTRAP_EDIT_AUDIOVIDEO                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editAudioVideo"]
#define CROWDBOOTSTRAP_FOLLOW_AUDIOVIDEO                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followAudio"]
#define CROWDBOOTSTRAP_UNFOLLOW_AUDIOVIDEO                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowAudio"]
#define CROWDBOOTSTRAP_LIKE_AUDIOVIDEO                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeAudio"]
#define CROWDBOOTSTRAP_UNLIKE_AUDIOVIDEO                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeAudio"]
#define CROWDBOOTSTRAP_LIKE_AUDIOVIDEO_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/audioLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_AUDIOVIDEO_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/audioDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_AUDIOVIDEO                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/audioCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_AUDIOVIDEO                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/audioUncommitment"]
#define CROWDBOOTSTRAP_AUDIOVIDEO_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/audioCommitmentList"]

// Information
#define CROWDBOOTSTRAP_FIND_INFORMATION                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findInformation"]
#define CROWDBOOTSTRAP_MYINFORMATION_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myInformation"]
#define CROWDBOOTSTRAP_ARCHIVE_INFORMATION_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveInformationList"]
#define CROWDBOOTSTRAP_DEACTIVATED_INFORMATION_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateInformationList"]
#define CROWDBOOTSTRAP_ARCHIVE_INFORMATION                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveInformation"]
#define CROWDBOOTSTRAP_DELETE_INFORMATION                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteInformation"]
#define CROWDBOOTSTRAP_DEACTIVATE_INFORMATION                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateInformation"]
#define CROWDBOOTSTRAP_ACTIVATE_INFORMATION                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateInformation"]
#define CROWDBOOTSTRAP_INFORMATION_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/informationKeywordsList"]
#define CROWDBOOTSTRAP_INFORMATION_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/informationInterestKeywordLists"]
#define CROWDBOOTSTRAP_INFORMATION_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/informationTargetMarketsList"]
#define CROWDBOOTSTRAP_INFORMATION_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/informationDetails"]
#define CROWDBOOTSTRAP_ADD_INFORMATION                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addInformation"]
#define CROWDBOOTSTRAP_EDIT_INFORMATION                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editInformation"]
#define CROWDBOOTSTRAP_FOLLOW_INFORMATION                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followInformation"]
#define CROWDBOOTSTRAP_UNFOLLOW_INFORMATION                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowInformation"]
#define CROWDBOOTSTRAP_LIKE_INFORMATION                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeInformation"]
#define CROWDBOOTSTRAP_UNLIKE_INFORMATION                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeInformation"]
#define CROWDBOOTSTRAP_LIKE_INFORMATION_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/informationLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_INFORMATION_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/informationDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_INFORMATION                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/informationCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_INFORMATION                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/informationUncommitment"]
#define CROWDBOOTSTRAP_INFORMATION_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/informationCommitmentList"]

// Productivity
#define CROWDBOOTSTRAP_FIND_PRODUCTIVITY                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findProductivity"]
#define CROWDBOOTSTRAP_MYPRODUCTIVITY_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myProductivity"]
#define CROWDBOOTSTRAP_ARCHIVE_PRODUCTIVITY_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveProductivityList"]
#define CROWDBOOTSTRAP_DEACTIVATED_PRODUCTIVITY_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateProductivityList"]
#define CROWDBOOTSTRAP_ARCHIVE_PRODUCTIVITY                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveProductivity"]
#define CROWDBOOTSTRAP_DELETE_PRODUCTIVITY                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteProductivity"]
#define CROWDBOOTSTRAP_DEACTIVATE_PRODUCTIVITY                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateProductivity"]
#define CROWDBOOTSTRAP_ACTIVATE_PRODUCTIVITY                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateProductivity"]
#define CROWDBOOTSTRAP_PRODUCTIVITY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/productivityKeywordsList"]
#define CROWDBOOTSTRAP_PRODUCTIVITY_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/productivityInterestKeywordLists"]
#define CROWDBOOTSTRAP_PRODUCTIVITY_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/productivityTargetMarketsList"]
#define CROWDBOOTSTRAP_PRODUCTIVITY_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/productivityDetails"]
#define CROWDBOOTSTRAP_ADD_PRODUCTIVITY                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addProductivity"]
#define CROWDBOOTSTRAP_EDIT_PRODUCTIVITY                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editProductivity"]
#define CROWDBOOTSTRAP_FOLLOW_PRODUCTIVITY                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followProductivity"]
#define CROWDBOOTSTRAP_UNFOLLOW_PRODUCTIVITY                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowProductivity"]
#define CROWDBOOTSTRAP_LIKE_PRODUCTIVITY                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeProductivity"]
#define CROWDBOOTSTRAP_UNLIKE_PRODUCTIVITY                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeProductivity"]
#define CROWDBOOTSTRAP_LIKE_PRODUCTIVITY_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/productivityLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_PRODUCTIVITY_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/productivityDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_PRODUCTIVITY                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/productivityCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_PRODUCTIVITY                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/productivityUncommitment"]
#define CROWDBOOTSTRAP_PRODUCTIVITY_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/productivityCommitmentList"]

// Jobs
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
#define CROWDBOOTSTRAP_RESEND_CONFIRMATION_MAIL    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/resendEmail"]
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


// Group
#define CROWDBOOTSTRAP_FIND_GROUP                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findGroup"]
#define CROWDBOOTSTRAP_MYGROUP_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myGroup"]
#define CROWDBOOTSTRAP_ARCHIVE_GROUP_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveGroupList"]
#define CROWDBOOTSTRAP_DEACTIVATED_GROUP_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateGroupList"]
#define CROWDBOOTSTRAP_ARCHIVE_GROUP                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveGroup"]
#define CROWDBOOTSTRAP_DELETE_GROUP                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteGroup"]
#define CROWDBOOTSTRAP_DEACTIVATE_GROUP                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateGroup"]
#define CROWDBOOTSTRAP_ACTIVATE_GROUP                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateGroup"]
#define CROWDBOOTSTRAP_GROUP_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupKeywordsList"]
#define CROWDBOOTSTRAP_GROUP_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupInterestKeywordLists"]
#define CROWDBOOTSTRAP_GROUP_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupTargetMarketsList"]
#define CROWDBOOTSTRAP_GROUP_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupDetails"]
#define CROWDBOOTSTRAP_ADD_GROUP                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addGroup"]
#define CROWDBOOTSTRAP_EDIT_GROUP                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editGroup"]
#define CROWDBOOTSTRAP_FOLLOW_GROUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followGroup"]
#define CROWDBOOTSTRAP_UNFOLLOW_GROUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowGroup"]
#define CROWDBOOTSTRAP_LIKE_GROUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeGroup"]
#define CROWDBOOTSTRAP_UNLIKE_GROUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeGroup"]
#define CROWDBOOTSTRAP_LIKE_GROUP_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_GROUP_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_GROUP                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_GROUP                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupUncommitment"]
#define CROWDBOOTSTRAP_GROUP_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupCommitmentList"]

// Webinar
#define CROWDBOOTSTRAP_FIND_WEBINAR                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findWebinar"]
#define CROWDBOOTSTRAP_MYWEBINAR_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myWebinar"]
#define CROWDBOOTSTRAP_ARCHIVE_WEBINAR_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveWebinarList"]
#define CROWDBOOTSTRAP_DEACTIVATED_WEBINAR_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateWebinarList"]
#define CROWDBOOTSTRAP_ARCHIVE_WEBINAR                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveWebinar"]
#define CROWDBOOTSTRAP_DELETE_WEBINAR                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteWebinar"]
#define CROWDBOOTSTRAP_DEACTIVATE_WEBINAR                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateWebinar"]
#define CROWDBOOTSTRAP_ACTIVATE_WEBINAR                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateWebinar"]
#define CROWDBOOTSTRAP_WEBINAR_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/webinarKeywordsList"]
#define CROWDBOOTSTRAP_WEBINAR_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/webinarInterestKeywordLists"]
#define CROWDBOOTSTRAP_WEBINAR_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/webinarTargetMarketsList"]
#define CROWDBOOTSTRAP_WEBINAR_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/webinarDetails"]
#define CROWDBOOTSTRAP_ADD_WEBINAR                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addWebinar"]
#define CROWDBOOTSTRAP_EDIT_WEBINAR                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editWebinar"]
#define CROWDBOOTSTRAP_FOLLOW_WEBINAR                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followWebinar"]
#define CROWDBOOTSTRAP_UNFOLLOW_WEBINAR                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowWebinar"]
#define CROWDBOOTSTRAP_LIKE_WEBINAR                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeWebinar"]
#define CROWDBOOTSTRAP_UNLIKE_WEBINAR                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeWebinar"]
#define CROWDBOOTSTRAP_LIKE_WEBINAR_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/webinarLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_WEBINAR_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/webinarDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_WEBINAR                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/webinarCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_WEBINAR                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/webinarUncommitment"]
#define CROWDBOOTSTRAP_WEBINAR_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/webinarCommitmentList"]


// MeetUp
#define CROWDBOOTSTRAP_FIND_MEETUP                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findMeetup"]
#define CROWDBOOTSTRAP_MYMEETUP_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myMeetup"]
#define CROWDBOOTSTRAP_ARCHIVE_MEETUP_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveMeetupList"]
#define CROWDBOOTSTRAP_DEACTIVATED_MEETUP_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateMeetupList"]
#define CROWDBOOTSTRAP_ARCHIVE_MEETUP                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveMeetup"]
#define CROWDBOOTSTRAP_DELETE_MEETUP                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteMeetup"]
#define CROWDBOOTSTRAP_DEACTIVATE_MEETUP                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateMeetup"]
#define CROWDBOOTSTRAP_ACTIVATE_MEETUP                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateMeetup"]
#define CROWDBOOTSTRAP_MEETUP_FORUMS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userForums"]
#define CROWDBOOTSTRAP_MEETUP_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/meetupKeywordsList"]
#define CROWDBOOTSTRAP_MEETUP_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/meetupInterestKeywordLists"]
#define CROWDBOOTSTRAP_MEETUP_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/meetupTargetMarketsList"]
#define CROWDBOOTSTRAP_MEETUP_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/meetupDetails"]
#define CROWDBOOTSTRAP_ADD_MEETUP                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addMeetup"]
#define CROWDBOOTSTRAP_EDIT_MEETUP                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editMeetup"]
#define CROWDBOOTSTRAP_FOLLOW_MEETUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followMeetup"]
#define CROWDBOOTSTRAP_UNFOLLOW_MEETUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowMeetup"]
#define CROWDBOOTSTRAP_LIKE_MEETUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeMeetup"]
#define CROWDBOOTSTRAP_UNLIKE_MEETUP                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeMeetup"]
#define CROWDBOOTSTRAP_LIKE_MEETUP_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/meetupLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_MEETUP_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/meetupDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_MEETUP                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/meetupCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_MEETUP                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/meetupUncommitment"]
#define CROWDBOOTSTRAP_MEETUP_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/meetupCommitmentList"]


// DemoDay
#define CROWDBOOTSTRAP_FIND_DEMODAY                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findDemoday"]
#define CROWDBOOTSTRAP_MYDEMODAY_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myDemoday"]
#define CROWDBOOTSTRAP_ARCHIVE_DEMODAY_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveDemodayList"]
#define CROWDBOOTSTRAP_DEACTIVATED_DEMODAY_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateDemodayList"]
#define CROWDBOOTSTRAP_ARCHIVE_DEMODAY                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveDemoday"]
#define CROWDBOOTSTRAP_DELETE_DEMODAY                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteDemoday"]
#define CROWDBOOTSTRAP_DEACTIVATE_DEMODAY                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateDemoday"]
#define CROWDBOOTSTRAP_ACTIVATE_DEMODAY                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateDemoday"]
#define CROWDBOOTSTRAP_DEMODAY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/demodayKeywordsList"]
#define CROWDBOOTSTRAP_DEMODAY_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/demodayInterestKeywordLists"]
#define CROWDBOOTSTRAP_DEMODAY_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/demodayTargetMarketsList"]
#define CROWDBOOTSTRAP_DEMODAY_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/demodayDetails"]
#define CROWDBOOTSTRAP_ADD_DEMODAY                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addDemoday"]
#define CROWDBOOTSTRAP_EDIT_DEMODAY                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editDemoday"]
#define CROWDBOOTSTRAP_FOLLOW_DEMODAY                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followDemoday"]
#define CROWDBOOTSTRAP_UNFOLLOW_DEMODAY                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowDemoday"]
#define CROWDBOOTSTRAP_LIKE_DEMODAY                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeDemoday"]
#define CROWDBOOTSTRAP_UNLIKE_DEMODAY                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeDemoday"]
#define CROWDBOOTSTRAP_LIKE_DEMODAY_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/demodayLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_DEMODAY_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/demodayDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_DEMODAY                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/demodayCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_DEMODAY                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/demodayUncommitment"]
#define CROWDBOOTSTRAP_DEMODAY_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/demodayCommitmentList"]

// Conference
#define CROWDBOOTSTRAP_FIND_CONFERENCE                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findConference"]
#define CROWDBOOTSTRAP_MYCONFERENCE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myConference"]
#define CROWDBOOTSTRAP_ARCHIVE_CONFERENCE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveConferenceList"]
#define CROWDBOOTSTRAP_DEACTIVATED_CONFERENCE_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateConferenceList"]
#define CROWDBOOTSTRAP_ARCHIVE_CONFERENCE                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveConference"]
#define CROWDBOOTSTRAP_DELETE_CONFERENCE                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteConference"]
#define CROWDBOOTSTRAP_DEACTIVATE_CONFERENCE                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateConference"]
#define CROWDBOOTSTRAP_ACTIVATE_CONFERENCE                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateConference"]
#define CROWDBOOTSTRAP_CONFERENCE_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/conferenceKeywordsList"]
#define CROWDBOOTSTRAP_CONFERENCE_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/conferenceInterestKeywordLists"]
#define CROWDBOOTSTRAP_CONFERENCE_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/conferenceTargetMarketsList"]
#define CROWDBOOTSTRAP_CONFERENCE_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/conferenceDetails"]
#define CROWDBOOTSTRAP_ADD_CONFERENCE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addConference"]
#define CROWDBOOTSTRAP_EDIT_CONFERENCE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editConference"]
#define CROWDBOOTSTRAP_FOLLOW_CONFERENCE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followConference"]
#define CROWDBOOTSTRAP_UNFOLLOW_CONFERENCE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowConference"]
#define CROWDBOOTSTRAP_LIKE_CONFERENCE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeConference"]
#define CROWDBOOTSTRAP_UNLIKE_CONFERENCE                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeConference"]
#define CROWDBOOTSTRAP_LIKE_CONFERENCE_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/conferenceLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_CONFERENCE_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/conferenceDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_CONFERENCE                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/conferenceCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_CONFERENCE                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/conferenceUncommitment"]
#define CROWDBOOTSTRAP_CONFERENCE_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/conferenceCommitmentList"]


// Career Advancement
#define CROWDBOOTSTRAP_FIND_CAREER                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findCareer"]
#define CROWDBOOTSTRAP_MYCAREER_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myCareer"]
#define CROWDBOOTSTRAP_ARCHIVE_CAREER_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveCareerList"]
#define CROWDBOOTSTRAP_DEACTIVATED_CAREER_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateCareerList"]
#define CROWDBOOTSTRAP_ARCHIVE_CAREER                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveCareer"]
#define CROWDBOOTSTRAP_DELETE_CAREER                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteCareer"]
#define CROWDBOOTSTRAP_DEACTIVATE_CAREER                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateCareer"]
#define CROWDBOOTSTRAP_ACTIVATE_CAREER                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateCareer"]
#define CROWDBOOTSTRAP_CAREER_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/careerKeywordsList"]
#define CROWDBOOTSTRAP_CAREER_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/careerInterestKeywordLists"]
#define CROWDBOOTSTRAP_CAREER_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/careerTargetMarketsList"]
#define CROWDBOOTSTRAP_CAREER_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/careerDetails"]
#define CROWDBOOTSTRAP_ADD_CAREER                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addCareer"]
#define CROWDBOOTSTRAP_EDIT_CAREER                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editCareer"]
#define CROWDBOOTSTRAP_FOLLOW_CAREER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followCareer"]
#define CROWDBOOTSTRAP_UNFOLLOW_CAREER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowCareer"]
#define CROWDBOOTSTRAP_LIKE_CAREER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeCareer"]
#define CROWDBOOTSTRAP_UNLIKE_CAREER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeCareer"]
#define CROWDBOOTSTRAP_LIKE_CAREER_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/careerLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_CAREER_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/careerDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_CAREER                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/careerCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_CAREER                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/careerUncommitment"]
#define CROWDBOOTSTRAP_CAREER_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/careerCommitmentList"]

// Self Improvement
#define CROWDBOOTSTRAP_FIND_IMPROVEMENT                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findSelfimprovement"]
#define CROWDBOOTSTRAP_MYIMPROVEMENT_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/mySelfimprovement"]
#define CROWDBOOTSTRAP_ARCHIVE_IMPROVEMENT_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveSelfimprovementList"]
#define CROWDBOOTSTRAP_DEACTIVATED_IMPROVEMENT_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateSelfimprovementList"]
#define CROWDBOOTSTRAP_ARCHIVE_IMPROVEMENT                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveSelfimprovement"]
#define CROWDBOOTSTRAP_DELETE_IMPROVEMENT                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteSelfimprovement"]
#define CROWDBOOTSTRAP_DEACTIVATE_IMPROVEMENT                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateSelfimprovement"]
#define CROWDBOOTSTRAP_ACTIVATE_IMPROVEMENT                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateSelfimprovement"]
#define CROWDBOOTSTRAP_IMPROVEMENT_KEYWORDS                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/selfimprovementKeywordsList"]
#define CROWDBOOTSTRAP_IMPROVEMENT_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/selfimprovementInterestKeywordLists"]
#define CROWDBOOTSTRAP_IMPROVEMENT_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/selfimprovementTargetMarketsList"]
#define CROWDBOOTSTRAP_IMPROVEMENT_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/selfimprovementDetails"]
#define CROWDBOOTSTRAP_ADD_IMPROVEMENT                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addSelfimprovement"]
#define CROWDBOOTSTRAP_EDIT_IMPROVEMENT                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editSelfimprovement"]
#define CROWDBOOTSTRAP_FOLLOW_IMPROVEMENT                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followSelfimprovement"]
#define CROWDBOOTSTRAP_UNFOLLOW_IMPROVEMENT                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowSelfimprovement"]
#define CROWDBOOTSTRAP_LIKE_IMPROVEMENT                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeSelfimprovement"]
#define CROWDBOOTSTRAP_UNLIKE_IMPROVEMENT                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeSelfimprovement"]
#define CROWDBOOTSTRAP_LIKE_IMPROVEMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/selfimprovementLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_IMPROVEMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/selfimprovementDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_IMPROVEMENT                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/selfimprovementCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_IMPROVEMENT                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/selfimprovementUncommitment"]
#define CROWDBOOTSTRAP_IMPROVEMENT_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/selfimprovementCommitmentList"]


// Launch Deal
#define CROWDBOOTSTRAP_FIND_LAUNCHDEAL                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findLaunchdeal"]
#define CROWDBOOTSTRAP_MYLAUNCHDEAL_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myLaunchdeal"]
#define CROWDBOOTSTRAP_ARCHIVE_LAUNCHDEAL_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveLaunchdealList"]
#define CROWDBOOTSTRAP_DEACTIVATED_LAUNCHDEAL_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateLaunchdealList"]
#define CROWDBOOTSTRAP_ARCHIVE_LAUNCHDEAL                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/archiveLaunchdeal"]
#define CROWDBOOTSTRAP_DELETE_LAUNCHDEAL                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteLaunchdeal"]
#define CROWDBOOTSTRAP_DEACTIVATE_LAUNCHDEAL                           [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deactivateLaunchdeal"]
#define CROWDBOOTSTRAP_ACTIVATE_LAUNCHDEAL                             [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activateLaunchdeal"]
#define CROWDBOOTSTRAP_LAUNCHDEAL_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/launchdealKeywordsList"]
#define CROWDBOOTSTRAP_LAUNCHDEAL_INDUSTRY_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/launchdealInterestKeywordLists"]
#define CROWDBOOTSTRAP_LAUNCHDEAL_TARGET_KEYWORDS                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/launchdealTargetMarketsList"]
#define CROWDBOOTSTRAP_LAUNCHDEAL_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/launchdealdetails"]
#define CROWDBOOTSTRAP_ADD_LAUNCHDEAL                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addLaunchdeal"]
#define CROWDBOOTSTRAP_EDIT_LAUNCHDEAL                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editLaunchdeal"]
#define CROWDBOOTSTRAP_FOLLOW_LAUNCHDEAL                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followLaunchdeal"]
#define CROWDBOOTSTRAP_UNFOLLOW_LAUNCHDEAL                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowLaunchdeal"]
#define CROWDBOOTSTRAP_LIKE_LAUNCHDEAL                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeLaunchdeal"]
#define CROWDBOOTSTRAP_UNLIKE_LAUNCHDEAL                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeLaunchdeal"]
#define CROWDBOOTSTRAP_LIKE_LAUNCHDEAL_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/launchdealLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_LAUNCHDEAL_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/launchdealDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_LAUNCHDEAL                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/launchdealCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_LAUNCHDEAL                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/launchdealUncommitment"]
#define CROWDBOOTSTRAP_LAUNCHDEAL_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/launchdealCommitmentList"]

// Group Buying/Purchase Order
#define CROWDBOOTSTRAP_FIND_PURCHASEORDER                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/findGroupbuying"]
#define CROWDBOOTSTRAP_MYPURCHASEORDER_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/myGroupbuying"]
#define CROWDBOOTSTRAP_PURCHASEORDER_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupbuyingKeywordsList"]
#define CROWDBOOTSTRAP_PURCHASEORDER_INTEREST_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupbuyingInterestKeywordLists"]
#define CROWDBOOTSTRAP_PURCHASEORDER_TARGET_KEYWORDS                   [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupbuyingTargetMarketsList"]
#define CROWDBOOTSTRAP_PURCHASEORDER_DETAILS                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupbuyingDetails"]
#define CROWDBOOTSTRAP_ADD_PURCHASEORDER                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addGroupbuying"]
#define CROWDBOOTSTRAP_EDIT_PURCHASEORDER                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editGroupbuying"]
#define CROWDBOOTSTRAP_FOLLOW_PURCHASEORDER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/followGroupbuying"]
#define CROWDBOOTSTRAP_UNFOLLOW_PURCHASEORDER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/unfollowGroupbuying"]
#define CROWDBOOTSTRAP_LIKE_PURCHASEORDER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/likeGroupbuying"]
#define CROWDBOOTSTRAP_UNLIKE_PURCHASEORDER                                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/disLikeGroupbuying"]
#define CROWDBOOTSTRAP_LIKE_PURCHASEORDER_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupbuyingLikeList"]
#define CROWDBOOTSTRAP_DISLIKE_PURCHASEORDER_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupbuyingDislikeList"]
#define CROWDBOOTSTRAP_COMMIT_PURCHASEORDER                                  [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupbuyingCommitment"]
#define CROWDBOOTSTRAP_UNCOMMIT_PURCHASEORDER                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupbuyingUncommitment"]
#define CROWDBOOTSTRAP_PURCHASEORDER_COMMITMENT_LIST                               [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/groupbuyingCommitmentList"]

// Networking Options
#define CROWDBOOTSTRAP_BUSINESS_CARD_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/businessCardList"]
#define CROWDBOOTSTRAP_ADD_BUSINESS_CARD                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addBusinessCard"]
#define CROWDBOOTSTRAP_VIEW_BUSINESS_CARD                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/businessCardDetails"]
#define CROWDBOOTSTRAP_EDIT_BUSINESS_CARD                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editBusinessCard"]
#define CROWDBOOTSTRAP_BUSINESS_CONNECTION_TYPE                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/businessConnectionType"]
#define CROWDBOOTSTRAP_ACTIVATE_BUSINESS_CARD                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/activeBusinessCard"]
#define CROWDBOOTSTRAP_DELETE_BUSINESS_CARD                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/deleteBusinessCard"]
#define CROWDBOOTSTRAP_SEARCH_BUSINESS_CONNECTION                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/searchBusinessNetworks"]
#define CROWDBOOTSTRAP_BUSINESS_CARD_NOTES_LIST                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/businessCardNotesList"]
#define CROWDBOOTSTRAP_ADD_BUSINESS_CARD_NOTE                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addBusinessCardNotes"]
#define CROWDBOOTSTRAP_ADD_BUSINESS_NETWORK                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addBusinessNetwork"]
#define CROWDBOOTSTRAP_EDIT_BUSINESS_CARD_NOTE                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editBusinessCardNotes"]
#define CROWDBOOTSTRAP_ADD_BUSINESS_GROUP                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addbusinessUserConnectionType"]
#define CROWDBOOTSTRAP_EDIT_BUSINESS_GROUP                [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/editbusinessUserConnectionType"]
#define CROWDBOOTSTRAP_ADD_BUSINESS_CONTACT                    [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/addBusinessContact"]
#define CROWDBOOTSTRAP_USER_AVAILABILITY                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userAvailabilityStatus"]
#define CROWDBOOTSTRAP_USER_VISIBILITY                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userVisibilityStatus"]
#define CROWDBOOTSTRAP_USERLIST_WITHINMILES                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/usersListWithinMiles"]
#define CROWDBOOTSTRAP_USERLIST_WITHSAMELATLONG                              [CROWDBOOTSTRAP_BASE_URL stringByAppendingString:@"/Api/userListWithSameLatLong"]


@interface ApiCrowdBootstrap : NSObject

+(void)loginWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)logoutWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)sendResetPasswordMailWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)resendConfirmationMailWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

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

#pragma mark - Save Device Token Api Methods
+(void)saveDeviceTokenWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Setting Api Methods
+(void)registerForRoleWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unregisterForRoleWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getRegisteredRoleListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getSettingsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - News/Blog Post Api Methods
+(void)getNewsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Feeds Api Methods
+(void)getFeedsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addFeedWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;

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

#pragma mark - Funds Api Methods
+(void)getFindFundsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyFundsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveFundsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedFundsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getFundKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getFundIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getFundSponsorKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getFundManagerKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getFundPortfolioKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getEditFundPortfolioKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress ;
+(void)editFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeFundWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeFundListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeFundListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Beta Tests Api Methods
+(void)getSearchBetaTestsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyBetaTestsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveBetaTestsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedBetaTestsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getBetaTestKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getBetaTestIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getBetaTestTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getBetaTestCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress ;
+(void)editBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeBetaTestWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeBetaTestListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeBetaTestListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Board Members Api Methods
+(void)getSearchBoardMembersWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyBoardMembersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveBoardMembersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedBoardMembersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getBoardMemberKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getBoardMemberIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getBoardMemberTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getBoardMemberCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeBoardMemberWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeBoardMemberListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeBoardMemberListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Communal Asset Api Methods
+(void)getSearchCommunalAssetsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyCommunalAssetsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveCommunalAssetsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedCommunalAssetsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getCommunalAssetKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getCommunalAssetIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getCommunalAssetTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getCommunalAssetCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeCommunalAssetWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeCommunalAssetListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeCommunalAssetListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Consulting Api Methods
+(void)getSearchConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getClosedConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getInvitationConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)openConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)closeConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getConsultingIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getConsultingTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getConsultingCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)searchConsultingContractorsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)sendConsultingInvitationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeConsultingWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeConsultingListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)acceptConsultingInvitationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)rejectConsultingInvitationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Early Adopters Api Methods
+(void)getSearchEarlyAdoptersWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyEarlyAdoptersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveEarlyAdoptersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedEarlyAdoptersListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getEarlyAdopterKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getEarlyAdopterIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getEarlyAdopterTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getEarlyAdopterCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeEarlyAdopterWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeEarlyAdopterListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeEarlyAdopterListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Endorsor Api Methods
+(void)getSearchEndorsorsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyEndorsorsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveEndorsorsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedEndorsorsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getEndorsorKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getEndorsorIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getEndorsorTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getEndorsorCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeEndorsorWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeEndorsorListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeEndorsorListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Focus Groups Api Methods
+(void)getSearchFocusGroupsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyFocusGroupsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveFocusGroupsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedFocusGroupsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getFocusGroupKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getFocusGroupIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getFocusGroupTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getFocusGroupCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeFocusGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeFocusGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeFocusGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Hardware Api Methods
+(void)getSearchHardwaresWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyHardwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveHardwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedHardwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getHardwareKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getHardwareIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getHardwareTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getHardwareCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeHardwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeHardwareListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeHardwareListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Software Api Methods
+(void)getSearchSoftwaresWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMySoftwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveSoftwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedSoftwaresListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getSoftwareKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getSoftwareIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getSoftwareTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getSoftwareCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeSoftwareWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeSoftwareListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeSoftwareListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Audio/Video Api Methods
+(void)getSearchAudioVideosWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyAudioVideosListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveAudioVideosListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedAudioVideosListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getAudioVideoKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getAudioVideoIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getAudioVideoTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getAudioVideoCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeAudioVideoWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeAudioVideoListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeAudioVideoListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Service Api Methods
+(void)getSearchServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyServiceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveServiceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedServiceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getServiceKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getServiceIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getServiceTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getServiceCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeServiceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeServiceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeServiceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Information Api Methods
+(void)getSearchInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyInformationListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveInformationListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedInformationListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getInformationKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getInformationIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getInformationTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getInformationCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeInformationWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeInformationListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeInformationListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Productivity Api Methods
+(void)getSearchProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyProductivityListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveProductivityListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedProductivityListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getProductivityKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getProductivityIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getProductivityTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getProductivityCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeProductivityWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeProductivityListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeProductivityListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

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

#pragma mark - Group Api Methods
+(void)getSearchGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getGroupKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getGroupIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getGroupTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getGroupCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeGroupListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Webinar Api Methods
+(void)getSearchWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyWebinarListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveWebinarListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedWebinarListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getWebinarKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getWebinarIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getWebinarTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getWebinarCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeWebinarWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeWebinarListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeWebinarListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Meet Up Api Methods
+(void)getSearchMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyMeetUpListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveMeetUpListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedMeetUpListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMeetUpForums:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMeetUpKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMeetUpIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMeetUpTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMeetUpCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeMeetUpWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeMeetUpListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeMeetUpListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Demo Day Api Methods
+(void)getSearchDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyDemoDayListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveDemoDayListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedDemoDayListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDemoDayKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDemoDayIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDemoDayTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDemoDayCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeDemoDayWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeDemoDayListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeDemoDayListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Conference Api Methods
+(void)getSearchConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyConferenceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveConferenceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedConferenceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getConferenceKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getConferenceIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getConferenceTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getConferenceCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeConferenceWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeConferenceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeConferenceListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Career Api Methods
+(void)getSearchCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyCareerListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveCareerListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedCareerListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getCareerKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getCareerIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getCareerTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getCareerCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeCareerWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeCareerListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeCareerListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Self Improvement Tool Api Methods
+(void)getSearchImprovementsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyImprovementsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveImprovementsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedImprovementsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getImprovementKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getImprovementIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getImprovementTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getImprovementCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeImprovementWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeImprovementListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeImprovementListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Launch Deal Api Methods
+(void)getSearchLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyLaunchDealListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getArchiveLaunchDealListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDeactivatedLaunchDealListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)archiveLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deActivateLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLaunchDealKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLaunchDealIndustryKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLaunchDealTargetMarketKeywordsListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLaunchDealCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likeLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikeLaunchDealWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikeLaunchDealListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikeLaunchDealListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - Group Buying/Purchase Order Api Methods
+(void)getSearchPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getMyPurchaseOrderListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getPurchaseOrderKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getPurchaseOrderInterestKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getPurchaseOrderTargetKeywordsList:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)viewPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)commitPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)uncommitPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getPurchaseOrderCommitmentListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)editPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)followPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)unfollowPurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)likePurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)dislikePurchaseOrderWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getLikePurchaseOrderListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getDislikePurchaseOrderListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;

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

#pragma mark - Networking Options Api Methods
+(void)setUserAvailabilityStatusWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)setUserVisibilityStatusWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getUserListWithinMilesWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getUserListWithSameLatLongWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getBusinessCardListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)activateBusinessCardWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)deleteBusinessCardWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addBusinessCardWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)viewBusinessCardDetailsWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)editBusinessCardWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;
+(void)getBusinessConnectionTypeListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)searchBusinessConnectionWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)getBusinessCardNotesListWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addBusinessCardNoteWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)editBusinessCardNoteWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addBusinessNetworkWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addBusinessUserGroupWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)addBusinessContactWithParameters:(NSDictionary *)dictParameters success:(SuccessBlock)success failure:(FailureBlock)failure progress:(ProgressBlock)progress;

@end
