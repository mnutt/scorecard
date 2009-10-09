//
//  CukeAppDelegate.h
//  Cuke
//
//  Created by Michael Nutt on 10/7/09.
//  Copyright 2009 Vanderbilt University. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CukeAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
