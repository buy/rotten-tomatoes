//
//  MoviesViewController.m
//  rotten-tomatoes
//
//  Created by Chang Liu on 10/25/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

#import "MoviesViewController.h"
#import "MoviesTableViewCell.h"
#import "MovieDetailsViewController.h"

#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *movies;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self setTitle:@"Movies"];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refresh];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    [self fetchMovies];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.refreshControl.superview sendSubviewToBack:self.refreshControl];
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];

    [self fetchMovies];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMovies {
    NSString *urlString = @"https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                [self.refreshControl endRefreshing];
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSLog(@"Response: %@", responseDictionary);
                                                    self.movies = responseDictionary[@"movies"];
                                                    [self.tableView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    [self alertNetworkError];
                                                }
                                            }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoviesTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MoviesTableViewCell"];
    NSDictionary *movie = self.movies[indexPath.row];

    cell.title.text = movie[@"title"];
    cell.year.text = [NSString stringWithFormat:@"%@", movie[@"year"]];
    cell.runtime.text = [NSString stringWithFormat:@"%@ mins", movie[@"runtime"]];
    cell.mpaa.text = movie[@"mpaa_rating"];
    cell.audienceScore.text = [NSString stringWithFormat:@"Audience %@", movie[@"ratings"][@"audience_score"]];
    cell.criticsScore.text = [NSString stringWithFormat:@"Critics %@", movie[@"ratings"][@"critics_score"]];
    cell.cast.text = [[[movie[@"abridged_cast"] subarrayWithRange:NSMakeRange(0, 3)] valueForKey:@"name"] componentsJoinedByString:@", "];
    NSURL *imageURL = [[NSURL alloc] initWithString: movie[@"posters"][@"thumbnail"]];
    [cell.poster setImageWithURL:imageURL];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MovieDetailsViewController *movieDetailsViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *movie = self.movies[indexPath.row];

    movieDetailsViewController.movie = movie;
}

- (void)alertNetworkError {
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                               message: @"Failed to load the movies, please check your data connection."
                                                                        preferredStyle:UIAlertControllerStyleAlert                   ];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [myAlertController addAction: ok];
    [self presentViewController:myAlertController animated:YES completion:nil];
}

@end
