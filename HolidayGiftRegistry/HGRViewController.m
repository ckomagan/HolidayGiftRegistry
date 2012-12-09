//
//  HGRViewController.m
//  HolidayGiftRegistry
//
//  Created by Chan Komagan on 12/4/12.
//  Copyright (c) 2012 Chan Komagan. All rights reserved.
//

#import "HGRViewController.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "GiftController.h"

@interface HGRViewController ()
@property (nonatomic, strong) NSString *nsURL;

@end

@implementation HGRViewController
NSString *newString;
BOOL nameExists;
NSDictionary *res;
@synthesize statusLabel, username, nsURL, responseData, useremail, userpass;
NSUserDefaults *standardUserDefaults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [self initiateUIControls];
    statusLabel.text = @"";
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
    name = [[UITextField alloc] initWithFrame:CGRectMake(380, 210, 280, 50)];
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
    email = [[UITextField alloc] initWithFrame:CGRectMake(380, 300, 280, 50)];
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
    password = [[UITextField alloc] initWithFrame:CGRectMake(380, 390, 280, 50)];
    password.borderStyle = 3; // rounded, recessed rectangle
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.textAlignment = UITextAlignmentCenter;
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.returnKeyType = UIReturnKeyDone;
    password.font = [UIFont fontWithName:@"Trebuchet MS" size:50];
    password.textColor = [UIColor blackColor];
    password.secureTextEntry = YES;
    password.delegate = self;
    [self.view addSubview:password];
    
    /* initiate registry */
    registry = [[UITextField alloc] initWithFrame:CGRectMake(380, 480, 280, 50)];
    registry.borderStyle = 3; // rounded, recessed rectangle
    registry.autocorrectionType = UITextAutocorrectionTypeNo;
    registry.textAlignment = UITextAlignmentCenter;
    registry.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    registry.returnKeyType = UIReturnKeyDone;
    registry.font = [UIFont fontWithName:@"Trebuchet MS" size:50];
    registry.textColor = [UIColor blackColor];
    registry.secureTextEntry = YES;
    registry.delegate = self;
    [self.view addSubview:registry];
    
    registerFrame.layer.borderWidth = 1;
    registerFrame.layer.borderColor = [[UIColor grayColor] CGColor];
    registerFrame.layer.cornerRadius = 20;
}

-(void)validateTextField
{
    username = name.text; useremail = email.text; userpass = password.text;
    
    if(nameExists) {
            statusLabel.text = [newString stringByAppendingString:@" Exists. Please enter another name"];
        }
    else if (username.length == 0 || useremail.length == 0 || userpass.length == 0){
            statusLabel.text = @"Please complete the form";
        }
    else {
        statusLabel.text = @"";
    }
   
    // make sure all fields are have something in them
    if (username.length  > 0 && username.length <= 6) {
        registration.enabled = YES;
    }
    else {
        registration.enabled = NO;
    }
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    [name resignFirstResponder];
    [email resignFirstResponder];
    [password resignFirstResponder];
    [self validateTextField];
    [self checkName];
}

- (IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
    [self checkName];
    [self validateTextField];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [name resignFirstResponder];
    [email resignFirstResponder];
    [password resignFirstResponder];
    [self checkName];
    [self validateTextField];
}

-(void)checkName
{
    nsURL = [@"http://www.komagan.com/holidaygift/index.php?format=json&checkname=1&email=" stringByAppendingFormat:@"%@", email.text];
    NSLog(@"nsURL = %@", nsURL);
    self.responseData = [NSMutableData data];
    NSURLRequest *aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: nsURL]];
    [[NSURLConnection alloc] initWithRequest:aRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *myError = nil;
    res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:&myError];
    for(NSDictionary *res1 in res) {
        nameExists = [[res1 objectForKey:@"result"] boolValue];
        if(nameExists)
        {
            statusLabel.text = [email.text stringByAppendingString:@" Exists. Please enter another name"];
        }
        else{
            [self validateTextField];
            }
    }
    if (myError) {
        NSLog(@"There was a JSONSerialization Error: %@",myError);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.responseData = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [registration setEnabled:NO];
}

-(IBAction)registerAccount
{
    nsURL = @"http://www.komagan.com/holidaygift/index.php?format=json&register=1";

    self.responseData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:nsURL];
    NSLog(@"%@", username);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [standardUserDefaults setObject:username forKey:@"name"];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/xml;charset=UTF-8;"];
    [request setPostValue:username forKey:@"name"];
    [request setPostValue:useremail forKey:@"email"];
    [request setPostValue:userpass forKey:@"password"];

    [request setDelegate:self];
    [request startAsynchronous];
    
    }

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"Request failed: %@",[request error]);
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"Submitted form successfully");
    NSLog(@"Response was:");
    NSLog(@"%@",[request responseString]);
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"LoginController"];
    [self presentModalViewController:vc animated:false];
}

@end
