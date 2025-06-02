import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:music/model/Song.dart';

import 'package:music/service/audio_player/impl/dynamicAudioPlayerImpl.dart';
import 'package:music/service/youtube/impl/yotube_service_impl.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  @override
  Widget build(BuildContext context) {
    final provider =Provider.of<DynamicAudioPlayerImpl>(context,listen: true);
    return Scaffold(


        appBar: AppBar(
            title: Text("Search"),
            actions: [const _SearchButton()]));
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showSearch(context: context, delegate: DynamicSearchDelegate());
      },
      icon: Icon(CupertinoIcons.search),
    );
  }
}

class DynamicSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [Icon(CupertinoIcons.search)];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(CupertinoIcons.arrow_left),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final Future search = YotubeServiceImpl().search(query);
    return FutureBuilder(
      future: search,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.waveDots(
              color: Colors.tealAccent,
              size: 24,
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Có lỗi khi search"));
        } else {
          List<Song> data = snapshot.data;


          return ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  final  provider =Provider.of<DynamicAudioPlayerImpl>(context,listen: false);
                  provider.start(data[index].id, null);
                },
                contentPadding: EdgeInsets.zero,
                title: Text(data[index].name),
                leading: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(data[index].thumb),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text("nothing here"));
  }
}
