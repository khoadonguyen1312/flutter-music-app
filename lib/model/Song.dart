class Song {
  Song(this.id, this.name, this.audio_stream,this.thumb,);
  String id;
  String name;
  String? audio_stream;
  Channel? channel;
  String thumb ;

}

class Channel {
  Channel(this.id, this.name);
  String id, name;
}
