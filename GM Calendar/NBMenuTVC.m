//
//  NBMenuTVC.m
//  GM Calendar
//
//  Created by Nils Becker on 21/12/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBMenuTVC.h"
#import "NBDish.h"

@interface NBMenuTVC ()

@property (nonatomic, strong) NSArray *menu;
@property (nonatomic, strong) NSMutableData *urlData;
@property (nonatomic, strong) UILabel *emptyTableViewTextLabel;

@end

@implementation NBMenuTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialSetup];
    [self setupEmptyTableViewLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateDataSourceManually:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.emptyTableViewTextLabel.hidden = [self.menu count] > 0;
    return [self.menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dishCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NBDish *currentDish = self.menu[indexPath.row];
    
    cell.textLabel.text = currentDish.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f €", currentDish.price];
    
    return cell;
}

#pragma mark - Helper Methods

- (void)initialSetup
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.title = @"Mensa Speiseplan";
    
    // setup tab bar
    self.tabBarItem.image = [UIImage imageNamed:@"coffee.png"];
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"coffee_filled.png"];
    self.tabBarItem.title = @"Mensa";
}

- (void)updateDataSourceManually:(BOOL)manually
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:API_URI]];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [urlConnection start];
}

#pragma mark - URL Connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.urlData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.urlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *jsonParsingError = nil;
    NSMutableString *filepath;
    filepath = [[NSMutableString  alloc] initWithString:[[NSBundle mainBundle] resourcePath]];
    [filepath appendString:@"/Menu.json"] ;
    NSData *testData = [NSData dataWithContentsOfFile:filepath];
    NSArray *menu = [NSJSONSerialization JSONObjectWithData:testData options:0 error:&jsonParsingError];

    if (jsonParsingError) {
        NSLog(@"error: %@", [jsonParsingError localizedDescription]);
    } else {
        
        NSMutableArray *dishes = [NSMutableArray array];

        for (NSDictionary *dict in menu) {
            [dishes addObject:[NBDish dishWithContentsOfDict:dict]];
        }
        
        self.menu = dishes;
        [self.tableView reloadData];
    }
}

#pragma mark - Helper

#define X_MARGIN 200
#define Y_MARGIN 100
#define TEXT_LABEL_WIDTH 200
- (void)setupEmptyTableViewLabel
{
    UIView *backgroundView = self.tableView.backgroundView;
    int posX = (self.view.frame.size.width - X_MARGIN) / 2;
    int posY = (self.view.frame.size.height / 2) - Y_MARGIN;
    
    self.emptyTableViewTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, TEXT_LABEL_WIDTH, 0)];
    self.emptyTableViewTextLabel.text = @"Heute gibt es kein Angebot in der Mensa \n\n 😞";
    self.emptyTableViewTextLabel.backgroundColor = [UIColor clearColor];
    self.emptyTableViewTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.emptyTableViewTextLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyTableViewTextLabel.textColor = [UIColor grayColor];
    self.emptyTableViewTextLabel.numberOfLines = 4;
    [self.emptyTableViewTextLabel sizeToFit];
    self.emptyTableViewTextLabel.hidden = YES;
    
    [self.tableView insertSubview:self.emptyTableViewTextLabel belowSubview:self.tableView];
    self.tableView.backgroundView = backgroundView;
}

@end
