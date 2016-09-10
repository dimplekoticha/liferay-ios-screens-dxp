//
//  DDLFormsViewController.h
//  dxp-screens
//
//  Created by Dimple Koticha on 2016-09-08.
//  Copyright © 2016 Liferay. All rights reserved.
//

#import <UIKit/UIKit.h>
@import LiferayScreens;
@import SWRevealViewController;

@interface DDLFormsViewController : UIViewController <DDLFormScreenletDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@end
