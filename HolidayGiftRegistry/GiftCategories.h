//
//  GiftCategories.h
//  HolidayGiftRegistry
//
//  Created by Chan Komagan on 12/4/12.
//  Copyright (c) 2012 Chan Komagan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftCategories : UIViewController
{
    IBOutlet UIButton *electronicsBtn, *homeBtn, *childrenBtn, *gamesBtn, *healthBtn, *booksBtn;
    IBOutlet UIButton *peopleBtn, *giftsBtn, *progressBtn, *storeBtn, *settingsBtn;
}

-(IBAction)sendToGiftPage:(id)sender;
@end
