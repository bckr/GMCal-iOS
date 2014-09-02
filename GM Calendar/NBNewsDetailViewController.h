//
//  NBNewsDetailViewController.h
//  GM Calendar
//
//  Created by Nils Becker on 3/2/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBNewsItem.h"

@interface NBNewsDetailViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, weak) NBNewsItem *newsItem;

@end
