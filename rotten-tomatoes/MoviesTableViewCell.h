//
//  MoviesTableViewCell.h
//  rotten-tomatoes
//
//  Created by Chang Liu on 10/25/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *runtime;
@property (weak, nonatomic) IBOutlet UILabel *mpaa;
@property (weak, nonatomic) IBOutlet UILabel *audienceScore;
@property (weak, nonatomic) IBOutlet UILabel *criticsScore;
@property (weak, nonatomic) IBOutlet UILabel *cast;

@end
