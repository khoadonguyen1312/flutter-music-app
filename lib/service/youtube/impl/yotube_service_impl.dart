import 'package:http/http.dart';
import 'package:music/config/AppLogger.dart';

import '../../../model/Song.dart';
import '../youtube_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;

class YotubeServiceImpl extends YoutubeService {
  final YoutubeExplode youtubeExplode = YoutubeExplode();

  @override
  Future<String> extractAudio(String id) async {
    try {
      var manifest = await youtubeExplode.videos.streams.getManifest(
        id,
        ytClients: [YoutubeApiClient.safari, YoutubeApiClient.androidVr],
      );

      var streamInfo = manifest.audioOnly.withHighestBitrate();
      var audio = streamInfo.url;

      return audio.toString();
    } catch (e) {
      print("Error extracting audio for $id: ${e.toString()}");
      throw Exception("Error extracting audio: ${e.toString()}");
    }
  }

  @override
  Future<List<String>> extractAudios(List<String> ids) async {
    try {
      List<Future<String>> futures = ids.map((id) => extractAudio(id)).toList();
      List<String> items = await Future.wait(futures);

      return items;
    } catch (e) {
      print("Error extracting audios: ${e.toString()}");
      throw Exception("Error extracting audios: ${e.toString()}");
    }
  }

  @override
  Future<Song> extractById(String id) async {
    try {
      Video video = await youtubeExplode.videos.get(id);
      if (video != null) {
        Song song = Song(
          video.id.toString(),
          video.title,
          null,
          video.thumbnails.highResUrl,
        );

        logger.d(
          "lấy thông tin thành công cho bài hát có tên : ${video.title} ",
        );
        return song;
      } else {
        throw Exception(video.toString());
      }
    } catch (e, straceTrace) {
      logger.e(
        "lỗi khi extract thông tin cho bài hát ",
        error: e,
        stackTrace: straceTrace,
      );
      throw Exception("");
    }
  }

  @override
  Future<List<Song>> recommendListForId(String id) async {
    try {
      print("đang lấy recomand list cho video co id" + id);
      var video = await youtubeExplode.videos.get(id);
      RelatedVideosList? videos = await youtubeExplode.videos.getRelatedVideos(
        video,
      );
      List<Song> results = [];
      if (videos != null) {
        for (var video in videos) {
          results.add(
            Song(
              video.id.toString(),
              video.title,
              null,
              video.thumbnails.highResUrl,
            ),
          );
        }
      }

      return results;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<Song>> getAllFromPlaylist(String id) async {
    try {
      var playlist = await youtubeExplode.playlists.getVideos(id);

      List<Song> results = [];
      await for (var item in playlist) {
        results.add(
          Song(
            item.id.toString(),
            item.title,
            null,
            item.thumbnails.highResUrl,
          ),
        );
      }

      return results;
    } catch (e) {
      throw "";
    }
  }

  @override
  Future<List<Song>> search(String query) async {
    try {
      var search = await youtubeExplode.search.search(query);
      List<Song> results = [];
      for (var item in search) {
        results.add(
          Song(
            item.id.toString(),
            item.title,
            null,
            item.thumbnails.highResUrl,
          ),
        );
      }
      return results;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<ClosedCaptionTrackInfo?>?> gSubtitle(String id) async {
    try {
      var manifest = await youtubeExplode.videos.closedCaptions.getManifest(id);

      if (manifest.tracks.isEmpty) {
        print('Không có phụ đề nào cho video với id: $id.');
        return null;
      } else {
        print('Danh sách phụ đề có sẵn:');

        Map<ClosedCaptionFormat, List<ClosedCaptionTrackInfo>> formatFiller =
        {};
        for (var i in manifest.tracks) {
          final format = i.format;
          formatFiller.putIfAbsent(format, () => []).add(i);
        }
        if (formatFiller.containsKey(ClosedCaptionFormat.vtt)) {
          return formatFiller[ClosedCaptionFormat.vtt];
        } else {
          return null;
        }
      }
    } catch (e) {
      // Xử lý lỗi và ném ngoại lệ nếu có lỗi xảy ra
      logger.e('Lỗi khi lấy phụ đề cho video với id: $id', error: e);
      throw Exception('Không thể lấy phụ đề cho video với id: $id');
    }
  }

  Future<String> rawSubtile(Uri uri) async {
    try {
      Response response = await http.get(uri);
      return response.body;
    } catch (e) {
      logger.e("co loi khi lay raw sub cho video co id ", error: e);
      throw Exception("co loi khi lay raw sub cho video co id");
    }
  }
  // Future<void> getRecomandIn
}

void main() async {
  await YotubeServiceImpl().gSubtitle("1JinnB5Ydtc");
}
