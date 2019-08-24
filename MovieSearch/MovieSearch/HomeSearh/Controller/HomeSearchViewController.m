//
//  HomeSearchViewController.m
//  MovieSearch
//
//  Created by huixiubao on 7/29/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import "HomeSearchViewController.h"

@interface HomeSearchViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@end

@implementation HomeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// Mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarSearchButtonClicked");
    
}

@end
