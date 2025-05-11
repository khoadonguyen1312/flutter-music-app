import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Song {
  Song(this.id, this.name, this.audio_stream,this.thumb,[this.subtitles]);
  String id;
  String name;
  String? audio_stream;
  Channel? channel;
  String thumb ;
  List<ClosedCaptionTrackInfo>? subtitles;
}

class Channel {
  Channel(this.id, this.name);
  String id, name;
}
