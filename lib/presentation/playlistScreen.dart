import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:music/service/audio_player/impl/dynamicAudioPlayerImpl.dart';
import 'package:provider/provider.dart';

class PLayListScreen extends StatefulWidget {
  const PLayListScreen({super.key});

  @override
  State<PLayListScreen> createState() => _PLayListScreenState();
}

class _PLayListScreenState extends State<PLayListScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DynamicAudioPlayerImpl>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: Row(
        children: [
          Text("Danh sách phát"),
          const SizedBox(width: 12,),
          LoadingAnimationWidget.stretchedDots(color: Colors.lightBlueAccent, size: 24)
        ],
      ),),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: provider.playlist.length(),
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              provider.seekToSong(index);
            },
           tileColor:  provider.playlist.gIndex == index
               ? Colors.black45
               : Colors.transparent,
            leading: CachedNetworkImage(
              imageUrl: provider.playlist.gPlayList[index].thumb,
              imageBuilder:
                  (context, imageProvider) => Container(
                    width: 32,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              placeholder: (context, url) => Container(width: 32,),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            title: Text(
              provider.playlist.gPlayList[index].name,
              style: TextStyle(
                fontSize: 14,
                color:
                    provider.playlist.gIndex == index
                        ? Colors.tealAccent
                        : Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
