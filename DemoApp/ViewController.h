//
//  ViewController.h
//  DemoApp
//
//  Created by Ismael Saad García on 05/01/12.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "LoginView.h"
#import "FriendsView.h"

@interface ViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate>

@property (readonly) Facebook *facebook;
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, retain) NSArray *friends;
@property (nonatomic, retain) LoginView *loginView;
@property (nonatomic, retain) FriendsView *friendsView;

@end
