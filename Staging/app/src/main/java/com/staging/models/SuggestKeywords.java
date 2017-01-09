package com.staging.models;

import com.staging.activities.BaseActivity;
import com.staging.adapter.UserSuggestedKeywordsAdapter;

/**
 * Created by Sunakshi.Gautam on 11/15/2016.
 */
public class SuggestKeywords {

    private String keywordName;
    private String keywordType;
    private String keywordID;
    private String keywordStatus;

    public String getKeywordName() {
        return keywordName;
    }

    public void setKeywordName(String keywordName) {
        this.keywordName = keywordName;
    }

    public String getKeywordType() {
        return keywordType;
    }

    public void setKeywordType(String keywordType) {
        this.keywordType = keywordType;
    }

    public String getKeywordID() {
        return keywordID;
    }

    public void setKeywordID(String keywordID) {
        this.keywordID = keywordID;
    }

    public String getKeywordStatus() {
        return keywordStatus;
    }

    public void setKeywordStatus(String keywordStatus) {
        this.keywordStatus = keywordStatus;
    }
}
