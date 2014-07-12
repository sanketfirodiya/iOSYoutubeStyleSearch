//
//  ViewController.m
//  TestBlogApp
//
//  Created by Firodiya, Sanket on 3/28/14.
//  Copyright (c) 2014 Firodiya, Sanket. All rights reserved.
//

#import "ViewController.h"

#define NAVIGATION_BORDER_COLOR [UIColor colorWithRed:236.0/255.0 green:0.0/255.0 blue:39.0/255.0 alpha:1.0]
#define NAVIGATION_BORDER_WIDTH 2.0
#define NAVIGATION_BORDER_TAG 100

@interface ViewController ()

@end

@implementation ViewController{
    UIView *uiDisableViewOverlay;
    UIView *uiSearchBarView;
    UISearchBar *uiSearchBar;
    NSMutableArray *arTableViewDataSource;
    NSArray *arDataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arDataSource = @[@"Mercedes-Benz", @"BMW", @"Porsche",
                     @"Opel", @"Volkswagen", @"Audi", @"Aston Martin",
                     @"Lotus", @"Jaguar", @"Bentley"];
    
    arTableViewDataSource = [NSMutableArray arrayWithArray:[arDataSource copy]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_BarButtonItem"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButtonTapped)];
    self.navigationItem.rightBarButtonItem.tintColor = NAVIGATION_BORDER_COLOR;
	[self setupNavigationBar];
    [self setupUISearchBar];
}

- (void)setupNavigationBar{
    
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [[self.navigationController.navigationBar viewWithTag:NAVIGATION_BORDER_TAG] removeFromSuperview];
    
    UIView *navigationBarBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - NAVIGATION_BORDER_WIDTH, self.navigationController.navigationBar.frame.size.width, NAVIGATION_BORDER_WIDTH)];
    
    [navigationBarBorder setBackgroundColor:NAVIGATION_BORDER_COLOR];
    [navigationBarBorder setOpaque:YES];
    navigationBarBorder.tag = NAVIGATION_BORDER_TAG;
    
    [self.navigationController.navigationBar addSubview:navigationBarBorder];
}

- (void)setupUISearchBar{
    uiSearchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, - 61.0, self.view.frame.size.width, 61.0)];
    uiSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0, 20.0, 300.0, 44.0)];
    
    uiSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    uiSearchBar.delegate = self;
    uiSearchBarView.backgroundColor = [UIColor whiteColor];
    uiSearchBar.tintColor = NAVIGATION_BORDER_COLOR;
    uiSearchBar.showsCancelButton = YES;
    
    [uiSearchBarView addSubview:uiSearchBar];
    
    uiDisableViewOverlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, self.view.frame.size.width, self.view.frame.size.height)];
    uiDisableViewOverlay.backgroundColor=[UIColor blackColor];
    uiDisableViewOverlay.alpha = 0;
    uiDisableViewOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    uiDisableViewOverlay.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    
    [self.navigationController.view addSubview:uiSearchBarView];
}

#pragma mark - UISearchBar methods

- (void)searchBarButtonTapped {
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         uiSearchBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 61.0);
                         [self searchBar:uiSearchBar activate:YES];
                         [uiSearchBar becomeFirstResponder];
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         uiSearchBar.text = @"";
                         [self filterResultsToOriginal];
                         uiSearchBarView.frame = CGRectMake(0, - 64.0, self.view.frame.size.width, 64.0);
                         [self searchBar:uiSearchBar activate:NO];
                         [uiSearchBar resignFirstResponder];
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)searchBar:(UISearchBar*)searchBar activate:(BOOL)active {
    self.uiTableView.allowsSelection = !active;
    self.uiTableView.scrollEnabled = !active;
    if (!active) {
        [uiDisableViewOverlay removeFromSuperview];
    } else{
        
        uiDisableViewOverlay.alpha = 0;
        [self.view addSubview:uiDisableViewOverlay];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            uiDisableViewOverlay.alpha = 0.6;
        }completion:^(BOOL finised){
        }];
    }
}


- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText {
    
    if ([searchText length] == 0) {
        [self filterResultsToOriginal];
        [self searchBar:uiSearchBar activate:YES];
    }
    else {
        [self filterResultsWithSearchTerm:searchText];
        [self searchBar:uiSearchBar activate:NO];
    }
}

- (void)filterResultsToOriginal {
    
    arTableViewDataSource = [NSMutableArray arrayWithArray:[arDataSource copy]];
    
    [self.uiTableView reloadData];
}

- (void)filterResultsWithSearchTerm:(NSString*)searchTerm{
    
    [arTableViewDataSource removeAllObjects];
    if (searchTerm.length > 0) {
        for (int i=0; i<arDataSource.count; i++) {
            if ([[arDataSource objectAtIndex:i] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [arTableViewDataSource addObject:[arDataSource objectAtIndex:i]];
            }
        }
    }
    
    [self.uiTableView reloadData];
}

#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arTableViewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [arTableViewDataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
