#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface GiftController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UITextFieldDelegate>{
    UITextField *itemText, *priceText, *storeText;
    IBOutlet UIPickerView *giftTypePicker;
    IBOutlet UILabel *statusLabel, *cameraLabel;
    UIPopoverController *popoverController;
    UIImageView *giftItemImageView;
    IBOutlet UIButton *addGiftBtn, *uploadBtn;
    IBOutlet UIButton *peopleBtn, *giftsBtn, *progressBtn, *storeBtn, *settingsBtn;
}
@property (nonatomic, retain) NSArray *levelpicker;
@property (nonatomic, strong) NSString *giftName, *giftType, *giftPrice, *giftStore, *userId;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIImageView *giftItemImageView;
@property (nonatomic, retain) NSMutableData *responseData;

-(IBAction)useCamera: (id)sender;
-(IBAction)useCameraRoll: (id)sender;
-(void)saveImage:(UIImage*)image;

@end
