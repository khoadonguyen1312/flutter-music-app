import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/presentation/componnent/cricleCardAnimation.dart';
import 'package:music/service/audio_player/impl/dynamicAudioPlayerImpl.dart';
import 'package:provider/provider.dart';

class CurrentSong extends StatefulWidget {
  const CurrentSong({super.key});

  @override
  State<CurrentSong> createState() => _CurrentSongState();
}

class _CurrentSongState extends State<CurrentSong> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DynamicAudioPlayerImpl>(context, listen: true);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: CachedNetworkImage(
              alignment: Alignment.center,
              imageUrl: provider.playlist.gsong().thumb,
              imageBuilder:
                  (context, imageProvider) => Container(
                    alignment: Alignment.center,
                    height: mediaQueryData.size.width * 0.8,
                    width: mediaQueryData.size.width * 0.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              placeholder:
                  (context, url) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.tealAccent.withOpacity(0.2),
                      ),
                    ),
                    height: mediaQueryData.size.width * 0.8,
                    width: mediaQueryData.size.width * 0.8,
                  ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              ListTile(
                title: Text(
                  provider.playlist.gsong().name,
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(CupertinoIcons.heart),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(CupertinoIcons.loop),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${provider.position.inHours < 1 ? "" : provider.position.inHours.toString() + ":"}${provider.position.inMinutes.remainder(60)} : ${provider.position.inSeconds.remainder(60)}",
                    ),
                    Text(
                      "${provider.duration.inHours < 1 ? "" : provider.duration.inHours.toString() + ":"}${provider.duration.inMinutes.remainder(60)} : ${provider.duration.inSeconds.remainder(60)}",
                    ),
                  ],
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,

                  secondaryActiveTrackColor: Colors.grey.shade300,

                  activeTrackColor: Colors.blueAccent,

                  inactiveTrackColor: Colors.grey.shade400,

                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  thumbColor: Colors.white,

                  overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                  overlayColor: Colors.blueAccent.withOpacity(0.2),

                  tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 2),
                  activeTickMarkColor: Colors.transparent,
                  inactiveTickMarkColor: Colors.transparent,
                ),
                child: Slider(
                  value: provider.getPosition.inMilliseconds.toDouble().clamp(
                    0.0,
                    provider.getDuration.inMilliseconds.toDouble(),
                  ),
                  min: 0.0,
                  max: provider.getDuration.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    provider.seekTo(Duration(milliseconds: value.toInt()));
                  },
                ),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      provider.back();
                    },
                    icon: Icon(CupertinoIcons.back, size: 32),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 3, color: Colors.tealAccent),
                      padding: EdgeInsets.all(24),
                      shape: CircleBorder(),
                    ),
                    onPressed: () {},
                    child: Icon(CupertinoIcons.pause, size: 32),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      provider.next();
                    },
                    icon: Icon(CupertinoIcons.forward, size: 32),
                  ),
                ],
              ),
              const SizedBox(height: 32,)
            ],
          ),
        ],
      ),
    );
  }
}
