package com.bdovaz.instagram;

import android.app.Activity;
import android.content.Intent;

public class Plugin {

    private static Plugin instance;

    public static Plugin getInstance() {
        return instance;
    }

    private Activity activity;
    private WebViewListener webViewListener;

    private String url;
    private String redirectUrl;

    public Plugin(Activity activity, WebViewListener listener) {
        instance = this;

        this.activity = activity;
        this.webViewListener = listener;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getRedirectUrl() {
        return redirectUrl;
    }

    public void setRedirectUrl(String url) {
        redirectUrl = url;
    }

    public WebViewListener getListener() {
        return webViewListener;
    }

    public void show() {
        Intent intent = new Intent(activity, WebViewActivity.class);
        intent.putExtra("url", url);
        intent.putExtra("redirectUrl", redirectUrl);

        activity.startActivity(intent);
    }

}