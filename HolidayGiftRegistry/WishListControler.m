
#import "WishListController.h"
#import <QuartzCore/QuartzCore.h>
#import "RegistryDetails.h"

@interface WishListController()
@property (nonatomic, strong) NSString *nsURL;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end;

@implementation WishListController
@synthesize giftimage, giftname, giftrecipient, giftstatus, nsURL, responseData;
NSDictionary *res;
NSUserDefaults *standardUserDefaults;
int totalItems, userid, giftId;
int rowHeight = 100;
NSString *name;
int completed = 1;
@synthesize spinner = _spinner;
NSString *baseImageURL = @"http://komagan.com/holidaygift/uploads/giftitem/";

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
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"snow-background.jpg"]]];

    giftTableList.rowHeight = rowHeight;
    giftIdList = [[NSMutableArray alloc] init];
    giftImageList = [[NSMutableArray alloc] init]; giftNameList = [[NSMutableArray alloc] init]; giftStatusList = [[NSMutableArray alloc] init];
    giftTableList.scrollEnabled = YES;
    [giftTableList setBackgroundColor:UIColor.clearColor]; // Make the table view transparent
    [giftTableList setDelegate:self];
    [giftTableList setDataSource:self];
    [self loadUserSession];
    [self initializeButtons];
    [self receiveData];
}

-(void)initializeButtons
{
    self.spinner.hidden = FALSE;
    self.spinner.transform = CGAffineTransformMakeScale(2.5, 2.5);
    [self.spinner startAnimating];
    UIImage * btnImage = [UIImage imageNamed: @"darkgray.jpg"];
    UIImage * btnSelectedImage = [UIImage imageNamed: @"darkblue.jpg"];
    [progressBtn setBackgroundImage:btnSelectedImage forState:UIControlStateNormal];
    [progressBtn setUserInteractionEnabled:NO];
    [progressBtn setEnabled:NO];
    
    [peopleBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [giftsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [settingsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

- (void)loadUserSession
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        NSLog(@" userid = %@", [standardUserDefaults objectForKey:@"userid"]);
        userid = [[standardUserDefaults objectForKey:@"userid"] intValue];
    }
}

-(void)receiveData
{
    nsURL = @"http://www.komagan.com/holidaygift/index.php?format=json&getwishlist=1&userid=";
    nsURL = [nsURL stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%d",userid]];
    self.responseData = [NSMutableData data];
    NSURLRequest *aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: nsURL]];
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
        name = [res1 objectForKey:@"name"];
        [giftIdList addObject:[res1 objectForKey:@"giftid"]];
        [giftImageList addObject:[res1 objectForKey:@"giftimage"]];
        [giftNameList addObject:[res1 valueForKey:@"giftname"]];
        //NSLog(@"gift name = %@", giftNameList);
        [giftStatusList addObject:[res1 objectForKey:@"giftstatus"]];
        totalItems++;
    }
    firstName.text = name;
    //NSLog(@"total rows = %d", [giftNameList count]);
    [standardUserDefaults setObject:name forKey:@"name"];
    [giftTableList reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.responseData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    cell = [giftTableList dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImageView *checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30,25, 60, 40)];
    UIImage *checkImage = [UIImage imageNamed: @"check_mark.jpg"];
    UIImage *sentImage = [UIImage imageNamed: @"sent_mark.png"];
    if ([[giftStatusList objectAtIndex:indexPath.row] isEqualToString:@"C"])
    {
        checkImageView.image = checkImage;
        [cell addSubview:checkImageView];
    }
    else if([[giftStatusList objectAtIndex:indexPath.row] isEqualToString:@"S"])
    {
        checkImageView.image = sentImage;
        [cell addSubview:checkImageView];
    }
    else{
        
    }

    UIImage *imageURL = [baseImageURL stringByAppendingString:[giftImageList objectAtIndex:indexPath.row]];
    //NSLog(@"imageURL = %@", imageURL);
    UIImage *previewImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(140,20, 100, 65)];
    imv.image = previewImage;
    [cell addSubview:imv];

    UILabel *cellLabelS3 = [[UILabel alloc] initWithFrame:CGRectMake(320, 20, cell.frame.size.width, cell.frame.size.height)];
    
    [cellLabelS3 viewWithTag:2];
    cellLabelS3.text = [giftNameList objectAtIndex:indexPath.row];
    cellLabelS3.font = [UIFont boldSystemFontOfSize: 40.0];
    [cellLabelS3 setBackgroundColor:UIColor.clearColor]; // Make the table view transparent
    [cell addSubview:cellLabelS3];
    
    
    /*cellLabelS3.text = [giftStatusList objectAtIndex:indexPath.row];
    cellLabelS3.font = [UIFont systemFontOfSize: 40.0];
    [cellLabelS3 setBackgroundColor:UIColor.clearColor]; // Make the table view transparent*/
    cell.detailTextLabel.text = @"Here is the note";
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    self.spinner.hidden = TRUE;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([giftNameList count] >= 6)
    {
        return 6;
    }
    else {
        return [giftNameList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    giftId = [[giftIdList objectAtIndex:row] intValue];
    giftimage = [giftImageList objectAtIndex:row];
    giftname = [giftNameList objectAtIndex:row];
    giftstatus = [giftStatusList objectAtIndex:row];
    giftrecipient = [giftRecipientList objectAtIndex:row];
    RegistryDetails *registryDetails = [[RegistryDetails alloc] initWithNibName:@"RegistryDetails" bundle:nil];
    registryDetails.giftId = giftId ;
    registryDetails.userId = userid;
    [self presentModalViewController:registryDetails animated:true];
}

- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(IBAction)performSignOff
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"LoginController"];
    [self presentModalViewController:vc animated:false];
}

-(IBAction)redirectAddGift
{
    self.spinner.hidden = FALSE;
    [self.spinner startAnimating];
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"GiftController"];
    [self presentModalViewController:vc animated:false];
}

-(IBAction)redirectAddContact
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"RecipientController"];
    [self presentModalViewController:vc animated:false];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.spinner.hidden = TRUE;
}

- (void)viewDidUnload
{
    giftNameList = giftImageList = giftStatusList = giftRecipientList = [[NSMutableArray alloc] init];
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
