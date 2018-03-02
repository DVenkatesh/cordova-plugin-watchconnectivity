#import "WCiOS.h"

@implementation WCiOS

@synthesize messageReceiver;
@synthesize messageDictionary;

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
        [self.commandDelegate sendPluginResult:pluginResult callbackId: callbackId];
    }];
}
- (void)messageReceiver:(CDVInvokedUrlCommand*)command {
    self.messageReceiver = [command callbackId];
}
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary : message];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.messageReceiver];
        replyHandler(message);
    });
}
- (void)sendMessage:(CDVInvokedUrlCommand*)command {
    NSDictionary* messageDictionary = [[command arguments] objectAtIndex:0];
    if (messageDictionary != nil) {
        [[WCSession defaultSession] sendMessage:messageDictionary
                                   replyHandler:^(NSDictionary *reply) {}
                                   errorHandler:^(NSError *error) {}
         ];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No messsage to send!"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

@end

