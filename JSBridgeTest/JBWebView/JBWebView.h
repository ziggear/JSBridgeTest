//
//  JBWebView.h
//  JSBridgeTest
//
//  Created by ziggear on 15-5-7.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBWebObject;
@interface JBWebView : UIWebView

- (NSString *)loadBundleJSByName:(NSString *)jsFileName;
- (BOOL)hasObjectForName:(NSString *)objName;
- (id)objectForName:(NSString *)objName;
- (void)appendWebObject:(JBWebObject *)wo;
- (BOOL)shouldStartLoadWithBridgeRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
@end
