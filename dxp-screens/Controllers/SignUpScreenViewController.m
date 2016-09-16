//
//  SignUpScreenViewController.m
//  dxp-screens
//
//  Created by Dimple Koticha on 2016-02-05.
//  Copyright © 2016 Liferay. All rights reserved.
//

#import "SignUpScreenViewController.h"

@interface SignUpScreenViewController ()

@property (nonatomic, weak) IBOutlet SignUpScreenlet *screenlet;

@end

@implementation SignUpScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenlet.delegate = self;
    NSLog(@"viewDidLoad");

}


- (void)screenlet:(SignUpScreenlet * __nonnull)screenlet onSignUpResponseUserAttributes:(NSDictionary<NSString *, id> * __nonnull)attributes {
    
    NSLog(@"Signup Successful %@", attributes);
    
    
    //Send Local Push Notification to direct newly signed up user to appropriate desk
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    // create a local notification
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:30];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = 0;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertAction = @"Let's do this";
    notification.alertBody = @"Please proceed to table 1.";
    
    [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
    
    [self performSegueWithIdentifier:@"SignupToHomeScreen" sender:self];

    
}
- (void)screenlet:(SignUpScreenlet * __nonnull)screenlet onSignUpError:(NSError * __nonnull)error {
    
    NSLog(@"Error Signing Up %@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
