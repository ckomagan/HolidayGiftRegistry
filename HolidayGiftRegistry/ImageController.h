#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ImageController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>{
    IBOutlet UIPickerView *giftTypePicker;
    UIPopoverController *popoverController;
    UIImageView *giftItemImage;
    IBOutlet UIButton *usePhotoBtn;
    IBOutlet UILabel *selectPhotoLbl;
}
@property (nonatomic, strong) NSString *photoName, *userId, *source;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIImageView *previewImage;
@property (nonatomic, retain) UIImage *image;

-(IBAction)useCamera: (id)sender;
-(IBAction)useCameraRoll: (id)sender;
-(IBAction)cancelButton: (id)sender;
-(IBAction)usePhoto: (id)sender;

-(void)saveImage:(UIImage*)image;

@end
