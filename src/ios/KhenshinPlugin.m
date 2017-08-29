#import "KhenshinPlugin.h"
#import <Cordova/CDVPlugin.h>
#import <khenshin/khenshin.h>
#import "PaymentProcessHeader.h"

@implementation KhenshinPlugin

- (void)pluginInitialize
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];

}

- (UIView*) processHeader {

    PaymentProcessHeader *processHeaderObj =    [[[NSBundle mainBundle] loadNibNamed:@"PaymentProcessHeader"
                                                                               owner:self
                                                                             options:nil]
                                                 objectAtIndex:0];

    //    return nil;
    return processHeaderObj;
}

-(UIColor *)getColor:(NSString*)col
{
    
    SEL selColor = NSSelectorFromString(col);
    UIColor *color = nil;
    if ( [UIColor respondsToSelector:selColor] == YES) {
        
        color = [UIColor performSelector:selColor];
    }
    return color;
}

- (void)finishLaunching:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] setBool:NO
                                            forKey:@"KH_SHOW_HOW_IT_WORKS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *khipuConfig = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"KhipuConfig"];
    
    enum KHMainButton buttonStyle = KHMainButtonDefault;
    NSString *style =khipuConfig[@"IOS_MAIN_BUTTON_STYLE"];
    
    if ([style isEqualToString:@"KHMainButtonFatOnForm"]) {
        buttonStyle = KHMainButtonFatOnForm;
    } else if ([style isEqualToString:@"KHMainButtonSkinnyOnForm"]) {
        buttonStyle = KHMainButtonSkinnyOnForm;
    }
   

    [KhenshinInterface initWithNavigationBarCenteredLogo:[[UIImage alloc] init]
                               NavigationBarLeftSideLogo:[[UIImage alloc] init]
                                         automatonAPIURL:[[NSURL alloc] initWithString:khipuConfig[@"TASK_API_URL"]]
                                           cerebroAPIURL:[[NSURL alloc] initWithString:khipuConfig[@"DUMP_API_URL"]]
                                           processHeader:(UIView<ProcessHeader>*)[self processHeader]
                                          processFailure:nil
                                          processSuccess:nil
                                          processWarning:nil
                                  allowCredentialsSaving:[khipuConfig[@"ALLOW_CREDENTIALS_SAVING"] isEqualToString:@"true"]
                                         mainButtonStyle:buttonStyle
                         hideWebAddressInformationInForm:[khipuConfig[@"HIDE_WEB_ADDRESS"] isEqualToString:@"true"]
                                useBarCenteredLogoInForm:[khipuConfig[@"IOS_USE_BAR_CENTERED_LOGO_IN_FORM"] isEqualToString:@"true"]
                                          principalColor: [self getColor:khipuConfig[@"IOS_PRINCIPAL_COLOR"]]
                                    darkerPrincipalColor:[self getColor:khipuConfig[@"IOS_DARKER_PRINCIPAL_COLOR"]]
                                          secondaryColor:[self getColor:khipuConfig[@"IOS_SECONDARY_COLOR"]]
                                   navigationBarTextTint:[self getColor:khipuConfig[@"IOS_NAVIGATION_BAR_TEXT_TINT"]]
                                                    font:[UIFont fontWithName:@"Avenir Next Condensed" size:15.0f]];
}

- (void)startByPaymentId:(CDVInvokedUrlCommand*)command
{


    [KhenshinInterface startEngineWithPaymentExternalId:[command.arguments objectAtIndex:0]
                                         userIdentifier:@""
                                      isExternalPayment:true
                                                success:^(NSURL *returnURL) {
                                                    CDVPluginResult* pluginResult = nil;
                                                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                                }
                                                failure:^(NSURL *returnURL) {
                                                    CDVPluginResult* pluginResult = nil;
                                                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                                }
                                               animated:false];
}

- (void)startByAutomatonId:(CDVInvokedUrlCommand*)command
{

    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] initWithCapacity:20];
    for(int i = 1; i < [command.arguments count] ; i ++) {
        NSArray* kv = [[command.arguments objectAtIndex:i] componentsSeparatedByString:@":"];
        [parameters setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
    }

    [KhenshinInterface startEngineWithAutomatonId:[command.arguments objectAtIndex:0]
                                         animated:false
                                       parameters:parameters
                                   userIdentifier:@""
                                          success:^(NSURL *returnURL) {
                                              CDVPluginResult* pluginResult = nil;
                                              pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                                              [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                          }
                                          failure:^(NSURL *returnURL) {
                                              CDVPluginResult* pluginResult = nil;
                                              pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                                              [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                          }];

}

@end
