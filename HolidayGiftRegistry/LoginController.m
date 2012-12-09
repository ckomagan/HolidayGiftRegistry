
#import "LoginController.h"
#import <QuartzCore/QuartzCore.h>
#import "GiftController.h"
#import "ASIFormDataRequest.h"

@interface LoginController()
@property (nonatomic, strong) NSString *nsURL;
@end;

@implementation LoginController
NSString *newString;
int userid;
NSDictionary *res;
@synthesize statusLabel, nsURL, responseData, useremail, userpass;
NSUserDefaults *standardUserDefaults;
UIImage *btnImage, *btnSelectedImage;
UIButton *loginBtn;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    btnImage = [UIImage imageNamed: @"darkgray.jpg"];
    btnSelectedImage = [UIImage imageNamed: @"darkblue.jpg"];
    hiLabel.hidden = true;
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [self initiateUIControls];
    [self initializeButton];
    [self loadUserSession];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)initiateUIControls
{
    /* initiate email */
    email = [[UITextField alloc] initWithFrame:CGRectMake(320, 510, 280, 50)];
    email.borderStyle = 3; // rounded, recessed rectangle
    email.autocorrectionType = UITextAutocorrectionTypeNo;
    email.textAlignment = UITextAlignmentCenter;
    email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    email.returnKeyType = UIReturnKeyDone;
    email.font = [UIFont fontWithName:@"Trebuchet MS" size:40];
    email.textColor = [UIColor blackColor];
    email.keyboardType = UIKeyboardTypeEmailAddress;
    email.delegate = self;
    [self.view addSubview:email];
    
    /* initiate password */
    password = [[UITextField alloc] initWithFrame:CGRectMake(320, 580, 280, 50)];
    password.borderStyle = 3; // rounded, recessed rectangle
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.textAlignment = UITextAlignmentCenter;
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.returnKeyType = UIReturnKeyDone;
    password.font = [UIFont fontWithName:@"Trebuchet MS" size:40];
    password.textColor = [UIColor blackColor];
    password.secureTextEntry = YES;
    password.delegate = self;
    [self.view addSubview:password];
    
    loginFrame.layer.borderWidth = 1;
    loginFrame.layer.borderColor = [[UIColor grayColor] CGColor];
    loginFrame.layer.cornerRadius = 5;
}

-(void)initializeButton
{
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(160, 680, 250, 60)];
    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [[loginBtn titleLabel] setFont:[UIFont fontWithName:@"Gill Sans" size:40.0f]];
    [loginBtn setBackgroundImage:btnSelectedImage forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(performLogin) forControlEvents:UIControlEventTouchUpInside];
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = loginBtn.bounds;
    [self.view addSubview:loginBtn];
}

- (void)saveUserSession
{
    if (standardUserDefaults) {
        [standardUserDefaults setObject:email.text forKey:@"email"];
        [standardUserDefaults setObject:password.text forKey:@"password"];
        [standardUserDefaults synchronize];
    }
}

- (void)loadUserSession
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {;
        //NSLog(@" session = %@", [standardUserDefaults objectForKey:@"email"]);
        email.text = [standardUserDefaults objectForKey:@"email"];
        password.text = [standardUserDefaults objectForKey:@"password"];
        hiLabel.hidden = false; nameLabel.text = [standardUserDefaults objectForKey:@"name"];
        loginBtn.enabled = YES;
    }
}

-(void)validateTextField
{
    useremail = email.text; userpass = password.text;
    if(useremail.length == 0 || userpass.length == 0)
    {
            statusLabel.text = @"Please complete the form";
    }
    else{
        statusLabel.text = @" ";
        loginBtn.enabled = YES;
        [loginBtn setBackgroundImage:btnSelectedImage forState:UIControlStateNormal];
    }
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    [email resignFirstResponder];
    [password resignFirstResponder];
    [self validateTextField];
}

- (IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
    [self validateTextField];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [email resignFirstResponder];
    [password resignFirstResponder];
    [self validateTextField];
}


-(void)viewWillAppear:(BOOL)animated
{
    [loginBtn setEnabled:NO];
}

-(IBAction)performLogin
{
    
    NSString *loginURL = @"http://www.komagan.com/holidaygift/index.php?format=json&login=1&email=";
    nsURL = [loginURL stringByAppendingFormat:@"%@", useremail];
    nsURL = [nsURL stringByAppendingFormat:@"&password="];
    nsURL = [nsURL stringByAppendingFormat:@"%@", userpass];
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
    NSError *myError = nil;
    res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:&myError];
    
    if(res != [NSNull null]){
    for(NSDictionary *res1 in res) {
            userid = [[res1 objectForKey:@"result"] intValue];
            if (standardUserDefaults) {
                [standardUserDefaults setInteger:userid forKey:@"userid"];
            }
            statusLabel.text = @"";
            [self saveUserSession];
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"WishListController"];
            [self presentModalViewController:vc animated:false];
        }
    }
    else{
        statusLabel.text = @"Login Failed. Please retry!";
    }
    if (myError) {
        NSLog(@"There was a JSONSerialization Error: %@",myError);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    }

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.responseData = nil;
}

-(IBAction)dismissView {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
