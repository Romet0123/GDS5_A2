var WebViewPlugin = {
    $internal: {
    },
    Instagram_WebView_NavigateTo: function(urlPtr) {
        var url = UTF8ToString(urlPtr);
        
        window.top.location.href = url;
    }
};

autoAddDeps(WebViewPlugin, '$internal');
mergeInto(LibraryManager.library, WebViewPlugin);