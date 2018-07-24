// Spelling Editor: A utility for editing the spelling user dictionary
//
// Copyright © 2018 Andrew Hyatt
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

#import "AppDelegate.h"

NSString* dictionaryPath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Spelling/LocalDictionary"];
}

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSArrayController *dataController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.spelling = [NSMutableArray new];
    [self loadSpelling];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)loadSpelling {
    NSError *error;
    NSString *spellingEntries = [NSString stringWithContentsOfFile:dictionaryPath() encoding:NSUTF8StringEncoding error:&error];
    if (error == nil) {
        NSArray *components = [spellingEntries componentsSeparatedByString:@"\n"];
        for (NSString *component in components) {
            if (component == nil || [component isEqualToString:@""]) {
                continue;
            }
            SpellingEntry *entry = [SpellingEntry new];
            entry.entry = component;
            [self.dataController addObject:entry];
        }
    }
}

- (void)saveDocument:(id)sender {
    NSMutableString *contents = [NSMutableString new];
    
    NSArray<SpellingEntry *> *entries = [self.dataController arrangedObjects];
    
    for (SpellingEntry *entry in entries) {
        if ([entry entry] == nil || [entry.entry isEqualToString:@""]) {
            continue;
        }
        [contents appendString:[entry.entry stringByAppendingString:@"\n"]];
    }
    [contents writeToFile:dictionaryPath() atomically:true encoding:NSUTF8StringEncoding error:nil];
}

@end
