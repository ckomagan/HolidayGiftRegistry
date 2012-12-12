#import <UIKit/UIKit.h>

@interface WishListController : UIViewController <UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource>{
    IBOutlet UILabel *firstName;
    IBOutlet UITableView *giftTableList;
    NSMutableArray *gifts, *giftIdList, *giftNameList, *giftImageList, *giftStatusList, *giftRecipientList;
    UITableViewCell *cell;
    BOOL checkboxSelected;
    UIButton *checkboxButton;
    IBOutlet UIButton *peopleBtn, *giftsBtn, *progressBtn, *settingsBtn;
}

@property (nonatomic, strong) NSString *giftname, *giftimage, *giftstatus, *giftrecipient;
@property (nonatomic, retain) NSMutableData *responseData;
@property BOOL checkboxSelected;;
@property (nonatomic, retain) UIButton *checkboxButton;

-(IBAction)performSignOff;
-(void) populateCheck:(char)flag;
-(IBAction)redirectAddGift;
-(IBAction)redirectAddContact;

@end
