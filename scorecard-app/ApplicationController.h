//
//  AppController.h
//  CucumberRunner
//
//  Created by Michael Nutt on 10/6/09.
//  Copyright 2009 Michael Nutt
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface AppController : NSObject {
	IBOutlet WebView *webView;
	IBOutlet WebView *largeWebView;
	NSString *pipePath;
	NSString *fileUrl;
	NSFileManager *fileManager;
	NSDate *latestDate;
	NSTask *specRunner;
	NSFileHandle *filehandleForReading;
}
- (NSString *) getPathFromCommandLine;
- (void) setupPipe;
- (void) closePipe;
- (void) appendData:(NSString *)data;
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;
@end