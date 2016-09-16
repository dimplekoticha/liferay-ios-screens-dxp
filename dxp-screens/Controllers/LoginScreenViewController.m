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
            
            NSLog(@"Completion with result: %@", resultAsString);

            //Build scanner on QR code string
            NSScanner *scan = [NSScanner scannerWithString:resultAsString];
            
            NSCharacterSet *newLine = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
            NSCharacterSet *colon = [NSCharacterSet characterSetWithCharactersInString:@":"];
            
            //Define parsing tokens. These are the items that will be used to sign up each user
            NSArray *keyArray = @[@"FN", @"EMAIL", @"ORG", @"TITLE"];
            NSMutableArray *valueArray = [[NSMutableArray alloc] init];
           
            NSString *result;
            
            while ([scan scanUpToCharactersFromSet: newLine intoString:&result]) {
                
                //if scanned token is FN, EMAIL, ORG, TITLE, parse further for value otherwise keep going
                
                NSScanner *secondScan = [NSScanner scannerWithString:result];
                NSString *secondResult, *value;
                
                if ([secondScan scanUpToCharactersFromSet:colon intoString:&secondResult]) {
                    NSLog(secondResult);
                    
                    if ([keyArray containsObject:secondResult]) {
                        
                        if ([secondScan scanUpToCharactersFromSet:newLine intoString:&value]){
                            NSLog(value);
                            
                            //Determine which key is the value associated with
                            [valueArray addObject:value];
                            
                        }
                        
                    }
                    
                }
                
                
                
            }
            
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    
    
    //Create session
    LRSession *session = [[LRSession alloc] initWithServer:@"https://cloud-10-0-20-48.liferay.com/"
                                            authentication:[[LRBasicAuthentication alloc] initWithUsername:@"bruno" password:@"test"]];
    
    LRUserService_v7 *service = [[LRUserService_v7 alloc] initWithSession:session];
    NSError *error;
    
    long long companyid = 20116;
    long long facebookId = 0;
    
    NSArray *blankArray = [[NSArray alloc]init];

    [service addUserWithCompanyId:companyid autoPassword:true password1:@"test" password2:@"test" autoScreenName:true screenName:@"Dimple" emailAddress:@"dimple@liferay.com" facebookId:0 openId:@"" locale:@"" firstName:@"Dimple" middleName:@"" lastName:@"Koticha" prefixId:0 suffixId:0 male:true birthdayMonth:1 birthdayDay:1 birthdayYear:1970 jobTitle:@"" groupIds:blankArray organizationIds:blankArray roleIds:blankArray userGroupIds:blankArray addresses:blankArray emailAddresses:blankArray phones:blankArray websites:blankArray announcementsDelivers:blankArray sendEmail:true serviceContext:nil error:&error];
    
    NSLog(@"Completed");
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
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
