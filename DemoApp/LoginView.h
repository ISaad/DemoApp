//
//  LoginView.h
//  DemoApp
//
//  Created by Ismael Saad García on 05/01/12.
//

#import <Foundation/Foundation.h>

@interface LoginView : UIView

@property (nonatomic, assign) id loginTarget;
@property (nonatomic) SEL loginAction;


- (IBAction) btnLoginTapped:(id)sender;

@end
