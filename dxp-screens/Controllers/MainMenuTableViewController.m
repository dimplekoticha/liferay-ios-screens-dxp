//
//  MainMenuTableViewController.m
//  dxp-screens
//
//  Created by Dimple Koticha on 2016-08-18.
//  Copyright © 2016 Liferay. All rights reserved.
//

#import "MainMenuTableViewController.h"
@import SWRevealViewController;

@interface MainMenuTableViewController ()

@end

@implementation MainMenuTableViewController {
    
    NSArray *mainMenu;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //Items in slide out menu on Main Screen after Login
    mainMenu = @[@"first", @"second", @"third", @"fourth"];
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //Only 1 column
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //Return number of elements in mainMenu
    return [mainMenu count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    //mainMenu is an array of identifiers used to make connection with prototype cells on TableViewController
    NSString *cellIdentifier = [mainMenu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue isKindOfClass:[SWRevealViewControllerSegueSetController class] ]){
        
        UIViewController *dvc = [segue destinationViewController];
        
        UINavigationController *navCtrl = (UINavigationController *) self.revealViewController.frontViewController;
        
        [navCtrl setViewControllers:@[dvc] animated:NO];
        
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
    
}


@end
