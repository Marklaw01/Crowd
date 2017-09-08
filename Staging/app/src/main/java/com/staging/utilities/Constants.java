package com.staging.utilities;

/**
 * Created by neelmani.karn on 1/6/2016.
 */
public final class Constants {

    //Live URL
//    public static final String APP_BASE_URL = "http://crowdbootstrap.com/Api/";
//    public static final String APP_IMAGE_URL = "http://crowdbootstrap.com";

    //Staging URL
    public static final String APP_BASE_URL = "http://stage.crowdbootstrap.com/api/";
    public static final String APP_IMAGE_URL = "http://stage.crowdbootstrap.com";

    public static final int API_CONNECTION_TIME_OUT_DURATION = 30000;

    public static final String NOTIFICATION_CONSTANT = "notifications";

    public static final String NOTIFICATION_TAG = "tag";

    public static final String NOTIFICATION_PROFILE_TAG = "Profile";
    public static final String NOTIFICATION_MESSAGE_TAG = "Message";

    public static final String NOTIFICATION_UNFOLLOW_CAMPAIGN_TAG = "UnFollow_Campaign";
    public static final String NOTIFICATION_FOLLOW_CAMPAIGN_TAG = "Follow_Campaign";

    public static final String NOTIFICATION_COMMIT_CAMPAIGN_TAG = "Commit_Campaign";
    public static final String NOTIFICATION_UNCOMMIT_CAMPAIGN_TAG = "Uncommit_Campaign";

    public static final String NOTIFICATION_TEAM_MEMBER_STAUS = "TeamMember_status";

    public static final String NOTIFICATION_COMMENT_FOURM = "Comment_Forum";

    public static final String NOTIFICATION_RATE_PROFILE = "Rate_user";

    public static final String NOTIFICATION_ADD_TEAM_MEMBER = "Add_member";
    public static final String NOTIFICATION_REPORT_ABUSE_FORUM_MEMBER = "Report_Abuse_User";
    public static final String NOTIFICATION_REPORT_ABUSE_FORUM = "Report_Abuse_Forum";

    public static final String NOTIFICATION_ADD_CONNECTION = "Add_Connection";


    //Campaigns Type
    public static final int RECOMMENDED = 0;
    public static final int FOLLOWING = 1;
    public static final int COMMITMENTS = 2;
    public static final int MY_CAMPAIGNS = 3;

    //Startups Type
    public static final int CURRENT_STARTUPS = 0;
    public static final int COMPLETED_STARTUPS = 1;
    public static final int SEARCH_STARTUPS = 2;
    public static final int MY_STARTUPS = 3;


    //suburls
    public static final String LOGIN_URL = "login";
    public static final String LOGIN_TAG = "login";

    public static final String LOGOUT_URL = "logout";
    //public static final String LOGOUT_TAG = "logout";

    public static final String SIGNUP_URL = "register";
    public static final String SIGNUP_TAG = "register";

    public static final String DEFAULT_COUNTRY_ID = "231";
    public static final String GET_COUNTRIES_LIST_WITH_STATES = "getCounrtyList";
    public static final String GET_COUNTRIES_LIST_WITH_STATES_TAG = "getCounrtyList_tag";
    public static final String COUNTRY_URL = "appcountryList";
    public static final String COUNTRY_TAG = "country_list";

    public static final String STATE_URL = "appstateList?country_id=";
    public static final String STATE_TAG = "states_list";

    public static final String PREDEFINED_QUESTIONS_URL = "appquestionList";
    public static final String PREDEFINED_QUESTIONS_TAG = "questions_list";

    public static final String FORGOT_PASSWORD_USER_QUESTIONS_LIST_URL = "appuserquestionlist?user_email=";
    public static final String FORGOT_PASSWORD_USER_QUESTIONS_LIST_TAG = "appuserquestionlist";

    public static final String FORGOT_PASSWORD_USER_MAIL_URL = "sendMailForResetPassword";
    public static final String FORGOT_PASSWORD_USER_MAIL_TAG = "sendMailForResetPassword_tag";

    public static final String FORGOT_PASSWORD_MAX_NUMBER_OF_LIMIT_URL = "maxLimitResetPass";
    public static final String FORGOT_PASSWORD_MAX_NUMBER_OF_LIMIT_TAG = "maxLimitResetPass_tag";

    public static final String HOME_FEEDS_LIST = "userFeedList";
    public static final String HOME_FEEDS_TAG = "userFeedList_tag";

    public static final String CONTRACTOR_BASIC_PROFILE_URL = "userContractorBasic?user_id=";
    public static final String CONTRACTOR_BASIC_PROFILE_TAG = "userContractorBasic_profile";

    public static final String CONTRACTOR_EDIT_BASIC_PROFILE_URL = "editContractorBasic";
    //public static final String CONTRACTOR_EDIT_BASIC_PROFILE_TAG = "editContractorBasic_profile";

    public static final String CONTRACTOR_PROFESSIONAL_PROFILE_URL = "userContractorProffesional?user_id=";
    public static final String CONTRACTOR_PROFESSIONAL_PROFILE_TAG = "userContractorProffesional_profile";

    public static final String CONTRACTOR_EDIT_PROFESSIONAL_PROFILE_URL = "editContractorProffesional";
    //public static final String CONTRACTOR_EDIT_PROFESSIONAL_PROFILE_TAG = "editContractorProffesional_profile";

    public static final String ENTREPRENEUR_BASIC_PROFILE_URL = "userEntrepreneurBasic?user_id=";
    public static final String ENTREPRENEUR_BASIC_PROFILE_TAG = "userEntrepreneurBasic_profile";

    public static final String ENTREPRENEUR_EDIT_BASIC_PROFILE_URL = "editEntrepreneurBasic";
    //public static final String ENTREPRENEUR_EDIT_BASIC_PROFILE_TAG = "editEntrepreneurBasic_profile";

    public static final String ENTREPRENEUR_PROFESSIONAL_PROFILE_URL = "userEntrepreneurProfessional?user_id=";
    public static final String ENTREPRENEUR_PROFESSIONAL_PROFILE_TAG = "userEntrepreneurProfessional_profile";

    public static final String ENTREPRENEUR_EDIT_PROFESSIONAL_PROFILE_URL = "editEntrepreneurProffesional";
    //public static final String ENTREPRENEUR_EDIT_PROFESSIONAL_PROFILE_TAG = "editEntrepreneurProffesional_profile";

    public static final String SKILLS_QUALIFICATIONS_KEYWORDS_EXPERIENCE_CONTRACTORTYPE_PREFEREDSTARTUP_CERTIFICATIONS_URL = "SQKCCPE";
    public static final String SKILLS_QUALIFICATIONS_KEYWORDS_EXPERIENCE_CONTRACTORTYPE_PREFEREDSTARTUP_CERTIFICATIONS_TAG = "SQKCCPE";

    public static final String USER_STARTUPS_URL = "userStartup";
    public static final String USER_STARTUPS_TAG = "userStartup_tag";


    public static final String JOB_ROLES_URL = "jobRoleLists";
    public static final String JOB_ROLES_TAG = "jobRoleLists_tag";


    public static final String GET_JOBEXPERIENCE_LIST_URL = "getUserExperiences";
    public static final String GET_JOBEXPERIENCE_LIST_TAG = "getUserExperiences_tag";


    public static final String JOB_DUTIES_URL = "jobDutiesLists";
    public static final String JOB_DUTIES_TAG = "jobDutiesLists_tag";

    public static final String JOB_ACHIEVEMENTS_URL = "jobAchievementLists";
    public static final String JOB_ACHIEVEMENTS_TAG = "jobAchievementLists_tag";


    public static final String USER_COMPANY_URL = "hiredCompanyList";
    public static final String USER_COMPANY_TAG = "hiredCompanyList_tag";

    public static final String USER_EDIT_EXPERIENCE_URL = "editExperiences";
    public static final String USER_EDIT_EXPERIENCE_TAG = "editExperiences_tag";

    public static final String KEYWORDTYPE_URL = "keywordTypeList";
    public static final String KEYWORDTYPE_TAG = "keywordTypeList_tag";

    public static final String ADD_EXPERIENCE_URL = "addExperiences";
    public static final String ADD_EXPERIENCE_TAG = "addExperiences_tag";


    public static final String ADDKEYWORD_KEYWORDTYPE_URL = "addSuggestKeywords";
    public static final String ADDKEYWORD_KEYWORDTYPE_TAG = "addSuggestKeywords_tag";

    public static final String DELETE_KEYWORDTYPE_URL = "deleteSuggestKeywords";
    public static final String DELETE_KEYWORDTYPE_TAG = "deleteSuggestKeywords_tag";

    public static final String USER_SELECTED_STARTUPS_URL = "userSelectedStartup";
    public static final String USER_SELECTED_STARTUPS_TAG = "userSelectedStartup_tag";

    public static final String ADD_STARTUPS_LIST_TO_PROFILE_URL = "addStartupList";
    public static final String ADD_STARTUPS_LIST_TO_PROFILE_TAG = "addStartupList_tag";

    public static final String PROFILE_SETTING_URL = "profileSettings";
    public static final String PROFILE_SETTING_TAG = "profileSettings_tag";


    public static final String BE_BETA_TESTER_SETTING_URL = "registerForRole";
    public static final String BE_BETA_TESTER_SETTING_TAG = "registerForRole_tag";

    public static final String UNREGISTER_BETA_TESTER_SETTING_URL = "unRegisterForRole";
    public static final String UNREGISTER_BETA_TESTER_SETTING_TAG = "unRegisterForRole_tag";


    public static final String ADD_STARTUP_URL = "addStartup";
    public static final String ADD_STARTUP_TAG = "addStartup_tag";

    public static final String LEAN_STARTUP_URL = "dynamicRoadmaps";
    public static final String LEAN_STARTUP_TAG = "dynamicRoadmaps_tag";

    public static final String KEYWORDS_URL = "keywords";
    public static final String KEYWORDS_TAG = "keywords_tag";


    public static final String JOB_INDUSTRIES_KEYWORDS_URL = "jobIndustrieLists";
    public static final String JOB_INDUSTRIES_KEYWORDS_TAG = "jobIndustrieLists_tag";


    public static final String EDIT_JOB_URL = "editJob";
    public static final String EDIT_JOB_TAG = "editJob_tag";


    public static final String JOB_TYPE_KEYWORDS_URL = "jobTypeLists";
    public static final String JOB_TYPE_KEYWORDS_TAG = "jobTypeLists_tag";

    public static final String JOB_POSTING_KEYWORDS_URL = "companyKeywordList";
    public static final String JOB_POSTING_KEYWORDS_TAG = "companyKeywordList_tag";

    public static final String CAMPAIGN_KEYWORDS_URL = "campaignKeywords";
    public static final String CAMPAIGN_KEYWORDS_TAG = "campaignKeywords_tag";

    public static final String FORUMS_KEYWORDS_URL = "forumKeywords";
    public static final String FORUMS_KEYWORDS_TAG = "forumKeywords_tag";


    public static final String STARTUP_KEYWORDS_URL = "startupKeywords";
    public static final String STARTUP_KEYWORDS_TAG = "startupKeywords_tag";

    public static final String CAMPAIGNS_URL = "campaignsList?user_id=";
    public static final String CAMPAIGNS_TAG = "campaignsList_tag";

    public static final String TIME_PERIOD_URL = "timePeriods";
    public static final String TIME_PERIOD_TAG = "time_period_tag";

    public static final String COMMIT_CAMPAIGN_URL = "commitCampaign";
    public static final String COMMIT_CAMPAIGN_TAG = "commitCampaign_tag";

    public static final String UNCOMMIT_CAMPAIGN_URL = "uncommitCampaign";
    public static final String UNCOMMIT_CAMPAIGN_TAG = "uncommitCampaign_tag";

    public static final String FOLLOW_CAMPAIGN_URL = "followCampaign";
    public static final String FOLLOW_CAMPAIGN_TAG = "followCampaign_tag";


    public static final String FOLLOW_JOB_URL = "followJob";
    public static final String FOLLOW_JOB_TAG = "followJob_tag";

    public static final String UN_FOLLOW_JOB_URL = "unfollowJob";
    public static final String UN_FOLLOW_JOB_TAG = "unfollowJob_tag";


    public static final String ADD_CAMPAIGN_URL = "addCampaign";
    public static final String APPLY_JOB_URL = "applyForJob";
    public static final String ADD_JOB_URL = "addJobs";
    public static final String EDIT_CAMPAIGN_URL = "editCampaign";

    public static final String ACTIVATE_JOB_URL = "activateJob";
    public static final String ACTIVATE_JOB_TAG = "activateJob_tag";

    public static final String DELETE_CAMPAIGN_URL = "deleteCampaign";

    public static final String CAMPAIGN_DETAILS_URL = "singleCampaignDetail";
    public static final String CAMPAIGN_DETAILS_TAG = "singleCampaignDetail_tag";

    public static final String VIEW_FOLLOWERS_URL = "jobFollowerLists";
    public static final String VIEW_FOLLOWERS_TAG = "jobFollowerLists_tag";

    public static final String JOB_DETAILS_URL = "viewJob";
    public static final String JOB_DETAILS_TAG = "viewJob_tag";

    public static final String CAMPAIGN_CONTRIBUTORS_LIST_URL = "campaignContributorsList";
    public static final String CAMPAIGN_CONTRIBUTORS_LIST_TAG = "campaignContributorsList_tag";

    public static final String STARTUPS_URL = "startupsList";
    public static final String STARTUPS_TAG = "startupsList_tag";

    public static final String SEARCH_CAMPAIGN_URL = "searchCampaigns";
    public static final String SEARCH_CAMPAIGN_TAG = "searchCampaigns_tag";

    public static final String DELETE_STARTUPS_URL = "deleteStartup";

    public static final String DELETE_JOB_URL = "deleteJob";
    public static final String ARCHIVE_JOB_URL = "archiveJob";
    public static final String DEACTIVATE_JOB_URL = "deactivateJob";

    public static final String STARTUP_OVERVIEW_URL = "startupOverview";
    public static final String STARTUP_OVERVIEW_TAG = "startupOverview_tag";

    public static final String STARTUP_OVERVIEW_UPDATE_URL = "updateStartup";

    public static final String STARTUP_TEAM_URL = "startupTeam";
    public static final String STARTUP_TEAM_TAG = "startupTeam_tag";

    public static final String MYJOBS_LIST_URL = "myJobLists";
    public static final String MYJOBS_LIST_TAG = "myJobLists_tag";

    public static final String STARTUP_WORKORDER_URL = "startupWorkorders";
    public static final String STARTUP_WORKORDER_TAG = "startupWorkorders_tag";

    public static final String ENTREPRENEUR_STARTUP_WORKORDER_URL = "entrepreneurStartupWorkorders";
    public static final String ENTREPRENEUR_STARTUP_WORKORDER_TAG = "entrepreneurStartupWorkorders_tag";

    public static final String STARTUP_WORKORDER_SAVED_URL = "startupSavedWorkorders";
    public static final String STARTUP_WORKORDER_SAVED_TAG = "startupSavedWorkorders_tag";

    public static final String DOWNLOAD_CONTRACTOR_STARTUP_WORKORDER_URL = "Contractorexcel";
    public static final String DOWNLOAD_CONTRACTOR_STARTUP_WORKORDER_TAG = "Contractorexcel_tag";

    public static final String STARTUP_WORKORDER_UPDATE_URL = "saveSubmitWorkorder";
    public static final String STARTUP_WORKORDER_UPDATE_TAG = "saveSubmitWorkorder_tag";

    public static final String STARTUP_WORKORDER_COMMENT_URL = "startupWorkorderRatings";
    public static final String STARTUP_WORKORDER_COMMENT_TAG = "startupWorkorderRatings_tag";

    public static final String STARTUP_SEND_MESSAGE_URL = "sendMessage";
    public static final String STARTUP_SEND_MESSAGE_TAG = "sendMessage_tag";

    public static final String STARTUP_TEAM_MEMBER_STATUS_URL = "teamMemberStatus";
    public static final String STARTUP_TEAM_MEMBER_STATUS_TAG = "teamMemberStatus_tag";
    public static final String STARTUP_TEAM_MEMBER_STATUS_HOME_SCREEN_TAG = "teamMemberStatus_home_tag";

    public static final String STARTUP_ENTREPRENEUR_WORKORDERS_URL = "approveWorkorderEntrepreneur";
    public static final String STARTUP_ENTREPRENEUR_WORKORDERS_TAG = "approveWorkorderEntrepreneur_tag";


    public static final String USER_SUGGESTED_KEYWORDS_URL = "suggestKeywordLists";
    public static final String USER_SUGGESTED_KEYWORDS_TAG = "suggestKeywordLists_tag";

    public static final String USER_NOTIFICATION_COUNT_URL = "notificationsCount";
    public static final String USER_NOTIFICATION_COUNT_TAG = "notificationsCount_tag";

    public static final String USER_NOTIFICATION_COUNT_UPDATE_URL = "updateNotificationsCount";
    public static final String USER_NOTIFICATION_COUNT_UPDATE_TAG = "updateNotificationsCount_tag";

    public static final String DOWNLOAD_STARTUP_ENTREPRENEUR_WORKORDERS_URL = "Entrepreneurexcel";
    public static final String DOWNLOAD_STARTUP_ENTREPRENEUR_WORKORDERS_TAG = "Entrepreneurexcel_tag";

    public static final String STARTUP_ENTREPRENEUR_WORKORDERS_ACCEPT_URL = "acceptWorkorderEntrepreneur";
    public static final String STARTUP_ENTREPRENEUR_WORKORDERS_ACCEPT_TAG = "acceptWorkorderEntrepreneur_tag";

    public static final String STARTUP_ENTREPRENEUR_WORKORDERS_REJECT_URL = "rejectWorkorderEntrepreneur";
    public static final String STARTUP_ENTREPRENEUR_WORKORDERS_REJECT_TAG = "rejectWorkorderEntrepreneur_tag";

    public static final String ALL_DELIVERABLES_URL = "allDeliverables";
    public static final String ALL_DELIVERABLES_TAG = "allDeliverables_tag";

    public static final String COMPLETED_DELIVERABLES_URL = "startupRoadmapsStaus";
    public static final String COMPLETED_DELIVERABLES_TAG = "startupRoadmapsStaus_tag";

    public static final String UPLOAD_DOCS_URL = "uploadRoadmapDocs";
    public static final String UPLOAD_ROADMAP_DOCS_URL = "updateStartupRoadmap";

    public static final String UPLOAD_STARTUP_PROFILE_URL = "uploadStartupProfile";

    public static final String ALL_DELIVERABLES_DOCS_LIST_URL = "deliverablesDocsList";
    public static final String ALL_DELIVERABLES_DOCS_LIST_TAG = "deliverablesDocsList_tag";

    public static final String RECOMMENDED_CONTRACTORS_OF_STARTUP_URL = "recommendedContractors";
    public static final String RECOMMENDED_CONTRACTORS_OF_STARTUP_TAG = "recommendedContractors_tag";

    public static final String SEARCH_CONTRACTORS_URL = "searchContractors";
    public static final String SEARCH_CONTRACTORS_TAG = "searchContractors_tag";


    public static final String SEARCH_JOBLIST_URL = "jobLists";
    public static final String SEARCH_JOBLIST_TAG = "jobLists_tag";

    public static final String MY_ARCHIVED_JOBS_URL = "archiveJobLists";
    public static final String MY_ARCHIVED_JOBS_TAG = "archiveJobLists_tag";

    public static final String MY_DEACTIVATED_JOBS_URL = "deactivatedJobLists";
    public static final String MY_DEACTIVATED_JOBS_TAG = "deactivatedJobLists_tag";

    public static final String SEARCH_CONNECTIONS_URL = "searchConnections";
    public static final String SEARCH_CONNECTIONS_TAG = "searchConnections_tag";

    public static final String MY_CONNECTIONS_URL = "myConnections";
    public static final String MY_CONNECTIONS_TAG = "myConnections_tag";

    public static final String SEARCH_ORGANIZATION_URL = "searchCompany";
    public static final String SEARCH_ORGANIZATION_TAG = "searchCompany_tag";

    public static final String DETAIL_ORGANIZATION_URL = "viewCompany";
    public static final String DETAIL_ORGANIZATION_TAG = "viewCompany_tag";

    public static final String CONNECTIONS_SENDMESSAGE_URL = "sendMessage";
    public static final String CONNECTIONS_SENDMESSAGE_TAG = "sendMessage_tag";

    public static final String TEAM_MEMBER_ROLES_URL = "teamMembersRoles";
    public static final String TEAM_MEMBER_ROLES_TAG = "teamMembersRoles_tag";

    public static final String ADD_CONTRACTOR_URL = "addTeamMember";
    public static final String ADD_CONTRACTOR_TAG = "addTeamMember_tag";

    public static final String ALL_RATINGS_OF_CONTRACTOR_URL = "allRatings";
    public static final String ALL_RATINGS_OF_CONTRACTOR_TAG = "allRatings_tag";

    public static final String RATE_CONTRACTOR_URL = "rateContractor";
    public static final String RATE_CONTRACTOR_TAG = "rateContractor_tag";

    public static final String STARTUP_QUESTIONS_URL = "startupQuestions";
    public static final String STARTUP_QUESTIONS_TAG = "startupQuestions_tag";

    public static final String STARTUP_SAVED_QUESTIONS_URL = "submitApplicationQuestions";
    public static final String STARTUP_SAVED_QUESTIONS_TAG = "submitApplicationQuestions_tag";

    public static final String FOLLOW_USER_URL = "userFollow";
    public static final String FOLLOW_USER_TAG = "userFollow_tag";

    public static final String CONNECT_USER_URL = "addConnection";
    public static final String CONNECT_USER_TAG = "addConnection_tag";

    public static final String DISCONNECT_USER_URL = "rejectConnection";
    public static final String DISCONNECT_USER_TAG = "rejectConnection_tag";

    public static final String ACCEPT_CONNECTION_USER_URL = "acceptConnection";
    public static final String ACCEPT_CONNECTION_USER_TAG = "acceptConnection_tag";

    public static final String USER_MESSAGES_URL = "messagesList";
    public static final String USER_MESSAGES_TAG = "messagesList_tag";

    public static final String MYCONNECTIONS_MESSAGES_URL = "myMessages";
    public static final String MYCONNECTIONS_MESSAGES_TAG = "myMessages_tag";

    public static final String USER_ARCHIEVED_MESSAGES_URL = "messagesArchiveList";
    public static final String USER_ARCHIEVED_MESSAGES_TAG = "messagesArchiveList_tag";

    public static final String USER_MESSAGES_DELETE_URL = "messageArchivedDelete";
    public static final String USER_MESSAGES_DELETE_TAG = "messageArchivedDelete_tag";

    public static final String MY_FORUMS_URL = "myForums";
    public static final String MY_FORUMS_TAG = "myForums_tag";

    public static final String ADD_FORUMS_URL = "addForum";

    public static final String FORUMS_ARCHIEVED_DELETE_URL = "forumArchivedDelete";
    public static final String FORUMS_ARCHIEVED_DELETE_TAG = "forumArchivedDelete_tag";

    public static final String STARTUP_LIST_UNDER_FORUMS_URL = "forumStartupsList";
    public static final String STARTUP_LIST_UNDER_FORUMS_TAG = "forumStartupsList_tag";

    public static final String STARTUP_FORUMS_LIST_URL = "startupForums";
    public static final String STARTUP_FORUMS_LIST_TAG = "startupForums_tag";

    public static final String SEARCH_FORUMS_LIST_URL = "searchForums";
    public static final String SEARCH_FORUMS_LIST_TAG = "searchForums_tag";

    public static final String FORUMS_DETAILS_URL = "forumDetail";
    public static final String FORUMS_DETAILS_TAG = "forumDetail_tag";

    public static final String FORUMS_COMMENTS_LIST_URL = "forumcomments";
    public static final String FORUMS_COMMENTS_LIST_TAG = "forumcomments_tag";

    public static final String ARCHIEVE_FORUMS_LIST_URL = "archivedForums";
    public static final String ARCHIEVE_FORUMS_LIST_TAG = "archivedForums_tag";

    public static final String ADD_FORUMS_COMMENT_URL = "addForumComment";
    public static final String ADD_FORUMS_COMMENT_TAG = "addForumComment_tag";

    public static final String FORUMS_REPORT_ABUSE_URL = "reportAbuse";
    public static final String FORUMS_REPORT_ABUSE_TAG = "reportAbuse_tag";

    public static final String FORUM_COMMENTED_USERS_URL = "commentedUsers";
    public static final String FORUM_COMMENTED_USERS_TAG = "commentedUsers_tag";

    public static final String LIST_OF_ALL_QUICKBLOX_USERS_URL = "quickBloxId";
    public static final String LIST_OF_ALL_QUICKBLOX_USERS_TAG = "quickBloxId_tag";

    public static final String DELETE_COMMIT_USER_URL = "deleteCommitedUser";
    public static final String DELETE_COMMIT_USER_TAG = "deleteCommitedUser_tag";

    public static final String COMPLETE_LISTOF_STARTUPS_OF_USER_URL = "startupListForUser";
    public static final String COMPLETE_LISTOF_STARTUPS_OF_USER_TAG = "startupListForUser_tag";


    public static final String LIST_OF_ALL_NOTIFICATIONS_URL = "UserNotifications";
    public static final String LIST_OF_ALL_NOTIFICATIONS_TAG = "UserNotifications_tag";

    public static final String SPONSORS_LIST = "sponsorsList?user_id=";
    public static final String SPONSORS_LIST_TAG = "sponsorsList_tag";

    public static final String FUND_MANAGERS_LIST = "fundsManagerLists?user_id=";
    public static final String FUND_MANAGERS_TAG = "fundsManagerLists_tag";

    public static final String FUND_KEYWORDS_LIST = "fundsKeywordList";
    public static final String FUND_KEYWORDS_TAG = "fundsKeywordList_tag";

    public static final String FUND_INDUSTRY_LIST = "fundIndustryLists";
    public static final String FUND_INDUSTRY_TAG = "fundIndustryLists_tag";

    public static final String FUND_PORTFOLIO_LIST = "fundPortfolioList?user_id=";
    public static final String FUND_PORTFOLIO_TAG = "fundPortfolioList_tag";

    public static final String FUND_EDIT_PORTFOLIO_LIST = "fundEditPortfolioList?user_id=";
    public static final String FUND_EDIT_PORTFOLIO_TAG = "fundEditPortfolioList_tag";

    public static final String CREATE_FUND_URL = "addFunds";
    public static final String EDIT_FUND_URL = "editFunds";

    public static final String FUND_SEARCH_LIST = "fundsSearch";
    public static final String FUND_SEARCH_TAG = "fundsSearch_tag";

    public static final String MY_FUND_LIST = "myFunds";
    public static final String MY_FUND_TAG = "myFunds_tag";


    public static final String FIND_FUND_LIST = "findFunds";
    public static final String FIND_FUND_TAG = "findFunds_tag";

    public static final String ARCHIVED_FUND_LIST = "archiveFundList";
    public static final String ARCHIVED_FUND_TAG = "archiveFundList_tag";

    public static final String DEACTIVATED_FUND_LIST = "deactivateFundList";
    public static final String DEACTIVATED_FUND_TAG = "deactivateFundList_tag";

    public static final String FUND_DETAILS_URL = "fundDetails";
    public static final String FUND_DETAILS_TAG = "fundDetails_tag";

    public static final String FUND_DELETE_URL = "deleteFund";
    public static final String FUND_ARCHIEVE_URL = "archiveFund";
    public static final String FUND_DEACTIVATE_URL = "deactivateFund";
    public static final String FUND_ACTIVATE_URL = "activateFund";
    public static final String FUND_LIKE_URL = "likeFund";
    public static final String FUND_LIKE_TAG = "likeFund_tag";
    public static final String FUND_DISLIKE_URL = "disLikeFund";
    public static final String FUND_DISLIKE_TAG = "disLikeFund_tag";

    public static final String FUND_LIKERS_LIST = "fundLikeList";
    public static final String FUND_LIKERS_TAG = "fundLikesList_tag";

    public static final String FUND_DISLIKERS_LIST = "fundDislikeList";
    public static final String FUND_DISLIKERS_TAG = "fundDislikesList_tag";

    public static final String FUND_FOLLOW_URL = "followFund";
    public static final String FUND_FOLLOW_TAG = "followFund_tag";

    public static final String FUND_UNFOLLOW_URL = "unfollowFund";
    public static final String FUND_UNFOLLOW_TAG = "unfollowFund_tag";

    //Beta test module
    public static final String BETA_TEST_KEYWORDS_LIST_URL = "betaTestKeywordsList";
    public static final String BETA_TEST_KEYWORDS_LIST_TAG = "betaTestKeywordsList_tag";

    public static final String BETA_TEST_INTEREST_KEYWORDS_LIST_URL = "betaInterestKeywordLists";
    public static final String BETA_TEST_INTEREST_KEYWORDS_LIST_TAG = "betaInterestKeywordLists_tag";

    public static final String BETA_TEST_TARGET_MARKET_LIST_URL = "betaTestTargetMarketsList";
    public static final String BETA_TEST_TARGET_MARKET_LIST_TAG = "betaTestTargetMarketsList_tag";

    public static final String BETA_TEST_DETAILS_URL = "betaTestDetails";
    public static final String BETA_TEST_DETAILS_TAG = "betaTestDetails_tag";

    public static final String BETA_TEST_COMMIT_URL = "betaCommitment";
    public static final String BETA_TEST_COMMIT_TAG = "betaCommitment_tag";

    public static final String BETA_TEST_UNCOMMIT_URL = "betaUncommitment";
    public static final String BETA_TEST_UNCOMMIT_TAG = "betaUncommitment_tag";

    public static final String REGISTER_ROLE_USER_LIST = "registerRoleList";
    public static final String REGISTER_ROLE_USER_LIST_TAG = "registerRoleList_tag";


    public static final String BETA_TESTER_COMMIT_LIST = "betaTestCommitmentList";
    public static final String BETA_TESTER_COMMIT_LIST_TAG = "betaTestCommitmentList_tag";

    public static final String CREATE_BETA_TEST_URL = "addBetaTest";
    public static final String UPDATE_BETA_TEST_URL = "editBetaTest";

    public static final String FIND_BETA_TESTER_LIST = "findBetaTests";
    public static final String FIND_BETA_TESTER_TAG = "findBetaTests_tag";

    public static final String MY_BETA_TESTER_LIST = "myBetaTest";
    public static final String MY_BETA_TESTER_TAG = "myBetaTest_tag";

    public static final String ARCHIVED_BETA_TESTER_LIST = "archiveBetaTestList";
    public static final String ARCHIVED_BETA_TESTER_TAG = "archiveBetaTestList_tag";

    public static final String DEACTIVATED_BETA_TESTER_LIST = "deactivateBetaTestList";
    public static final String DEACTIVATED_BETA_TESTER_TAG = "deactivateBetaTestList_tag";

    public static final String BETA_TESTER_DELETE_URL = "deleteBetaTest";
    public static final String BETA_TESTER_ARCHIEVE_URL = "archiveBetaTest";
    public static final String BETA_TESTER_DEACTIVATE_URL = "deactivateBetaTest";
    public static final String BETA_TESTER_ACTIVATE_URL = "activateBetaTest";
    public static final String BETA_TESTER_LIKE_URL = "likeBetaTest";
    public static final String BETA_TESTER_LIKE_TAG = "likeBetaTest_tag";
    public static final String BETA_TESTER_DISLIKE_URL = "disLikeBetaTest";
    public static final String BETA_TESTER_DISLIKE_TAG = "disLikeBetaTest_tag";

    public static final String BETA_TESTER_LIKERS_LIST = "betaTestLikeList";
    public static final String BETA_TESTER_LIKERS_TAG = "betaTestLikeList_tag";

    public static final String BETA_TESTER_DISLIKERS_LIST = "betaTestDislikeList";
    public static final String BETA_TESTER_DISLIKERS_TAG = "betaTestDislikeList_tag";

    public static final String BETA_TESTER_FOLLOW_URL = "followBetaTest";
    public static final String BETA_TESTER_FOLLOW_TAG = "followBetaTest_tag";

    public static final String BETA_TESTER_UNFOLLOW_URL = "unfollowBetaTest";
    public static final String BETA_TESTER_UNFOLLOW_TAG = "unfollowBetaTest_tag";

    // Board Members module
    public static final String BOARD_MEMBERS_KEYWORDS_LIST_URL = "boardOppertunityKeywordsList";
    public static final String BOARD_MEMBERS_KEYWORDS_LIST_TAG = "boardOppertunityKeywordsList_tag";

    public static final String BOARD_MEMBERS_INTEREST_KEYWORDS_LIST_URL = "boardInterestKeywordLists";
    public static final String BOARD_MEMBERS_INTEREST_KEYWORDS_LIST_TAG = "boardInterestKeywordLists_tag";

    public static final String BOARD_MEMBERS_TARGET_MARKET_LIST_URL = "boardMemberTargetMarketsList";
    public static final String BOARD_MEMBERS_TARGET_MARKET_LIST_TAG = "boardMemberTargetMarketsList_tag";

    public static final String BOARD_MEMBERS_DETAILS_URL = "boardMemberDetails";
    public static final String BOARD_MEMBERS_DETAILS_TAG = "boardMemberDetails_tag";

    public static final String BOARD_MEMBERS_COMMIT_URL = "boardCommitment";
    public static final String BOARD_MEMBERS_COMMIT_TAG = "boardCommitment_tag";

    public static final String BOARD_MEMBERS_UNCOMMIT_URL = "boardUncommitment";
    public static final String BOARD_MEMBERS_UNCOMMIT_TAG = "boardUncommitment_tag";

    public static final String BOARD_MEMBERS_COMMIT_LIST = "boardCommitmentList";
    public static final String BOARD_MEMBERS_COMMIT_LIST_TAG = "boardCommitmentList_tag";

    public static final String CREATE_BOARD_MEMBERS_URL = "addBoardMember";
    public static final String UPDATE_BOARD_MEMBERS_URL = "editBoardMember";

    public static final String FIND_BOARD_MEMBERS_LIST = "findBoardMembers";
    public static final String FIND_BOARD_MEMBERS_TAG = "findBoardMembers_tag";

    public static final String MY_BOARD_MEMBERS_LIST = "myBoardMember";
    public static final String MY_BOARD_MEMBERS_TAG = "myBoardMember_tag";

    public static final String ARCHIVED_BOARD_MEMBERS_LIST = "archiveBoardMemberList";
    public static final String ARCHIVED_BOARD_MEMBERS_TAG = "archiveBoardMemberList_tag";

    public static final String DEACTIVATED_BOARD_MEMBERS_LIST = "deactivateBoardMemberList";
    public static final String DEACTIVATED_BOARD_MEMBERS_TAG = "deactivateBoardMemberList_tag";

    public static final String BOARD_MEMBERS_DELETE_URL = "deleteBoardMember";
    public static final String BOARD_MEMBERS_ARCHIEVE_URL = "archiveBoardMember";
    public static final String BOARD_MEMBERS_DEACTIVATE_URL = "deactivateBoardMember";
    public static final String BOARD_MEMBERS_ACTIVATE_URL = "activateBoardMember";

    public static final String BOARD_MEMBERS_LIKE_URL = "likeBoardMember";
    public static final String BOARD_MEMBERS_LIKE_TAG = "likeBoardMember_tag";

    public static final String BOARD_MEMBERS_DISLIKE_URL = "disLikeBoardMember";
    public static final String BOARD_MEMBERS_DISLIKE_TAG = "disLikeBoardMember_tag";

    public static final String BOARD_MEMBERS_LIKERS_LIST = "boardMemberLikeList";
    public static final String BOARD_MEMBERS_LIKERS_TAG = "boardMemberLikeList_tag";

    public static final String BOARD_MEMBERS_DISLIKERS_LIST = "boardMemberDislikeList";
    public static final String BOARD_MEMBERS_DISLIKERS_TAG = "boardMemberDislikeList_tag";

    public static final String BOARD_MEMBERS_FOLLOW_URL = "followBoardMember";
    public static final String BOARD_MEMBERS_FOLLOW_TAG = "followBoardMember_tag";

    public static final String BOARD_MEMBERS_UNFOLLOW_URL = "unfollowBoardMember";
    public static final String BOARD_MEMBERS_UNFOLLOW_TAG = "unfollowBoardMember_tag";

    // Early Adopter module
    public static final String EARLY_ADOPTORS_KEYWORDS_LIST_URL = "earlyAdopterKeywordsKeywordsList";
    public static final String EARLY_ADOPTORS_KEYWORDS_LIST_TAG = "earlyAdopterKeywordsKeywordsList_tag";

    public static final String EARLY_ADOPTORS_INTEREST_KEYWORDS_LIST_URL = "earlyAdopterInterestKeywordLists";
    public static final String EARLY_ADOPTORS_INTEREST_KEYWORDS_LIST_TAG = "earlyAdopterInterestKeywordLists_tag";

    public static final String EARLY_ADOPTORS_TARGET_MARKET_LIST_URL = "earlyAdopterTargetMarketsList";
    public static final String EARLY_ADOPTORS_TARGET_MARKET_LIST_TAG = "earlyAdopterTargetMarketsList_tag";

    public static final String EARLY_ADOPTORS_DETAILS_URL = "earlyAdopterDetails";
    public static final String EARLY_ADOPTORS_DETAILS_TAG = "earlyAdopterDetails_tag";

    public static final String EARLY_ADOPTORS_COMMIT_URL = "earlyCommitment";
    public static final String EARLY_ADOPTORS_COMMIT_TAG = "earlyCommitment_tag";

    public static final String EARLY_ADOPTORS_UNCOMMIT_URL = "earlyUncommitment";
    public static final String EARLY_ADOPTORS_UNCOMMIT_TAG = "earlyUncommitment_tag";

    public static final String EARLY_ADOPTORS_COMMIT_LIST = "earlyCommitmentList";
    public static final String EARLY_ADOPTORS_COMMIT_LIST_TAG = "earlyCommitmentList_tag";

    public static final String CREATE_EARLY_ADOPTORS_URL = "addEarlyAdopter";
    public static final String UPDATE_EARLY_ADOPTORS_URL = "editEarlyAdopter";

    public static final String FIND_EARLY_ADOPTORS_LIST = "findEarlyAdopters";
    public static final String FIND_EARLY_ADOPTORS_TAG = "findEarlyAdopters_tag";

    public static final String MY_EARLY_ADOPTORS_LIST = "myEarlyAdopter";
    public static final String MY_EARLY_ADOPTORS_TAG = "myEarlyAdopter_tag";

    public static final String ARCHIVED_EARLY_ADOPTORS_LIST = "archiveEarlyAdopterList";
    public static final String ARCHIVED_EARLY_ADOPTORS_TAG = "archiveEarlyAdopterList_tag";

    public static final String DEACTIVATED_EARLY_ADOPTORS_LIST = "deactivateEarlyAdopterList";
    public static final String DEACTIVATED_EARLY_ADOPTORS_TAG = "deactivateEarlyAdopterList_tag";

    public static final String EARLY_ADOPTORS_DELETE_URL = "deleteEarlyAdopter";
    public static final String EARLY_ADOPTORS_ARCHIEVE_URL = "archiveEarlyAdopter";
    public static final String EARLY_ADOPTORS_DEACTIVATE_URL = "deactivateEarlyAdopter";
    public static final String EARLY_ADOPTORS_ACTIVATE_URL = "activateEarlyAdopter";

    public static final String EARLY_ADOPTORS_LIKE_URL = "likeEarlyAdopter";
    public static final String EARLY_ADOPTORS_LIKE_TAG = "likeEarlyAdopter_tag";

    public static final String EARLY_ADOPTORS_DISLIKE_URL = "disLikeEarlyAdopter";
    public static final String EARLY_ADOPTORS_DISLIKE_TAG = "disLikeEarlyAdopter_tag";

    public static final String EARLY_ADOPTORS_LIKERS_LIST = "earlyAdopterLikeList";
    public static final String EARLY_ADOPTORS_LIKERS_TAG = "earlyAdopterLikeList_tag";

    public static final String EARLY_ADOPTORS_DISLIKERS_LIST = "earlyAdopterDislikeList";
    public static final String EARLY_ADOPTORS_DISLIKERS_TAG = "earlyAdopterDislikeList_tag";

    public static final String EARLY_ADOPTORS_FOLLOW_URL = "followEarlyAdopter";
    public static final String EARLY_ADOPTORS_FOLLOW_TAG = "followEarlyAdopter_tag";

    public static final String EARLY_ADOPTORS_UNFOLLOW_URL = "unfollowEarlyAdopter";
    public static final String EARLY_ADOPTORS_UNFOLLOW_TAG = "unfollowEarlyAdopter_tag";

    // Endorsor module
    public static final String ENDORSOR_KEYWORDS_LIST_URL = "endorsorKeywordsList";
    public static final String ENDORSOR_KEYWORDS_LIST_TAG = "endorsorKeywordsList_tag";

    public static final String ENDORSOR_INTEREST_KEYWORDS_LIST_URL = "endorsorInterestKeywordLists";
    public static final String ENDORSOR_INTEREST_KEYWORDS_LIST_TAG = "endorsorInterestKeywordLists_tag";

    public static final String ENDORSOR_TARGET_MARKET_LIST_URL = "endorsorTargetMarketsList";
    public static final String ENDORSOR_TARGET_MARKET_LIST_TAG = "endorsorTargetMarketsList_tag";

    public static final String ENDORSOR_DETAILS_URL = "endorsorDetails";
    public static final String ENDORSOR_DETAILS_TAG = "endorsorDetails_tag";

    public static final String ENDORSOR_COMMIT_URL = "endorsorCommitment";
    public static final String ENDORSOR_COMMIT_TAG = "endorsorCommitment_tag";

    public static final String ENDORSOR_UNCOMMIT_URL = "endorsorUncommitment";
    public static final String ENDORSOR_UNCOMMIT_TAG = "endorsorUncommitment_tag";

    public static final String ENDORSOR_COMMIT_LIST = "endorsorCommitmentList";
    public static final String ENDORSOR_COMMIT_LIST_TAG = "endorsorCommitmentList_tag";

    public static final String CREATE_ENDORSOR_URL = "addEndorsor";
    public static final String UPDATE_ENDORSOR_URL = "editEndorsor";

    public static final String FIND_ENDORSOR_LIST = "findEndorsors";
    public static final String FIND_ENDORSOR_TAG = "findEndorsors_tag";

    public static final String MY_ENDORSOR_LIST = "myEndorsor";
    public static final String MY_ENDORSOR_TAG = "myEndorsor_tag";

    public static final String ARCHIVED_ENDORSOR_LIST = "archiveEndorsorList";
    public static final String ARCHIVED_ENDORSOR_TAG = "archiveEndorsorList_tag";

    public static final String DEACTIVATED_ENDORSOR_LIST = "deactivateEndorsorList";
    public static final String DEACTIVATED_ENDORSOR_TAG = "deactivateEndorsorList_tag";

    public static final String ENDORSOR_DELETE_URL = "deleteEndorsor";
    public static final String ENDORSOR_ARCHIEVE_URL = "archiveEndorsor";
    public static final String ENDORSOR_DEACTIVATE_URL = "deactivateEndorsor";
    public static final String ENDORSOR_ACTIVATE_URL = "activateEndorsor";

    public static final String ENDORSOR_LIKE_URL = "likeEndorsor";
    public static final String ENDORSOR_LIKE_TAG = "likeEndorsor_tag";

    public static final String ENDORSOR_DISLIKE_URL = "disLikeEndorsor";
    public static final String ENDORSOR_DISLIKE_TAG = "disLikeEndorsor_tag";

    public static final String ENDORSOR_LIKERS_LIST = "endorsorLikeList";
    public static final String ENDORSOR_LIKERS_TAG = "endorsorLikeList_tag";

    public static final String ENDORSOR_DISLIKERS_LIST = "endorsorDislikeList";
    public static final String ENDORSOR_DISLIKERS_TAG = "endorsorDislikeList_tag";

    public static final String ENDORSOR_FOLLOW_URL = "followEndorsor";
    public static final String ENDORSOR_FOLLOW_TAG = "followEndorsor_tag";

    public static final String ENDORSOR_UNFOLLOW_URL = "unfollowEndorsor";
    public static final String ENDORSOR_UNFOLLOW_TAG = "unfollowEndorsor_tag";


    // Services Module

    public static final String SERVICES_KEYWORDS_LIST_URL = "serviceKeywordsList";
    public static final String SERVICES_KEYWORDS_LIST_TAG = "serviceKeywordsList_tag";

    public static final String SERVICES_INTEREST_KEYWORDS_LIST_URL = "serviceInterestKeywordLists";
    public static final String SERVICES_INTEREST_KEYWORDS_LIST_TAG = "serviceInterestKeywordLists_tag";

    public static final String SERVICES_TARGET_MARKET_KEYWORDS_LIST_URL = "serviceTargetMarketsList";
    public static final String SERVICES_TARGET_MARKET_KEYWORDS_LIST_TAG = "serviceTargetMarketsList_tag";

    public static final String CREATE_SERVICES_URL = "addService";
    public static final String UPDATE_SERVICES_URL = "editService";

    public static final String SERVICES_DETAILS_URL = "serviceDetails";
    public static final String SERVICES_DETAILS_TAG = "serviceDetails_tag";

    public static final String MY_SERVICES_URL = "myService";
    public static final String MY_SERVICES_TAG = "myService_tag";

    public static final String ARCHIVED_SERVICES_URL = "archiveServiceList";
    public static final String ARCHIVED_SERVICES_TAG = "archiveServiceList_tag";

    public static final String DEACTIVATED_SERVICES_LIST = "deactivateServiceList";
    public static final String DEACTIVATED_SERVICES_TAG = "deactivateServiceList_tag";

    public static final String FIND_SERVICES_LIST = "findService";
    public static final String FIND_SERVICES_TAG = "findService_tag";

    public static final String SERVICES_DELETE_URL = "deleteService";
    public static final String SERVICES_ARCHIEVE_URL = "archiveService";
    public static final String SERVICES_DEACTIVATE_URL = "deactivateService";
    public static final String SERVICES_ACTIVATE_URL = "activateService";

    public static final String SERVICES_LIKE_URL = "likeService";
    public static final String SERVICES_LIKE_TAG = "likeService_tag";

    public static final String SERVICES_DISLIKE_URL = "disLikeService";
    public static final String SERVICES_DISLIKE_TAG = "disLikeService_tag";

    public static final String SERVICES_LIKERS_LIST = "serviceLikeList";
    public static final String SERVICES_LIKERS_TAG = "serviceLikeList_tag";

    public static final String SERVICES_DISLIKERS_LIST = "serviceDislikeList";
    public static final String SERVICES_DISLIKERS_TAG = "serviceDislikeList_tag";

    public static final String SERVICES_FOLLOW_URL = "followService";
    public static final String SERVICES_FOLLOW_TAG = "followService_tag";

    public static final String SERVICES_UNFOLLOW_URL = "unfollowService";
    public static final String SERVICES_UNFOLLOW_TAG = "unfollowService_tag";

    public static final String SERVICES_COMMIT_URL = "serviceCommitment";
    public static final String SERVICES_COMMIT_TAG = "serviceCommitment_tag";

    public static final String SERVICES_UNCOMMIT_URL = "serviceUncommitment";
    public static final String SERVICES_UNCOMMIT_TAG = "serviceUncommitment_tag";

    public static final String SERVICES_COMMIT_LIST = "serviceCommitmentList";
    public static final String SERVICES_COMMIT_LIST_TAG = "serviceCommitmentList_tag";

    // Group Module

    public static final String GROUP_KEYWORDS_LIST_URL = "groupKeywordsList";
    public static final String GROUP_KEYWORDS_LIST_TAG = "groupKeywordsList_tag";

    public static final String GROUP_INTEREST_KEYWORDS_LIST_URL = "groupInterestKeywordLists";
    public static final String GROUP_INTEREST_KEYWORDS_LIST_TAG = "groupInterestKeywordLists_tag";

    public static final String GROUP_TARGET_MARKET_KEYWORDS_LIST_URL = "groupTargetMarketsList";
    public static final String GROUP_TARGET_MARKET_KEYWORDS_LIST_TAG = "groupTargetMarketsList_tag";

    public static final String CREATE_GROUP_URL = "addGroup";
    public static final String UPDATE_GROUP_URL = "editGroup";

    public static final String GROUP_DETAILS_URL = "groupDetails";
    public static final String GROUP_DETAILS_TAG = "groupDetails_tag";

    public static final String MY_GROUP_URL = "myGroup";
    public static final String MY_GROUP_TAG = "myGroup_tag";

    public static final String ARCHIVED_GROUP_URL = "archiveGroupList";
    public static final String ARCHIVED_GROUP_TAG = "archiveGroupList_tag";

    public static final String DEACTIVATED_GROUP_LIST = "deactivateGroupList";
    public static final String DEACTIVATED_GROUP_TAG = "deactivateGroupList_tag";

    public static final String FIND_GROUP_LIST = "findGroup";
    public static final String FIND_GROUP_TAG = "findGroup_tag";

    public static final String GROUP_DELETE_URL = "deleteGroup";
    public static final String GROUP_ARCHIEVE_URL = "archiveGroup";
    public static final String GROUP_DEACTIVATE_URL = "deactivateGroup";
    public static final String GROUP_ACTIVATE_URL = "activateGroup";

    public static final String GROUP_LIKE_URL = "likeGroup";
    public static final String GROUP_LIKE_TAG = "likeGroup_tag";

    public static final String GROUP_DISLIKE_URL = "disLikeGroup";
    public static final String GROUP_DISLIKE_TAG = "disLikeGroup_tag";

    public static final String GROUP_LIKERS_LIST = "groupLikeList";
    public static final String GROUP_LIKERS_TAG = "groupLikeList_tag";

    public static final String GROUP_DISLIKERS_LIST = "groupDislikeList";
    public static final String GROUP_DISLIKERS_TAG = "groupDislikeList_tag";

    public static final String GROUP_FOLLOW_URL = "followGroup";
    public static final String GROUP_FOLLOW_TAG = "followGroup_tag";

    public static final String GROUP_UNFOLLOW_URL = "unfollowGroup";
    public static final String GROUP_UNFOLLOW_TAG = "unfollowGroup_tag";

    public static final String GROUP_COMMIT_URL = "groupCommitment";
    public static final String GROUP_COMMIT_TAG = "groupCommitment_tag";

    public static final String GROUP_UNCOMMIT_URL = "groupUncommitment";
    public static final String GROUP_UNCOMMIT_TAG = "groupUncommitment_tag";

    public static final String GROUP_COMMIT_LIST = "groupCommitmentList";
    public static final String GROUP_COMMIT_LIST_TAG = "groupCommitmentList_tag";


    // Hardware Module

    public static final String HARDWARE_KEYWORDS_LIST_URL = "hardwareKeywordsList";
    public static final String HARDWARE_KEYWORDS_LIST_TAG = "hardwareKeywordsList_tag";

    public static final String HARDWARE_INTEREST_KEYWORDS_LIST_URL = "hardwareInterestKeywordLists";
    public static final String HARDWARE_INTEREST_KEYWORDS_LIST_TAG = "hardwareInterestKeywordLists_tag";

    public static final String HARDWARE_TARGET_MARKET_KEYWORDS_LIST_URL = "hardwareTargetMarketsList";
    public static final String HARDWARE_TARGET_MARKET_KEYWORDS_LIST_TAG = "hardwareTargetMarketsList_tag";

    public static final String CREATE_HARDWARE_URL = "addHardware";
    public static final String UPDATE_HARDWARE_URL = "editHardware";

    public static final String HARDWARE_DETAILS_URL = "hardwareDetails";
    public static final String HARDWARE_DETAILS_TAG = "hardwareDetails_tag";

    public static final String MY_HARDWARE_URL = "myHardware";
    public static final String MY_HARDWARE_TAG = "myHardware_tag";

    public static final String ARCHIVED_HARDWARE_URL = "archiveHardwareList";
    public static final String ARCHIVED_HARDWARE_TAG = "archiveHardwareList_tag";

    public static final String DEACTIVATED_HARDWARE_LIST = "deactivateHardwareList";
    public static final String DEACTIVATED_HARDWARE_TAG = "deactivateHardwareList_tag";

    public static final String FIND_HARDWARE_LIST = "findHardware";
    public static final String FIND_HARDWARE_TAG = "findHardware_tag";

    public static final String HARDWARE_DELETE_URL = "deleteHardware";
    public static final String HARDWARE_ARCHIEVE_URL = "archiveHardware";
    public static final String HARDWARE_DEACTIVATE_URL = "deactivateHardware";
    public static final String HARDWARE_ACTIVATE_URL = "activateHardware";

    public static final String HARDWARE_LIKE_URL = "likeHardware";
    public static final String HARDWARE_LIKE_TAG = "likeHardware_tag";

    public static final String HARDWARE_DISLIKE_URL = "disLikeHardware";
    public static final String HARDWARE_DISLIKE_TAG = "disLikeHardware_tag";

    public static final String HARDWARE_LIKERS_LIST = "hardwareLikeList";
    public static final String HARDWARE_LIKERS_TAG = "hardwareLikeList_tag";

    public static final String HARDWARE_DISLIKERS_LIST = "hardwareDislikeList";
    public static final String HARDWARE_DISLIKERS_TAG = "hardwareDislikeList_tag";

    public static final String HARDWARE_FOLLOW_URL = "followHardware";
    public static final String HARDWARE_FOLLOW_TAG = "followHardware_tag";

    public static final String HARDWARE_UNFOLLOW_URL = "unfollowHardware";
    public static final String HARDWARE_UNFOLLOW_TAG = "unfollowHardware_tag";

    public static final String HARDWARE_COMMIT_URL = "hardwareCommitment";
    public static final String HARDWARE_COMMIT_TAG = "hardwareCommitment_tag";

    public static final String HARDWARE_UNCOMMIT_URL = "hardwareUncommitment";
    public static final String HARDWARE_UNCOMMIT_TAG = "hardwareUncommitment_tag";

    public static final String HARDWARE_COMMIT_LIST = "hardwareCommitmentList";
    public static final String HARDWARE_COMMIT_LIST_TAG = "hardwareCommitmentList_tag";


    //Demo Days Module

    public static final String DEMODAYS_KEYWORDS_LIST_URL = "demodayKeywordsList";
    public static final String DEMODAYS_KEYWORDS_LIST_TAG = "demodayKeywordsList_tag";

    public static final String DEMODAYS_INTEREST_KEYWORDS_LIST_URL = "demodayInterestKeywordLists";
    public static final String DEMODAYS_INTEREST_KEYWORDS_LIST_TAG = "demodayInterestKeywordLists_tag";

    public static final String DEMODAYS_TARGET_MARKET_KEYWORDS_LIST_URL = "demodayTargetMarketsList";
    public static final String DEMODAYS_TARGET_MARKET_KEYWORDS_LIST_TAG = "demodayTargetMarketsList_tag";

    public static final String CREATE_DEMODAYS_URL = "addDemoday";
    public static final String UPDATE_DEMODAYS_URL = "editDemoday";

    public static final String DEMODAYS_DETAILS_URL = "demodayDetails";
    public static final String DEMODAYS_DETAILS_TAG = "demodayDetails_tag";

    public static final String MY_DEMODAYS_URL = "myDemoday";
    public static final String MY_DEMODAYS_TAG = "myDemoday_tag";

    public static final String ARCHIVED_DEMODAYS_URL = "archiveDemodayList";
    public static final String ARCHIVED_DEMODAYS_TAG = "archiveDemodayList_tag";

    public static final String DEACTIVATED_DEMODAYS_LIST = "deactivateDemodayList";
    public static final String DEACTIVATED_DEMODAYS_TAG = "deactivateDemodayList_tag";

    public static final String FIND_DEMODAYS_LIST = "findDemoday";
    public static final String FIND_DEMODAYS_TAG = "findDemoday_tag";

    public static final String DEMODAYS_DELETE_URL = "deleteDemoday";
    public static final String DEMODAYS_ARCHIEVE_URL = "archiveDemoday";
    public static final String DEMODAYS_DEACTIVATE_URL = "deactivateDemoday";
    public static final String DEMODAYS_ACTIVATE_URL = "activateDemoday";

    public static final String DEMODAYS_LIKE_URL = "likeDemoday";
    public static final String DEMODAYS_LIKE_TAG = "likeDemoday_tag";

    public static final String DEMODAYS_DISLIKE_URL = "disLikeDemoday";
    public static final String DEMODAYS_DISLIKE_TAG = "disLikeDemoday_tag";

    public static final String DEMODAYS_LIKERS_LIST = "demodayLikeList";
    public static final String DEMODAYS_LIKERS_TAG = "demodayLikeList_tag";

    public static final String DEMODAYS_DISLIKERS_LIST = "demodayDislikeList";
    public static final String DEMODAYS_DISLIKERS_TAG = "demodayDislikeList_tag";

    public static final String DEMODAYS_FOLLOW_URL = "followDemoday";
    public static final String DEMODAYS_FOLLOW_TAG = "followDemoday_tag";

    public static final String DEMODAYS_UNFOLLOW_URL = "unfollowDemoday";
    public static final String DEMODAYS_UNFOLLOW_TAG = "unfollowDemoday_tag";

    public static final String DEMODAYS_COMMIT_URL = "demodayCommitment";
    public static final String DEMODAYS_COMMIT_TAG = "demodayCommitment_tag";

    public static final String DEMODAYS_UNCOMMIT_URL = "demodayUncommitment";
    public static final String DEMODAYS_UNCOMMIT_TAG = "demodayUncommitment_tag";

    public static final String DEMODAYS_COMMIT_LIST = "demodayCommitmentList";
    public static final String DEMODAYS_COMMIT_LIST_TAG = "demodayCommitmentList_tag";


    //Conferences Module

    public static final String CONFERENCE_KEYWORDS_LIST_URL = "conferenceKeywordsList";
    public static final String CONFERENCE_KEYWORDS_LIST_TAG = "conferenceKeywordsList_tag";

    public static final String CONFERENCE_INTEREST_KEYWORDS_LIST_URL = "conferenceInterestKeywordLists";
    public static final String CONFERENCE_INTEREST_KEYWORDS_LIST_TAG = "conferenceInterestKeywordLists_tag";

    public static final String CONFERENCE_TARGET_MARKET_KEYWORDS_LIST_URL = "conferenceTargetMarketsList";
    public static final String CONFERENCE_TARGET_MARKET_KEYWORDS_LIST_TAG = "conferenceTargetMarketsList_tag";

    public static final String CREATE_CONFERENCE_URL = "addConference";
    public static final String UPDATE_CONFERENCE_URL = "editConference";

    public static final String CONFERENCE_DETAILS_URL = "conferenceDetails";
    public static final String CONFERENCE_DETAILS_TAG = "conferenceDetails_tag";

    public static final String MY_CONFERENCE_URL = "myConference";
    public static final String MY_CONFERENCE_TAG = "myConference_tag";

    public static final String ARCHIVED_CONFERENCE_URL = "archiveConferenceList";
    public static final String ARCHIVED_CONFERENCE_TAG = "archiveConferenceList_tag";

    public static final String DEACTIVATED_CONFERENCE_LIST = "deactivateConferenceList";
    public static final String DEACTIVATED_CONFERENCE_TAG = "deactivateConferenceList_tag";

    public static final String FIND_CONFERENCE_LIST = "findConference";
    public static final String FIND_CONFERENCE_TAG = "findConference_tag";

    public static final String CONFERENCE_DELETE_URL = "deleteConference";
    public static final String CONFERENCE_ARCHIEVE_URL = "archiveConference";
    public static final String CONFERENCE_DEACTIVATE_URL = "deactivateConference";
    public static final String CONFERENCE_ACTIVATE_URL = "activateConference";

    public static final String CONFERENCE_LIKE_URL = "likeConference";
    public static final String CONFERENCE_LIKE_TAG = "likeConference_tag";

    public static final String CONFERENCE_DISLIKE_URL = "disLikeConference";
    public static final String CONFERENCE_DISLIKE_TAG = "disLikeConference_tag";

    public static final String CONFERENCE_LIKERS_LIST = "conferenceLikeList";
    public static final String CONFERENCE_LIKERS_TAG = "conferenceLikeList_tag";

    public static final String CONFERENCE_DISLIKERS_LIST = "conferenceDislikeList";
    public static final String CONFERENCE_DISLIKERS_TAG = "conferenceDislikeList_tag";

    public static final String CONFERENCE_FOLLOW_URL = "followConference";
    public static final String CONFERENCE_FOLLOW_TAG = "followConference_tag";

    public static final String CONFERENCE_UNFOLLOW_URL = "unfollowConference";
    public static final String CONFERENCE_UNFOLLOW_TAG = "unfollowConference_tag";

    public static final String CONFERENCE_COMMIT_URL = "conferenceCommitment";
    public static final String CONFERENCE_COMMIT_TAG = "conferenceCommitment_tag";

    public static final String CONFERENCE_UNCOMMIT_URL = "conferenceUncommitment";
    public static final String CONFERENCE_UNCOMMIT_TAG = "conferenceUncommitment_tag";

    public static final String CONFERENCE_COMMIT_LIST = "conferenceCommitmentList";
    public static final String CONFERENCE_COMMIT_LIST_TAG = "conferenceCommitmentList_tag";


    //Meetups Module


    public static final String MEETUPS_KEYWORDS_LIST_URL = "meetupKeywordsList";
    public static final String MEETUPS_KEYWORDS_LIST_TAG = "meetupKeywordsList_tag";

    public static final String MEETUPS_INTEREST_KEYWORDS_LIST_URL = "meetupInterestKeywordLists";
    public static final String MEETUPS_INTEREST_KEYWORDS_LIST_TAG = "meetupInterestKeywordLists_tag";

    public static final String MEETUPS_TARGET_MARKET_KEYWORDS_LIST_URL = "meetupTargetMarketsList";
    public static final String MEETUPS_TARGET_MARKET_KEYWORDS_LIST_TAG = "meetupTargetMarketsList_tag";

    public static final String CREATE_MEETUPS_URL = "addMeetup";
    public static final String UPDATE_MEETUPS_URL = "editMeetup";

    public static final String MEETUPS_DETAILS_URL = "meetupDetails";
    public static final String MEETUPS_DETAILS_TAG = "meetupDetails_tag";

    public static final String MY_MEETUPS_URL = "myMeetup";
    public static final String MY_MEETUPS_TAG = "myMeetup_tag";

    public static final String ARCHIVED_MEETUPS_URL = "archiveMeetupList";
    public static final String ARCHIVED_MEETUPS_TAG = "archiveMeetupList_tag";

    public static final String DEACTIVATED_MEETUPS_LIST = "deactivateMeetupList";
    public static final String DEACTIVATED_MEETUPS_TAG = "deactivatemMeetupList_tag";

    public static final String FIND_MEETUPS_LIST = "findMeetup";
    public static final String FIND_MEETUPS_TAG = "findMeetup_tag";

    public static final String MEETUPS_DELETE_URL = "deleteMeetup";
    public static final String MEETUPS_ARCHIEVE_URL = "archiveMeetup";
    public static final String MEETUPS_DEACTIVATE_URL = "deactivateMeetup";
    public static final String MEETUPS_ACTIVATE_URL = "activateMeetup";

    public static final String MEETUPS_LIKE_URL = "likeMeetup";
    public static final String MEETUPS_LIKE_TAG = "likeMeetup_tag";

    public static final String MEETUPS_DISLIKE_URL = "disLikeMeetup";
    public static final String MEETUPS_DISLIKE_TAG = "disLikeMeetup_tag";

    public static final String MEETUPS_LIKERS_LIST = "MeetupLikeList";
    public static final String MEETUPS_LIKERS_TAG = "MeetupLikeList_tag";

    public static final String MEETUPS_DISLIKERS_LIST = "meetupDislikeList";
    public static final String MEETUPS_DISLIKERS_TAG = "meetupDislikeList_tag";

    public static final String MEETUPS_FOLLOW_URL = "followMeetup";
    public static final String MEETUPS_FOLLOW_TAG = "followMeetup_tag";

    public static final String MEETUPS_UNFOLLOW_URL = "unfollowMeetup";
    public static final String MEETUPS_UNFOLLOW_TAG = "unfollowMeetup_tag";

    public static final String MEETUPS_COMMIT_URL = "meetupCommitment";
    public static final String MEETUPS_COMMIT_TAG = "meetupCommitment_tag";

    public static final String MEETUPS_UNCOMMIT_URL = "meetupUncommitment";
    public static final String MEETUPS_UNCOMMIT_TAG = "meetupUncommitment_tag";

    public static final String MEETUPS_COMMIT_LIST = "meetupCommitmentList";
    public static final String MEETUPS_COMMIT_LIST_TAG = "meetupCommitmentList_tag";


    //Launch Deals

    public static final String LAUNCHDEAL_KEYWORDS_LIST_URL = "launchdealKeywordsList";
    public static final String LAUNCHDEAL_KEYWORDS_LIST_TAG = "launchdealKeywordsList_tag";

    public static final String LAUNCHDEAL_INTEREST_KEYWORDS_LIST_URL = "launchdealInterestKeywordLists";
    public static final String LAUNCHDEAL_INTEREST_KEYWORDS_LIST_TAG = "launchdealInterestKeywordLists_tag";

    public static final String LAUNCHDEAL_TARGET_MARKET_KEYWORDS_LIST_URL = "launchdealTargetMarketsList";
    public static final String LAUNCHDEAL_TARGET_MARKET_KEYWORDS_LIST_TAG = "launchdealTargetMarketsList_tag";

    public static final String CREATE_LAUNCHDEAL_URL = "addLaunchdeal";
    public static final String UPDATE_LAUNCHDEAL_URL = "editLaunchdeal";

    public static final String LAUNCHDEAL_DETAILS_URL = "launchdealDetails";
    public static final String LAUNCHDEAL_DETAILS_TAG = "launchdealDetails_tag";

    public static final String MY_LAUNCHDEAL_URL = "myLaunchdeal";
    public static final String MY_LAUNCHDEAL_TAG = "myLaunchdeal_tag";

    public static final String ARCHIVED_LAUNCHDEAL_URL = "archiveLaunchdealList";
    public static final String ARCHIVED_LAUNCHDEAL_TAG = "archiveLaunchdealList_tag";

    public static final String DEACTIVATED_LAUNCHDEAL_LIST = "deactivateLaunchdealList";
    public static final String DEACTIVATED_LAUNCHDEAL_TAG = "deactivateLaunchdealList_tag";

    public static final String FIND_LAUNCHDEAL_LIST = "findLaunchdeal";
    public static final String FIND_LAUNCHDEAL_TAG = "findLaunchdeal_tag";

    public static final String LAUNCHDEAL_DELETE_URL = "deleteLaunchdeal";
    public static final String LAUNCHDEAL_ARCHIEVE_URL = "archiveLaunchdeal";
    public static final String LAUNCHDEAL_DEACTIVATE_URL = "deactivateLaunchdeal";
    public static final String LAUNCHDEAL_ACTIVATE_URL = "activateLaunchdeal";

    public static final String LAUNCHDEAL_LIKE_URL = "likeLaunchdeal";
    public static final String LAUNCHDEAL_LIKE_TAG = "likeLaunchdeal_tag";

    public static final String LAUNCHDEAL_DISLIKE_URL = "disLikeLaunchdeal";
    public static final String LAUNCHDEAL_DISLIKE_TAG = "disLikeLaunchdeal_tag";

    public static final String LAUNCHDEAL_LIKERS_LIST = "launchdealLikeList";
    public static final String LAUNCHDEAL_LIKERS_TAG = "launchdealLikeList_tag";

    public static final String LAUNCHDEAL_DISLIKERS_LIST = "launchdealDislikeList";
    public static final String LAUNCHDEAL_DISLIKERS_TAG = "launchdealDislikeList_tag";

    public static final String LAUNCHDEAL_FOLLOW_URL = "followLaunchdeal";
    public static final String LAUNCHDEAL_FOLLOW_TAG = "followLaunchdeal_tag";

    public static final String LAUNCHDEAL_UNFOLLOW_URL = "unfollowLaunchdeal";
    public static final String LAUNCHDEAL_UNFOLLOW_TAG = "unfollowLaunchdeal_tag";

    public static final String LAUNCHDEAL_COMMIT_URL = "launchdealCommitment";
    public static final String LAUNCHDEAL_COMMIT_TAG = "launchdealCommitment_tag";

    public static final String LAUNCHDEAL_UNCOMMIT_URL = "launchdealUncommitment";
    public static final String LAUNCHDEAL_UNCOMMIT_TAG = "launchdealUncommitment_tag";

    public static final String LAUNCHDEAL_COMMIT_LIST = "launchdealCommitmentList";
    public static final String LAUNCHDEAL_COMMIT_LIST_TAG = "launchdealCommitmentList_tag";


    // Career Advancement

    public static final String CAREERADVANCEMENT_KEYWORDS_LIST_URL = "careerKeywordsList";
    public static final String CAREERADVANCEMENT_KEYWORDS_LIST_TAG = "careerKeywordsList_tag";

    public static final String CAREERADVANCEMENT_INTEREST_KEYWORDS_LIST_URL = "careerInterestKeywordLists";
    public static final String CAREERADVANCEMENT_INTEREST_KEYWORDS_LIST_TAG = "careerInterestKeywordLists_tag";

    public static final String CAREERADVANCEMENT_TARGET_MARKET_KEYWORDS_LIST_URL = "careerTargetMarketsList";
    public static final String CAREERADVANCEMENT_TARGET_MARKET_KEYWORDS_LIST_TAG = "careerTargetMarketsList_tag";

    public static final String CREATE_CAREERADVANCEMENT_URL = "addCareer";
    public static final String UPDATE_CAREERADVANCEMENT_URL = "editCareer";

    public static final String CAREERADVANCEMENT_DETAILS_URL = "careerDetails";
    public static final String CAREERADVANCEMENT_DETAILS_TAG = "careerDetails_tag";

    public static final String MY_CAREERADVANCEMENT_URL = "myCareer";
    public static final String MY_CAREERADVANCEMENT_TAG = "myCareer_tag";

    public static final String ARCHIVED_CAREERADVANCEMENT_URL = "archiveCareerList";
    public static final String ARCHIVED_CAREERADVANCEMENT_TAG = "archiveCareerList_tag";

    public static final String DEACTIVATED_CAREERADVANCEMENT_LIST = "deactivateCareerList";
    public static final String DEACTIVATED_CAREERADVANCEMENT_TAG = "deactivateCareerList_tag";

    public static final String FIND_CAREERADVANCEMENT_LIST = "findCareer";
    public static final String FIND_CAREERADVANCEMENT_TAG = "findCareer_tag";

    public static final String CAREERADVANCEMENT_DELETE_URL = "deleteCareer";
    public static final String CAREERADVANCEMENT_ARCHIEVE_URL = "archiveCareer";
    public static final String CAREERADVANCEMENT_DEACTIVATE_URL = "deactivateCareer";
    public static final String CAREERADVANCEMENT_ACTIVATE_URL = "activateCareer";

    public static final String CAREERADVANCEMENT_LIKE_URL = "likeCareer";
    public static final String CAREERADVANCEMENT_LIKE_TAG = "likeCareer_tag";

    public static final String CAREERADVANCEMENT_DISLIKE_URL = "disLikeCareer";
    public static final String CAREERADVANCEMENT_DISLIKE_TAG = "disLikeCareer_tag";

    public static final String CAREERADVANCEMENT_LIKERS_LIST = "careerLikeList";
    public static final String CAREERADVANCEMENT_LIKERS_TAG = "careerLikeList_tag";

    public static final String CAREERADVANCEMENT_DISLIKERS_LIST = "careerDislikeList";
    public static final String CAREERADVANCEMENT_DISLIKERS_TAG = "careerDislikeList_tag";

    public static final String CAREERADVANCEMENT_FOLLOW_URL = "followCareer";
    public static final String CAREERADVANCEMENT_FOLLOW_TAG = "followCareer_tag";

    public static final String CAREERADVANCEMENT_UNFOLLOW_URL = "unfollowCareer";
    public static final String CAREERADVANCEMENT_UNFOLLOW_TAG = "unfollowCareera_tag";

    public static final String CAREERADVANCEMENT_COMMIT_URL = "careerCommitment";
    public static final String CAREERADVANCEMENT_COMMIT_TAG = "careerCommitment_tag";

    public static final String CAREERADVANCEMENT_UNCOMMIT_URL = "careerUncommitment";
    public static final String CAREERADVANCEMENT_UNCOMMIT_TAG = "careerUncommitment_tag";

    public static final String CAREERADVANCEMENT_COMMIT_LIST = "careerCommitmentList";
    public static final String CAREERADVANCEMENT_COMMIT_LIST_TAG = "careerCommitmentList_tag";


    // Communal Assets


    public static final String COMMUNALASSET_KEYWORDS_LIST_URL = "communalassetKeywordsList";
    public static final String COMMUNALASSET_KEYWORDS_LIST_TAG = "communalassetKeywordsList_tag";

    public static final String COMMUNALASSET_INTEREST_KEYWORDS_LIST_URL = "communalassetInterestKeywordLists";
    public static final String COMMUNALASSET_INTEREST_KEYWORDS_LIST_TAG = "communalassetInterestKeywordLists_tag";

    public static final String COMMUNALASSET_TARGET_MARKET_KEYWORDS_LIST_URL = "communalassetTargetMarketsList";
    public static final String COMMUNALASSET_TARGET_MARKET_KEYWORDS_LIST_TAG = "communalassetTargetMarketsList_tag";

    public static final String CREATE_COMMUNALASSET_URL = "addCommunalasset";
    public static final String UPDATE_COMMUNALASSET_URL = "editCommunalasset";

    public static final String COMMUNALASSET_DETAILS_URL = "CommunalassetDetails";
    public static final String COMMUNALASSET_DETAILS_TAG = "CommunalassetDetails_tag";

    public static final String MY_COMMUNALASSET_URL = "myCommunalasset";
    public static final String MY_COMMUNALASSET_TAG = "myCommunalasset_tag";

    public static final String ARCHIVED_COMMUNALASSET_URL = "archiveCommunalassetList";
    public static final String ARCHIVED_COMMUNALASSET_TAG = "archiveCommunalassetList_tag";

    public static final String DEACTIVATED_COMMUNALASSET_LIST = "deactivateCommunalassetList";
    public static final String DEACTIVATED_COMMUNALASSET_TAG = "deactivateCommunalassetList_tag";

    public static final String FIND_COMMUNALASSET_LIST = "findCommunalasset";
    public static final String FIND_COMMUNALASSET_TAG = "findCommunalasset_tag";

    public static final String COMMUNALASSET_DELETE_URL = "deleteCommunalasset";
    public static final String COMMUNALASSET_ARCHIEVE_URL = "archiveCommunalasset";
    public static final String COMMUNALASSET_DEACTIVATE_URL = "deactivateCommunalasset";
    public static final String COMMUNALASSET_ACTIVATE_URL = "activateCommunalasset";

    public static final String COMMUNALASSET_LIKE_URL = "likeCommunalasset";
    public static final String COMMUNALASSET_LIKE_TAG = "likeCommunalasset_tag";

    public static final String COMMUNALASSET_DISLIKE_URL = "disLikeCommunalasset";
    public static final String COMMUNALASSET_DISLIKE_TAG = "disLikeCommunalasset_tag";

    public static final String COMMUNALASSET_LIKERS_LIST = "communalassetLikeList";
    public static final String COMMUNALASSET_LIKERS_TAG = "communalassetLikeList_tag";

    public static final String COMMUNALASSET_DISLIKERS_LIST = "communalassetDislikeList";
    public static final String COMMUNALASSET_DISLIKERS_TAG = "communalassetDislikeList_tag";

    public static final String COMMUNALASSET_FOLLOW_URL = "followCommunalasset";
    public static final String COMMUNALASSET_FOLLOW_TAG = "followCommunalasset_tag";

    public static final String COMMUNALASSET_UNFOLLOW_URL = "unfollowCommunalasset";
    public static final String COMMUNALASSET_UNFOLLOW_TAG = "unfollowCommunalasset_tag";

    public static final String COMMUNALASSET_COMMIT_URL = "communalassetCommitment";
    public static final String COMMUNALASSET_COMMIT_TAG = "communalassetCommitment_tag";

    public static final String COMMUNALASSET_UNCOMMIT_URL = "communalassetUncommitment";
    public static final String COMMUNALASSET_UNCOMMIT_TAG = "communalassetUncommitment_tag";

    public static final String COMMUNALASSET_COMMIT_LIST = "communalassetCommitmentList";
    public static final String COMMUNALASSET_COMMIT_LIST_TAG = "communalassetCommitmentList_tag";


    // Self Improvement Tool
    public static final String SELFIMPROVEMENT_KEYWORDS_LIST_URL = "selfimprovementKeywordsList";
    public static final String SELFIMPROVEMENT_KEYWORDS_LIST_TAG = "selfimprovementKeywordsList_tag";

    public static final String SELFIMPROVEMENT_INTEREST_KEYWORDS_LIST_URL = "selfimprovementInterestKeywordLists";
    public static final String SELFIMPROVEMENT_INTEREST_KEYWORDS_LIST_TAG = "selfimprovementInterestKeywordLists_tag";

    public static final String SELFIMPROVEMENT_TARGET_MARKET_KEYWORDS_LIST_URL = "selfimprovementTargetMarketsList";
    public static final String SELFIMPROVEMENT_TARGET_MARKET_KEYWORDS_LIST_TAG = "selfimprovementTargetMarketsList_tag";

    public static final String CREATE_SELFIMPROVEMENT_URL = "addSelfimprovement";
    public static final String UPDATE_SELFIMPROVEMENT_URL = "editSelfimprovement";

    public static final String SELFIMPROVEMENT_DETAILS_URL = "selfimprovementDetails";
    public static final String SELFIMPROVEMENT_DETAILS_TAG = "selfimprovementDetails_tag";

    public static final String MY_SELFIMPROVEMENT_URL = "mySelfimprovement";
    public static final String MY_SELFIMPROVEMENT_TAG = "mySelfimprovement_tag";

    public static final String ARCHIVED_SELFIMPROVEMENT_URL = "archiveSelfimprovementList";
    public static final String ARCHIVED_SELFIMPROVEMENT_TAG = "archiveSelfimprovementList_tag";

    public static final String DEACTIVATED_SELFIMPROVEMENT_LIST = "deactivateSelfimprovementList";
    public static final String DEACTIVATED_SELFIMPROVEMENT_TAG = "deactivateSelfimprovementList_tag";

    public static final String FIND_SELFIMPROVEMENT_LIST = "findSelfimprovement";
    public static final String FIND_SELFIMPROVEMENT_TAG = "findSelfimprovement_tag";

    public static final String SELFIMPROVEMENT_DELETE_URL = "deleteSelfimprovement";
    public static final String SELFIMPROVEMENT_ARCHIEVE_URL = "archiveSelfimprovement";
    public static final String SELFIMPROVEMENT_DEACTIVATE_URL = "deactivateSelfimprovement";
    public static final String SELFIMPROVEMENT_ACTIVATE_URL = "activateSelfimprovement";

    public static final String SELFIMPROVEMENT_LIKE_URL = "likeSelfimprovement";
    public static final String SELFIMPROVEMENT_LIKE_TAG = "likeSelfimprovement_tag";

    public static final String SELFIMPROVEMENT_DISLIKE_URL = "disLikeSelfimprovement";
    public static final String SELFIMPROVEMENT_DISLIKE_TAG = "disLikeSelfimprovement_tag";

    public static final String SELFIMPROVEMENT_LIKERS_LIST = "selfimprovementLikeList";
    public static final String SELFIMPROVEMENT_LIKERS_TAG = "selfimprovementLikeList_tag";

    public static final String SELFIMPROVEMENT_DISLIKERS_LIST = "selfimprovementDislikeList";
    public static final String SELFIMPROVEMENT_DISLIKERS_TAG = "selfimprovementDislikeList_tag";

    public static final String SELFIMPROVEMENT_FOLLOW_URL = "followSelfimprovement";
    public static final String SELFIMPROVEMENT_FOLLOW_TAG = "followSelfimprovement_tag";

    public static final String SELFIMPROVEMENT_UNFOLLOW_URL = "unfollowSelfimprovement";
    public static final String SELFIMPROVEMENT_UNFOLLOW_TAG = "unfollowSelfimprovement_tag";

    public static final String SELFIMPROVEMENT_COMMIT_URL = "selfimprovementCommitment";
    public static final String SELFIMPROVEMENT_COMMIT_TAG = "selfimprovementCommitment_tag";

    public static final String SELFIMPROVEMENT_UNCOMMIT_URL = "selfimprovementUncommitment";
    public static final String SELFIMPROVEMENT_UNCOMMIT_TAG = "selfimprovementUncommitment_tag";

    public static final String SELFIMPROVEMENT_COMMIT_LIST = "selfimprovementCommitmentList";
    public static final String SELFIMPROVEMENT_COMMIT_LIST_TAG = "selfimprovementCommitmentList_tag";

    //CREATE FEEDS
    public static final String CREATE_FEEEDS_URL = "addFeed";

    public static final String SETTINGS_PREFS_URL = "settingList";
    public static final String SETTINGS_PREFS_TAG = "settingList_tag";


    // Webinar Module

    public static final String WEBINAR_KEYWORDS_LIST_URL = "webinarKeywordsList";
    public static final String WEBINAR_KEYWORDS_LIST_TAG = "webinarKeywordsList_tag";

    public static final String WEBINAR_INTEREST_KEYWORDS_LIST_URL = "webinarInterestKeywordLists";
    public static final String WEBINAR_INTEREST_KEYWORDS_LIST_TAG = "webinarInterestKeywordLists_tag";

    public static final String WEBINAR_TARGET_MARKET_KEYWORDS_LIST_URL = "webinarTargetMarketsList";
    public static final String WEBINAR_TARGET_MARKET_KEYWORDS_LIST_TAG = "webinarTargetMarketsList_tag";

    public static final String CREATE_WEBINAR_URL = "addWebinar";
    public static final String UPDATE_WEBINAR_URL = "editWebinar";

    public static final String WEBINAR_DETAILS_URL = "webinarDetails";
    public static final String WEBINAR_DETAILS_TAG = "webinarDetails_tag";

    public static final String MY_WEBINAR_URL = "myWebinar";
    public static final String MY_WEBINAR_TAG = "myWebinar_tag";

    public static final String ARCHIVED_WEBINAR_URL = "archiveWebinarList";
    public static final String ARCHIVED_WEBINAR_TAG = "archiveWebinarList_tag";

    public static final String DEACTIVATED_WEBINAR_LIST = "deactivateWebinarList";
    public static final String DEACTIVATED_WEBINAR_TAG = "deactivateWebinarList_tag";

    public static final String FIND_WEBINAR_LIST = "findWebinar";
    public static final String FIND_WEBINAR_TAG = "findWebinar_tag";

    public static final String WEBINAR_DELETE_URL = "deleteWebinar";
    public static final String WEBINAR_ARCHIEVE_URL = "archiveWebinar";
    public static final String WEBINAR_DEACTIVATE_URL = "deactivateWebinar";
    public static final String WEBINAR_ACTIVATE_URL = "activateWebinar";

    public static final String WEBINAR_LIKE_URL = "likeWebinar";
    public static final String WEBINAR_LIKE_TAG = "likeWebinar_tag";

    public static final String WEBINAR_DISLIKE_URL = "disLikeWebinar";
    public static final String WEBINAR_DISLIKE_TAG = "disLikeWebinar_tag";

    public static final String WEBINAR_LIKERS_LIST = "webinarLikeList";
    public static final String WEBINAR_LIKERS_TAG = "webinarLikeList_tag";

    public static final String WEBINAR_DISLIKERS_LIST = "webinarDislikeList";
    public static final String WEBINAR_DISLIKERS_TAG = "webinarDislikeList_tag";

    public static final String WEBINAR_FOLLOW_URL = "followWebinar";
    public static final String WEBINAR_FOLLOW_TAG = "followWebinar_tag";

    public static final String WEBINAR_UNFOLLOW_URL = "unfollowWebinar";
    public static final String WEBINAR_UNFOLLOW_TAG = "unfollowWebinar_tag";

    public static final String WEBINAR_COMMIT_URL = "webinarCommitment";
    public static final String WEBINAR_COMMIT_TAG = "webinarCommitment_tag";

    public static final String WEBINAR_UNCOMMIT_URL = "webinarUncommitment";
    public static final String WEBINAR_UNCOMMIT_TAG = "webinarUncommitment_tag";

    public static final String WEBINAR_COMMIT_LIST = "webinarCommitmentList";
    public static final String WEBINAR_COMMIT_LIST_TAG = "webinarCommitmentList_tag";


    //Software Module

    public static final String SOFTWARE_KEYWORDS_LIST_URL = "softwareKeywordsList";
    public static final String SOFTWARE_KEYWORDS_LIST_TAG = "softwareKeywordsList_tag";

    public static final String SOFTWARE_INTEREST_KEYWORDS_LIST_URL = "softwareInterestKeywordLists";
    public static final String SOFTWARE_INTEREST_KEYWORDS_LIST_TAG = "softwareInterestKeywordLists_tag";

    public static final String SOFTWARE_TARGET_MARKET_KEYWORDS_LIST_URL = "softwareTargetMarketsList";
    public static final String SOFTWARE_TARGET_MARKET_KEYWORDS_LIST_TAG = "softwareTargetMarketsList_tag";

    public static final String CREATE_SOFTWARE_URL = "addSoftware";
    public static final String UPDATE_SOFTWARE_URL = "editSoftware";

    public static final String SOFTWARE_DETAILS_URL = "softwareDetails";
    public static final String SOFTWARE_DETAILS_TAG = "softwareDetails_tag";

    public static final String MY_SOFTWARE_URL = "mySoftware";
    public static final String MY_SOFTWARE_TAG = "mySoftware_tag";

    public static final String ARCHIVED_SOFTWARE_URL = "archiveSoftwareList";
    public static final String ARCHIVED_SOFTWARE_TAG = "archiveSoftwareList_tag";

    public static final String DEACTIVATED_SOFTWARE_LIST = "deactivateSoftwareList";
    public static final String DEACTIVATED_SOFTWARE_TAG = "deactivateSoftwareList_tag";

    public static final String FIND_SOFTWARE_LIST = "findSoftware";
    public static final String FIND_SOFTWARE_TAG = "findSoftware_tag";

    public static final String SOFTWARE_DELETE_URL = "deleteSoftware";
    public static final String SOFTWARE_ARCHIEVE_URL = "archiveSoftware";
    public static final String SOFTWARE_DEACTIVATE_URL = "deactivateSoftware";
    public static final String SOFTWARE_ACTIVATE_URL = "activateSoftware";

    public static final String SOFTWARE_LIKE_URL = "likeSoftware";
    public static final String SOFTWARE_LIKE_TAG = "likeSoftware_tag";

    public static final String SOFTWARE_DISLIKE_URL = "disLikeSoftware";
    public static final String SOFTWARE_DISLIKE_TAG = "disLikeSoftware_tag";

    public static final String SOFTWARE_LIKERS_LIST = "softwareLikeList";
    public static final String SOFTWARE_LIKERS_TAG = "softwareLikeList_tag";

    public static final String SOFTWARE_DISLIKERS_LIST = "softwareDislikeList";
    public static final String SOFTWARE_DISLIKERS_TAG = "softwareDislikeList_tag";

    public static final String SOFTWARE_FOLLOW_URL = "followSoftware";
    public static final String SOFTWARE_FOLLOW_TAG = "followSoftware_tag";

    public static final String SOFTWARE_UNFOLLOW_URL = "unfollowSoftware";
    public static final String SOFTWARE_UNFOLLOW_TAG = "unfollowSoftware_tag";

    public static final String SOFTWARE_COMMIT_URL = "softwareCommitment";
    public static final String SOFTWARE_COMMIT_TAG = "softwareCommitment_tag";

    public static final String SOFTWARE_UNCOMMIT_URL = "softwareUncommitment";
    public static final String SOFTWARE_UNCOMMIT_TAG = "softwareUncommitment_tag";

    public static final String SOFTWARE_COMMIT_LIST = "softwareCommitmentList";
    public static final String SOFTWARE_COMMIT_LIST_TAG = "softwareCommitmentList_tag";


    // Productivity Module

    public static final String PRODUCTIVITY_KEYWORDS_LIST_URL = "productivityKeywordsList";
    public static final String PRODUCTIVITY_KEYWORDS_LIST_TAG = "productivityKeywordsList_tag";

    public static final String PRODUCTIVITY_INTEREST_KEYWORDS_LIST_URL = "productivityInterestKeywordLists";
    public static final String PRODUCTIVITY_INTEREST_KEYWORDS_LIST_TAG = "productivityInterestKeywordLists_tag";

    public static final String PRODUCTIVITY_TARGET_MARKET_KEYWORDS_LIST_URL = "productivityTargetMarketsList";
    public static final String PRODUCTIVITY_TARGET_MARKET_KEYWORDS_LIST_TAG = "productivityTargetMarketsList_tag";

    public static final String CREATE_PRODUCTIVITY_URL = "addProductivity";
    public static final String UPDATE_PRODUCTIVITY_URL = "editProductivity";

    public static final String PRODUCTIVITY_DETAILS_URL = "productivityDetails";
    public static final String PRODUCTIVITY_DETAILS_TAG = "productivityDetails_tag";

    public static final String MY_PRODUCTIVITY_URL = "myProductivity";
    public static final String MY_PRODUCTIVITY_TAG = "myProductivity_tag";

    public static final String ARCHIVED_PRODUCTIVITY_URL = "archiveProductivityList";
    public static final String ARCHIVED_PRODUCTIVITY_TAG = "archiveProductivityList_tag";

    public static final String DEACTIVATED_PRODUCTIVITY_LIST = "deactivateProductivityList";
    public static final String DEACTIVATED_PRODUCTIVITY_TAG = "deactivateProductivityList_tag";

    public static final String FIND_PRODUCTIVITY_LIST = "findProductivity";
    public static final String FIND_PRODUCTIVITY_TAG = "findProductivity_tag";

    public static final String PRODUCTIVITY_DELETE_URL = "deleteProductivity";
    public static final String PRODUCTIVITY_ARCHIEVE_URL = "archiveProductivity";
    public static final String PRODUCTIVITY_DEACTIVATE_URL = "deactivateProductivity";
    public static final String PRODUCTIVITY_ACTIVATE_URL = "activateProductivity";

    public static final String PRODUCTIVITY_LIKE_URL = "likeProductivity";
    public static final String PRODUCTIVITY_LIKE_TAG = "likeProductivity_tag";

    public static final String PRODUCTIVITY_DISLIKE_URL = "disLikeProductivity";
    public static final String PRODUCTIVITY_DISLIKE_TAG = "disLikeProductivity_tag";

    public static final String PRODUCTIVITY_LIKERS_LIST = "productivityLikeList";
    public static final String PRODUCTIVITY_LIKERS_TAG = "productivityLikeList_tag";

    public static final String PRODUCTIVITY_DISLIKERS_LIST = "productivityDislikeList";
    public static final String PRODUCTIVITY_DISLIKERS_TAG = "productivityDislikeList_tag";

    public static final String PRODUCTIVITY_FOLLOW_URL = "followProductivity";
    public static final String PRODUCTIVITY_FOLLOW_TAG = "followProductivity_tag";

    public static final String PRODUCTIVITY_UNFOLLOW_URL = "unfollowProductivity";
    public static final String PRODUCTIVITY_UNFOLLOW_TAG = "unfollowProductivity_tag";

    public static final String PRODUCTIVITY_COMMIT_URL = "productivityCommitment";
    public static final String PRODUCTIVITY_COMMIT_TAG = "productivityCommitment_tag";

    public static final String PRODUCTIVITY_UNCOMMIT_URL = "productivityUncommitment";
    public static final String PRODUCTIVITY_UNCOMMIT_TAG = "productivityUncommitment_tag";

    public static final String PRODUCTIVITY_COMMIT_LIST = "productivityCommitmentList";
    public static final String PRODUCTIVITY_COMMIT_LIST_TAG = "productivityCommitmentList_tag";


    // Information Module

    public static final String INFORMATION_KEYWORDS_LIST_URL = "informationKeywordsList";
    public static final String INFORMATION_KEYWORDS_LIST_TAG = "informationKeywordsList_tag";

    public static final String INFORMATION_INTEREST_KEYWORDS_LIST_URL = "informationInterestKeywordLists";
    public static final String INFORMATION_INTEREST_KEYWORDS_LIST_TAG = "informationInterestKeywordLists_tag";

    public static final String INFORMATION_TARGET_MARKET_KEYWORDS_LIST_URL = "informationTargetMarketsList";
    public static final String INFORMATION_TARGET_MARKET_KEYWORDS_LIST_TAG = "informationTargetMarketsList_tag";

    public static final String CREATE_INFORMATION_URL = "addInformation";
    public static final String UPDATE_INFORMATION_URL = "editInformation";

    public static final String INFORMATION_DETAILS_URL = "informationDetails";
    public static final String INFORMATION_DETAILS_TAG = "informationDetails_tag";

    public static final String MY_INFORMATION_URL = "myInformation";
    public static final String MY_INFORMATION_TAG = "myInformation_tag";

    public static final String ARCHIVED_INFORMATION_URL = "archiveInformationList";
    public static final String ARCHIVED_INFORMATION_TAG = "archiveInformationList_tag";

    public static final String DEACTIVATED_INFORMATION_LIST = "deactivateInformationList";
    public static final String DEACTIVATED_INFORMATION_TAG = "deactivateInformationList_tag";

    public static final String FIND_INFORMATION_LIST = "findInformation";
    public static final String FIND_INFORMATION_TAG = "findInformation_tag";

    public static final String INFORMATION_DELETE_URL = "deleteInformation";
    public static final String INFORMATION_ARCHIEVE_URL = "archiveInformation";
    public static final String INFORMATION_DEACTIVATE_URL = "deactivateInformation";
    public static final String INFORMATION_ACTIVATE_URL = "activateInformation";

    public static final String INFORMATION_LIKE_URL = "likeInformation";
    public static final String INFORMATION_LIKE_TAG = "likeInformation_tag";

    public static final String INFORMATION_DISLIKE_URL = "disLikeInformation";
    public static final String INFORMATION_DISLIKE_TAG = "disLikeInformation_tag";

    public static final String INFORMATION_LIKERS_LIST = "informationLikeList";
    public static final String INFORMATION_LIKERS_TAG = "informationLikeList_tag";

    public static final String INFORMATION_DISLIKERS_LIST = "informationDislikeList";
    public static final String INFORMATION_DISLIKERS_TAG = "informationDislikeList_tag";

    public static final String INFORMATION_FOLLOW_URL = "followInformation";
    public static final String INFORMATION_FOLLOW_TAG = "followInformation_tag";

    public static final String INFORMATION_UNFOLLOW_URL = "unfollowInformation";
    public static final String INFORMATION_UNFOLLOW_TAG = "unfollowInformation_tag";

    public static final String INFORMATION_COMMIT_URL = "informationCommitment";
    public static final String INFORMATION_COMMIT_TAG = "informationCommitment_tag";

    public static final String INFORMATION_UNCOMMIT_URL = "informationUncommitment";
    public static final String INFORMATION_UNCOMMIT_TAG = "informationUncommitment_tag";

    public static final String INFORMATION_COMMIT_LIST = "informationCommitmentList";
    public static final String INFORMATION_COMMIT_LIST_TAG = "informationCommitmentList_tag";


    //Audio Video Module

    public static final String AUDIO_VIDEO_KEYWORDS_LIST_URL = "audiorKeywordsList";
    public static final String AUDIO_VIDEO_KEYWORDS_LIST_TAG = "audiorKeywordsList_tag";

    public static final String AUDIO_VIDEO_INTEREST_KEYWORDS_LIST_URL = "audioInterestKeywordLists";
    public static final String AUDIO_VIDEO_INTEREST_KEYWORDS_LIST_TAG = "audioInterestKeywordLists_tag";

    public static final String AUDIO_VIDEO_TARGET_MARKET_KEYWORDS_LIST_URL = "audioTargetMarketsList";
    public static final String AUDIO_VIDEO_TARGET_MARKET_KEYWORDS_LIST_TAG = "audioTargetMarketsList_tag";

    public static final String CREATE_AUDIO_VIDEO_URL = "addAudioVideo";
    public static final String UPDATE_AUDIO_VIDEO_URL = "editAudioVideo";

    public static final String AUDIO_VIDEO_DETAILS_URL = "audioDetails";
    public static final String AUDIO_VIDEO_DETAILS_TAG = "audioDetails_tag";

    public static final String MY_AUDIO_VIDEO_URL = "myAudioVideo";
    public static final String MY_AUDIO_VIDEO_TAG = "myAudioVideo_tag";

    public static final String ARCHIVED_AUDIO_VIDEO_URL = "archiveAudioList";
    public static final String ARCHIVED_AUDIO_VIDEO_TAG = "archiveAudioList_tag";

    public static final String DEACTIVATED_AUDIO_VIDEO_LIST = "deactivateAudioList";
    public static final String DEACTIVATED_AUDIO_VIDEO_TAG = "deactivateAudioList_tag";

    public static final String FIND_AUDIO_VIDEO_LIST = "findAudioVideo";
    public static final String FIND_AUDIO_VIDEO_TAG = "findAudioVideo_tag";

    public static final String AUDIO_VIDEO_DELETE_URL = "deleteAudio";
    public static final String AUDIO_VIDEO_ARCHIEVE_URL = "archiveAudio";
    public static final String AUDIO_VIDEO_DEACTIVATE_URL = "deactivateAudio";
    public static final String AUDIO_VIDEO_ACTIVATE_URL = "activateAudio";

    public static final String AUDIO_VIDEO_LIKE_URL = "likeAudio";
    public static final String AUDIO_VIDEO_LIKE_TAG = "likeAudio_tag";

    public static final String AUDIO_VIDEO_DISLIKE_URL = "disLikeAudio";
    public static final String AUDIO_VIDEO_DISLIKE_TAG = "disLikeAudio_tag";

    public static final String AUDIO_VIDEO_LIKERS_LIST = "audioLikeList";
    public static final String AUDIO_VIDEO_LIKERS_TAG = "audioLikeList_tag";

    public static final String AUDIO_VIDEO_DISLIKERS_LIST = "audioDislikeList";
    public static final String AUDIO_VIDEO_DISLIKERS_TAG = "audioDislikeList_tag";

    public static final String AUDIO_VIDEO_FOLLOW_URL = "followAudio";
    public static final String AUDIO_VIDEO_FOLLOW_TAG = "followAudio_tag";

    public static final String AUDIO_VIDEO_UNFOLLOW_URL = "unfollowAudio";
    public static final String AUDIO_VIDEO_UNFOLLOW_TAG = "unfollowAudio_tag";

    public static final String AUDIO_VIDEO_COMMIT_URL = "audioCommitment";
    public static final String AUDIO_VIDEO_COMMIT_TAG = "audioCommitment_tag";

    public static final String AUDIO_VIDEO_UNCOMMIT_URL = "audioUncommitment";
    public static final String AUDIO_VIDEO_UNCOMMIT_TAG = "audioUncommitment_tag";

    public static final String AUDIO_VIDEO_COMMIT_LIST = "audioCommitmentList";
    public static final String AUDIO_VIDEO_COMMIT_LIST_TAG = "audioCommitmentList_tag";


    // Focus Group module
    public static final String FOCUS_GROUP_KEYWORDS_LIST_URL = "focusGroupKeywordsList";
    public static final String FOCUS_GROUP_KEYWORDS_LIST_TAG = "focusGroupKeywordsList_tag";

    public static final String FOCUS_GROUP_INTEREST_KEYWORDS_LIST_URL = "focusGroupInterestKeywordLists";
    public static final String FOCUS_GROUP_INTEREST_KEYWORDS_LIST_TAG = "focusGroupInterestKeywordLists_tag";

    public static final String FOCUS_GROUP_TARGET_MARKET_LIST_URL = "focusGroupTargetMarketsList";
    public static final String FOCUS_GROUP_TARGET_MARKET_LIST_TAG = "focusGroupTargetMarketsList_tag";

    public static final String FOCUS_GROUP_DETAILS_URL = "focusGroupDetails";
    public static final String FOCUS_GROUP_DETAILS_TAG = "focusGroupDetails_tag";

    public static final String FOCUS_GROUP_COMMIT_URL = "focusCommitment";
    public static final String FOCUS_GROUP_COMMIT_TAG = "focusCommitment_tag";

    public static final String FOCUS_GROUP_UNCOMMIT_URL = "focusUncommitment";
    public static final String FOCUS_GROUP_UNCOMMIT_TAG = "focusUncommitment_tag";

    public static final String FOCUS_GROUP_COMMIT_LIST = "focusCommitmentList";
    public static final String FOCUS_GROUP_COMMIT_LIST_TAG = "focusCommitmentList_tag";

    public static final String CREATE_FOCUS_GROUP_URL = "addFocusGroup";
    public static final String UPDATE_FOCUS_GROUP_URL = "editFocusGroup";

    public static final String FIND_FOCUS_GROUP_LIST = "findFocusGroups";
    public static final String FIND_FOCUS_GROUP_TAG = "findFocusGroups_tag";

    public static final String MY_FOCUS_GROUP_LIST = "myFocusGroup";
    public static final String MY_FOCUS_GROUP_TAG = "myFocusGroup_tag";

    public static final String ARCHIVED_FOCUS_GROUP_LIST = "archiveFocusGroupList";
    public static final String ARCHIVED_FOCUS_GROUP_TAG = "archiveFocusGroupList_tag";

    public static final String DEACTIVATED_FOCUS_GROUP_LIST = "deactivateFocusGroupList";
    public static final String DEACTIVATED_FOCUS_GROUP_TAG = "deactivateFocusGroupList_tag";

    public static final String FOCUS_GROUP_DELETE_URL = "deleteFocusGroup";
    public static final String FOCUS_GROUP_ARCHIEVE_URL = "archiveFocusGroup";
    public static final String FOCUS_GROUP_DEACTIVATE_URL = "deactivateFocusGroup";
    public static final String FOCUS_GROUP_ACTIVATE_URL = "activateFocusGroup";

    public static final String FOCUS_GROUP_LIKE_URL = "likeFocusGroup";
    public static final String FOCUS_GROUP_LIKE_TAG = "likeFocusGroup_tag";

    public static final String FOCUS_GROUP_DISLIKE_URL = "disLikeFocusGroup";
    public static final String FOCUS_GROUP_DISLIKE_TAG = "disLikeFocusGroup_tag";

    public static final String FOCUS_GROUP_LIKERS_LIST = "focusGroupLikeList";
    public static final String FOCUS_GROUP_LIKERS_TAG = "focusGroupLikeList_tag";

    public static final String FOCUS_GROUP_DISLIKERS_LIST = "focusGroupDislikeList";
    public static final String FOCUS_GROUP_DISLIKERS_TAG = "focusGroupDislikeList_tag";

    public static final String FOCUS_GROUP_FOLLOW_URL = "followFocusGroup";
    public static final String FOCUS_GROUP_FOLLOW_TAG = "followFocusGroup_tag";

    public static final String FOCUS_GROUP_UNFOLLOW_URL = "unfollowFocusGroup";
    public static final String FOCUS_GROUP_UNFOLLOW_TAG = "unfollowFocusGroup_tag";


    // Group Buying

    public static final String GROUP_BUYING_KEYWORDS_LIST_URL = "groupbuyingKeywordsList";
    public static final String GROUP_BUYING_KEYWORDS_LIST_TAG = "groupbuyingKeywordsList_tag";

    public static final String GROUP_BUYING_DETAILS_URL = "groupbuyingDetails";
    public static final String GROUP_BUYING_DETAILS_TAG = "groupbuyingDetails_tag";

    public static final String GROUP_BUYING_COMMIT_URL = "groupbuyingCommitment";
    public static final String GROUP_BUYING_COMMIT_TAG = "groupbuyingCommitment_tag";

    public static final String GROUP_BUYING_UNCOMMIT_URL = "groupbuyingUncommitment";
    public static final String GROUP_BUYING_UNCOMMIT_TAG = "groupbuyingUncommitment_tag";

    public static final String GROUP_BUYING_COMMIT_LIST = "groupbuyingCommitmentList";
    public static final String GROUP_BUYING_COMMIT_LIST_TAG = "groupbuyingCommitmentList_tag";

    public static final String CREATE_GROUP_BUYING_URL = "addGroupbuying";
    public static final String UPDATE_GROUP_BUYING_URL = "editGroupbuying";

    public static final String FIND_GROUP_BUYING_LIST = "findGroupbuying";
    public static final String FIND_GROUP_BUYING_TAG = "findGroupbuying_tag";

    public static final String MY_GROUP_BUYING_LIST = "myGroupbuying";
    public static final String MY_GROUP_BUYING_TAG = "myGroupbuying_tag";

    public static final String GROUP_BUYING_LIKE_URL = "likeGroupbuying";
    public static final String GROUP_BUYING_LIKE_TAG = "likeGroupbuying_tag";

    public static final String GROUP_BUYING_DISLIKE_URL = "disLikeGroupbuying";
    public static final String GROUP_BUYING_DISLIKE_TAG = "disLikeGroupbuying_tag";

    public static final String GROUP_BUYING_LIKERS_LIST = "groupbuyingLikeList";
    public static final String GROUP_BUYING_LIKERS_TAG = "groupbuyingLikeList_tag";

    public static final String GROUP_BUYING_DISLIKERS_LIST = "groupbuyingDislikeList";
    public static final String GROUP_BUYING_DISLIKERS_TAG = "groupbuyingDislikeList_tag";

    public static final String GROUP_BUYING_FOLLOW_URL = "followGroupbuying";
    public static final String GROUP_BUYING_FOLLOW_TAG = "followGroupbuying_tag";

    public static final String GROUP_BUYING_UNFOLLOW_URL = "unfollowGroupbuying";
    public static final String GROUP_BUYING_UNFOLLOW_TAG = "unfollowGroupbuying_tag";

    public static final String GROUP_BUYING_INTEREST_KEYWORDS_LIST_URL = "groupbuyingInterestKeywordLists";
    public static final String GROUP_BUYING_INTEREST_KEYWORDS_LIST_TAG = "groupbuyingInterestKeywordLists_tag";

    public static final String GROUP_BUYING_TARGET_MARKET_LIST_URL = "groupbuyingTargetMarketsList";
    public static final String GROUP_BUYING_TARGET_MARKET_LIST_TAG = "groupbuyingTargetMarketsList_tag";


    //++++++++++++++++Consulting APIS+++++++++++++++++++++++++++++++++++++++++++++++++++

    public static final String CONSULTING_KEYWORDS_LIST_URL = "consultingTargetKeywordLists";
    public static final String CONSULTING_KEYWORDS_LIST_TAG = "consultingTargetKeywordLists_tag";

    public static final String CONSULTING_INTEREST_KEYWORDS_LIST_URL = "consultingInterestKeywordsList";
    public static final String CONSULTING_INTEREST_KEYWORDS_LIST_TAG = "consultingInterestKeywordsList_tag";

    public static final String ARCHIVED_CONSULTING_LIST = "archiveConsultingList";
    public static final String ARCHIVED_CONSULTING_TAG = "archiveConsultingList_tag";

    public static final String CLOSED_CONSULTING_LIST = "closeConsultingList";
    public static final String CLOSED_CONSULTING_TAG = "closeConsultingList_tag";

    public static final String MY_CONSULTING_LIST = "myConsulting";
    public static final String MY_CONSULTING_TAG = "myConsulting_tag";

    public static final String CONSULTING_DELETE_URL = "deleteConsulting";
    public static final String CONSULTING_ARCHIEVE_URL = "archiveConsulting";
    public static final String CONSULTING_CLOSE_URL = "closeConsulting";
    public static final String CONSULTING_CLOSE_TAG = "closeConsulting_tag";
    public static final String CONSULTING_OPEN_URL = "openConsulting";

    public static final String CONSULTING_LIKE_URL = "likeConsulting";
    public static final String CONSULTING_LIKE_TAG = "likeConsulting_tag";

    public static final String CONSULTING_DISLIKE_URL = "disLikeConsulting";
    public static final String CONSULTING_DISLIKE_TAG = "disLikeConsulting_tag";

    public static final String CONSULTING_LIKERS_LIST = "consultingLikeList";
    public static final String CONSULTING_LIKERS_TAG = "consultingLikeList_tag";

    public static final String CONSULTING_DISLIKERS_LIST = "consultingDislikeList";
    public static final String CONSULTING_DISLIKERS_TAG = "consultingDislikeList_tag";

    public static final String FIND_CONSULTING_LIST = "findConsulting";
    public static final String FIND_CONSULTING_TAG = "findConsulting_tag";

    public static final String CONSULTING_DETAILS_URL = "consultingDetails";
    public static final String CONSULTING_DETAILS_TAG = "consultingDetails_tag";

    public static final String CONSULTING_FOLLOW_URL = "followConsulting";
    public static final String CONSULTING_FOLLOW_TAG = "followConsulting_tag";

    public static final String CONSULTING_UNFOLLOW_URL = "unfollowConsulting";
    public static final String CONSULTING_UNFOLLOW_TAG = "unfollowConsulting_tag";

    public static final String CREATE_CONSULTING_URL = "addConsulting";
    public static final String UPDATE_CONSULTING_URL = "editConsulting";
    public static final String APPLY_CONSULTING_URL = "consultingCommitment";

    public static final String CONSULTING_UNCOMMIT_URL = "consultingUncommitment";
    public static final String CONSULTING_UNCOMMIT_TAG = "consultingUncommitment_tag";

    public static final String INVITE_USER_CONSULTING = "sendConsultingInvitation";
    public static final String ACCEPT_INVITE_CONSULTING = "acceptConsultingInvitation";
    public static final String REJECT_INVITE_CONSULTING = "consultingCommitment";


    public static final String USER_INVITELIST_CONSULTING = "consultingInvitationList";
    public static final String USER_INVITELIST_CONSULTING_TAG = "consultingInvitationList_tag";

    public static final String CONSULTING_COMMIT_LIST = "consultingCommitmentList";
    public static final String CONSULTING_COMMIT_LIST_TAG = "consultingCommitmentList_tag";

    public static final String SEARCH_CONSULTING_INVITATION_LIST = "invitationContractorList";
    public static final String SEARCH_CONSULTING_INVITATION_LIST_TAG = "invitationContractorList_tag";

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    //Password regex pattern for validation.
    public static final String PASSWORD_REGEX_PATTERN = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[$@$!%*?&])(?=\\S+$).{8,25}$";
    public static final String EXTRACT_FLOAT_FROM_STRING_REGEX_PATTERN = "[^\\d.]+|\\.(?!\\d)";

    //Shared Preferences constants
    public final static String APP_SHARED_PREFERENCES = "CrowdBootstrap";
    public static final String GCM_REGISTRATION_ID = "registration_id";
    public static final String APP_VERSION = "appVersion";
    public final static int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    public static final String DEVICE_TOKEN = "device_token";
    public static final String SENT_TOKEN_TO_SERVER = "sentTokenToServer";
    public static final String REGISTRATION_COMPLETE = "registrationComplete";

    //Constants User type
    public static final String ENTREPRENEUR = "ENTREPRENEUR";
    public static final String CONTRACTOR = "CONTRACTOR";

    //User details constants for shared preference
    public static final String USER_EMAIL = "user_email";
    public static final String USER_PASSWORD = "user_password";
    public static final String USER_FIRST_NAME = "first_name";
    public static final String USER_LAST_NAME = "last_name";
    public static final String USER_ID = "user_id";
    public static final String USER_SELECTED_COUNTRY_ID = "country_id";
    public static final String USER_SELECTED_STATE_ID = "state_id";
    public static final String USER_SELECTED_SEARCH_TEXT = "search_text";
    public static final String USER_PROFILE_IMAGE_URL = "user_profile_image_url";
    // public static final String ENTREPRENEUR_PROFILE_IMAGE_URL = "ENTREPRENEUR_profile_image_url";
    public static final String USER_PHONE_NUMBER = "phoneno";
    public static final String USER_NAME = "username";
    public static final String USER_TYPE = "user_type";
    public static final String ISLOGGEDIN = "isloggedin";
    public static final String IS_NOTIFICATION_ON = "is_notification_on";

    public static final String IS_BOARD_MEMBER = "is_boardmember_on";
    public static final String IS_BETA_TESTER = "is_betatester_on";
    public static final String IS_ENDORSER = "is_endorser_on";
    public static final String IS_EARLY_ADOPTER = "is_earlyadopter_on";
    public static final String IS_FOCUS_GROUP = "is_focusgroup_on";
    public static final String IS_CONSULTING = "is_consulting_on";

    public static final String IS_CONNECTION_UPDATE = "is_connection_update";
    public static final String IS_STARTUP_UPDATE = "is_startup_update";
    public static final String IS_FUND_UPDATE = "is_fund_update";
    public static final String IS_CAMPAIGN_FOLLOWED_UPDATE = "is_campaignfollowed_update";
    public static final String IS_CAMPAIGN_COMMITED_UPDATE = "is_campaigncommited_update";
    public static final String IS_SELF_IMPROVEMENT_UPDATE = "is_selfimprovement_update";
    public static final String IS_CAREER_HELP_UPDATE = "is_careerhelp_update";
    public static final String IS_ORGANIZATION_UPDATE = "is_organization_update";
    public static final String IS_FORUM_UPDATE = "is_forum_update";
    public static final String IS_GROUP_UPDATE = "is_group_update";
    public static final String IS_HARDWARE_UPDATE = "is_hardware_update";
    public static final String IS_SOFTWARE_UPDATE = "is_software_update";
    public static final String IS_SERVICE_UPDATE = "is_service_update";
    public static final String IS_AUDIOVIDEO_UPDATE = "is_audiovideo_update";
    public static final String IS_INFORMATION_UPDATE = "is_information_update";
    public static final String IS_PRODUCTIVITY_UPDATE = "is_productivity_update";
    public static final String IS_CONFERENCE_UPDATE = "is_conference_update";
    public static final String IS_DEMODAY_UPDATE = "is_demoday_update";
    public static final String IS_WEBINAR_UPDATE = "is_webinar_update";
    public static final String IS_MEETUP_UPDATE = "is_meetup_update";
    public static final String IS_BETATEST_UPDATE = "is_betatest_update";
    public static final String IS_BOARD_MEMBER_UPDATE = "is_boardmember_update";
    public static final String IS_CONSULTING_UPDATE = "is_consulting_update";
    public static final String IS_COMMUNAL_ASSET_UPDATE = "is_communal_asset_update";
    public static final String IS_EARLY_ADOPTER_UPDATE = "is_earlyadopter_update";
    public static final String IS_ENDORSER_UPDATE = "is_endorser_update";
    public static final String IS_FOCUS_GROUP_UPDATE = "is_focusgroup_update";
    public static final String IS_JOB_UPDATE = "is_job_update";
    public static final String IS_LAUNCH_DEAL_UPDATE = "is_launchdeal_update";
    public static final String IS_GROUP_BUYING_UPDATE = "is_groupbuying_update";


    public static final String IS_CONTRACTOR_PUBLIC_PROFILE_ON = "is_contractor_public_profile_on";
    public static final String IS_ENTREPRENEUR_PUBLIC_PROFILE_ON = "is_entrepreneur_public_profile_on";

    public static final String ENTREPRENEUR_PROFILE_COMPLETENESS = "ENTREPRENEUR_PROFILE_COMPLETENESS";
    public static final String CONTRACTOR_PROFILE_COMPLETENESS = "CONTRACTOR_PROFILE_COMPLETENESS";

    public static final String QUICKBLOX_SESSION_TOKEN = "token";

    //Date and time format constants
    public static final String DATE_FORMAT = "MMM dd, yyyy";
    public static final String TIME_FORMAT = "hh:mm a";

    //Html tags
    public static final String HTTP_PREFIX_TAX = "<html><style>body{background:#F0F0F0;}div {text-align: justify;}</style><body><div>";
    public static final String HTTP_SUFFIX_TAX = "</div></body></html>";
    public static final String FUND_ID = "fund_id";
    public static final String LIKE_DISLIKE = "like_dislike_tag";
    public static final String LIKE = "Likes";
    public static final String DISLIKE = "Dislikes";
    public static final String LOGGED_USER = "logged_user";
    public static final String NOT_LOGGED_USER = "not_logged_user";
    public static final String TIMEOUT_EXCEPTION = "timeout";
    public static final int POSITION = 1001;
    public static final java.lang.String CALLED_FROM = "calledFrom";
    public static final String UTF_8 = "UTF-8";
    public static final String FUND_NAME = "fundName";


    //Passing data constants using intent
    public static String COMMING_FROM_INTENT = "";

    //Either file of camera open intent constants
    public static final int FILE_PICKER = 1;
    public static final int FILE_PICKER_RESUME = 12;
    public static final int FILE_BROWSER = 4;
    public static final int CAMERA_CAPTURE_IMAGE_REQUEST_CODE = 2;
    public static final int IMAGE_PICKER = 3;

    public static final long MAX_FILE_LENGTH_ALLOWED = 20242880;

    public static final String IMAGE_DIRECTORY_NAME = "Crowdbootstrap";

    //Runtime app permission constants
    public static final int APP_PERMISSION = 5;

    //Constants for Background thread.
    public static final String NOINTERNET = "no_internet";
    public static final String SERVEREXCEPTION = "server_exception";

    //Google Project id created under crowdbootstrap2016@gmail.com account
    //API key for staging
    public static final String GOOGLE_PROJECT_ID_STAGING = "965286451869";
    public static final String GOOGLE_PROJECT_API_KEY_STAGING = "AIzaSyDQ18y3vc76UXoSLtQuv7NHurrsVVklByE";

    //API key for productions
    public static final String GOOGLE_PROJECT_ID_PRODUCTION = "15119152410";
    public static final String GOOGLE_PROJECT_API_KEY_PRODUCTION = "AIzaSyABVL3JTP0h_jN0JYCFkeHxiGfbneg6Qck";


    //Constants for Ad Banner on Home Screen created under Client's account
    public static final String Ad_UNIT_NAME = "mybanner";
    public static final String Ad_UNIT_ID = "ca-app-pub-8861665785664393/7833609069";
    public static final String App_TRACKING_ID = "UA-33366220-3";

    //HTTP request type constants
    public final static int HTTP_GET = 1;
    public final static int HTTP_POST = 2;

    public final static String HTTP_GET_REQUEST = "GET";
    public final static String HTTP_POST_REQUEST = "POST";

    //Code comming from Server side.
    public final static String RESPONSE_STATUS_CODE = "code";
    public final static String RESPONSE_SUCESS_STATUS_CODE = "200";
    public final static String RESPONSE_ERROR_STATUS_CODE = "404";


    //Constants for QuickBlox chat for live app created under crowdbootstrap2016@gmail.com account
    public static final String QUICKBLOX_APP_ID = "41172";
    public static final String QUICKBLOX_AUTH_KEY = "atp85LpFMSSk-My";
    public static final String QUICKBLOX_AUTH_SECRET = "xu5sSy6uPsf9BA5";
    public static final String QUICKBLOX_ACCOUNT_KEY = "aNstpqyjBhYp2zTd4HFR";
    public static final String QUICKBLOX_ACCOUNT_ID = "52034";

    /*Constants for QuickBlox chat for testing created under neelmani.karn@trantorinc.com account*/
//    public static final String QUICKBLOX_APP_ID = "32716";
//    public static final String QUICKBLOX_AUTH_KEY = "GFZx5kekuYNsP7Z";
//    public static final String QUICKBLOX_AUTH_SECRET = "mUJHuFX3m-uXu2x";
//    public static final String QUICKBLOX_ACCOUNT_KEY = "8RTz3Q7iLeGokw3MrzP5";
//    public static final String QUICKBLOX_ACCOUNT_ID = "41443";


    public static final String STICKER_API_KEY = "847b82c49db21ecec88c510e377b452c";

    public static final String USER_LOGIN_KEY = "USER_LOGIN_KEY";
    public static final String USER_PASSWORD_KEY = "USER_PASSWORD_KEY";

    public static final String EMPTY_STRING = "";

    public static final String QB_USER_ID = "qb_user_id";
    public static final String QB_USER_LOGIN = "qb_user_login";
    public static final String QB_USER_PASSWORD = "qb_user_password";
    public static final String QB_USER_FULL_NAME = "qb_user_full_name";
}