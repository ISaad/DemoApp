//
//  FriendsView.h
//  DemoApp
//
//  Created by Ismael Saad García on 05/01/12.
//

#import <Foundation/Foundation.h>

@interface FriendsView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *friends;
@property (nonatomic, retain) NSMutableArray *indexValues;
@property (nonatomic, retain) NSMutableArray *index;
@property (nonatomic, retain) IBOutlet UITableView *tableFriends;


- (void) configure: (NSArray *) friends;

@end
