#import "view_controller.h"

@implementation ViewController

- (void)loadView {
    self.view = [[NSView alloc] initWithFrame: NSMaskRect(0,0,720,480)];
    [self.view setWantsLayer: YES];
}

@end