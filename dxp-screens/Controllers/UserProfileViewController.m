//
//  UserProfileViewController.m
//  dxp-screens
//
//  Created by Dimple Koticha on 2016-09-08.
//  Copyright © 2016 Liferay. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@property (nonatomic, weak) IBOutlet UserPortraitScreenlet *screenlet;


@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenlet.delegate = self;
    
    //[SessionContext loginWithBasicWithUsername:@"bruno" password:@"test" userAttributes:[NSDictionary dictionary]];
    [self.screenlet loadLoggedUserPortrait];
    [self.screenlet setPresentingViewController:self];
}

//Get other delegate method definitions and add them. XCode isn't opening the UserPortraitScreenletDelegate class for me to grab those methods.

- (void)screenlet:(BaseScreenlet * __nonnull)screenlet onUserPortraitError:(NSError * __nonnull)error {
 
    NSLog(@"Portrait Loading Error: %@", error);
    
}

- (void)screenlet:(BaseScreenlet * __nonnull)screenlet onUserPortraitUploadError:(NSError * __nonnull)error {
    
    NSLog(@"Portrait Upload Error: %@", error);
    
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
