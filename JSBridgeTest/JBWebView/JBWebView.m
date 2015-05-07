//
//  JBWebView.m
//  JSBridgeTest
//
//  Created by ziggear on 15-5-7.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "JBWebView.h"

@implementation JBWebView

- (NSString *)loadBundleJSByName:(NSString *)jsFileName {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:jsFileName ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return [self stringByEvaluatingJavaScriptFromString:js];
}

- (BOOL)hasObjectForName:(NSString *)objName {
    NSString *jsString = [NSString stringWithFormat:@"typeof %@ == 'object'", objName];
    return [[self stringByEvaluatingJavaScriptFromString:jsString] isEqualToString:@"true"];
}

- (id)objectForName:(NSString *)objName {
    NSString *jsString = [NSString stringWithFormat:@"JSON.stringify(%@)", objName];
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:[jsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if(!error) {
        return obj;
    }
    return nil;
}

@end
