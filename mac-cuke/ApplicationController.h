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
	NSString *filePath;
	NSString *fileUrl;
	NSFileManager *fileManager;
	NSDate *latestDate;
}
- (void) reload;
- (NSString *) getFileFromCommandLine;
- (BOOL) application:(NSApplication *)theApplication openFile:(NSString *)filename;
@end
