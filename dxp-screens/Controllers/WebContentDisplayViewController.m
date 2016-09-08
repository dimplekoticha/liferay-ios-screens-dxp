//
//  WebContentDisplayViewController.m
//  dxp-screens
//
//  Created by Dimple Koticha on 2016-02-05.
//  Copyright © 2016 Liferay. All rights reserved.
//

#import "WebContentDisplayViewController.h"

@interface WebContentDisplayViewController ()

@property (nonatomic, weak) IBOutlet WebContentDisplayScreenlet *screenlet;

@end

@implementation WebContentDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set the screenlets delegate - The viewcontroller is the delegate.
    self.screenlet.delegate = self;
   
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //[SessionContext loginWithBasicWithUsername:@"bruno" password:@"test" userAttributes:[NSDictionary dictionary]];
  
    [self.screenlet loadWebContent];
    
    // Do any additional setup after loading the view.
}

- (void)screenlet:(WebContentDisplayScreenlet * _Nonnull)screenlet onRecordContentResponse:(DDLRecord * _Nonnull)record
{
    
}

- (NSString * _Nullable)screenlet:(WebContentDisplayScreenlet * _Nonnull)screenlet onWebContentResponse:(NSString * _Nonnull)html
{
    NSLog(@"html-> %@", html);
    return html;
}

- (void)screenlet:(WebContentDisplayScreenlet * __nonnull)screenlet onWebContentError:(NSError * __nonnull)error {
    
    NSLog(@"Webcontent Loading Error: %@", error);
    
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
