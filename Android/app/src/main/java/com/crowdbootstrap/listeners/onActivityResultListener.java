package com.crowdbootstrap.listeners;

import android.content.Intent;

public interface onActivityResultListener {
    void onActivityResult(int requestCode, int resultCode, Intent data);
}