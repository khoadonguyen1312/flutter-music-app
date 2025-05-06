import 'package:flutter/cupertino.dart';

abstract class DynamicAudioPlayer  {
  Future<void> start(String? id, List<String>? ids);

  Future<void> pause();

  Future<void> next();

  Future<void> back();

  Future<void> auto_next();

  Future<void> addnewSongs();

  Future<void> seekTo(Duration duration);
  Future<void> seekToSong(int index);
  Future<void> remove(int index);

  Future<void> playsong(String audio_link);

  Future<void> listenDuration();

  Future<void> dispose();
}


enum Playstate {
  init,
  loading,
  playing,
  pause,
  error
}
