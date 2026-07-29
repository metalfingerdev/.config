pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    // PwObjectTracker ensures properties like volume and muted are bound and accessible on the default sink
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0.0
    readonly property bool muted: sink?.audio?.muted ?? false

    function setVolume(val: real) {
        if (sink?.audio) {
            sink.audio.volume = Math.max(0.0, Math.min(1.0, val));
        }
    }

    function toggleMute() {
        if (sink?.audio) {
            sink.audio.muted = !sink.audio.muted;
        }
    }
}