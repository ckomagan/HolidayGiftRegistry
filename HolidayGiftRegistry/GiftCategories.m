//
//  HGRViewController.m
//  HolidayGiftRegistry
//
//  Created by Chan Komagan on 12/4/12.
//  Copyright (c) 2012 Chan Komagan. All rights reserved.
//

#import "GiftCategories.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "GiftController.h"

@interface GiftCategories ()
@property (nonatomic, strong) NSString *nsURL;

@end

@implementation GiftCategories
NSUserDefaults *standardUserDefaults;
NSString *category;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [electronicsBtn setTag:0];
    [homeBtn setTag:1];
    [childrenBtn setTag:2];
    [gamesBtn setTag:3];
    [healthBtn setTag:4];
    [booksBtn setTag:5];
    
    [peopleBtn setTag:0];
    [giftsBtn setTag:1];
    [progressBtn setTag:2];
    [settingsBtn setTag:3];

    [[progressBtn layer] setBorderWidth:2.0f];
    [[progressBtn layer] setBackgroundColor:[UIColor grayColor].CGColor];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendToGiftPage:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:button.tag forKey:@"category"];
        [standardUserDefaults synchronize];
    }
    /*
    if(button.tag == 1) category = @"Electronics";
    if(button.tag == 2) category = @"Home";
    if(button.tag == 3) category = @"Children";
    if(button.tag == 4) category = @"Games";
    if(button.tag == 5) category = @"Health";
    if(button.tag == 6) category = @"Books";*/
    
    [self redirectPage];
}

-(void)redirectPage
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"GiftController"];
    
    [self presentModalViewController:vc animated:false];
}

- (void)saveUserSession
{
    if (standardUserDefaults) {
        [standardUserDefaults setObject:category forKey:@"category"];
        [standardUserDefaults synchronize];
    }
}

@end
