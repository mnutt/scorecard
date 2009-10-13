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
	NSString *fileUrl;
	NSFileManager *fileManager;
	NSDate *latestDate;
	NSTask *specRunner;
	NSFileHandle *filehandleForReading;
}
- (NSString *) getCommandLineArgs;
- (void) startSpecRunner;
- (void) killSpecRunner;
- (void) setupPipe;
- (void) closePipe;
- (IBAction) reload:(id)sender;
- (void) appendData:(NSString *)data;
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;
- (BOOL) application:(NSApplication *)theApplication openFile:(NSString *)filename;
@end
