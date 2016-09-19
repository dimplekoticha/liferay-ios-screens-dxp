//
//  LoginScreenViewController.h
//  dxp-screens
//
//  Created by Dimple Koticha on 2016-02-04.
//  Copyright © 2016 Liferay. All rights reserved.
//

#import <UIKit/UIKit.h>
@import LiferayScreens;
@import QRCodeReaderViewController;

@interface LoginScreenViewController : UIViewController <LoginScreenletDelegate, QRCodeReaderDelegate>


- (IBAction)scanAction:(id)sender;

@end
