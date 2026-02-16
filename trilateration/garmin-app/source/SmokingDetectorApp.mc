//
// SmokingDetectorApp.mc
// Main application entry point
//

using Toybox.Application;
using Toybox.WatchUi;

class SmokingDetectorApp extends Application.AppBase {

    var detectionService;

    function initialize() {
        AppBase.initialize();
        detectionService = new DetectionService();
    }

    // Return initial view
    function getInitialView() {
        return [new SmokingDetectorView(), new SmokingDetectorDelegate()];
    }

    // App started
    function onStart(state) {
        System.println("[App] Started");
        detectionService.start();
    }

    // App stopped
    function onStop(state) {
        System.println("[App] Stopped");
        detectionService.stop();
    }
}
