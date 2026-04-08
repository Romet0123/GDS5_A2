#import <UIKit/UIKit.h>
#import "WebViewPlugin.h"

extern UIViewController *UnityGetGLViewController();

extern "C" {
    
    const void* Instagram_WebView_Instantiate() {
        WebViewPlugin *instance = [[WebViewPlugin alloc] init];
        
        return CFBridgingRetain(instance);
    }
    
    void Instagram_WebView_SetAuthenticationCodeCallback(const void* instance, AuthenticationCodeCallback callback) {
        [(__bridge WebViewPlugin*)instance setAuthenticationCodeCallback:callback];
    }

    void Instagram_WebView_SetAuthenticationErrorCallback(const void* instance, AuthenticationErrorCallback callback) {
        [(__bridge WebViewPlugin*)instance setAuthenticationErrorCallback:callback];
    }

    void Instagram_WebView_SetAuthenticationCancelCallback(const void* instance, AuthenticationCancelCallback callback) {
        [(__bridge WebViewPlugin*)instance setAuthenticationCancelCallback:callback];
    }

    const char* Instagram_WebView_GetUrl(const void* instance) {
        return [WebViewPlugin NSStringToChar:[(__bridge WebViewPlugin*)instance getUrl]];
    }

    void Instagram_WebView_SetUrl(const void* instance, const char* value) {
        NSString *nsstr = [NSString stringWithUTF8String:value];
        
        [(__bridge WebViewPlugin*)instance setUrl:nsstr];
    }

    const char* Instagram_WebView_GetRedirectUrl(const void* instance) {
        return [WebViewPlugin NSStringToChar:[(__bridge WebViewPlugin*)instance getRedirectUrl]];
    }

    void Instagram_WebView_SetRedirectUrl(const void* instance, const char* value) {
        NSString *nsstr = [NSString stringWithUTF8String:value];
        
        [(__bridge WebViewPlugin*)instance setRedirectUrl:nsstr];
    }

    void Instagram_WebView_Show(const void* instance) {
        [(__bridge WebViewPlugin*)instance show];
    }
}

@implementation WebViewPlugin

int const headerHeight = 50;

-(id)init {
    _toolbar = [[UIToolbar alloc] init];
    _toolbar.frame = CGRectMake(0, 0, UnityGetGLViewController().view.bounds.size.width, 50);

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    _back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(buttonBackClick)];
    _forward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(buttonForwardClick)];
    _refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(buttonRefreshClick)];
    _close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(buttonCloseClick)];

    _toolbar.items = @[_back, _forward, _refresh, flexibleSpace, flexibleSpace, _close];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];

    CGRect frame = [UIApplication sharedApplication].keyWindow.bounds;
    frame.origin.y = headerHeight;
    frame.size.height -= headerHeight;

    _webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    _webView.navigationDelegate = self;

    return self;
}

-(void)setAuthenticationCodeCallback:(AuthenticationCodeCallback)callback {
    _authenticationCodeCallback = callback;
}

-(void)setAuthenticationErrorCallback:(AuthenticationErrorCallback)callback {
    _authenticationErrorCallback = callback;
}

-(void)setAuthenticationCancelCallback:(AuthenticationCancelCallback)callback {
    _authenticationCancelCallback = callback;
}

-(NSString*)getUrl {
    return _url;
}

-(void)setUrl:(NSString*)value {
    _url = value;
}

-(NSString*)getRedirectUrl {
    return _redirectUrl;
}

-(void)setRedirectUrl:(NSString*)value {
    _redirectUrl = value;
}

-(void)loadUrl:(NSString*)url {
    NSString* properlyEncodedString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL *nsurl = [NSURL URLWithString:properlyEncodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsurl];

    [_webView loadRequest:request];
}

-(void)show {
    [UnityGetGLViewController().view addSubview:_webView];
    [UnityGetGLViewController().view addSubview:_toolbar];
    
    [self loadUrl:_url];
}

-(void)hide {
    [_webView removeFromSuperview];
    [_toolbar removeFromSuperview];
}

-(void)updateButtons {
    _forward.enabled = _webView.canGoForward;
    _back.enabled = _webView.canGoBack;
}

-(void)buttonBackClick {
    [_webView goBack];
}

-(void)buttonForwardClick {
    [_webView goForward];
}

-(void)buttonRefreshClick {
    [_webView reload];
}

-(void)buttonCloseClick {
    [self hide];

    self.authenticationCancelCallback();
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *requestNSUrl = navigationAction.request.URL;
    NSURL *redirectNSUrl = [NSURL URLWithString:_redirectUrl];
    
    if ([[requestNSUrl host] isEqualToString: [redirectNSUrl host]] ) {
        decisionHandler(WKNavigationActionPolicyCancel);

        [self hide];

        self.authenticationCodeCallback([WebViewPlugin NSStringToChar:[requestNSUrl absoluteString]]);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self updateButtons];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.authenticationErrorCallback((int)error.code, [WebViewPlugin NSStringToChar:error.description]);
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.authenticationErrorCallback((int)error.code, [WebViewPlugin NSStringToChar:error.description]);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self updateButtons];
}

+(NSString*)CharToNSString:(const char*)string {
    if (string) {
        return [NSString stringWithUTF8String: string];
    } else {
        return [NSString stringWithUTF8String: ""];
    }
}

+(char*)NSStringToChar:(NSString*)str {
    const char* string = [str UTF8String];

    if (string == NULL) {
        return NULL;
    }

    char* res = (char*)malloc(strlen(string) + 1);

    strcpy(res, string);

    return res;
}

@synthesize description;

@synthesize hash;

@synthesize superclass;

@end