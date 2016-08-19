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
    [_screenlet loadWebContent];
    
    //Set the screenlets delegate - The viewcontroller is the delegate.
    self.screenlet.delegate = self;
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Do any additional setup after loading the view.
}

- (NSString * __nullable)screenlet:(WebContentDisplayScreenlet * __nonnull)screenlet onWebContentResponse:(NSString * __nonnull)html {
    
    NSLog(@"onWebContentResponse");
    return(@"");
    
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
