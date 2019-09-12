import 'package:flutter/foundation.dart';
import 'package:wccm/models/audio.dart';

class AudioData extends ChangeNotifier {
  Audio track = Audio();

  Duration get audioDuration {
    return track.duration;
  }

  Duration get audioPosition {
    return track.position;
  }

  String get audioState {
    return track.audioState;
  }

  void setAudioDuration(Duration trackTime) {
    track.setDuration(trackTime);
    notifyListeners();
  }

  void setAudioPosition(Duration trackPosition) {
    track.setPosition(trackPosition);
    notifyListeners();
  }

  void rewindToZero() {
    track.rewindToBeginning();
    notifyListeners();
  }

  void setPlayingState() {
    track.setPlaying();
    notifyListeners();
  }

  void setPausedState() {
    track.setPaused();
    notifyListeners();
  }

  void setStoppedState() {
    track.setStopped();
    notifyListeners();
  }
}
