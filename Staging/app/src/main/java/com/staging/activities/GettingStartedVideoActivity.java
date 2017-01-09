package com.staging.activities;

import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;

import com.google.android.youtube.player.YouTubeInitializationResult;
import com.google.android.youtube.player.YouTubePlayer;
import com.google.android.youtube.player.YouTubePlayerSupportFragment;
import com.staging.R;

/**
 * Created by Sunakshi.Gautam on 12/13/2016.
 */
public class GettingStartedVideoActivity extends BaseActivity {
    private YouTubePlayer YPlayer;
    @Override
    public void setActionBarTitle(String title) {

    }

    @Override
    public void onSessionCreated(boolean success) {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.gettingstartedvideo);
        YouTubePlayerSupportFragment youTubePlayerFragment = YouTubePlayerSupportFragment.newInstance();


        youTubePlayerFragment.initialize("AIzaSyCOWQ6wWFcI3B8CHF4uL_gybbMBVOD-c1A", new YouTubePlayer.OnInitializedListener() {

            @Override
            public void onInitializationSuccess(YouTubePlayer.Provider arg0, YouTubePlayer youTubePlayer, boolean b) {
                if (!b) {
                    YPlayer = youTubePlayer;
                    YPlayer.setFullscreen(false);
                    YPlayer.loadVideo("Q9tYHQnb7xI");
                    YPlayer.play();
                }
            }

            @Override
            public void onInitializationFailure(YouTubePlayer.Provider provider, YouTubeInitializationResult youTubeInitializationResult) {

            }


        });
        FragmentTransaction transaction = GettingStartedVideoActivity.this.getSupportFragmentManager().beginTransaction();
        transaction.add(R.id.youtube_fragment, youTubePlayerFragment).commit();;
    }
}
