#import <Cordova/CDV.h>
#import <WatchConnectivity/WatchConnectivity.h>
@interface WCiOS : CDVPlugin <WCSessionDelegate>
{
    NSString *messageReceiver;
}
@property (nonatomic, copy) NSString *messageReceiver;
- (void) init:(CDVInvokedUrlCommand*)command;
- (void) messageReceiver:(CDVInvokedUrlCommand*)command;
- (void) sendMessage:(CDVInvokedUrlCommand*)command;
@end
