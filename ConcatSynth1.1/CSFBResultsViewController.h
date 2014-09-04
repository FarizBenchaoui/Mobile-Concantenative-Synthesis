//
//  CSFBResultsViewController.h
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 21/07/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CSFBCoreDataInterface.h"


@interface CSFBResultsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *concatButton;
@property (strong,nonatomic) NSMutableArray *trackNames;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) NSString *selectedString;

- (IBAction)launchConcat:(id)sender;

@end
