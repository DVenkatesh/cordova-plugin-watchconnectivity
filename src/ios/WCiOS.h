#import <Cordova/CDV.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface WCiOS : CDVPlugin <WCSessionDelegate>
{
    NSString *messageReceiver;
    NSString *messageString;
}

@property (nonatomic, strong) NSString *messageReceiver;
@property (nonatomic, copy) NSString *messageString;

- (void) init:(CDVInvokedUrlCommand*)command;
- (void) messageReceiver:(CDVInvokedUrlCommand*)command;
- (void) sendMessage:(CDVInvokedUrlCommand*)command;
@end
