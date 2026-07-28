import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  // schellout-chat: keep running after the last window closes so Matrix sync
  // and notifications stay alive in the background (see BRANDING.md).
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    // Keep the window instance alive when closed so it can be reopened.
    mainFlutterWindow?.isReleasedWhenClosed = false
    super.applicationDidFinishLaunching(notification)
  }

  // schellout-chat: reopen the window when the dock icon is clicked.
  override func applicationShouldHandleReopen(
    _ sender: NSApplication,
    hasVisibleWindows flag: Bool
  ) -> Bool {
    if !flag {
      mainFlutterWindow?.makeKeyAndOrderFront(self)
    }
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
