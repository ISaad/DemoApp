//
//  FriendsView.m
//  DemoApp
//
//  Created by Ismael Saad García on 05/01/12.
//

#import "FriendsView.h"
#import "UIImageView+AFNetworking.h"
#import "AFImageCache.h"

@implementation FriendsView

@synthesize friends = _friends;
@synthesize tableFriends = _tableFriends;
@synthesize index = _index;
@synthesize indexValues = _indexValues;


#pragma mark - Managing the view
- (void) configure: (NSArray *) friends {
    self.friends = friends;
    
    // Set the cache limit to 10 references
    [[AFImageCache sharedImageCache] setCountLimit: 10];
    
    // _index stores the positions of the sections
    _index = [[NSMutableArray alloc] init];
    
    // _indexValues stores the values of the sections (@"A", @"B", ...)
    _indexValues = [[NSMutableArray alloc] init];
    
    // Building the index
    int i = 0;
    for (NSDictionary *friend in self.friends) {
        
        NSString *friendName = [friend valueForKey: @"name"];
        NSString *nameFirstLetter = [NSString stringWithFormat: @"%c", [friendName characterAtIndex: 0]];
        
        if (self.indexValues.count == 0 || ![self.indexValues.lastObject isEqualToString: nameFirstLetter]) {
            [self.indexValues addObject: nameFirstLetter];
            [self.index addObject: [NSNumber numberWithInt: i]];
        }
        
        i++;
    }
    
    [self.tableFriends reloadData];
    self.tableFriends.hidden = NO;
}


#pragma mark - Table view delegate and data source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.index.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.index.count - 1) {
        return self.friends.count - [[self.index objectAtIndex: section] intValue];
    } else {
        return [[self.index objectAtIndex: section + 1] intValue] - [[self.index objectAtIndex: section] intValue];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    NSDictionary *friend = [self.friends objectAtIndex: [[self.index objectAtIndex: indexPath.section] intValue] + indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize: 14];
    cell.textLabel.text = [friend valueForKey: @"name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Building the URL with the profile picture
    NSString *urlString = [NSString stringWithFormat: @"http://graph.facebook.com/%@/picture", [friend valueForKey: @"id"]];
    
    // Loading the image using the AFNetworking category for UIImageView
    [cell.imageView setImageWithURL: [NSURL URLWithString: urlString] placeholderImage: [UIImage imageNamed: @"friend_avatar.png"]];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"cell_background.png"]];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexValues objectAtIndex: section];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexValues;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.indexValues indexOfObject:title];
}


#pragma mark - Memory management
- (void) dealloc {
    [super dealloc];
    [_index release];
    [_indexValues release];
}



@end
