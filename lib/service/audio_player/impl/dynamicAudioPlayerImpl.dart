import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/config/AppLogger.dart';
import 'package:music/model/Song.dart';
import 'package:music/service/audio_player/dynamic_audio_player.dart';
import 'package:music/service/playlist/playlist.dart';
import 'package:music/service/youtube/impl/yotube_service_impl.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DynamicAudioPlayerImpl extends ChangeNotifier
    implements DynamicAudioPlayer {
  final AudioPlayer audioPlayer;
  final YotubeServiceImpl youtubeService;
  final DynamicPLaylist playlist;
  late final StreamSubscription _processingStateSub;
  late Duration position;
  late Duration duration;

  DynamicAudioPlayerImpl({
    AudioPlayer? audioPlayer,
    YotubeServiceImpl? youtubeService,
    DynamicPLaylist? playlist,
  }) : audioPlayer = audioPlayer ?? AudioPlayer(),
       youtubeService = youtubeService ?? YotubeServiceImpl(),
       playlist = playlist ?? DynamicPLaylist() {
    auto_next();
    listenDuration();
  }

  @override
  Future<void> listenDuration() async {
    duration =
        audioPlayer.duration ??
        Duration.zero; // Khởi tạo giá trị mặc định cho duration
    position = audioPlayer.position; // Khởi tạo giá trị mặc định cho position

    // Lắng nghe sự thay đổi của duration
    audioPlayer.durationStream.listen((event) {
      if (event != null) {
        duration = event;
        notifyListeners(); // Thông báo UI khi duration thay đổi
      }
    });

    // Lắng nghe sự thay đổi của position
    audioPlayer.positionStream.listen((event) {
      position = event;
      notifyListeners(); // Thông báo UI khi position thay đổi
    });
  }

  Duration get getPosition => position;

  Duration get getDuration => duration;

  @override
  Future<void> addnewSongs() {
    // TODO: implement addnewSongs
    throw UnimplementedError();
  }

  @override
  Future<void> auto_next() async {
    _processingStateSub = audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        next();
        notifyListeners();
      }
    });
  }

  @override
  Future<void> back() async {
    playlist.back();
    playsong("");
    notifyListeners();
  }

  @override
  Future<void> next() async {
    playlist.next();
    playsong("");
    notifyListeners();
  }

  bool _isPlaying = false;

  @override
  Future<void> pause() async {
    try {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
        _isPlaying = false;
      } else {
        await audioPlayer.play();
        _isPlaying = true;
      }
    } catch (error, st) {
      logger.e('Error toggling playback', error: error, stackTrace: st);
    }
    notifyListeners();
  }

  bool get isPlaying => _isPlaying;

  @override
  Future<void> remove(int index) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  Future<void> seekTo(Duration duration) async {
    await audioPlayer.seek(duration);
    notifyListeners();
  }

  @override
  Future<void> start(String? id, List<String>? ids) async {
    try {
      playlist.clear();
      logger.d("dọn playlist của bài hát");
      logger.d("start bài hát có id ${id}");
      Song firstSong = await youtubeService.extractById(id!);
      logger.d("lấy thành công thông tin cho bài hát");
      playlist.add(firstSong);
      playsong("");
      _isPlaying = true;
      logger.d("thêm bài hát mới");
      playlist.addAll((await youtubeService.recommendListForId(firstSong.id)));
      notifyListeners();
    } catch (error, stackTrace) {
      logger.e(
        "lỗi khi start bài hát có id ${id}",
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> playsong(String audio_link) async {
    try {
      if (audioPlayer.playing) {
        _isPlaying = false;
        await audioPlayer.stop();
      }
      logger.d("đang chuẩn bị phát bài hát");
      String? audio = playlist.gsong().audio_stream;
      if (audio == null) {
        logger.d("audio của bài hát đang rỗng");
        playlist.gsong().audio_stream = await youtubeService.extractAudio(
          playlist.gsong().id,
        );
      }
      await audioPlayer.setUrl(playlist.gsong().audio_stream!);
      logger.d("set thành công audio link : ${audio} cho audioplayer");
      await audioPlayer.play();
      logger.d("phát thành công audio link");

      notifyListeners();
    } catch (error, strackTrace) {
      logger.e(
        "không set được url cho audio lý do :",
        error: error,
        stackTrace: strackTrace,
      );
    }
  }

  @override
  Future<void> dispose() async {
    final audioPlayer = this.audioPlayer;
    if (audioPlayer != null) {
      audioPlayer.dispose();
    }
  }

  @override
  Future<void> seekToSong(int index) async{
    playlist.seekto(index);
    playsong("");
    notifyListeners();
  }
}
