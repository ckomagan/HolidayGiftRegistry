//
//  HGRViewController.m
//  HolidayGiftRegistry
//
//  Created by Chan Komagan on 12/4/12.
//  Copyright (c) 2012 Chan Komagan. All rights reserved.
//

#import "HGRViewController.h"
#import "ASIFormDataRequest.h"

@interface HGRViewController ()
@property (nonatomic, strong) NSString *nsURL;

@end

@implementation HGRViewController
@synthesize username, nsURL, responseData, useremail, userpass;


- (void)viewDidLoad
{
    [self initiateUIControls];
    

    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initiateUIControls
{
    /* initiate name */
    name = [[UITextField alloc] initWithFrame:CGRectMake(360, 210, 240, 50)];
    name.borderStyle = 3; // rounded, recessed rectangle
    name.autocorrectionType = UITextAutocorrectionTypeNo;
    name.textAlignment = UITextAlignmentCenter;
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    name.returnKeyType = UIReturnKeyDone;
    name.font = [UIFont fontWithName:@"Trebuchet MS" size:50];
    name.textColor = [UIColor blackColor];
    name.delegate = self;
    [self.view addSubview:name];
    
    /* initiate email */
    email = [[UITextField alloc] initWithFrame:CGRectMake(360, 300, 240, 50)];
    email.borderStyle = 3; // rounded, recessed rectangle
    email.autocorrectionType = UITextAutocorrectionTypeNo;
    email.textAlignment = UITextAlignmentCenter;
    email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    email.returnKeyType = UIReturnKeyDone;
    email.font = [UIFont fontWithName:@"Trebuchet MS" size:50];
    email.textColor = [UIColor blackColor];
    email.delegate = self;
    [self.view addSubview:email];
    
    /* initiate password */
    password = [[UITextField alloc] initWithFrame:CGRectMake(360, 390, 240, 50)];
    password.borderStyle = 3; // rounded, recessed rectangle
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.textAlignment = UITextAlignmentCenter;
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.returnKeyType = UIReturnKeyDone;
    password.font = [UIFont fontWithName:@"Trebuchet MS" size:50];
    password.textColor = [UIColor blackColor];
    password.delegate = self;
    [self.view addSubview:password];
}

-(IBAction)registerAccount
{
    nsURL = @"http://www.komagan.com/KidsIQ/leaders.php?format=json&adduser2=1";

    self.responseData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:nsURL];
    NSLog(@"%@", username);    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/xml;charset=UTF-8;"];
    [request setPostValue:username forKey:@"name"];
    [request setPostValue:useremail forKey:@"email"];
    [request setPostValue:userpass forKey:@"password"];

    [request setDelegate:self];
    [request startAsynchronous];

}

@end
