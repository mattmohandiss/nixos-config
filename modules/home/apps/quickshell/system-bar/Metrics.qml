import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

Scope {
    id: root
    property string cpu: "--"
    property string temperature: "--"
    property string ram: "--"
    property string disk: "--"
    property string wifi: "offline"
    property string wifiSignal: "--"
    property bool wifiEnabled: false
    property bool bluetoothEnabled: false
    property string volume: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio ? Math.round(Pipewire.defaultAudioSink.audio.volume * 100) : "--"
    property bool volumeMuted: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio ? Pipewire.defaultAudioSink.audio.muted : false
    property string backlight: "--"
    property string battery: "--"
    property string batteryState: "unknown"
    property string powerProfile: "unknown"

    function updateBacklight() {
        if (!backlightFile.loaded || !maxBacklightFile.loaded) return;
        const current = Number(backlightFile.text().trim());
        const maximum = Number(maxBacklightFile.text().trim());
        if (maximum > 0) root.backlight = Math.round(current / maximum * 100);
    }

    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }

    Process { id: cpuProcess; command: ["sh", "-c", "top -bn1 | awk '/Cpu/ { print int(100 - $8); exit }'"]; running: true; stdout: StdioCollector { onStreamFinished: root.cpu = this.text.trim() } }
    Process { id: ramProcess; command: ["sh", "-c", "free -b | awk '/^Mem:/ { print int($3 / $2 * 100) }'"]; running: true; stdout: StdioCollector { onStreamFinished: root.ram = this.text.trim() } }
    Process { id: temperatureProcess; command: ["sh", "-c", "for z in /sys/class/thermal/thermal_zone*; do if grep -q x86_pkg_temp $z/type; then awk '{ print int($1 / 1000) }' $z/temp; break; fi; done"]; running: true; stdout: StdioCollector { onStreamFinished: root.temperature = this.text.trim() || "--" } }
    Process { id: diskProcess; command: ["sh", "-c", "df -P / | awk 'NR == 2 { print $5 }' | tr -d %"]; running: true; stdout: StdioCollector { onStreamFinished: root.disk = this.text.trim() } }
    Process { id: wifiProcess; command: ["sh", "-c", "nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes$/ { print $2; exit }'"]; running: true; stdout: StdioCollector { onStreamFinished: root.wifi = this.text.trim() || "offline" } }
    Process { id: wifiSignalProcess; command: ["sh", "-c", "nmcli -t -f active,signal dev wifi | awk -F: '$1 ~ /^yes$/ { print $2; exit }'"]; running: true; stdout: StdioCollector { onStreamFinished: root.wifiSignal = this.text.trim() || "--" } }
    Process { id: wifiRadioProcess; command: ["nmcli", "radio", "wifi"]; running: true; stdout: StdioCollector { onStreamFinished: root.wifiEnabled = this.text.trim() === "enabled" } }
    Process { id: bluetoothRadioProcess; command: ["sh", "-c", "rfkill list bluetooth | awk -F': ' '/Soft blocked/ { print $2; exit }'"]; running: true; stdout: StdioCollector { onStreamFinished: root.bluetoothEnabled = this.text.trim() === "no" } }
    Process {
        id: backlightDeviceProcess
        command: ["sh", "-c", "brightnessctl -m | cut -d, -f1"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.backlightDevice = this.text.trim() }
    }

    property string backlightDevice: ""

    FileView {
        id: backlightFile
        path: root.backlightDevice ? "/sys/class/backlight/" + root.backlightDevice + "/brightness" : ""
        watchChanges: true
        onLoaded: root.updateBacklight()
        onFileChanged: backlightFile.reload()
    }

    FileView {
        id: maxBacklightFile
        path: root.backlightDevice ? "/sys/class/backlight/" + root.backlightDevice + "/max_brightness" : ""
        onLoaded: root.updateBacklight()
    }
    Process { id: batteryProcess; command: ["sh", "-c", "for f in /sys/class/power_supply/BAT*/capacity; do [ -r $f ] && { cat $f; break; }; done"]; running: true; stdout: StdioCollector { onStreamFinished: root.battery = this.text.trim() || "--" } }
    Process { id: batteryStateProcess; command: ["sh", "-c", "for f in /sys/class/power_supply/BAT*/status; do [ -r $f ] && { cat $f; break; }; done"]; running: true; stdout: StdioCollector { onStreamFinished: root.batteryState = this.text.trim().toLowerCase() } }
    Process { id: powerProfileProcess; command: ["powerprofilesctl", "get"]; running: true; stdout: StdioCollector { onStreamFinished: root.powerProfile = this.text.trim() || "unknown" } }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            cpuProcess.running = true; temperatureProcess.running = true; ramProcess.running = true; diskProcess.running = true;
            wifiProcess.running = true; wifiSignalProcess.running = true; batteryProcess.running = true; batteryStateProcess.running = true;
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: if (!powerProfileProcess.running) powerProfileProcess.running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            if (!wifiRadioProcess.running) wifiRadioProcess.running = true;
            if (!bluetoothRadioProcess.running) bluetoothRadioProcess.running = true;
        }
    }
}
