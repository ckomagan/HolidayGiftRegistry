//
//  RegistryDetails.m
//  HolidayRegistry
//
//  Created by Chan Komagan on 12/11/12.
//  Copyright (c) 2012 Chan Komagan. All rights reserved.
//

#import "RegistryDetails.h"
#import <QuartzCore/QuartzCore.h>

@interface RegistryDetails()
@property (nonatomic, strong) NSString *nsURL;
@end

@implementation RegistryDetails
@synthesize nsURL, giftName, giftStatus, giftStore, giftImage, giftContact, userId, giftId, responseData;
NSUserDefaults *standardUserDefaults;
NSDictionary *res;
NSString *giftImageDetailURL = @"http://komagan.com/holidaygift/uploads/giftitem/";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self receiveData];
    giftNameLabel.text = giftName;
    
    registryDetailsFrame.layer.borderWidth = 1;
    registryDetailsFrame.layer.borderColor = [[UIColor grayColor] CGColor];
    registryDetailsFrame.layer.cornerRadius = 20;

}

-(void)receiveData
{
    nsURL = @"http://www.komagan.com/holidaygift/index.php?format=json&getgiftdetails=1&userid=";
    nsURL = [nsURL stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%d",userId]];
    nsURL = [nsURL stringByAppendingFormat:@"%@", @"&giftid="];
    nsURL = [nsURL stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%d",giftId]];
    self.responseData = [NSMutableData data];
    NSURLRequest *aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: nsURL]];
    NSLog(@"%@nsURL = ", nsURL);
    [[NSURLConnection alloc] initWithRequest:aRequest delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    NSError *myError = nil;
    res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    for(NSDictionary *res1 in res) {
        giftContact = [res1 objectForKey:@"recipientname"];
        giftImage = [res1 objectForKey:@"giftimage"];
        giftName = [res1 valueForKey:@"giftname"];
        giftStatus = [res1 valueForKey:@"giftstatus"];
        giftStore = [res1 valueForKey:@"giftstore"];
        NSLog(@"gift name = %@", giftName);
    }
    giftNameLabel.text = giftName;
    giftContactLabel.text = giftContact;
    giftStoreLabel.text = giftStore;
    giftImageDetailURL = [giftImageDetailURL stringByAppendingString:giftImage];
    NSLog(@"imageURL = %@", giftImageDetailURL);
    UIImage *previewImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:giftImageDetailURL]]];
    
    giftImageView.image = previewImage;
    if([giftStatus isEqualToString:@"C"])
    {
        giftStatusLabel = @"Completed";
    }
    if([giftStatus isEqualToString:@"S"])
    {
        giftStatusLabel = @"Request Sent";
    }
    if([giftStatus isEqualToString:@"N"])
    {
        giftStatusLabel = @"Not Sent";
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.responseData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

-(IBAction)dismissView {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
