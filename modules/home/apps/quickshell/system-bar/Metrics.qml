import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root
    property string cpu: "--"
    property string temperature: "--"
    property string ram: "--"
    property string disk: "--"
    property string wifi: "offline"
    property string wifiSignal: "--"
    property string volume: "--"
    property bool volumeMuted: false
    property string backlight: "--"
    property string battery: "--"
    property string batteryState: "unknown"

    Process { id: cpuProcess; command: ["sh", "-c", "top -bn1 | awk '/Cpu/ { print int(100 - $8); exit }'"]; running: true; stdout: StdioCollector { onStreamFinished: root.cpu = this.text.trim() } }
    Process { id: ramProcess; command: ["sh", "-c", "free -b | awk '/^Mem:/ { print int($3 / $2 * 100) }'"]; running: true; stdout: StdioCollector { onStreamFinished: root.ram = this.text.trim() } }
    Process { id: temperatureProcess; command: ["sh", "-c", "for z in /sys/class/thermal/thermal_zone*; do if grep -q x86_pkg_temp $z/type; then awk '{ print int($1 / 1000) }' $z/temp; break; fi; done"]; running: true; stdout: StdioCollector { onStreamFinished: root.temperature = this.text.trim() || "--" } }
    Process { id: diskProcess; command: ["sh", "-c", "df -P / | awk 'NR == 2 { print $5 }' | tr -d %"]; running: true; stdout: StdioCollector { onStreamFinished: root.disk = this.text.trim() } }
    Process { id: wifiProcess; command: ["sh", "-c", "nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes$/ { print $2; exit }'"]; running: true; stdout: StdioCollector { onStreamFinished: root.wifi = this.text.trim() || "offline" } }
    Process { id: wifiSignalProcess; command: ["sh", "-c", "nmcli -t -f active,signal dev wifi | awk -F: '$1 ~ /^yes$/ { print $2; exit }'"]; running: true; stdout: StdioCollector { onStreamFinished: root.wifiSignal = this.text.trim() || "--" } }
    Process { id: volumeProcess; command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print int($2 * 100) }'"]; running: true; stdout: StdioCollector { onStreamFinished: root.volume = this.text.trim() } }
    Process { id: volumeMutedProcess; command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && printf 1 || printf 0"]; running: true; stdout: StdioCollector { onStreamFinished: root.volumeMuted = this.text.trim() === "1" } }
    Process { id: backlightProcess; command: ["sh", "-c", "brightnessctl -m | cut -d, -f4 | tr -d %"]; running: true; stdout: StdioCollector { onStreamFinished: root.backlight = this.text.trim() } }
    Process { id: batteryProcess; command: ["sh", "-c", "for f in /sys/class/power_supply/BAT*/capacity; do [ -r $f ] && { cat $f; break; }; done"]; running: true; stdout: StdioCollector { onStreamFinished: root.battery = this.text.trim() || "--" } }
    Process { id: batteryStateProcess; command: ["sh", "-c", "for f in /sys/class/power_supply/BAT*/status; do [ -r $f ] && { cat $f; break; }; done"]; running: true; stdout: StdioCollector { onStreamFinished: root.batteryState = this.text.trim().toLowerCase() } }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            cpuProcess.running = true; temperatureProcess.running = true; ramProcess.running = true; diskProcess.running = true;
            wifiProcess.running = true; wifiSignalProcess.running = true; volumeProcess.running = true; volumeMutedProcess.running = true;
            backlightProcess.running = true; batteryProcess.running = true; batteryStateProcess.running = true;
        }
    }
}
