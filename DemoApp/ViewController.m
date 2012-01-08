//
//  ViewController.m
//  DemoApp
//
//  Created by Ismael Saad García on 05/01/12.
//

#import "ViewController.h"
#import "FBConnect.h"

static NSString* kAppId = nil;

@implementation ViewController

@synthesize facebook = _facebook;
@synthesize permissions = _permissions;
@synthesize friends = _friends;
@synthesize loginView = _loginView;
@synthesize friendsView = _friendsView;


#pragma mark - Managing the view
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!kAppId) {
        NSLog(@"Missing facebook app id");
        exit(1);
        return nil;
    }
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _permissions = [[NSArray alloc] init];
        _facebook = [[Facebook alloc] initWithAppId:kAppId
                                        andDelegate:self];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Check whether the token is valid or not. If it is, we do not need to login again
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        _facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        _facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }  
    if (![_facebook isSessionValid]) {
        self.loginView = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] objectAtIndex:0];
        self.friendsView = [[[NSBundle mainBundle] loadNibNamed:@"FriendsView" owner:self options:nil] objectAtIndex:0];
        self.loginView.loginTarget = self;
        self.loginView.loginAction = @selector(authorize);
        [self.view addSubview: self.loginView];
        [self.view addSubview: self.friendsView];
        self.friendsView.hidden = YES;
    } else {
        self.friendsView = [[[NSBundle mainBundle] loadNibNamed:@"FriendsView" owner:self options:nil] objectAtIndex:0];
        [self fbDidLogin];
        [self.view addSubview: self.friendsView];
    }
}


#pragma mark - Configuring the view orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - Facebook operations
- (void) authorize {
    // Opens a web view to login
    [_facebook authorize:_permissions]; 
}


- (void) fbDidLogin {
    // Store the access token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];  
    
    if (self.loginView) {
        self.loginView.hidden = YES;
        self.friendsView.hidden = NO;
    }
    
    // Request the list of friends
    [_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
    
}


- (void)request:(FBRequest *)request didLoad:(id)result {
    // The request must be the list of friends (the only request performed)
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        // We sort the list alphabetically
        self.friends = [[result valueForKey: @"data"] sortedArrayUsingComparator: 
                            (NSComparator)^(NSDictionary *f1, NSDictionary *f2) {
                                return [[f1 valueForKey: @"name"] caseInsensitiveCompare: [f2 valueForKey: @"name"]];
                            }
                        ];
         
        // Load the view with the list of friends
        [self.friendsView configure: self.friends];
    }
}


#pragma mark - Memory management
- (void) dealloc {
    [super dealloc];
    [_permissions release];
    [_facebook release];
}

@end
