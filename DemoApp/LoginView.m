//
//  LoginView.m
//  DemoApp
//
//  Created by Ismael Saad García on 05/01/12.
//

#import "LoginView.h"

@implementation LoginView

@synthesize loginTarget = loginTarget;
@synthesize loginAction = _loginAction;


- (IBAction) btnLoginTapped:(id)sender {
    [self.loginTarget performSelector: self.loginAction];
}

@end
