//
//  AppController.h
//  CucumberRunner
//
//  Created by Michael Nutt on 10/6/09.
//  Copyright 2009 Vanderbilt University. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface AppController : NSObject {
	IBOutlet WebView *webView;
	IBOutlet WebView *largeWebView;
	NSString *specPath;
	NSString *pipePath;
	NSString *templateUrl;
	NSFileManager *fileManager;
	NSDate *latestDate;
	NSTask *specRunner;
	NSFileHandle *filehandleForReading;
}
- (NSString *) getCommandLineArgs;
- (NSString *) getTemplate;
- (void) setupPipe;
- (void) closePipe;
- (void) appendData:(NSString *)data;

@end
