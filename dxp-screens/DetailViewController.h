//
//  DetailViewController.h
//  dxp-screens
//
//  Created by Dimple Koticha on 2016-02-04.
//  Copyright © 2016 Liferay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

