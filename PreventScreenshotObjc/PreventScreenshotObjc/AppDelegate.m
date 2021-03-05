//
//  AppDelegate.m
//  PreventScreenshotObjc
//
//  Created by Abbie on 05/03/21.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    return YES;
}

- (void)userDidTakeScreenshot {
    // Screenshot taken, act accordingly.
    NSLog(@"Screenshot Taken");
    
    
    UIView *colourView = [[UIView alloc]initWithFrame:self.window.frame];

            colourView.backgroundColor = [UIColor blackColor];

            colourView.tag = 1234;

            colourView.alpha = 0;

            

            // fade in the view
    UILabel *lbl1 = [[UILabel alloc] init];
    lbl1.textColor = [UIColor blackColor];
    [lbl1 setFrame:colourView.frame];
    lbl1.backgroundColor=[UIColor clearColor];
    lbl1.textColor=[UIColor whiteColor];
    lbl1.textAlignment = NSTextAlignmentCenter;
    lbl1.numberOfLines = 0;
    lbl1.userInteractionEnabled=NO;
    lbl1.text= @"Screenshots are not allowed in our app. Please kill your app and launch again";
    [colourView addSubview:lbl1];
    [self.window makeKeyAndVisible];
    [self.window addSubview:colourView];

            [UIView animateWithDuration:0.5 animations:^{

                colourView.alpha = 1;

            }];

}

-(void)dealloc {
    NSLog(@"viewController is being deallocated");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

@end
