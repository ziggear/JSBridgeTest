//
//  ViewController.m
//  JSBridgeTest
//
//  Created by ziggear on 15-5-6.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "ViewController.h"
#import "JBWebView.h"
#import "JBWebObject.h"

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet JBWebView *webView;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"JSBridgeTest";
    
    self.webView.delegate = self;
    [self.webView stringByEvaluatingJavaScriptFromString:@"onload=function(){window.location.href = 'simulatedjsbridge://windowOnLoad/'}"];
    
    JBWebObject *wo = [[JBWebObject alloc] initWithObjectName:@"abc"];
    [wo appendJavascriptFunctionName:@"hello" handler:^(id responseParams){
        NSLog(@"hello i was called by javascript!");
        //handle response params
    }];
    
    [self.webView appendWebObject:wo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.webView loadRequest:self.request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@", request.URL.scheme);
    if([self.webView shouldStartLoadWithBridgeRequest:request navigationType:navigationType]) {
        return NO;
    }
    
    if([request.URL.scheme isEqualToString:@"simulatedjsbridge"]) {
        if ([request.URL.host isEqualToString:@"windowOnLoad"]) {
            [self.webView stringByEvaluatingJavaScriptFromString:@"abc.hello('a', 1, 'bcd');"];
        }
        return NO;
    }
    return YES;
}

@end
