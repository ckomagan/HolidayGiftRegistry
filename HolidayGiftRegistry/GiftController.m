
#import "GiftController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"

@interface GiftController()
@property (nonatomic, strong) NSString *nsURL;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end;

@implementation GiftController
@synthesize levelpicker, popoverController, giftItemImage, nsURL, responseData, userId;
@synthesize giftName, giftType, giftPrice, giftStore, giftImage, toolbar;
@synthesize spinner = _spinner;
BOOL newMedia;
NSUserDefaults *standardUserDefaults;
NSString *imageURL = @"http://komagan.com/holidaygift/uploads/giftitem/";
UIImage *image;

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
    addGiftBtn.enabled = NO;
    statusLabel.text = @" ";
    self.spinner.hidden = TRUE;

    levelpicker = [NSArray arrayWithObjects:@"Electronics", @"Home & Garden", @"Children & Toys", @"Games & Music", @"Health & Beauty", @"Books", nil];
    giftTypePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    giftTypePicker.delegate = self;
    giftTypePicker.showsSelectionIndicator = YES;
    [self.view addSubview:giftTypePicker];
    //giftTypePicker.center = CGPointMake(600,460);
    giftTypePicker.frame = CGRectMake(460,340,220,180);

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
    itemText = [[UITextField alloc] initWithFrame:CGRectMake(480, 240, 200, 50)];
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
    priceText = [[UITextField alloc] initWithFrame:CGRectMake(480, 560, 200, 50)];
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
    storeText = [[UITextField alloc] initWithFrame:CGRectMake(480, 660, 200, 50)];
    storeText.borderStyle = 3; // rounded, recessed rectangle
    storeText.autocorrectionType = UITextAutocorrectionTypeNo;
    storeText.textAlignment = UITextAlignmentCenter;
    storeText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [storeText setReturnKeyType:UIReturnKeyDone];
    storeText.font = [UIFont fontWithName:@"Trebuchet MS" size:45];
    storeText.textColor = [UIColor blackColor];
    storeText.delegate = self;
    [self.view addSubview:storeText];
    
    imageURL = [imageURL stringByAppendingString:@"/chan.jpg"];
    NSLog(@"imageUrl = %@", imageURL);
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];

    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    giftItemImage.image = [UIImage imageWithData:imageData];
    
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
    CGRect rect = CGRectMake(560, 260, 160, 100);
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

- (IBAction)useCamera: (id)sender
{
 
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker
                                animated:YES];
        newMedia = YES;
    }
}

- (IBAction)useCameraRoll: (id)sender
{
    if(itemText.text)
    {
    self.spinner.hidden = FALSE;
    if ([self.popoverController isPopoverVisible]) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                      (NSString *) kUTTypeImage,
                                      nil];
            imagePicker.allowsEditing = NO;
            
            self.popoverController = [[UIPopoverController alloc]
                                      initWithContentViewController:imagePicker];
            
            popoverController.delegate = self;
            
            [self.popoverController presentPopoverFromRect:uploadBtn.frame
                                                   inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            newMedia = NO;
        }
    }
    }
    else{
        statusLabel.text = @"Please enter a Gift name first!";
    }
}

//delegate methode will be called after picking photo either from camera or library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverController dismissPopoverAnimated:true];
    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
        [self saveImage:image];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
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
        
        /*Display stored image in the UIImageView*/
        imageURL = [imageURL stringByAppendingString:giftName];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        giftItemImage.image = [UIImage imageWithData:imageData];
        NSLog(@"%@", returnString);
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

-(IBAction)addGift
{
    [self validateTextField];
    nsURL = @"http://www.komagan.com/holidaygift/index.php?format=json&addGift=1";
    giftName = itemText.text; giftPrice = priceText.text; giftStore = storeText.text;
    self.responseData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:nsURL];
    giftImage = [imageURL stringByAppendingString:giftName];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    userId = [standardUserDefaults objectForKey:@"id"];
    NSLog(@"%@", userId);

    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/xml;charset=UTF-8;"];
    [request setPostValue:userId forKey:@"userid"];
    [request setPostValue:giftName forKey:@"giftName"];
    [request setPostValue:giftType forKey:@"giftType"];
    [request setPostValue:giftPrice forKey:@"giftPrice"];
    [request setPostValue:giftStore forKey:@"giftStore"];
    [request setPostValue:giftImage forKey:@"giftImage"];

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

-(IBAction)redirectMyRegistry
{
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
    giftItemImage = nil;
    self.popoverController = nil;
    self.toolbar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
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
