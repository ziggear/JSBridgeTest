//
//  JBWebObject.m
//  JSBridgeTest
//
//  Created by ziggear on 15-5-8.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import "JBWebObject.h"

@interface JBWebObject ()
@property (nonatomic, strong) NSMutableDictionary *handlersDict;
@end

@implementation JBWebObject

- (id)initWithObjectName:(NSString *)name {
    if(self = [super init]) {
        _name = name;
        _handlersDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)appendJavascriptFunctionName:(NSString *)functionName handler:(void (^)(id responseParams))handler {
    if(functionName && handler) {
        [_handlersDict setObject:handler forKey:functionName];
    }
}

- (void)performJavascriptFunctionName:(NSString *)functionName {
    [self performJavascriptFunctionName:functionName withObject:nil];
}

- (void)performJavascriptFunctionName:(NSString *)functionName withObject:(id)responseObject {
    void (^handler)() = [_handlersDict objectForKey:functionName];
    handler(responseObject);
}

- (NSString *)javascriptImplementation {
    NSMutableString *imp = [NSMutableString stringWithString:@""];
    [imp appendFormat:@"var %@ = document.createElement('iframe');\n", self.name];
    [imp appendFormat:@"window.%@ = %@;\n", self.name, self.name];
    for(NSString *key in _handlersDict) {
        [imp appendFormat:@"window.%@.%@ = function (){var params = []; for (i = 0; i < arguments.length; i++) {params[i]=arguments[i];} params_str = JSON.stringify(params); window.location.href='jbwebbridge://performObjcImp?obj_name=%@&func_name=%@&params='+params_str;}\n", self.name, key, self.name, key];
    }
    return imp;
}

@end
