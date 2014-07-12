//
//  ViewController.h
//  TestBlogApp
//
//  Created by Firodiya, Sanket on 3/28/14.
//  Copyright (c) 2014 Firodiya, Sanket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *uiTableView;

@end
