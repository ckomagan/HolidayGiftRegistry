
#import "ImageController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"

@interface ImageController()
@property (nonatomic, strong) NSString *nsURL;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end;

@implementation ImageController
@synthesize popoverController, photoName, previewImage, userId, toolbar, image;
@synthesize spinner = _spinner;
BOOL newMedia;
NSUserDefaults *standardUserDefaults;
UIImagePickerController *imagePicker;
NSString *imageURL;

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
    self.spinner.hidden = TRUE;
    usePhotoBtn.hidden = TRUE;
    selectPhotoLbl.hidden = FALSE;
    
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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Cancel"
                                         style:UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(cancelButton:)];
    NSArray *items = [NSArray arrayWithObjects: cameraButton,
                      cameraRollButton, cancelButton, nil];

    [toolbar setItems:items animated:NO];
    imageURL = @"http://komagan.com/holidaygift/uploads/chan.jpg";
    NSLog(@"imageUrl = %@", imageURL);
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    previewImage.image = [UIImage imageWithData:imageData];

    [self loadUserSession];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    if(photoName)
    {
    self.spinner.hidden = FALSE;
    [self.spinner startAnimating];

    if ([self.popoverController isPopoverVisible]) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            imagePicker =
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
            
            [self.popoverController
             presentPopoverFromBarButtonItem:sender
             permittedArrowDirections:UIPopoverArrowDirectionUp
             animated:YES];
            
            newMedia = NO;
        }
    }
    }
    else{
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverController dismissPopoverAnimated:true];
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
        usePhotoBtn.hidden = FALSE;
        selectPhotoLbl.hidden = TRUE;
        previewImage.image = image;
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)thePopoverController{
    NSLog(@"clicked outside the popover");//never prints
    [thePopoverController dismissPopoverAnimated: YES];
    //[self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    picker.delegate = nil;
}

-(IBAction)cancelButton: (id)sender
{
    previewImage = nil;;
    image = nil;
    imageURL = nil;
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)usePhoto:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    imageURL = nil;
}

-(void)validateTextField
{
}

- (void)loadUserSession
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
    }
}

- (void)viewDidUnload
{
    previewImage = nil;
    self.popoverController = nil;
    self.toolbar = nil;
    imageURL = nil;
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
