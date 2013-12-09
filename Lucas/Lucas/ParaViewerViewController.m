//
//  ParaViewerViewController.m
//  Lucas
//
//  Created by xiangyuh on 13-8-23.
//  Copyright (c) 2013年 xiangyuh. All rights reserved.
//

#import "ParaViewerViewController.h"
#import "IIViewDeckController.h"
#import "IISideController.h"
#import "MCSwipeTableViewCell.h"

#define DEMO_VIEW_CONTROLLER_PUSH FALSE
static NSUInteger const kMCNumItems = 8;

@implementation Color
@synthesize color = _color,
name = _name;

+ (id)createColor:(UIColor *)color withName:(NSString *)name {
    Color *temp = [[Color alloc] init];
    temp.color = color;
    temp.name = name;
    return temp;
}

@end

@interface ParaViewerViewController () <ReaderViewControllerDelegate, MCSwipeTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate, CommandMasterDelegate> {

    NSArray *_bgColors;
    NSArray *_groups;
    NSString *_selectedBg;
    NSString *_selectedAccent;
    NSString *_selectedGroup;
    IIViewDeckController *controller;
}
@end


@implementation ParaViewerViewController
// Sub views defined.
@synthesize leftScopeViewController = _leftScopeViewController;
@synthesize nbItems = _nbItems;
@synthesize tableView = _tableView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _nbItems = kMCNumItems;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        if (self) {
        _nbItems = kMCNumItems;
    }

//    self.tableView.separatorStyle = NO;
    
    self.title = @"Viewer";
    [self reload:nil];
    
    self.view.backgroundColor = [UIColor darkGrayColor]; //
    [[self.navigationController navigationBar] setTranslucent:NO];
    
	CGRect viewBounds = self.view.bounds;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.width, viewBounds.size.height - 44.0f)];
    NSLOG_CGRECT("tableview", viewBounds);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = YES;
    [self.view addSubview:_tableView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    NSLog(@"Bounds %@", NSStringFromCGRect(self.view.bounds));
//    NSLog(@"Frame %@", NSStringFromCGRect(self.view.frame));
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [AMCommandMaster reload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleSwipe
{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
	NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    
	NSString *filePath = [pdfs lastObject]; assert(filePath != nil); // Path to last PDF file
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document delegate:self];
        readerViewController.view.backgroundColor = [UIColor darkGrayColor];
        
        if ([readerViewController.navigationItem respondsToSelector:@selector(leftBarButtonItems)]) {
            
            controller = [[IIViewDeckController alloc] initWithCenterViewController:readerViewController];
            controller.delegate = (id)self;
            readerViewController.delegate = self; // Set the ReaderViewController delegate to self
            
            
            controller.navigationControllerBehavior = IIViewDeckNavigationControllerContained;
            
            _leftScopeViewController = [[LeftScopeViewController alloc] initWithNibName:@"LeftScopeViewController" bundle:nil];
            _leftScopeViewController = [_leftScopeViewController initWithReaderDocument:document];
            //    initWithReaderDocument:document];
            _leftScopeViewController.delegate = (id)readerViewController;
            IISideController *leftSideController = [[IISideController alloc] initWithViewController:(UIViewController *) _leftScopeViewController constrained:250.0f];
            controller.rightController = leftSideController;
            [controller setSizeMode:IIViewDeckViewSizeMode];
            [controller setRightSize:250.0f];
            
            UIBarButtonItem *rightScopeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(leftScopeButtonClicked:)];
            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:Nil action:Nil];
            fixedSpace.width = 20.0f;
            UIBarButtonItem *bookMarkButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:readerViewController action:@selector(bookMarkClicked)];
            UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:Nil];
            controller.navigationItem.rightBarButtonItems = @[rightScopeButton, fixedSpace, bookMarkButton, fixedSpace];
            controller.navigationItem.leftItemsSupplementBackButton = YES;
            controller.navigationItem.leftBarButtonItems = @[fixedSpace, actionButton];
            
            [_leftScopeViewController.view setNeedsDisplay];
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.navigationController pushViewController:controller animated:YES
             ];
        }
    }
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
    [self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
    
    controller.rightController = nil;
}

- (void)leftScopeButtonClicked:(UIButton *)button
{
    [controller toggleRightView];
    //    [self.viewDeckController.view setNeedsDisplay];
}

- (void)setNeedsResume
{
    [controller closeRightView];
//    sleep(1);

//    [AMCommandMaster reload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _nbItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    MCSwipeTableViewCell *cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    [cell setDelegate:self];
    [cell setFirstStateIconName:@"check.png"
                     firstColor:[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]
            secondStateIconName:@"cross.png"
                    secondColor:[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]
                  thirdIconName:@"clock.png"
                     thirdColor:[UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0]
                 fourthIconName:@"list.png"
                    fourthColor:[UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0]];
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    //
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    if (indexPath.row % kMCNumItems == 0) {
        [cell.textLabel setText:@"Switch Mode Cell"];
        [cell.detailTextLabel setText:@"Swipe to switch"];
        cell.mode = MCSwipeTableViewCellModeSwitch;
    }
    
    else if (indexPath.row % kMCNumItems == 1) {
        [cell.textLabel setText:@"Exit Mode Cell"];
        [cell.detailTextLabel setText:@"Swipe to delete"];
        cell.mode = MCSwipeTableViewCellModeExit;
    }
    
    else if (indexPath.row % kMCNumItems == 2) {
        [cell.textLabel setText:@"Mixed Mode Cell"];
        [cell.detailTextLabel setText:@"Swipe to switch or delete"];
        cell.modeForState1 = MCSwipeTableViewCellModeSwitch;
        cell.modeForState2 = MCSwipeTableViewCellModeExit;
        cell.modeForState3 = MCSwipeTableViewCellModeSwitch;
        cell.modeForState4 = MCSwipeTableViewCellModeExit;
        cell.shouldAnimatesIcons = YES;
    }
    
    else if (indexPath.row % kMCNumItems == 3) {
        [cell.textLabel setText:@"Unanimated Icons"];
        [cell.detailTextLabel setText:@"Swipe"];
        cell.mode = MCSwipeTableViewCellModeSwitch;
        cell.shouldAnimatesIcons = NO;
    }
    
    else if (indexPath.row % kMCNumItems == 4) {
        [cell.textLabel setText:@"Disabled right swipe"];
        [cell.detailTextLabel setText:@"Swipe"];
        [cell setFirstStateIconName:nil
                         firstColor:nil
                secondStateIconName:nil
                        secondColor:nil
                      thirdIconName:@"clock.png"
                         thirdColor:[UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0]
                     fourthIconName:@"list.png"
                        fourthColor:[UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0]];
        
        
    }
    
    else if (indexPath.row % kMCNumItems == 5) {
        [cell.textLabel setText:@"Disabled left swipe"];
        [cell.detailTextLabel setText:@"Swipe"];
        [cell setFirstStateIconName:@"check.png"
                         firstColor:[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]
                secondStateIconName:@"cross.png"
                        secondColor:[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]
                      thirdIconName:nil
                         thirdColor:nil
                     fourthIconName:nil
                        fourthColor:nil];
    }
    
    else if (indexPath.row % kMCNumItems == 6) {
        [cell.textLabel setText:@"Small triggers"];
        [cell.detailTextLabel setText:@"Using 10% and 50%"];
        cell.firstTrigger = 0.1;
        cell.secondTrigger = 0.5;
    }
    
    else if (indexPath.row % kMCNumItems == 7) {
        [cell.textLabel setText:@"Small triggers"];
        [cell.detailTextLabel setText:@"and unanimated icons"];
        cell.firstTrigger = 0.1;
        cell.secondTrigger = 0.5;
        cell.shouldAnimatesIcons = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ParaViewerViewController *tableViewController = [[ParaViewerViewController alloc] init];
//    [self.navigationController pushViewController:tableViewController animated:YES];
    [self handleSingleSwipe];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - MCSwipeTableViewCellDelegate

// When the user starts swiping the cell this method is called
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell {
    NSLog(@"Did start swiping the cell!");
}

// When the user ends swiping the cell this method is called
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell {
    NSLog(@"Did end swiping the cell!");
}

/*
 // When the user is dragging, this method is called and return the dragged percentage from the border
 - (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipWithPercentage:(CGFloat)percentage {
 NSLog(@"Did swipe with percentage : %f", percentage);
 }
 */

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didEndSwipingSwipingWithState:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode {
    NSLog(@"Did end swipping with IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [self.tableView indexPathForCell:cell], state, mode);
    
    if (mode == MCSwipeTableViewCellModeExit) {
        _nbItems--;
        [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -

- (void)reload:(id)sender {
    _nbItems++;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
