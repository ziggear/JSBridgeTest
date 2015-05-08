//
//  JBWebView.m
//  JSBridgeTest
//
//  Created by ziggear on 15-5-7.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "JBWebView.h"
#import "JBWebObject.h"

@interface JBWebView ()
@property (nonatomic, strong) NSMutableDictionary *webObjects;
@end

@implementation JBWebView

- (instancetype)init {
    if(self = [super init]) {
        _webObjects = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)awakeFromNib {
    _webObjects = [NSMutableDictionary dictionary];
}

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

- (void)appendWebObject:(JBWebObject *)wo {
    if(wo && wo.name) {
        [_webObjects setObject:wo forKey:wo.name];
        [self stringByEvaluatingJavaScriptFromString:wo.javascriptImplementation];
    }
}

- (BOOL)shouldStartLoadWithBridgeRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if([request.URL.scheme isEqualToString:@"jbwebbridge"]) {
        [self handleBridgedURL:request.URL];
        return YES;
    }
    return NO;
}

- (void)handleBridgedURL:(NSURL *)url {
    NSString *query = url.query;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (query) {
        NSArray *array = [query componentsSeparatedByString:@"&"];
        
        for (NSString *string in array) {
            NSRange range = [string rangeOfString:@"="];
            if (range.location != NSNotFound) {
                NSString *key = [string substringToIndex:range.location];
                NSString *value = [[string substringFromIndex:range.location + 1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                if (key && value) {
                    params[key] = value;
                }
            }
        }
    }
    
    if([url.host isEqualToString:@"performObjcImp"]) {
        if([params objectForKey:@"obj_name"] && [params objectForKey:@"func_name"]) {
            JBWebObject *wo = [_webObjects objectForKey:[params objectForKey:@"obj_name"]];
            [wo performJavascriptFunctionName:[params objectForKey:@"func_name"]];
        }
    }
}


@end
