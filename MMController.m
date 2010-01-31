//
//  MMController.m
//  Memo
//
//  Created by Zac White on 10/31/08.
//  Copyright 2008 Zac White. All rights reserved.
//

#import "MMController.h"

@implementation MMController

@synthesize lastKey, lastCombo;

- (void)awakeFromNib {
	[recorder setCanCaptureGlobalHotKeys:YES];
	
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	
	NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"keyCombo"];
	
	if(dict) {
		PTKeyCombo *combo = [[PTKeyCombo alloc] initWithPlistRepresentation:dict];
		KeyCombo oldCombo;
		oldCombo.code = [combo keyCode];
		oldCombo.flags = [recorder carbonToCocoaFlags:[combo modifiers]];
		
		[combo release];
		
		[self assignKeyCombo:oldCombo];
		
		[recorder setKeyCombo:oldCombo];
	}
	
	[statusItem setHighlightMode:YES];
	[statusItem setToolTip:@"Memo"];
	[statusItem setEnabled:YES];
	[statusItem setImage:[NSImage imageNamed:@"pin.png"]];
	[statusItem setAlternateImage:[NSImage imageNamed:@"pin.png"]];
	
	[statusItem setTarget:self];
	[statusItem setAction:@selector(toggleWindow:)];
	
	NSButton *customButton = [[NSButton alloc] initWithFrame:NSMakeRect(3, 2, 16, 16)];
	[customButton setImage:[NSImage imageNamed:@"switch.png"]];
	[[customButton cell] setBordered:NO];
	
	[customButton setTarget:self];
	[customButton setAction:@selector(showPreferences:)];
	
	[[memoWindow contentView] addSubview:customButton];
	[customButton release];
	
	[memoWindow center];
}

- (void)showPreferences:(id)sender {	
	[NSApp beginSheet:prefsWindow modalForWindow:memoWindow modalDelegate:self didEndSelector:NULL contextInfo:NULL];
}

- (IBAction)dismissSheet:(id)sender {
	[[PTHotKeyCenter sharedCenter] registerHotKey:self.lastKey];
	
	[[NSUserDefaults standardUserDefaults] setObject:[self.lastCombo plistRepresentation] forKey:@"keyCombo"];
	
	[NSApp endSheet:prefsWindow returnCode:NSOKButton];
	[prefsWindow close];
}

- (void)assignKeyCombo:(KeyCombo)newCombo {
	self.lastCombo = [PTKeyCombo keyComboWithKeyCode:newCombo.code modifiers:[recorder cocoaToCarbonFlags:newCombo.flags]];
	self.lastKey = [[[PTHotKey alloc] initWithIdentifier:@"KeyCombo" keyCombo:self.lastCombo] autorelease];
	
	[self.lastKey setTarget:self];
	[self.lastKey setAction:@selector(toggleWindow:)];
	
	[[PTHotKeyCenter sharedCenter] registerHotKey:self.lastKey];
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
	[self assignKeyCombo:newKeyCombo];
}

- (void)toggleWindow:(id)sender {
	[self dismissSheet:sender];
	
	if([memoWindow isVisible]) {
		SetFrontProcess( &last_process );
		[memoWindow orderOut:self];
	} else {
		GetFrontProcess( &last_process );
		
		[NSApp activateIgnoringOtherApps:YES];
		
		[textView setSelectedRange:NSMakeRange(0, [[textView string] length])];
		[memoWindow makeKeyAndOrderFront:self];
	}
}

- (void)dealloc {
	self.lastKey = nil;
	self.lastCombo = nil;
	[statusItem release];
	[super dealloc];
}

@end
