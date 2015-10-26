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

@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.movie[@"title"]];
    [self loadMovieDetails];
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

    self.synopsis.text = self.movie[@"synopsis"];
    self.synopsis.lineBreakMode = NSLineBreakByWordWrapping;
    self.synopsis.numberOfLines = 0;
}

@end
