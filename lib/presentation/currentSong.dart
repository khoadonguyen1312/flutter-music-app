import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:duration/duration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';
import 'package:marquee/marquee.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:music/config/AppLogger.dart';
import 'package:music/service/audio_player/impl/dynamicAudioPlayerImpl.dart';
import 'package:music/util/ColorFromImage.dart';
import 'package:music/util/duration_format.dart';
import 'package:provider/provider.dart';

class CurrentSong extends StatefulWidget {
  const CurrentSong({super.key});

  @override
  State<CurrentSong> createState() => _CurrentSongState();
}

class _CurrentSongState extends State<CurrentSong> {
  late final AnimatedMeshGradientController _controller;
  late final FixedExtentScrollController lyric_controller;
  late int origin_increase = 0;
  late int increase = 1;
  List<Color> gradientColors = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimatedMeshGradientController();
    _controller.start();
    lyric_controller = FixedExtentScrollController();
    _updateColors();
  }

  Future<void> _updateColors() async {
    final provider = Provider.of<DynamicAudioPlayerImpl>(
      context,
      listen: false,
    );
    final colors = await getImagePalette(
      CachedNetworkImageProvider(provider.playlist
          .gsong()
          .thumb),
    );

    if (mounted && colors.isNotEmpty) {
      setState(() {
        gradientColors = colors;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = Provider.of<DynamicAudioPlayerImpl>(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final provider = Provider.of<DynamicAudioPlayerImpl>(context);

    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.back),
        ),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: InkWell(
        onTap: () {},
        child: Container(
          height: mediaQueryData.size.height,
          width: mediaQueryData.size.width,
          child: AnimatedMeshGradient(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          // if (increase < origin_increase) {
                          //   increase += new Random().nextInt(20);
                          // }
                          // if (increase >= origin_increase) {
                          //   increase -= new Random().nextInt(20);
                          // }
                          int bienso = new Random().nextInt(25);
                          logger.d(bienso);
                          increase -= bienso;
                          setState(() {});
                          Future.delayed(Duration(milliseconds: 150), () {
                            increase += bienso;

                            setState(() {});
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.linear,
                          height:
                          (provider.audioPlayer.state == PlayerState.playing
                              ? 420
                              : 320) +
                              increase.toDouble(),
                          width:
                          (provider.audioPlayer.state == PlayerState.playing
                              ? 420
                              : 320) +
                              increase.toDouble(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              fit: BoxFit.cover,

                              image: CachedNetworkImageProvider(
                                provider.playlist
                                    .gsong()
                                    .thumb,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 420,
                        height: 24,
                        child: Marquee(text: provider.playlist
                            .gsong()
                            .name),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 42),
                        child: Row(
                          children: [
                            Text(formatDurationShort(provider.position)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 12,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 0,
                                    ),
                                    overlayShape:
                                    SliderComponentShape.noOverlay,
                                    activeTrackColor: Colors.white,
                                    inactiveTrackColor: Colors.grey.shade700,
                                  ),
                                  child: Slider(
                                    max:
                                    provider.duration.inMilliseconds
                                        .toDouble(),
                                    value:
                                    provider.position.inMilliseconds
                                        .toDouble(),
                                    onChanged: (pos) {
                                      provider.seekTo(
                                        Duration(milliseconds: pos.toInt()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),
                            Text(formatDurationShort(provider.duration)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              setState(() {});
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
                              setState(() {});
                            },
                            icon: Icon(Icons.skip_next),
                          ),
                          const SizedBox(width: 6),
                          IconButton(onPressed: () {}, icon: Icon(Icons.cast)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child:
                      provider.lyricLines.isEmpty
                          ? Column(
                        children: [
                          Row(children: List.generate(3, (index) =>
                              CachedNetworkImage(
                                  imageUrl: "https://i0.wp.com/lordlibidan.com/wp-content/uploads/2019/03/Running-Pikachu-GIF.gif?fit=480%2C342&ssl=1"),),),
                          Text(
                            "Không tìm thấy lyric cho bài hát",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      )
                          : Consumer<DynamicAudioPlayerImpl>(
                        builder: (context, value, child) {
                          int current_index = 0;

                          for (
                          int i = 0;
                          i < value.lyricLines.length - 1;
                          i++
                          ) {
                            if (value.lyricLines[i].start <=
                                value.position) {
                              current_index = i;
                            } else {
                              break;
                            }
                          }
                          lyric_controller.animateToItem(
                            current_index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.linear,
                          );
                          return Container(
                            child: CupertinoPicker(
                              itemExtent: 60,

                              diameterRatio: 1.4,
                              selectionOverlay: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                ),
                              ),
                              magnification: 1.2,
                              squeeze: 0.95,
                              looping: false,
                              onSelectedItemChanged: (value) {},
                              children: List.generate(
                                value.lyricLines.length,
                                    (index) =>
                                    Text(value.lyricLines[index].text),
                              ),
                              scrollController: lyric_controller,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  flex: 5,
                ),
              ],
            ),
            colors: gradientColors.map((e) => e.withOpacity(0.4)).toList(),
            options: AnimatedMeshGradientOptions(),
          ),
        ),
      ),
    );
  }
}
