var WebViewPlugin = {
    $internal: {
    },
    Instagram_WebView_NavigateTo: function(urlPtr) {
        var url = Pointer_stringify(urlPtr);
        
        window.location.href = url;
    }
};

autoAddDeps(WebViewPlugin, '$internal');
mergeInto(LibraryManager.library, WebViewPlugin);