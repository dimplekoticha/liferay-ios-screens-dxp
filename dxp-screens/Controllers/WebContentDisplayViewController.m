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
    self.screenlet.delegate = self;

    // Do any additional setup after loading the view.
}

- (NSString * __nullable)screenlet:(WebContentDisplayScreenlet * __nonnull)screenlet onWebContentResponse:(NSString * __nonnull)html {
    
    return(@"");
    
}

- (void)screenlet:(WebContentDisplayScreenlet * __nonnull)screenlet onWebContentError:(NSError * __nonnull)error {
    
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
