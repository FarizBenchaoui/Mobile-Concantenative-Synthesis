//
//  CSFBResultsViewController.m
//  ConcatSynth1.1
//
//  Created by Fariz Benchaoui on 21/07/2014.
//  Copyright (c) 2014 FarizBenchaoui. All rights reserved.
//

#import "CSFBResultsViewController.h"
#import "CSFBLinkedList.h"


@implementation CSFBResultsViewController
CSFBCoreDataInterface *coreDataInterface;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
     [self populateTable];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl  addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}
-(void)viewWillAppear:(BOOL)animated
{
   [self populateTable];
    [self.tableView reloadData];
   
}
-(void) refreshView
{
    [self populateTable];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trackNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [self.trackNames objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self.concatButton setTitle:@"Concat" forState:UIControlStateNormal];
    self.selectedString = self.trackNames[[indexPath item]];
}
- (IBAction)launchConcat:(id)sender {
    if (self.selectedString != NULL) {
    
    NSMutableArray *chosenFFT;
    NSMutableArray *chosenTrackName;
    CSFBCoreDataInterface *coreDataInterface2 = [[CSFBCoreDataInterface alloc]init];
    CSFBTrackList *test=[[CSFBTrackList alloc] init:[coreDataInterface2 fetchResults]];
    int indexNum = 0;
    NSUInteger count =[test getTrackNameArray].count;
    int i = 0;
    do{
    
     NSString *name = test.trackArray[i];
     
        if ([name isEqualToString:self.selectedString ]){
            indexNum = i;
            chosenFFT = [[NSMutableArray alloc]initWithArray:test.fftResultArray];
            chosenTrackName = [[NSMutableArray alloc]initWithArray:test.trackArray];
            CSFBLinkedList *linkedList = [[CSFBLinkedList alloc]init:self.selectedString array:chosenFFT[indexNum]];
            [chosenFFT removeObjectAtIndex:indexNum];
            [chosenTrackName removeObjectAtIndex:indexNum];
          
            for (int y = 0; y< chosenTrackName.count; y++) {
             
                [linkedList insertNewNode:chosenTrackName[y] array:chosenFFT[y]];
            }
        
            [linkedList saveTopEight];
             [self.concatButton setTitle:@"Concatenation Complete" forState:UIControlStateNormal];
            break;
        }
        i++;
    }while(i<count);
    }else{
         [self.concatButton setTitle:@"No track selected, try Again" forState:UIControlStateNormal];
    }
}
-(void)populateTable
{
    

    coreDataInterface = [[CSFBCoreDataInterface alloc] init];
    CSFBTrackList *resultList=[[CSFBTrackList alloc] init:[coreDataInterface fetchResults]];
    if ([resultList getTrackNameArray].count > 0) {
        self.trackNames  = [[NSMutableArray alloc]initWithArray:[resultList getTrackNameArray]];
    }else{
        self.trackNames = [[NSMutableArray alloc]init];
    }
  
}

@end
