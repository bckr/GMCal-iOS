//
//  NBNewsDetailViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 3/2/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBNewsDetailViewController.h"

@interface NBNewsDetailViewController ()

@end

@implementation NBNewsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.newsItem.title;
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.spinner startAnimating];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.newsItem.guid]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.webView = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.spinner stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [webView stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 1.2;"];
}

@end
