#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

// Delegates
typedef void(*AuthenticationCodeCallback)(const char* url);
typedef void(*AuthenticationErrorCallback)(int errorCode, const char* errorDescription);
typedef void(*AuthenticationCancelCallback)();

@interface WebViewPlugin:NSObject<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *back;
@property (nonatomic, strong) UIBarButtonItem *forward;
@property (nonatomic, strong) UIBarButtonItem *refresh;
@property (nonatomic, strong) UIBarButtonItem *close;

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *redirectUrl;

@property (nonatomic) AuthenticationCodeCallback authenticationCodeCallback;
@property (nonatomic) AuthenticationErrorCallback authenticationErrorCallback;
@property (nonatomic) AuthenticationCancelCallback authenticationCancelCallback;

-(id)init;

-(NSString*)getUrl;
-(void)setUrl:(NSString*)value;
-(NSString*)getRedirectUrl;
-(void)setRedirectUrl:(NSString*)value;

-(void)setAuthenticationCodeCallback:(AuthenticationCodeCallback)callback;
-(void)setAuthenticationErrorCallback:(AuthenticationErrorCallback)callback;
-(void)setAuthenticationCancelCallback:(AuthenticationCancelCallback)callback;

-(void)show;

+(NSString*)CharToNSString:(const char*)string;
+(char*)NSStringToChar:(NSString*)str;

@end