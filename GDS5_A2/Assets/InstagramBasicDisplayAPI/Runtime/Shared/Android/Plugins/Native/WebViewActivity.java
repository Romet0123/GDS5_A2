package com.bdovaz.instagram;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.Window;
import android.webkit.WebView;

public class WebViewActivity extends Activity {

    private WebViewListener webViewListener;
    private WebView mWebView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getWindow().requestFeature(Window.FEATURE_NO_TITLE);

        Intent intent = getIntent();

        String url = intent.getStringExtra("url");
        String redirectUrl = intent.getStringExtra("redirectUrl");
        webViewListener = Plugin.getInstance().getListener();

        mWebView = new WebView(this);
        mWebView.getSettings().setJavaScriptEnabled(true);
        mWebView.loadUrl(url);
        mWebView.setWebViewClient(new CustomWebViewClient(this, webViewListener, redirectUrl));

        setContentView(mWebView);
    }

    @Override
    public boolean onKeyDown(final int keyCode, final KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && mWebView.canGoBack()) {
            mWebView.goBack();
            return true;
        }

        webViewListener.onAuthenticationCanceled();

        return super.onKeyDown(keyCode, event);
    }

}
