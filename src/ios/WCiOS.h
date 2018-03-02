#import <Cordova/CDV.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface WCiOS : CDVPlugin <WCSessionDelegate>
{
    NSString *messageReceiver;
    NSDictionary *messageDictionary;
}

@property (nonatomic, strong) NSString *messageReceiver;
@property (nonatomic, copy) NSDictionary *messageDictionary;

- (void) init:(CDVInvokedUrlCommand*)command;
- (void) messageReceiver:(CDVInvokedUrlCommand*)command;
- (void) sendMessage:(CDVInvokedUrlCommand*)command;
@end
