#import "WCiOS.h"

@implementation WCiOS
@synthesize messageReceiver;
- (void)init:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    CDVPluginResult* pluginResult = nil;
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"WCSession is not supported!"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}
- (void)messageReceiver:(CDVInvokedUrlCommand*)command {
    self.messageReceiver = [command callbackId];
}
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler{
    NSError *err;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:0 error:&err] encoding:NSUTF8StringEncoding]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.messageReceiver];
}
- (void)sendMessage:(CDVInvokedUrlCommand*)command {
    NSString* message = [[command arguments] objectAtIndex:0];
    NSDictionary *messageDictionary = [[NSDictionary alloc] initWithObjects:@[message] forKeys:@[@"message"]];
    [[WCSession defaultSession] sendMessage:messageDictionary
                               replyHandler:^(NSDictionary *reply) {}
                               errorHandler:^(NSError *error) {}
     ];
}

@end
