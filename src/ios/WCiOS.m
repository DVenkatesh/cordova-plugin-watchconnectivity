#import "WCiOS.h"

@implementation WCiOS

@synthesize messageReceiver;
@synthesize messageDictionary;

// Init does the WCSession.activateSession and keeps the callbackId pointer
// the callbackId pointer is later used when messages are received in
- (void)init:(CDVInvokedUrlCommand*)command
{
    NSLog(@"WatchConnectivity :: init");
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

// It gets invoked when a message is received by didReceiveMessage
// or alternatively through didReceiveApplicationContext
- (void)messageReceiver:(CDVInvokedUrlCommand*)command {
    NSLog(@"WatchConnectivity :: messageReceiver");
    self.messageReceiver = [command callbackId];
}

// Received a message from WCSession.default.sendMessage
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"WatchConnectivity :: didReceiveMessage :: replyHandler :: msg: %@", message);
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary : message];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.messageReceiver];
        replyHandler(message);
    });
}

// Received a message from WCSession.default.sendMessage - no replyHandler
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"WatchConnectivity :: didReceiveMessage :: msg: %@", message);
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary : message];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.messageReceiver];
    });
}

// Received a message from WCSession.default.updateApplicationContext
- (void) session:(nonnull WCSession *)session didReceiveApplicationContext:(nonnull NSDictionary<NSString *,id> *)applicationContext {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"WatchConnectivity :: didReceiveApplicationContext :: msg: %@", applicationContext);
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary : applicationContext];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.messageReceiver];
    });
}

// Sends a message to the watch through WCSession.default.sendMessage
- (void)sendMessage:(CDVInvokedUrlCommand*)command {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary* messageDictionary = [[command arguments] objectAtIndex:0];
        NSLog(@"WatchConnectivity :: sendMessage :: msg: %@", messageDictionary);
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
    });
}

// Sends a message to the watch through WCSession.default.updateApplicationContext
- (void)updateApplicationContext:(CDVInvokedUrlCommand*)command {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary* messageDictionary = [[command arguments] objectAtIndex:0];
        NSLog(@"WatchConnectivity :: updateApplicationContext :: msg: %@", messageDictionary);
        if (messageDictionary != nil) {
            NSError* error = nil;
            BOOL isContextUpdated = [[WCSession defaultSession] updateApplicationContext:messageDictionary error:&error];
            if (isContextUpdated){
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        } else {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No messsage to send!"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    });
}

@end
