
#import "GiftController.h"
#import "ImageController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"

@interface GiftController()
@property (nonatomic, strong) NSString *nsURL;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end;

@implementation GiftController
@synthesize levelpicker, popoverController, giftItemImageView, nsURL, responseData, userId;
@synthesize giftName, giftType, giftPrice, giftStore, giftNotes, toolbar;
@synthesize spinner = _spinner;
BOOL newMedia;
NSUserDefaults *standardUserDefaults;
NSString *giftImageURL = @"http://komagan.com/holidaygift/uploads/giftitem/";
UIImage *giftImage;
UIImagePickerController *imagePicker;
ImageController *imageController;

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
    addGiftBtn.enabled = NO;
    statusLabel.text = @" ";
    self.spinner.hidden = TRUE;
    self.spinner.transform = CGAffineTransformMakeScale(2.5, 2.5);

    levelpicker = [NSArray arrayWithObjects:@"Electronics", @"Home & Garden", @"Children & Toys", @"Games & Music", @"Health & Beauty", @"Books", nil];
    giftTypePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    giftTypePicker.delegate = self;
    giftTypePicker.showsSelectionIndicator = YES;
    [self.view addSubview:giftTypePicker];
    //giftTypePicker.center = CGPointMake(600,460);
    giftTypePicker.frame = CGRectMake(470,300,220,180);

    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Camera"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(useCamera:)];
    UIBarButtonItem *cameraRollButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Camera Roll"
                                         style:UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(useCameraRoll:)];
    NSArray *items = [NSArray arrayWithObjects: cameraButton,
                      cameraRollButton, nil];

    //[toolbar setItems:items animated:NO];
    [self loadUserSession];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)initiateUIControls
{
    [[giftsBtn layer] setBorderWidth:2.0f];
    [[giftsBtn layer] setBackgroundColor:[UIColor grayColor].CGColor];

    /* initiate item name */
    itemText = [[UITextField alloc] initWithFrame:CGRectMake(480, 220, 200, 50)];
    itemText.borderStyle = 3; // rounded, recessed rectangle
    itemText.autocorrectionType = UITextAutocorrectionTypeNo;
    itemText.textAlignment = UITextAlignmentCenter;
    itemText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [itemText setReturnKeyType:UIReturnKeyDone];
    itemText.font = [UIFont fontWithName:@"Trebuchet MS" size:45];
    itemText.textColor = [UIColor blackColor];
    itemText.delegate = self;
    [self.view addSubview:itemText];
    
    /* initiate item price */
    priceText = [[UITextField alloc] initWithFrame:CGRectMake(480, 520, 200, 50)];
    priceText.borderStyle = 3; // rounded, recessed rectangle
    priceText.autocorrectionType = UITextAutocorrectionTypeNo;
    priceText.textAlignment = UITextAlignmentCenter;
    priceText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [priceText setReturnKeyType:UIReturnKeyDone];
    priceText.font = [UIFont fontWithName:@"Trebuchet MS" size:45];
    priceText.textColor = [UIColor blackColor];
    priceText.delegate = self;
    [self.view addSubview:priceText];
    
    /* initiate item vendor */
    storeText = [[UITextField alloc] initWithFrame:CGRectMake(480, 600, 200, 50)];
    storeText.borderStyle = 3; // rounded, recessed rectangle
    storeText.autocorrectionType = UITextAutocorrectionTypeNo;
    storeText.textAlignment = UITextAlignmentCenter;
    storeText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [storeText setReturnKeyType:UIReturnKeyDone];
    storeText.font = [UIFont fontWithName:@"Trebuchet MS" size:45];
    storeText.textColor = [UIColor blackColor];
    storeText.delegate = self;
    [self.view addSubview:storeText];
    
    /* initiate item notes */
    notesText = [[UITextField alloc] initWithFrame:CGRectMake(480, 680, 200, 50)];
    notesText.borderStyle = 3; // rounded, recessed rectangle
    notesText.autocorrectionType = UITextAutocorrectionTypeNo;
    notesText.textAlignment = UITextAlignmentCenter;
    notesText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [notesText setReturnKeyType:UIReturnKeyDone];
    notesText.font = [UIFont fontWithName:@"Trebuchet MS" size:45];
    notesText.textColor = [UIColor blackColor];
    notesText.delegate = self;
    [self.view addSubview:notesText];

    
    //giftItemImage.image = image;
}

-(void)initializeButtons
{
    UIImage * btnImage = [UIImage imageNamed: @"darkgray.jpg"];
    UIImage * btnSelectedImage = [UIImage imageNamed: @"darkblue.jpg"];
  
    [giftsBtn setBackgroundImage:btnSelectedImage forState:UIControlStateNormal];
    [giftsBtn setUserInteractionEnabled:NO];
    [giftsBtn setEnabled:NO];
    
    [progressBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [settingsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [peopleBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 6;
    return numRows;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGRect rect = CGRectMake(580, 220, 160, 100);
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.text = [levelpicker objectAtIndex:row];
    label.font = [UIFont systemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentLeft;
    label.numberOfLines = 1;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.backgroundColor = [UIColor clearColor];
    label.clipsToBounds = YES;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    giftType = [levelpicker objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [levelpicker objectAtIndex:row];
}

-(void)saveImage:(UIImage*)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);     //change Image to NSData
    
    if (imageData != nil)
    {
        NSString *urlString = @"http://www.komagan.com/holidaygift/index.php?format=json&uploadImage=1";
        urlString = [urlString stringByAppendingString:@"&target=uploads/giftitem/"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        NSString *fileName = [giftName stringByAppendingString:@".jpg\r\n"];
        NSString *fileFormat = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename="];
        fileFormat = [fileFormat stringByAppendingString:fileName];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:fileFormat,index] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        [self dismissView];
    }
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)thePopoverController{
    NSLog(@"clicked outside the popover");//never prints
    return YES;
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    picker.delegate = nil;
}

-(IBAction)addGift
{
    [self validateTextField];
    [self saveImage:giftImage];
    nsURL = @"http://www.komagan.com/holidaygift/index.php?format=json&addGift=1";
    giftName = itemText.text; giftPrice = priceText.text; giftStore = storeText.text;
    self.responseData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:nsURL];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    userId = [NSString stringWithFormat:@"%@", [standardUserDefaults objectForKey:@"userid"]];
    NSLog(@"userId = %@", userId);
    NSString *giftImageURL = [userId stringByAppendingString:giftName];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/xml;charset=UTF-8;"];
    [request setPostValue:userId forKey:@"userid"];
    [request setPostValue:giftName forKey:@"giftName"];
    [request setPostValue:giftType forKey:@"giftType"];
    [request setPostValue:giftPrice forKey:@"giftPrice"];
    [request setPostValue:giftStore forKey:@"giftStore"];
    [request setPostValue:giftImageURL forKey:@"giftImage"];
    [request setPostValue:@"N" forKey:@"status"];

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

-(void)validateTextField
{
    giftName = itemText.text; giftPrice = priceText.text; giftStore = storeText.text;
    
    if(giftName.length == 0)
    {
        statusLabel.text = @"Please enter a gift name!";
    }
    else{
        statusLabel.text = @" ";
        addGiftBtn.enabled = YES;
    }
}

-(BOOL)textFieldShouldReturn:(id)sender
{
    [sender resignFirstResponder];
    [itemText resignFirstResponder];
    [priceText resignFirstResponder];
    [storeText resignFirstResponder];
    [self validateTextField];
    return YES;
}

- (IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
    [self validateTextField];
}

- (void)textFieldDidEndEditing:(UITextView *)textView
{
    [itemText resignFirstResponder];
    [priceText resignFirstResponder];
    [storeText resignFirstResponder];
    [self validateTextField];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [itemText resignFirstResponder];
    [priceText resignFirstResponder];
    [storeText resignFirstResponder];
    [self validateTextField];
}

- (void)loadUserSession
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        [giftTypePicker selectRow:[[standardUserDefaults objectForKey:@"category"] intValue] inComponent:0 animated:YES];
    }
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    [giftTypePicker selectRow:[[standardUserDefaults objectForKey:@"category"] intValue] inComponent:component animated:NO];
}

-(IBAction)UpLoadImage {
    if(giftName)
    {
    imageController = [[ImageController alloc] initWithNibName:@"ImageController" bundle:nil];
    imageController.source = @"Game";
    imageController.photoName = giftName;
    [self presentModalViewController:imageController animated:true];
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
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"GiftController"];
    [self presentModalViewController:vc animated:false];
}

-(IBAction)redirectAddContact
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"RecipientController"];
    [self presentModalViewController:vc animated:false];
}

- (void)viewDidUnload
{
    giftItemImageView = nil;
    self.popoverController = nil;
    self.toolbar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(imageController && itemText.text)
    {
    giftImage = imageController.image;
    if(giftImage) {
        giftItemImageView.image = giftImage;
        uploadBtn.hidden = TRUE;
    }
    }
    [super viewWillAppear:animated];
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
