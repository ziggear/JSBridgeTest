//
//  JBWebObject.h
//  JSBridgeTest
//
//  Created by ziggear on 15-5-8.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBWebObject : NSObject

@property (nonatomic, readonly, strong) NSString *name;

- (id)initWithObjectName:(NSString *)name;
- (void)appendJavascriptFunctionName:(NSString *)functionName handler:(void (^)())handler;
- (void)performJavascriptFunctionName:(NSString *)functionName;
- (NSString *)javascriptImplementation;

@end
