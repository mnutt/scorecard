//
//  AppController.m
//  CucumberRunner
//
//  Created by Michael Nutt on 10/6/09.
//  Copyright 2009 Vanderbilt University. All rights reserved.
//

#import "ApplicationController.h"
#import <WebKit/WebKit.h>
#include <stdio.h>

extern char ***_NSGetArgv(void);
extern int _NSGetArgc(void);

@implementation AppController
- (void)awakeFromNib
{
	fileManager = [NSFileManager defaultManager];
	latestDate = [NSDate distantPast];
	[latestDate retain];
	
	filePath = [[NSString alloc] initWithString:[self getFileFromCommandLine]];
	
	fileUrl = [@"file://" stringByAppendingString:[filePath stringByStandardizingPath]];
	
	NSLog(@"Watching file %@", filePath);
	NSLog(@"And opening URL %@", fileUrl);
	
	[webView setDrawsBackground:FALSE];
	[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]]];

	[NSTimer scheduledTimerWithTimeInterval:0.2
									 target:self
								   selector:@selector(reload)
								   userInfo: nil
									repeats:YES];
}

- (NSString *)getFileFromCommandLine
{
	char **argv = *_NSGetArgv();
	NSString *commandLineArg;
	NSString *fullFilePath;
	
	if (sizeof(argv) > 1) {
		commandLineArg = [[NSString alloc] initWithCString: argv[1] encoding:1];
	} else {
		NSLog(@"Need a file to monitor");
		exit(1);
	}
	
	if ([[commandLineArg stringByExpandingTildeInPath] hasPrefix:@"/"]) {
		fullFilePath = [[NSString alloc] initWithString:[commandLineArg stringByExpandingTildeInPath]];
	} else {
		fullFilePath = [[NSString alloc] initWithString:[[[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingString:@"/"] stringByAppendingString:commandLineArg]];
	}
	
	return fullFilePath;
}

- (void)reload
{
	if(![fileManager fileExistsAtPath:filePath])
		return;
	NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:nil];
	
	NSDate *fileModificationDate = [attributes valueForKey:@"NSFileModificationDate"];
	[fileModificationDate retain];
	
	if ([fileModificationDate compare:latestDate] == NSOrderedDescending){
		// NSLog(@"updating");
		[webView reload:self];
		// NSLog(@"%@", fileModificationDate);
		latestDate = fileModificationDate;
	}
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
	NSLog(@"hi");
	return TRUE;
}

@end
