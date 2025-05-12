import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music/config/AppLogger.dart';
import 'package:music/model/Lyric.dart';
import 'package:music/model/Song.dart';
import 'package:music/service/audio_player/dynamic_audio_player.dart';
import 'package:music/service/playlist/playlist.dart';
import 'package:music/service/youtube/impl/yotube_service_impl.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;

class DynamicAudioPlayerImpl extends ChangeNotifier
    implements DynamicAudioPlayer {
  late List<LyricLine> lyricLines = [];
  late String _raw_lyric;
  final AudioPlayer audioPlayer;
  final YotubeServiceImpl youtubeService;
  final DynamicPLaylist playlist;
  late final StreamSubscription _processingStateSub;
  late Duration position =Duration.zero;
  late Duration duration =Duration.zero;
  late List<String> subtiles;

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


    audioPlayer.onDurationChanged.listen((event) {
      if (event != null) {
        duration = event;
        notifyListeners();
      }
    });

    //
    audioPlayer.onPositionChanged.listen((event) {
      position = event;
      notifyListeners();
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
    _processingStateSub = audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
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
      if (audioPlayer.state == PlayerState.playing) {
        await audioPlayer.pause();
        _isPlaying = false;
      } else {
        await audioPlayer.resume();
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
    try{
      logger.d("dang seek duration bai hat toi ${duration.toString()} ");
      await audioPlayer.seek(duration);
      notifyListeners();
    }
    catch(e)
    {

    }
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

  Map<String, List<ClosedCaptionTrackInfo>> _fillerBylangcode(
    List<ClosedCaptionTrackInfo> list,
  ) {
    Map<String, List<ClosedCaptionTrackInfo>> results = {};
    for (var item in list) {
      final lang_code = item.language.code;
      results.putIfAbsent(lang_code, () => []).add(item);
    }
    return results;
  }

  @override
  Future<void> playsong(String audio_link) async {
    try {
      lyricLines = [];

      if (audioPlayer.state == PlayerState.playing) {
        _isPlaying = false;
        await audioPlayer.stop();
      }
      logger.d("đang chuẩn bị phát bài hát");
      String? audio = playlist.gsong().audio_stream;
      if (audio == null) {
        List<Future> futures = [];
        if (playlist.gsong().subtitles == null) {
          futures.add(youtubeService.gSubtitle(playlist.gsong().id));
        }
        logger.d("audio của bài hát đang rỗng");
        futures.add(youtubeService.extractAudio(playlist.gsong().id));
        List<dynamic> process = await Future.wait(futures);
        playlist.gsong().subtitles = process[0];
        playlist.gsong().audio_stream = process[1];
      }
      try {
        final vttSubtitles = playlist.gsong().subtitles;

        Uri? uri;
        if (vttSubtitles != null && vttSubtitles.isNotEmpty) {
          ClosedCaptionTrackInfo? track;

          // try {
          //   track = vttSubtitles.firstWhere((e) => e.language.code == "vi");
          // } catch (_) {
          //   try {
          //     track = vttSubtitles.firstWhere((e) => e.language.code == "en");
          //   } catch (_) {
          //     track = null;
          //   }
          // }
          Map<String, List<ClosedCaptionTrackInfo>> mapByLang =
              _fillerBylangcode(vttSubtitles);
          logger.d(mapByLang);
          ClosedCaptionTrackInfo? sub;

          final viList = mapByLang["vi"];
          if (viList != null && viList.isNotEmpty) {
            logger.d("lay duoc v sub");
            sub = viList.first;
          } else {
            logger.d("khong lay duoc v sub");
            final enList = mapByLang["en"];
            if (enList != null && enList.isNotEmpty) {
              logger.d("lay duoc en sub");
              sub = enList.first;
            }
          }
          uri = sub!.url;
        }

        logger.d("lay duoc uri ");
        logger.d(uri);
        if (uri != null) {
          _raw_lyric = await youtubeService.rawSubtile(uri!);
          lyricLines = parseVtt(_raw_lyric);
          logger.d("parse thanh cong uri");
        }
      } catch (e) {
        logger.e("khong set duoc sub cho audio");
      }
      // await audioPlayer.setSourceUrl(playlist.gsong().audio_stream!);
      logger.d("set thành công audio link : ${audio} cho audioplayer");
      await audioPlayer.play(UrlSource(playlist.gsong().audio_stream!));
      listenDuration();
      logger.d("phát thành công audio link");

      notifyListeners();
    } catch (error, strackTrace) {
      logger.e(
        "không set được url cho audio lý do :${error.toString()}",
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
  Future<void> seekToSong(int index) async {
    playlist.seekto(index);
    playsong("");
    notifyListeners();
  }

  Future<void> _extractSub(List<ClosedCaptionTrackInfo> subs) async {
    if (subs.isEmpty) {
      return;
    }
    ClosedCaptionTrackInfo sub =
        subs
            .where((element) => element.format == ClosedCaptionFormat.vtt)
            .first;
    final res = await http.get(sub.url);
    if (res.statusCode == 200) {}
  }
}
