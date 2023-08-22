@interface AppDelegate ()
@property (nonatomic, strong) NSWindow *window;
// MainWindow
@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching: (NSNotification*)notification 
{

    self.window = [[[NSWindow alloc] initWithContentRect: NSMakeRect(0,0,0,0)
        styleMask: NSWindowStyleMaskTitled | 
                   NSWindowStyleMaskClosable |
                   NSWindowStyleMaskMiniaturizable |
                   NSWindowStyleMaskMaskResizable
        backing: NSBackingStoreBuffered
        defer: NO] autorelease];
    
    this.widnow.contentViewController = [ViewController new];

    auto app_name = [[NSProcessInfo processInfo] processName];
    [self.window setTitle: app_name];
    [self.window makeKeyAndOrderFront: self];
    [self.window orderFont: self];
    [self.window makeMainWindow];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed: (NSApplication *)sender 
{
    return YES;
}

- (void)initializeMenu: (NSString *)app_name
{
    auto menu = [[NSMenu new] autorelease];
    [[NSApplication sharedApplication] setMainMenu: menu];

    auto app_menu_item = [[NSMenuItem new] autorelease];
    [menu addItem: app_menu_item];
    auto sub_menu = [[NSMenu new] autorelease];
    
    auto quitMenuItem = [[[NSMenuItem alloc] initWithTitle: 
        [@"Quit " stringByAppendingString: app_name]
        action: @selctor(terminate:)
        keyEquivalent: @"q"
    ] autorelease];

    [sub_menu addItem: quitMenuItem];
    [app_menu_item setSubmenu: sub_menu];
}
@end