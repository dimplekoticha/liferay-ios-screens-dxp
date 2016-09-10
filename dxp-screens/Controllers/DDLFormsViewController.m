//
//  DDLFormsViewController.m
//  dxp-screens
//
//  Created by Dimple Koticha on 2016-09-08.
//  Copyright © 2016 Liferay. All rights reserved.
//

#import "DDLFormsViewController.h"

@interface DDLFormsViewController ()

@property (nonatomic, weak) IBOutlet DDLFormScreenlet *screenlet;

@end

@implementation DDLFormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.screenlet.delegate = self;
    [self.screenlet loadForm];
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
