# JSBridgeTest
A light-weight solution for interaction with objective-c and javascript (based on UIWebView).

#### Usage
  * 1 copy 'JBWebView' folder to your project
  * 2 add JBWebView on your view or xib
  * 3 insert following code to webView's callback 'webView:shouldStartLoadWithRequest:navigationType:'

```
if([self.webView shouldStartLoadWithBridgeRequest:request navigationType:navigationType]) {
	        return NO;
}
```

#### Basic Interaction
  * 1 load javascript file
    ```objc
    [self.webView loadBundleJSByName:@"yourJSFileName"];
    ```
    
  * 2 check whether javascript object exists 
    ```objc
    [self.webView hasObjectForName:@"obj_name"];
    ```
  
  * 3 obtain json serializeable object from javascript
	  * javascript
	  
	   ```javascript
	    abc = [1, 2, 'def'];
	    ```
	  * Objective-C
	  
	   ```objc
	    [self.webView objectForName:@"abc"]
	    ```

#### JS object with native implementation

* Objective-C
``` objc
JBWebObject *wo = [[JBWebObject alloc] initWithObjectName:@"abc"];
[wo appendJavascriptFunctionName:@"hello" handler:^(id responseParams){
	NSLog(@"hello i was called by javascript!");
	//handle response params
}];
    
[self.webView appendWebObject:wo];
```

* javascript
``` objc
abc.hello('a', 1, 'bcd');
```

when javascript function 'hello' called, handler block in JBWebObject will be perform.
