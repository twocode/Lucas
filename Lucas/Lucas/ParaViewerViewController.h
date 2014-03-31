//
//  ParaViewerViewController.h
//  Lucas
//
//  Created by xiangyuh on 13-8-23.
//  Copyright (c) 2013年 xiangyuh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "LeftScopeViewController.h"
#import "IIViewDeckController.h"


@interface Color : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *name;

+ (id)createColor:(UIColor *)color withName:(NSString *)name;

@end


//@interface ParaViewerViewController : UITableViewController
@interface ParaViewerViewController : UIViewController

@property (nonatomic, strong) LeftScopeViewController *leftScopeViewController;
@property(nonatomic, assign) NSUInteger nbItems;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSArray *bookInfoArray;
@property (strong, nonatomic) UIToolbar *toolBar;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
