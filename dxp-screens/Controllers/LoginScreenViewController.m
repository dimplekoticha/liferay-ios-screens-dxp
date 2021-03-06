//
//  LoginScreenViewController.m
//  dxp-screens
//
//  Created by Dimple Koticha on 2016-02-04.
//  Copyright © 2016 Liferay. All rights reserved.
//

#import "LoginScreenViewController.h"
#import "LRUserService_v7.h"


@interface LoginScreenViewController ()

@property (nonatomic, weak) IBOutlet LoginScreenlet *screenlet;
@property (nonatomic, weak) NSString *qrResult;
@property (nonatomic, strong) NSString *globalFullName;

@end

@implementation LoginScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenlet.delegate = self;
    NSLog(@"viewDidLoad");
}

- (void)screenlet:(BaseScreenlet * __nonnull)screenlet onLoginResponseUserAttributes:(NSDictionary<NSString *, id> * __nonnull)attributes {
    
    NSLog(@"Login Done: %@", attributes);
    [self performSegueWithIdentifier:@"LoginToHomeScreen" sender:self];
    
    
}

- (void)screenlet:(BaseScreenlet * __nonnull)screenlet onLoginError:(NSError * __nonnull)error {
    
    [self viewDidLoad];
    NSLog(@"Login Error: %@", error);
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanAction:(id)sender
{
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            
            /* Parse the QR code result VCard/Contact and build service call with contact info to Liferay instance
             
             BEGIN:VCARD
             VERSION:2.1
             N:4 (Liferay Speaker);Test
             FN:Test 4 (Liferay Speaker)
             EMAIL:sana.razvi@liferay.com
             ORG:Liferay
             TITLE:Manager
             END:VCARD
             
             */
            
            if (resultAsString != nil) {
            
                NSLog(@"Scanned QR Code: %@", resultAsString);
                NSLog(@"Starting to parse user data from QR code");

                //Build scanner on QR code string
                NSScanner *scanresultAsString = [NSScanner scannerWithString:resultAsString];
                
                NSCharacterSet *newLine = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
                NSCharacterSet *colon = [NSCharacterSet characterSetWithCharactersInString:@":"];
                NSCharacterSet *bracket = [NSCharacterSet characterSetWithCharactersInString:@"("];
                
                //Define parsing tokens. These are the items that will be used to sign up each user
                NSArray *keyArray = @[@"FN", @"EMAIL", @"ORG", @"TITLE"];
                NSMutableArray *valueArray = [[NSMutableArray alloc] init];
               
                NSString *result;
                
                //Start by scanning one line at a time tokenized by /n
                while ([scanresultAsString scanUpToCharactersFromSet:newLine intoString:&result]) {
                    
                    //if scanned token is FN, EMAIL, ORG, TITLE, parse further for value otherwise keep going
                    NSScanner *scanSecondary = [NSScanner scannerWithString:result];
                    NSString *secondResult, *value;
                    
                    //Scan until colon to extract "key"
                    if ([scanSecondary scanUpToCharactersFromSet:colon intoString:&secondResult]) {
                        NSLog(secondResult);
                        
                        //If the "key" is FN, EMAIL, ORG, TITLE
                        if ([keyArray containsObject:secondResult]) {
                            
                            if ([scanSecondary scanUpToCharactersFromSet:newLine intoString:&value]){
                                NSLog(value);
                                
                                //Determine which key is the value associated with
                                [valueArray addObject:value];
                            }
                            
                        }
                        
                    }
        
                }
                
                    
                //Make service call
                
                NSLog(@"Making service call to create user");
                
                //Create session
                LRSession *session = [[LRSession alloc] initWithServer:@"https://cloud-10-0-20-48.liferay.com/"
                                                        authentication:[[LRBasicAuthentication alloc] initWithUsername:@"bruno" password:@"test"]];
                
                
                
                //Instead of implementing separate call back class, using block to implement callback
                [session
                 onSuccess:^(id result) {
                     
                     NSLog(@"Callback - Success");
                     
                     
                     //Send Local Push Notification to direct newly signed up user to appropriate desk
                     
                     [[UIApplication sharedApplication] cancelAllLocalNotifications];
                     UILocalNotification *notification = [[UILocalNotification alloc]init];
                     
                     // create a local notification
                     notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:30];
                     notification.timeZone = [NSTimeZone defaultTimeZone];
                     notification.repeatInterval = 0;
                     notification.soundName = UILocalNotificationDefaultSoundName;
                     NSString *title = @"Welcome to DXP Bank, ";
                     //notification.alertTitle = (@"Welcome to DXP Bank");
                     notification.alertTitle = ([title stringByAppendingString:_globalFullName]);
                     notification.alertBody = (@"Meet with your banker now!");
                     
                     [[UIApplication sharedApplication]presentLocalNotificationNow:notification];
                     
                      NSLog(@"New QR User Registered");
                    
                 }
                 onFailure:^(NSError *e) {
                     // Implement error handling code
                     NSLog(@"Session error %@", e );
                     [self dismissViewControllerAnimated:YES completion:NULL];

                 }
                 ];
                

                long long companyid = 20116;
                
                //Trim off colon at the first position of the string
                NSString *name = [[valueArray objectAtIndex:0] stringByTrimmingCharactersInSet:colon];
                NSString *email = [[valueArray objectAtIndex:1] stringByTrimmingCharactersInSet:colon];
                NSString *jobTitle = [[valueArray objectAtIndex:3] stringByTrimmingCharactersInSet:colon];
                NSArray *blankArray = [[NSArray alloc]init];
                NSString *fullName;
                
                NSScanner *scanAttendeeName = [NSScanner scannerWithString:name];
                if ([scanAttendeeName scanUpToCharactersFromSet:bracket intoString:&fullName]) {
                    
                    if (fullName != nil) {
                        
                        //Update Category with new user for it to be read by portlet on the server side. even if the call to register the user fails
                        //We still want the server side portlet scanning for user name to be updated to give the effect that it's welcoming a returning user.
                        
                        LRAssetCategoryPropertyService_v7 *assetCategoryService = [[LRAssetCategoryPropertyService_v7 alloc] initWithSession:session];
                        NSError *error;
                        
                        //Using hardcoded categorypropertyid for now. It would be alot more work to call to retrieve and then parse it out
                        [assetCategoryService updateCategoryPropertyWithCategoryPropertyId:57612 key:@"lastregistereduser" value:fullName error:&error];

                        LRUserService_v7 *service = [[LRUserService_v7 alloc] initWithSession:session];
                        
                        [service addUserWithCompanyId:companyid autoPassword:true password1:@"test" password2:@"test" autoScreenName:true screenName:@"Dimple" emailAddress:email facebookId:0 openId:@"" locale:@"" firstName:fullName middleName:@"" lastName:@"Koticha" prefixId:0 suffixId:0 male:true birthdayMonth:1 birthdayDay:1 birthdayYear:1970 jobTitle:jobTitle groupIds:blankArray organizationIds:blankArray roleIds:blankArray userGroupIds:blankArray addresses:blankArray emailAddresses:blankArray phones:blankArray websites:blankArray announcementsDelivers:blankArray sendEmail:true serviceContext:nil error:&error];
                        
                        self.globalFullName = [[NSString alloc] initWithString:fullName];
                    }

                }
                
            }
    }];
    
    [self presentViewController:vc animated:YES completion:NULL];
    }
    
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
