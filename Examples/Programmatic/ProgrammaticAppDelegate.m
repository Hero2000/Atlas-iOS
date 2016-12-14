//
//  ProgrammaticAppDelegate.m
//  Atlas
//
//  Created by Kevin Coleman on 2/14/15.
//
//

#import "ProgrammaticAppDelegate.h"
#import "ATLSampleConversationListViewController.h"
#import "LayerKitMock.h"
#import <Atlas/Atlas.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@import LayerKit; 

static BOOL ATLIsRunningTests()
{
    return (NSClassFromString(@"XCTestCase") || [[[NSProcessInfo processInfo] environment] valueForKey:@"XCInjectBundle"]);
}

@interface ProgrammaticAppDelegate ()

@end

@implementation ProgrammaticAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];

    ATLUserMock *mockUser = [ATLUserMock userWithMockUserName:ATLMockUserNameBlake];
    LYRClientMock *layerClient = [LYRClientMock layerClientMockWithAuthenticatedUserID:mockUser.userID];
    
    UIViewController *controller;
    if (ATLIsRunningTests()) {
        controller = [UIViewController new];
    } else {
        // NB: only hydrate a conversation with a random user when it's not test related, to avoid odd collisions
        [[LYRMockContentStore sharedStore] hydrateConversationsForAuthenticatedUserID:layerClient.authenticatedUserID count:1];

        controller = [ATLSampleConversationListViewController conversationListViewControllerWithLayerClient:(LYRClient *)layerClient];
        controller.view.backgroundColor = [UIColor whiteColor];
    }
    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
