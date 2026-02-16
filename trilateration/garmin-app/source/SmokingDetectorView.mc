//
// SmokingDetectorView.mc
// Main UI view
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class SmokingDetectorView extends WatchUi.View {

    var cigaretteCount = 0;
    var statusText = "Ready";

    function initialize() {
        View.initialize();
    }

    // Load resources
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Update UI
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Cigarette count
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2 - 40,
            Graphics.FONT_NUMBER_THAI_HOT,
            cigaretteCount.toString(),
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Status
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2 + 20,
            Graphics.FONT_SMALL,
            statusText,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Label
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2 + 40,
            Graphics.FONT_TINY,
            "cigarettes detected",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    // Update count
    function updateCount(count) {
        cigaretteCount = count;
        WatchUi.requestUpdate();
    }

    // Update status
    function updateStatus(status) {
        statusText = status;
        WatchUi.requestUpdate();
    }
}

class SmokingDetectorDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    // Handle select button (start/stop)
    function onSelect() {
        System.println("[View] Select pressed");
        return true;
    }
}
