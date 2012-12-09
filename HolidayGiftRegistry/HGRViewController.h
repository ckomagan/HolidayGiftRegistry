//
//  HGRViewController.h
//  HolidayGiftRegistry
//
//  Created by Chan Komagan on 12/4/12.
//  Copyright (c) 2012 Chan Komagan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGRViewController : UIViewController
{
    IBOutlet UIButton *registration;
    UITextField *name, *email, *password, *registry;
    IBOutlet UILabel *statusLabel, *registerFrame;
}
@property (nonatomic, strong) NSString *username, *useremail, *userpass;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain)  UILabel *statusLabel;

-(IBAction)registerAccount;

@end
