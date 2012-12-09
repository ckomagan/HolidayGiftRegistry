#import <UIKit/UIKit.h>

@interface LoginController : UIViewController {
    IBOutlet UILabel *loginFrame, *statusLabel, *nameLabel, *hiLabel;
    UITextField *email, *password;
}

@property (nonatomic, strong) NSString *useremail, *userpass;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain)  UILabel *statusLabel;
@end
