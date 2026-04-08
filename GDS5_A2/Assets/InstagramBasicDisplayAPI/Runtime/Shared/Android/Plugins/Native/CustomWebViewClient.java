package com.bdovaz.instagram;

import android.annotation.TargetApi;
import android.app.Activity;
import android.net.Uri;
import android.os.Build;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class CustomWebViewClient extends WebViewClient {

    private Activity activity;
    private WebViewListener webViewListener;
    private String redirectUrl;

    CustomWebViewClient(Activity activity, WebViewListener webViewListener, String redirectUrl) {
        this.activity = activity;
        this.webViewListener = webViewListener;
        this.redirectUrl = redirectUrl;
    }

    @TargetApi(Build.VERSION_CODES.M)
    @Override
    public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
        super.onReceivedError(view, request, error);

        webViewListener.onAuthenticationError(error.getErrorCode(), error.getDescription().toString());
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void onReceivedHttpError(WebView view, WebResourceRequest request, WebResourceResponse errorResponse) {
        super.onReceivedHttpError(view, request, errorResponse);

        webViewListener.onAuthenticationError(errorResponse.getStatusCode(), errorResponse.toString());
    }

    @Override
    public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
        super.onReceivedError(view, errorCode, description, failingUrl);

        webViewListener.onAuthenticationError(errorCode, description);
    }

    @TargetApi(Build.VERSION_CODES.N)
    @Override
    public boolean shouldOverrideUrlLoading(android.webkit.WebView view, WebResourceRequest request) {
        Uri uri = request.getUrl();
        Uri redirectUri = Uri.parse(redirectUrl);

        if (uri.getHost() != null && uri.getHost().equalsIgnoreCase(redirectUri.getHost())) {
            webViewListener.onAuthenticationCodeRetrieved(uri.toString());

            activity.finish();

            return true;
        } else {
            return false;
        }
    }

    @Override
    public boolean shouldOverrideUrlLoading(android.webkit.WebView view, String url) {
        Uri uri = Uri.parse(url);
        Uri redirectUri = Uri.parse(redirectUrl);

        if (uri.getHost() != null && uri.getHost().equalsIgnoreCase(redirectUri.getHost())) {
            webViewListener.onAuthenticationCodeRetrieved(url);

            activity.finish();

            return true;
        } else {
            return false;
        }
    }

}
