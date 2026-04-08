package com.bdovaz.instagram;

import java.io.Serializable;

public interface WebViewListener extends Serializable {

    void onAuthenticationCodeRetrieved(String url);

    void onAuthenticationError(int errorCode, String errorDescription);

    void onAuthenticationCanceled();

}