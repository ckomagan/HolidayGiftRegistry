
#import "RecipientController.h"
#import "ImageController.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>

@interface RecipientController()
@property (nonatomic, strong) NSString *nsURL;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end;

@implementation RecipientController
@synthesize statusLabel, popoverController, contactImageView, userfirstname, useremail, userphone, nsURL, responseData, userId;
@synthesize spinner = _spinner;
NSDictionary *res;
NSUserDefaults *standardUserDefaults;
BOOL newMedia;
NSString *imagePeopleURL = @"http://komagan.com/holidaygift/uploads/people/";
UIImage *contactImage;
ImageController *peopleImageController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self initiateUIControls];
    [self initializeButtons];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snow-background.jpg"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)initiateUIControls
{
    self.spinner.hidden = TRUE;

    /* initiate name */
    firstNameTxt = [[UITextField alloc] initWithFrame:CGRectMake(240, 220, 440, 50)];
    firstNameTxt.borderStyle = 3; // rounded, recessed rectangle
    firstNameTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    firstNameTxt.textAlignment = UITextAlignmentCenter;
    firstNameTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    firstNameTxt.returnKeyType = UIReturnKeyDone;
    firstNameTxt.font = [UIFont fontWithName:@"Trebuchet MS" size:45];
    firstNameTxt.textColor = [UIColor blackColor];
    firstNameTxt.delegate = self;
    [self.view addSubview:firstNameTxt];
    
    /* initiate email */
    emailTxt = [[UITextField alloc] initWithFrame:CGRectMake(240, 300, 440, 50)];
    emailTxt.borderStyle = 3; // rounded, recessed rectangle
    emailTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTxt.textAlignment = UITextAlignmentCenter;
    emailTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailTxt.returnKeyType = UIReturnKeyDone;
    emailTxt.keyboardType = UIKeyboardTypeEmailAddress;
    emailTxt.font = [UIFont fontWithName:@"Trebuchet MS" size:45];
    emailTxt.textColor = [UIColor blackColor];
    emailTxt.delegate = self;
    [self.view addSubview:emailTxt];
    
    /* initiate phone */
    phoneNumberTxt = [[UITextField alloc] initWithFrame:CGRectMake(240, 380, 440, 50)];
    phoneNumberTxt.borderStyle = 3; // rounded, recessed rectangle
    phoneNumberTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    phoneNumberTxt.textAlignment = UITextAlignmentCenter;
    phoneNumberTxt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneNumberTxt.returnKeyType = UIReturnKeyDone;
    phoneNumberTxt.font = [UIFont fontWithName:@"Trebuchet MS" size:45];
    phoneNumberTxt.textColor = [UIColor blackColor];
    phoneNumberTxt.delegate = self;
    [self.view addSubview:phoneNumberTxt];
    
    addContactBtn.enabled = NO;
    
    recipientFrame.layer.borderWidth = 1;
    recipientFrame.layer.borderColor = [[UIColor grayColor] CGColor];
    recipientFrame.layer.cornerRadius = 20;
}

-(void)initializeButtons
{
    UIImage * btnImage = [UIImage imageNamed: @"darkgray.jpg"];
    UIImage * btnSelectedImage = [UIImage imageNamed: @"darkblue.jpg"];
    
    [peopleBtn setBackgroundImage:btnSelectedImage forState:UIControlStateNormal];
    [peopleBtn setUserInteractionEnabled:NO];
    [peopleBtn setEnabled:NO];
    
    [progressBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [giftsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [settingsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

- (IBAction)showPicker:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentModalViewController:picker animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    [firstNameTxt setText:name];

    NSString* email = nil;
    ABMultiValueRef emailaddresses = ABRecordCopyValue(person,
                                                     kABPersonEmailProperty);
    if (ABMultiValueGetCount(emailaddresses) > 0) {
        email = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(emailaddresses, 0);
    } else {
        email = @"[None]";
    }

    if(email) [emailTxt setText:email];
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    
    if(phone) [phoneNumberTxt setText:phone];
}

-(IBAction)addContact
{
    [self saveImage:contactImage];
    nsURL = @"http://www.komagan.com/holidaygift/index.php?format=json&addContact=1";
    userfirstname = firstNameTxt.text; useremail = emailTxt.text; userphone = phoneNumberTxt.text;
    self.responseData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:nsURL];
    //NSLog(@"%@", firstNameTxt.text);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    userId = [standardUserDefaults objectForKey:@"id"];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/xml;charset=UTF-8;"];
    [request setPostValue:userId forKey:@"user"];
    [request setPostValue:userfirstname forKey:@"name"];
    [request setPostValue:useremail forKey:@"email"];
    [request setPostValue:userphone forKey:@"phone"];
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

-(void)saveImage:(UIImage*)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);     //change Image to NSData
    
    if (imageData != nil)
    {
        self.spinner.hidden = FALSE;
        [self.spinner startAnimating];
        NSString *urlString = @"http://www.komagan.com/holidaygift/index.php?format=json&uploadImage=1";
        urlString = [urlString stringByAppendingString:@"&target=uploads/people/"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        NSString *fileName = [userfirstname stringByAppendingString:@".jpg\r\n"];
        NSString *fileFormat = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename="];
        fileFormat = [fileFormat stringByAppendingString:fileName];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:fileFormat,index] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", returnString);
    }
}

-(void)validateTextField
{
    userfirstname = firstNameTxt.text; useremail = emailTxt.text; userphone = phoneNumberTxt.text;
    
    if(userfirstname.length == 0 || useremail.length == 0 )
    {
        statusLabel.text = @"Please enter the contact info!";
    }
    else{
        statusLabel.text = @" ";
        addContactBtn.enabled = YES;
    }
}

-(BOOL)textFieldShouldReturn:(id)sender
{
    [sender resignFirstResponder];
    [firstNameTxt resignFirstResponder];
    [emailTxt resignFirstResponder];
    [phoneNumberTxt resignFirstResponder];
    [self validateTextField];
    return YES;
}

- (IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
    [self validateTextField];
}

- (void)textFieldDidEndEditing:(UITextView *)textView
{
    [firstNameTxt resignFirstResponder];
    [emailTxt resignFirstResponder];
    [phoneNumberTxt resignFirstResponder];
    [self validateTextField];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [firstNameTxt resignFirstResponder];
    [emailTxt resignFirstResponder];
    [phoneNumberTxt resignFirstResponder];
    [self validateTextField];
}

-(IBAction)UpLoadImage {
    if(userfirstname)
    {
        peopleImageController = [[ImageController alloc] initWithNibName:@"ImageController" bundle:nil];
        peopleImageController.source = @"Contact";
        peopleImageController.photoName = userfirstname;
        [self presentModalViewController:peopleImageController animated:true];
    }
    else{
        statusLabel.text = @"Please enter the gift name!";
    }
}


-(IBAction)redirectMyRegistry
{
    self.spinner.hidden = TRUE;
    [self.spinner startAnimating];

    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"WishListController"];
    [self presentModalViewController:vc animated:false];
}

-(IBAction)redirectAddGift
{
    self.spinner.hidden = FALSE;
    [self.spinner startAnimating];
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"GiftController"];
    [self presentModalViewController:vc animated:false];
}

-(IBAction)redirectAddContact
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"RecipientController"];
    [self presentModalViewController:vc animated:false];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(peopleImageController && firstNameTxt.text)
    {
        contactImage = peopleImageController.image;
        if(contactImage) {
            contactImageView.image = contactImage;
            uploadBtn.hidden = TRUE;
        }
    }
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
