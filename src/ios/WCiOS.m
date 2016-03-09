#import "WCiOS.h"

@implementation WCiOS
@synthesize messageReceiver;
@synthesize messageString;
- (void)init:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
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
    }];
}
- (void)messageReceiver:(CDVInvokedUrlCommand*)command {
    self.messageReceiver = [command callbackId];
}
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        replyHandler([[NSDictionary alloc] initWithObjects:@[self.messageString?self.messageString:@""] forKeys:@[@"message"]]);
    });
}
- (void)sendMessage:(CDVInvokedUrlCommand*)command {
    NSString* message = [[command arguments] objectAtIndex:0];
    if (message != nil) {
        self.messageString = message;
    }
    NSDictionary *messageDictionary = [[NSDictionary alloc] initWithObjects:@[message] forKeys:@[@"message"]];
    [[WCSession defaultSession] sendMessage:messageDictionary
                               replyHandler:^(NSDictionary *reply) {}
                               errorHandler:^(NSError *error) {}
     ];
}

@end
