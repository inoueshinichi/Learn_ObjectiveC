#import <AppKit/NSApplication.h>
#import "app_delegate.h"

int main([[maybe_unused]] int argc, 
         [[maybe_unused]] const char *argv[]) {

    auto app = [NSApplication sharedApplication];
    app.delegate = [AppDelegate new];
    [app run];

    return 0;
}