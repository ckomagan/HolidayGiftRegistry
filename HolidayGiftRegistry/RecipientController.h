#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface RecipientController : UIViewController <ABPeoplePickerNavigationControllerDelegate, UIImagePickerControllerDelegate,  UIPopoverControllerDelegate> {
    UITextField *firstNameTxt, *emailTxt, *phoneNumberTxt;
    IBOutlet UILabel *statusLabel, *recipientFrame;
    UIPopoverController *popoverController;
    UIImageView *contactImageView;
    IBOutlet UIButton *addContactBtn, *uploadBtn;
    IBOutlet UIButton *peopleBtn, *giftsBtn, *progressBtn, *settingsBtn;
}

@property (nonatomic, strong) NSString *userfirstname, *useremail, *userphone, *userId;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain)  UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIImageView *contactImageView;
@property (nonatomic, retain) UIPopoverController *popoverController;

-(IBAction)showPicker:(id)sender;
-(IBAction)useCameraRoll:(id)sender;
-(IBAction)addContact;

@end
