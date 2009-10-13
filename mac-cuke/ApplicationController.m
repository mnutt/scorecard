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
extern int mkfifo (const char *, mode_t);


@implementation AppController
- (void)awakeFromNib
{
	fileManager = [NSFileManager defaultManager];
	latestDate = [NSDate distantPast];
	[latestDate retain];
	
//	specPath = [[NSString alloc] initWithString:[self getFileFromCommandLine]];
	
	
	fileUrl = @"file:///Users/michael/code/rspec-cukeapp/template/index.html";
	
	pipePath = @"/tmp/spec-pipe";
	
	NSLog(@"Speccing directory %@", [fileManager currentDirectoryPath]);
	NSLog(@"And opening URL %@", fileUrl);
	
	[self startSpecRunner];
	
	[webView setDrawsBackground:FALSE];
	[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]]];
}

- (NSString *)getCommandLineArgs
{
	char **argv = *_NSGetArgv();
	NSString *commandLineArg;
	
	if (sizeof(argv) > 1 && argv[1] != nil) {
		commandLineArg = [[NSString alloc] initWithCString: argv[1] encoding:1];
	} else {
		commandLineArg = @"";
		NSLog(@"No argument specified, using %@", commandLineArg);
	}
	
	return commandLineArg;
}

- (void)startSpecRunner
{
	specRunner = [[NSTask alloc] init];
	
	NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	NSString *helperPath = [thisBundle pathForResource:@"specviz-helper" ofType:@"sh"];
	NSArray *arguments = [NSArray arrayWithObjects:helperPath, @"/Users/michael/code/limecast", pipePath, [self getCommandLineArgs], nil];
	[specRunner setArguments:arguments];
	
//	[specRunner setCurrentDirectoryPath:@"~/code/limecast"];
	[specRunner setLaunchPath:@"/bin/bash"];
	
	[self setupPipe];
	[specRunner launch];
}

- (void)setupPipe
{
	const char * path = [pipePath cStringUsingEncoding:NSASCIIStringEncoding];
	if(mkfifo(path, 0666) == -1 && errno !=EEXIST){
		NSLog(@"Unable to open the named pipe %c", path);
	}
	
	int fd = open(path, O_RDWR | O_NDELAY);
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
	if(![specRunner isRunning]) { return; }
	
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

- (void)reload:(id)sender
{
	[self killSpecRunner];
	[webView reload:sender];
	[self startSpecRunner];
}

- (void)killSpecRunner
{
	[self closePipe];
	// BAD RSPEC!
	if([specRunner isRunning]) {
		NSLog(@"TERMINATE: %@", specRunner);
		[specRunner terminate];
	}
	[specRunner dealloc];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	NSLog(@"app should terminate");
	[self killSpecRunner];
	return NSTerminateNow;
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
	NSLog(@"hi");
	return TRUE;
}

@end
