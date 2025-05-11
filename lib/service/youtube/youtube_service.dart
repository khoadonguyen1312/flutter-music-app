import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../model/Song.dart';

abstract class YoutubeService {
  /// Extracts song metadata from a YouTube video ID
  Future<Song> extractById(String id);

  /// Recommends a list of similar songs based on a YouTube video ID
  Future<List<Song>> recommendListForId(String id);

  /// Searches YouTube for songs based on a query
  Future<List<Song>> search(String query);

  /// Extracts the audio stream URL from a YouTube video ID
  Future<String> extractAudio(String id);

  /// Extracts multiple audio stream URLs from a list of YouTube video IDs
  Future<List<String>> extractAudios(List<String> ids);

  Future<List<Song>> getAllFromPlaylist(String id);

}
