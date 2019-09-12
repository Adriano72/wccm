class Audio {
  String audioState;
  Duration position;
  Duration duration;

  Audio(
      {this.audioState = 'stopped',
      this.position = const Duration(milliseconds: 0),
      this.duration = const Duration(milliseconds: 0)});

  void setDuration(Duration trackTime) {
    duration = trackTime;
  }

  void setPosition(Duration trackPosition) {
    position = trackPosition;
  }

  void rewindToBeginning() {
    position = Duration(milliseconds: 0);
  }

  void setPlaying() {
    audioState = 'playing';
  }

  void setPaused() {
    audioState = 'paused';
  }

  void setStopped() {
    audioState = 'stopped';
  }
}
