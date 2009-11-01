//
//  AppController.m
//  CucumberRunner
//
//  Created by Michael Nutt on 10/6/09.
//  Copyright 2009 Michael Nutt.
//

#import "ApplicationController.h"
#import <WebKit/WebKit.h>
#include <stdio.h>

extern char ***_NSGetArgv(void);
extern int _NSGetArgc(void);
extern int mkfifo (const char *, mode_t);


@implementation AppController
- (void)awakeFromNib
{
	fileManager = [NSFileManager defaultManager];
	latestDate = [NSDate distantPast];
	[latestDate retain];
	
	pipePath = [[NSString alloc] initWithString:[self getPathFromCommandLine]];
	fileUrl = [NSString stringWithFormat:@"file://%@/templates/default/index.html", [[NSBundle mainBundle] resourcePath]];
	// fileUrl = @"file:///Users/michael/code/scorecard/template/index.html";
	
	NSLog(@"Reading from pipe %@", pipePath);
	NSLog(@"And opening URL %@", fileUrl);
	
	[self setupPipe];
	
	[webView setDrawsBackground:FALSE];
	[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]]];
}

- (NSString *)getPathFromCommandLine
{
	char **argv = *_NSGetArgv();
	NSString *commandLineArg;
	NSString *fullFilePath;
	
	if (sizeof(argv) > 1 && argv[1] != nil) {
		commandLineArg = [[NSString alloc] initWithCString: argv[1] encoding:1];
	} else {
		commandLineArg = @"/tmp/scorecard-pipe";
		NSLog(@"No argument specified, using %@", commandLineArg);
	}
	
	if ([[commandLineArg stringByExpandingTildeInPath] hasPrefix:@"/"]) {
		fullFilePath = [[NSString alloc] initWithString:[commandLineArg stringByExpandingTildeInPath]];
	} else {
		fullFilePath = [[NSString alloc] initWithString:[[[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingString:@"/"] stringByAppendingString:commandLineArg]];
	}
	
	return fullFilePath;
}

- (void)setupPipe
{
	if(mkfifo([pipePath UTF8String], 0666) == -1 && errno !=EEXIST){
		NSLog(@"Unable to open the named pipe %@", pipePath);
	}
	
	int fd = open([pipePath UTF8String], O_RDWR | O_NDELAY);
	filehandleForReading = [[NSFileHandle alloc] initWithFileDescriptor:fd closeOnDealloc: YES];
	
	NSNotificationCenter *nc;
	nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[nc addObserver:self
		   selector:@selector(dataReady:)
			   name:NSFileHandleReadCompletionNotification
			 object:filehandleForReading];
	[filehandleForReading readInBackgroundAndNotify];
}

- (void)closePipe
{
	[filehandleForReading dealloc];
}

- (void)dataReady:(NSNotification *)n
{
	NSData *d;
	d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
	
	NSLog(@"dataReady:%d bytes", [d length]);
	
	NSString *dataString;
	dataString = [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
	
	if ([d length]) {
		[self appendData:dataString];
	}
	
	//Tell the fileHandler to asychronusly report back
	[filehandleForReading readInBackgroundAndNotify];
}

- (void)appendData:(NSString *)data
{
	// When we pass the json to webkit it becomes unescaped, so we need to re-escape it
	NSString *escapedSlashes = [data stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
	NSString *escapedQuotes = [escapedSlashes stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
	
	// Remove the trailing newline character
	NSString *trimmedString = [escapedQuotes substringWithRange:NSMakeRange(0, [escapedQuotes length]-1)];
	
	NSString *script = [[NSString alloc] initWithFormat:@"handle(\"%@\");", trimmedString];
	NSLog(@"SCRIPT: %@", script);
	
	[webView stringByEvaluatingJavaScriptFromString:script];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	[self closePipe];
	return NSTerminateNow;
}

@end
