import 'package:flutter/cupertino.dart';
import 'package:music/model/Song.dart';

class DynamicPLaylist extends ChangeNotifier {
  late List<Song> playlist = [];
  int index = 0;

  void clear() {
    index = 0;
    playlist.clear();
  }

  int get gIndex => index;

  bool isEmpty() {
    return playlist.isEmpty;
  }

  void add(Song song) {
    playlist.add(song);
  }

  int length() {
    return playlist.length;
  }

  List<Song> get gPlayList => playlist;

  void addAll(List<Song> songs) {
    playlist.addAll(songs);
  }

  void next() {
    if (index < playlist.length) {
      index++;
    }
  }

  void seekto(int newindex) {
    index = newindex;
  }

  void back() {
    if (index > 0 && index <= playlist.length) {
      index--;
    }
  }

  void delete(int index) {
    playlist.removeAt(index);
  }

  void shuffle() {
    playlist.shuffle();
  }

  Song gsong() => playlist[index];
}
