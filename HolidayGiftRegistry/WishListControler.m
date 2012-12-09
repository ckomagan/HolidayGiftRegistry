
#import "WishListController.h"
#import <QuartzCore/QuartzCore.h>

@interface WishListController()
@property (nonatomic, strong) NSString *nsURL;
@end;

@implementation WishListController
@synthesize giftimage, giftname, giftrecipient, giftstatus, nsURL, responseData;
NSDictionary *res;
NSUserDefaults *standardUserDefaults;
int totalItems, userid;
int rowHeight = 80;
NSString *name;
int completed = 1;

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
    giftTableList.rowHeight = rowHeight;
    gifts = [[NSMutableArray alloc] init];
    giftNameList = giftImageList = giftStatusList = giftRecipientList = [[NSMutableArray alloc] init];
    giftTableList.scrollEnabled = YES;
    [giftTableList setBackgroundColor:UIColor.clearColor]; // Make the table view transparent
    [giftTableList setDelegate:self];
    [giftTableList setDataSource:self];
    [self initializeCheckButton];
    [self loadUserSession];
    [self receiveData];
    [self initializeButtons];
}

-(void)initializeButtons
{
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
    
    //[giftTableList beginUpdates];
    for(NSDictionary *res1 in res) {
        name = [res1 objectForKey:@"name"];
        giftimage = [res1 objectForKey:@"giftimage"];
        giftname = [res1 objectForKey:@"giftname"];
        giftstatus = [res1 objectForKey:@"giftstatus"];
        giftrecipient = [res1 objectForKey:@"recipientname"];

        NSString *space = @"       ";
        //NSString *row = [giftimage stringByAppendingString:[space stringByAppendingString:[giftname stringByAppendingString:[space stringByAppendingString:giftstatus]]]];
        //NSLog(@"row = %@", row);
        [giftImageList addObject:giftimage];
        [giftNameList addObject:giftname];
        [giftStatusList addObject:giftstatus];
        [giftRecipientList addObject:giftrecipient];

        //[gifts addObject:row];
        totalItems++;
    }
    firstName.text = name;
    [standardUserDefaults setObject:name forKey:@"name"];
    NSLog(@"gifts rows = %d", [gifts count]);
    //[giftTableList endUpdates];
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
    
    UILabel *cellLabelS1 = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, cell.frame.size.width, cell.frame.size.height)];
    
    [cellLabelS1 viewWithTag:1];
    cellLabelS1.text = [giftNameList objectAtIndex:indexPath.row];
    cellLabelS1.font = [UIFont systemFontOfSize: 45.0];
    [cellLabelS1 setBackgroundColor:UIColor.clearColor]; // Make the table view transparent
    [cell addSubview:cellLabelS1];
    
    UILabel *cellLabelS2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, cell.frame.size.width, cell.frame.size.height)];
    
    [cellLabelS2 viewWithTag:2];
    cellLabelS2.text = [giftImageList objectAtIndex:indexPath.row];
    cellLabelS2.font = [UIFont boldSystemFontOfSize: 45.0];
    [cellLabelS2 setBackgroundColor:UIColor.clearColor]; // Make the table view transparent
    [cell addSubview:cellLabelS2];
    
    UILabel *cellLabelS3 = [[UILabel alloc] initWithFrame:CGRectMake(475, 0, cell.frame.size.width, cell.frame.size.height)];
    
    [cellLabelS3 viewWithTag:3];
    if(giftStatusList)
    cellLabelS3.text = [giftStatusList objectAtIndex:indexPath.row];
    cellLabelS3.font = [UIFont systemFontOfSize: 40.0];
    [cellLabelS3 setBackgroundColor:UIColor.clearColor]; // Make the table view transparent
    [cell addSubview:cellLabelS3];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"total rows = %d", totalItems);
    if(totalItems >= 6)
    {
        return 6;
    }
    else {
        return totalItems;
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
    giftimage = [giftImageList objectAtIndex:row];
    giftname = [giftNameList objectAtIndex:row];
    giftstatus = [giftStatusList objectAtIndex:row];
    giftrecipient = [giftRecipientList objectAtIndex:row];
    [self performSegueWithIdentifier:@"showGiftDetails" sender:self];
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
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"GiftController"];
    [self presentModalViewController:vc animated:false];
}

-(IBAction)redirectAddContact
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]  instantiateViewControllerWithIdentifier:@"RecipientController"];
    [self presentModalViewController:vc animated:false];
}

-(void)initializeCheckButton
{
    UIButton* checkBox = [[UIButton alloc] initWithFrame:CGRectMake(100, 60,120, 44)];
    [checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    // uncomment below to see the hit area
    // [checkBox setBackgroundColor:[UIColor redColor]];
    [checkBox addTarget:self action:@selector(toggleButton:) forControlEvents: UIControlEventTouchUpInside];
    // make the button's image flush left, and then push the image 20px left
    [checkBox setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [checkBox setImageEdgeInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)];
    [self.view addSubview:checkBox];
    
    // add checkbox text text
    UILabel *checkBoxLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 74,200, 16)];
    [checkBoxLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [checkBoxLabel setTextColor:[UIColor whiteColor]];
    [checkBoxLabel setBackgroundColor:[UIColor clearColor]];
    [checkBoxLabel setText:@"Checkbox"];
    [self.view addSubview:checkBox];
}

- (void)toggleButton: (id) sender
{
    checkboxSelected = !checkboxSelected;
    UIButton* check = (UIButton*) sender;
    if (checkboxSelected == NO)
        [check setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    else
        [check setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    
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
