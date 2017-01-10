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
    public static final String GOOGLE_PROJECT_ID = "965286451869";
    public static final String GOOGLE_PROJECT_API_KEY = "AIzaSyDQ18y3vc76UXoSLtQuv7NHurrsVVklByE";

    //Constants for Ad Banner on Home Screen created under karn.neelmani@gmail.com account
    public static final String Ad_UNIT_NAME = "mybanner";
    public static final String Ad_UNIT_ID = "ca-app-pub-8877526086007040/4416451611";
    public static final String App_TRACKING_ID = "UA-33366220-3";

    //HTTP request type constants
    public final static int HTTP_GET = 1;
    public final static int HTTP_POST = 2;

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