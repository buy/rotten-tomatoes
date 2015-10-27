//
//  MovieDetailsViewController.m
//  rotten-tomatoes
//
//  Created by Chang Liu on 10/25/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Helpers.h"

@interface MovieDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *cast;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.movie[@"title"]];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self loadMovieDetails];
    CGSize labelSize = [self.synopsis.text sizeWithFont:self.synopsis.font
                                      constrainedToSize:self.synopsis.frame.size
                                          lineBreakMode:NSLineBreakByWordWrapping];
    self.scrollView.contentSize = CGSizeMake(320, 1150 + labelSize.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMovieDetails {
    // load low resolution image first
    NSURL *imageURL = [[NSURL alloc] initWithString: self.movie[@"posters"][@"thumbnail"]];
    [self.poster setImageWithURL:imageURL];

    NSURL *highResImageURL = [Helpers getHighResImageURL:self.movie];
    [self.poster setImageWithURL:highResImageURL];

    self.movieTitle.text = self.movie[@"title"];
    self.year.text = [NSString stringWithFormat:@"%@", self.movie[@"year"]];
    self.cast.text = [NSString stringWithFormat:@"Stars: %@", [[self.movie[@"abridged_cast"] valueForKey:@"name"] componentsJoinedByString:@", "]];
    self.cast.lineBreakMode = NSLineBreakByWordWrapping;
    self.cast.numberOfLines = 0;
    [self.cast sizeToFit];
    self.synopsis.text = self.movie[@"synopsis"];
    self.synopsis.lineBreakMode = NSLineBreakByWordWrapping;
    self.synopsis.numberOfLines = 0;
    [self.synopsis sizeToFit];
}

@end
