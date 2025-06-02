import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:marquee/marquee.dart';
import 'package:music/presentation/componnent/cricleCardAnimation.dart';
import 'package:music/presentation/currentSong.dart';
import 'package:music/presentation/home/homescreen.dart';
import 'package:music/presentation/search/searchscreen.dart';
import 'package:music/presentation/settingscreen.dart';
import 'package:music/provider/DesktopTabProvider.dart';
import 'package:music/service/audio_player/impl/dynamicAudioPlayerImpl.dart';
import 'package:music/service/playlist/playlist.dart';
import 'package:music/util/ResponsiveUtil.dart';
import 'package:music/util/duration_format.dart';
import 'package:provider/provider.dart';

class DynamicBottomSheet extends StatefulWidget {
  const DynamicBottomSheet({super.key});

  @override
  State<DynamicBottomSheet> createState() => _DynamicBottomSheetState();
}

class _DynamicBottomSheetState extends State<DynamicBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DynamicAudioPlayerImpl>(context, listen: true);
    return DefaultTabController(
      length: _bottomItems.length,
      child: Scaffold(
        bottomSheet:
            context.isMobile
                ? !provider.playlist.isEmpty()
                    ? BottomAudioPlayer()
                    : null
                : null,

        bottomNavigationBar: context.isMobile ? _BottomContainer() : null,
        body:
            context.isMobile
                ? TabBarView(
                  children: List.generate(
                    _bottomItems.length,
                    (index) => _bottomItems[index].screen,
                  ),
                )
                : Stack(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            child: ListView(
                              children: [
                                for (var i = 0; i < _bottomItems.length; i++)
                                  ListTile(
                                    leading: Icon(_bottomItems[i].iconData),
                                    title: Text(_bottomItems[i].label),
                                    onTap: () {
                                      Provider.of<DesktopTabProvider>(
                                        context,
                                        listen: false,
                                      ).sNewIndex(i);
                                    },
                                    tileColor:
                                        i ==
                                                Provider.of<DesktopTabProvider>(
                                                  context,
                                                ).index
                                            ? Color(0xff00CAFF)
                                            : Colors.transparent,
                                  ),

                                const SizedBox(height: 12),

                                ListTile(title: Text("Feature")),

                                ListTile(
                                  onTap: () {},
                                  title: Text("Created playlist"),

                                  leading: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    width: 42,
                                    height: 42,
                                    child: Icon(Icons.add, color: Colors.black),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {},
                                  title: Text("Liked song"),

                                  leading: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xff0065F8),
                                          Colors.white,
                                        ],
                                      ),
                                    ),
                                    width: 42,
                                    height: 42,
                                    child: Icon(CupertinoIcons.heart_fill),
                                  ),
                                ),
                                ListTile(
                                  title: Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                        Flexible(
                          child: Container(
                            child:
                                _bottomItems[Provider.of<DesktopTabProvider>(
                                      context,
                                    ).index]
                                    .screen,
                          ),
                          flex: 8,
                        ),
                      ],
                    ),

                    if (!provider.playlist.isEmpty())
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(color: Color(0xff121212)),
                          height: 75,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: AspectRatio(
                                    aspectRatio: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CurrentSong(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              provider.playlist.gsong().thumb,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: SizedBox(
                                    height: 20,
                                    child: Marquee(
                                      style: TextStyle(fontSize: 12),
                                      text: provider.playlist.gsong().name,
                                    ),
                                  ),
                                  subtitle: Text("ROSE"),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(CupertinoIcons.heart),
                                  ),
                                  contentPadding: EdgeInsets.all(12),
                                ),
                                flex: 3,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    titleAlignment:
                                        ListTileTitleAlignment.center,
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.shuffle),
                                        ),
                                        const SizedBox(width: 6),
                                        IconButton(
                                          onPressed: () {
                                            provider.back();
                                          },
                                          icon: Icon(Icons.skip_previous),
                                        ),
                                        const SizedBox(width: 6),
                                        IconButton(
                                          onPressed: () {
                                            provider.pause();
                                          },
                                          icon: Icon(Icons.pause_circle),
                                        ),
                                        const SizedBox(width: 6),
                                        IconButton(
                                          onPressed: () {
                                            provider.next();
                                          },
                                          icon: Icon(Icons.skip_next),
                                        ),
                                        const SizedBox(width: 6),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.cast),
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          formatDurationShort(
                                            provider.position,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: SizedBox(
                                            height: 12,
                                            child: SliderTheme(
                                              data: SliderTheme.of(
                                                context,
                                              ).copyWith(
                                                trackHeight: 2,
                                                thumbShape:
                                                    const RoundSliderThumbShape(
                                                      enabledThumbRadius: 0,
                                                    ),
                                                overlayShape:
                                                    SliderComponentShape
                                                        .noOverlay,
                                                activeTrackColor: Colors.white,
                                                inactiveTrackColor:
                                                    Colors.grey.shade700,
                                              ),
                                              child: Slider(
                                                max:
                                                    provider
                                                        .duration
                                                        .inMilliseconds
                                                        .toDouble(),
                                                value:
                                                    provider
                                                        .position
                                                        .inMilliseconds
                                                        .toDouble(),
                                                onChanged: (value) {
                                                  provider.seekTo(
                                                    Duration(
                                                      milliseconds:
                                                          value.toInt(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),
                                        Text("3:20"),
                                      ],
                                    ),
                                  ),
                                ),
                                flex: 4,
                              ),
                              Expanded(child: Container(), flex: 3),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
      ),
    );
  }
}

class BottomAudioPlayer extends StatelessWidget {
  const BottomAudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DynamicAudioPlayerImpl>(context, listen: true);
    return Stack(
      children: [
        Container(
          height: 60,
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return CurrentSong();
                  },
                ),
              );
            },
            leading: Criclecardanimation(
              url: provider.playlist.gsong().thumb,
              height: 42,
              width: 42,
            ),
            title: Text(
              provider.playlist.gsong().name,
              style: TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              children: [
                IconButton(
                  onPressed: () {
                    provider.back();
                  },
                  icon: Icon(Ionicons.play_skip_back),
                ),
                IconButton(
                  onPressed: () {
                    provider.pause();
                  },
                  icon:
                      !provider.isPlaying
                          ? Icon(CupertinoIcons.pause)
                          : Icon(CupertinoIcons.play),
                ),
                IconButton(
                  onPressed: () {
                    provider.next();
                  },
                  icon: Icon(Ionicons.play_skip_forward_sharp),
                ),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          ),
        ),
        Positioned(
          child: SizedBox(
            height: 2,
            child: SliderTheme(
              data: SliderThemeData(
                inactiveTrackColor: Colors.transparent,
                // Màu của track khi không có thumb
                activeTrackColor: Colors.blue,
                // Màu của track khi thumb đang di chuyển
                thumbColor: Colors.transparent,
                // Màu của thumb (dấu chấm kéo slider)
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                // Tạo thumb không hiển thị
                trackHeight: 1, // Chiều cao của track
              ),
              child: Slider(
                value: provider.getPosition.inMilliseconds.toDouble().clamp(
                  0.0,
                  provider.getDuration.inMilliseconds.toDouble(),
                ),
                min: 0.0,
                max: provider.getDuration.inMilliseconds.toDouble(),
                onChanged: (value) {
                  // provider.seekTo(Duration(milliseconds: value.toInt()));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomContainer extends StatelessWidget {
  const _BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: MediaQuery.of(context).size.width,
      child: TabBar(
        tabs: List.generate(
          _bottomItems.length,
          (index) => Tab(
            icon: Icon(_bottomItems[index].iconData),
            text: _bottomItems[index].label,
          ),
        ),
      ),
    );
  }
}

class _BottomItem {
  const _BottomItem({
    required this.iconData,
    required this.label,
    required this.screen,
  });

  final IconData iconData;
  final String label;
  final Widget screen;
}

const List<_BottomItem> _bottomItems = [
  _BottomItem(iconData: Icons.home, label: "Home", screen: HomeScreen()),
  _BottomItem(iconData: Icons.search, label: "Search", screen: SearchScreen()),
  _BottomItem(
    iconData: Icons.settings,
    label: "Setting",
    screen: SettingScreen(),
  ),
];
