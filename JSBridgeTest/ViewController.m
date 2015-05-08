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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    self.shareButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    self.shareButton.hidden = YES;
    
    self.webView.delegate = self;
    [self.webView stringByEvaluatingJavaScriptFromString:@"onload=function(){window.location.href = 'simulatedweixinjsbridge://windowOnLoad/'}"];
    
    JBWebObject *wo = [[JBWebObject alloc] initWithObjectName:@"abc"];
    [wo appendJavascriptFunctionName:@"hello" handler:^(id responseParams){
        NSLog(@"hello i was called by javascript!");
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

- (IBAction)share:(id)sender {
    [self.webView stringByEvaluatingJavaScriptFromString:@"WeixinJSBridge.dispatchShareEvent()"];
}

- (void)didFinishLoad
{
    //do bridge stuff ...
    if ([self.webView hasObjectForName:@"WeixinJSBridge"] == NO) {
        [self.webView loadBundleJSByName:@"SimulatedWeixinJSBridge"];
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"WeixinJSBridge.onWebViewReady();"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self didFinishLoad];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@", request.URL.scheme);
    if([self.webView shouldStartLoadWithBridgeRequest:request navigationType:navigationType]) {
        return NO;
    }
    
    if([request.URL.scheme isEqualToString:@"simulatedweixinjsbridge"]) {
        if([request.URL.host isEqualToString:@"sendAppMessage"]) {
            NSString *jsonString = [self.webView stringByEvaluatingJavaScriptFromString:@"WeixinJSBridge.fetchQueue();"];
            NSDictionary *queueData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            if(queueData) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享内容" message:jsonString delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        } else if ([request.URL.host isEqualToString:@"windowOnLoad"]) {
            NSLog(@"shareTitle: %@", [webView stringByEvaluatingJavaScriptFromString:@"window.shareTitle"]);
            [self.webView stringByEvaluatingJavaScriptFromString:@"abc.hello('a', 1, 'bcd');"];
            self.shareButton.hidden = NO;
        }
        return NO;
    }
    return YES;
}

@end
