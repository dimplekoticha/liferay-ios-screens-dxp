//
//  WebContentDisplayViewController.h
//  dxp-screens
//
//  Created by Dimple Koticha on 2016-02-05.
//  Copyright © 2016 Liferay. All rights reserved.
//

#import <UIKit/UIKit.h>
@import LiferayScreens;
@import SWRevealViewController;

@interface WebContentDisplayViewController : UIViewController <WebContentDisplayScreenletDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@end
