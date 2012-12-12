//
//  RegistryDetails.h
//  HolidayRegistry
//
//  Created by Chan Komagan on 12/11/12.
//  Copyright (c) 2012 Chan Komagan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistryDetails : UIViewController
{
    IBOutlet UILabel *giftNameLabel, *giftStatusLabel, *giftStoreLabel, *giftContactLabel;
    IBOutlet UIImageView *giftImageView;
    IBOutlet UILabel *registryDetailsFrame;
}
@property (nonatomic, retain) NSString *giftName, *giftStatus, *giftImage, *giftStore, *giftContact;
@property int userId, giftId;
@property (nonatomic, retain) NSMutableData *responseData;

-(IBAction)dismissView;

@end
