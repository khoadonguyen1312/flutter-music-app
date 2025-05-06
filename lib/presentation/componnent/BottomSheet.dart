import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/presentation/componnent/cricleCardAnimation.dart';
import 'package:music/presentation/currentSong.dart';
import 'package:music/presentation/home/homescreen.dart';
import 'package:music/presentation/search/searchscreen.dart';
import 'package:music/presentation/settingscreen.dart';
import 'package:music/service/audio_player/impl/dynamicAudioPlayerImpl.dart';
import 'package:music/service/playlist/playlist.dart';
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
        bottomSheet: !provider.playlist.isEmpty() ? BottomAudioPlayer() : null,
        bottomNavigationBar: _BottomContainer(),
        body: TabBarView(
          children: List.generate(
            _bottomItems.length,
            (index) => _bottomItems[index].screen,
          ),
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
                  icon: Icon(CupertinoIcons.back),
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
                  icon: Icon(CupertinoIcons.forward),
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
