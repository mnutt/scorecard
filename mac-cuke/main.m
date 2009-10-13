//
//  main.m
//  Cuke
//
//  Created by Michael Nutt on 10/7/09.
//  Copyright 2009 Vanderbilt University. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[NSUserDefaults standardUserDefaults] registerDefaults: [NSDictionary dictionaryWithObject: @"YES"
																						 forKey: @"WebKitDeveloperExtras"]];
	[pool release];
    return NSApplicationMain(argc,  (const char **) argv);
}
