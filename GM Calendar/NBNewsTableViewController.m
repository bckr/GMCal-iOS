//
//  NBNewsTableViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 2/22/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBNewsTableViewController.h"
#import "NBNewsFeedFetcher.h"
#import "NBNewsItem.h"
#import "AppDelegate.h"
#import "NBNewsItemCell.h"
#import "NBNewsDetailViewController.h"
#import "NSString+Extensions.h"

@interface NBNewsTableViewController ()
@property (nonatomic, strong) NBNewsFeedFetcher *newsFetcher;
@end

@implementation NBNewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Schwarzes Brett";
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchNews) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchedNews) name:@"fetchedNews" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!animated) {
        [self.refreshControl beginRefreshing];
        [self.newsFetcher fetch];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)fetchNews {
    [self.newsFetcher fetch];
}

- (void)fetchedNews {
    [self.refreshControl endRefreshing];
}

- (NBNewsFeedFetcher *)newsFetcher {
    if (!_newsFetcher) {
        NSString *branch = [[NSUserDefaults standardUserDefaults] stringForKey:@"branch"];
        NSString *searchString;

        if ([@[@"WI", @"AI", @"MI", @"TI", @"WEB", @"ZV", @"MMI", @"IM", @"AITM"] containsObject:branch]) {
            searchString = @"ki=|274|&fid=00";
        } else if ([branch isEqualToString:@"EEL"]){
            searchString = @"ki=|10|278|&fid=00";
        } else if ([branch isEqualToString:@"BB"]) {
            searchString = @"ki=|283|&fid=00";
        } else {
            searchString = @"ki=|279|&fid=00";
        }
        
        NSURL *feedURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.campus-it.fh-koeln.de/rss_feeder.php?%@", [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        _newsFetcher = [[NBNewsFeedFetcher alloc] initWithNewsFeedURL:feedURL];
    }
    return _newsFetcher;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"newsItemCell";
    NBNewsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE dd.MM.yy"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    NBNewsItem *currentNewsItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [dateFormatter stringFromDate:currentNewsItem.date];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"guid" cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return _fetchedResultsController;
}

#pragma mark FetchedResultController Delegation

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(NBNewsItemCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (NSManagedObjectContext *)managedObjectContext {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NBNewsItem *selectedNewsItem = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
    selectedNewsItem.read = [NSNumber numberWithBool:YES];
    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:sender]] withRowAnimation:UITableViewRowAnimationAutomatic];
    NBNewsDetailViewController *newsDetailView = segue.destinationViewController;
    newsDetailView.newsItem = selectedNewsItem;
}

#pragma mark - Helper methods

- (void)configureCell:(NBNewsItemCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NBNewsItem *currentNewsItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.newsTitle.text = currentNewsItem.title;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    NSString *metaText = [[NSString alloc] initWithData:currentNewsItem.content encoding:NSUTF8StringEncoding];
    cell.newsMeta.text = [metaText stringByStrippingHTML];
    cell.author.text = @"webredaktion";
    cell.read = [currentNewsItem.read boolValue];
    cell.readIndicator.color = self.navigationController.navigationBar.tintColor;
}

@end
