//
//  ViewController.m
//  JSBridgeTest
//
//  Created by ziggear on 15-5-6.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.webView.delegate = self;
    self.shareButton.hidden = YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"onload=function(){window.location.href = 'simulatedweixinjsbridge://windowOnLoad/'}"];
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
    if (![[self.webView stringByEvaluatingJavaScriptFromString:@"typeof WeixinJSBridge == 'object'"] isEqualToString:@"true"]) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *filePath = [bundle pathForResource:@"SimulatedWeixinJSBridge" ofType:@"js"];
        NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.webView stringByEvaluatingJavaScriptFromString:js];
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"WeixinJSBridge.onWebViewReady();"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self didFinishLoad];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
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
            self.shareButton.hidden = NO;
        }
        return NO;
    }
    return YES;
}

@end
