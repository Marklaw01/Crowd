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


    //Passing data constants using intent
    public static String COMMING_FROM_INTENT = "";

    //Either file of camera open intent constants
    public static final int FILE_PICKER = 1;
    public static final int FILE_PICKER_RESUME = 12;
    public static final int FILE_BROWSER = 4;
    public static final int CAMERA_CAPTURE_IMAGE_REQUEST_CODE = 2;
    public static final int IMAGE_PICKER = 3;

    public static final long MAX_FILE_LENGTH_ALLOWED = 5242880;

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


    //Constants for Ad Banner on Home Screen created under karn.neelmani@gmail.com account
    public static final String Ad_UNIT_NAME = "mybanner";
    public static final String Ad_UNIT_ID = "ca-app-pub-8877526086007040/4416451611";
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