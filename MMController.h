//
//  MMController.h
//  Memo
//
//  Created by Zac White on 10/31/08.
//  Copyright 2008 Zac White. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

#import "PTHotKey.h"
#import "PTHotKeyCenter.h"

#import <ShortcutRecorder/ShortcutRecorder.h>

@interface MMController : NSObject {
	NSStatusItem *statusItem;
	
	IBOutlet NSWindow *memoWindow;
	IBOutlet NSTextView *textView;
	IBOutlet NSWindow *prefsWindow;
	
	PTHotKey *lastKey;
	PTKeyCombo *lastCombo;
		
	IBOutlet SRRecorderControl *recorder;
	
	ProcessSerialNumber last_process;
}

@property (nonatomic, retain) PTHotKey *lastKey;
@property (nonatomic, retain) PTKeyCombo *lastCombo;

- (void)assignKeyCombo:(KeyCombo)newCombo;
- (IBAction)dismissSheet:(id)sender;

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo;

- (void)showPreferences:(id)sender;
- (void)toggleWindow:(id)sender;

@end
