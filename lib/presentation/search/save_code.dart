// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:music/config/AppLogger.dart';
//
// import 'package:music/presentation/componnent/cricleCardAnimation.dart';
// import 'package:music/service/audio_player/impl/dynamicAudioPlayerImpl.dart';
// import 'package:music/util/ColorFromImage.dart';
// import 'package:provider/provider.dart';
// import 'package:text_marquee/text_marquee.dart';
//
// int previousIndex = -1;
//
// class CurrentSong extends StatefulWidget {
//   const CurrentSong({super.key});
//
//   @override
//   State<CurrentSong> createState() => _CurrentSongState();
// }
//
// class _CurrentSongState extends State<CurrentSong> {
//   late FixedExtentScrollController controller;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     controller = FixedExtentScrollController();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<DynamicAudioPlayerImpl>(context, listen: true);
//     final MediaQueryData mediaQueryData = MediaQuery.of(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Playing now"),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         surfaceTintColor: Colors.transparent,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             children: [
//               Center(
//                 child: AvatarGlow(
//                   glowRadiusFactor: 0.2,
//                   startDelay: const Duration(milliseconds: 1000),
//                   glowColor: Colors.white54,
//                   glowShape: BoxShape.circle,
//                   curve: Curves.fastOutSlowIn,
//                   child: CachedNetworkImage(
//                     alignment: Alignment.center,
//                     imageUrl: provider.playlist.gsong().thumb,
//                     imageBuilder:
//                         (context, imageProvider) => Container(
//                       alignment: Alignment.center,
//                       height: 230,
//                       width: 230,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                           image: imageProvider,
//                           fit: BoxFit.none,
//                         ),
//                       ),
//                     ),
//                     placeholder:
//                         (context, url) => Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.tealAccent.withOpacity(0.2),
//                         ),
//                       ),
//                       height: 230,
//                       width: 230,
//                     ),
//                     errorWidget: (context, url, error) => Icon(Icons.error),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 42),
//
//               if (provider.lyricLines != null)
//                 Container(
//                   height: 280,
//                   child: Consumer<DynamicAudioPlayerImpl>(
//                     builder: (context, value, child) {
//                       int current_index = 0;
//
//                       for (int i = 0; i < value.lyricLines.length - 1; i++) {
//                         if (value.lyricLines[i].start <= value.position) {
//                           current_index = i;
//                         } else {
//                           break;
//                         }
//                       }
//
//                       if (current_index != previousIndex) {
//                         controller.animateToItem(
//                           current_index,
//                           duration: Duration(milliseconds: 400),
//                           curve: Curves.decelerate,
//                         );
//                       }
//
//                       return CupertinoPicker(
//                         scrollController: controller,
//                         itemExtent: 60,
//
//                         diameterRatio: 1.8,
//                         selectionOverlay: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         magnification: 1.2,
//                         squeeze: 0.95,
//                         looping: false,
//                         onSelectedItemChanged: (time) {},
//                         children:
//                         value.lyricLines.length == 0
//                             ? [
//                           Center(
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 LoadingAnimationWidget.bouncingBall(
//                                   color: Colors.white,
//                                   size: 32,
//                                 ),
//                                 SizedBox(width: 12),
//                                 Text("Không tìm thấy sub"),
//                               ],
//                             ),
//                           ),
//                         ]
//                             : List.generate(
//                           value.lyricLines.length,
//                               (index) => Container(
//                             width:
//                             MediaQuery.of(context).size.width *
//                                 0.8,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 value.lyricLines[index].text,
//                                 style: TextStyle(
//                                   color:
//                                   index == current_index
//                                       ? Colors.white
//                                       : Colors.white.withOpacity(
//                                     0.6,
//                                   ),
//                                   fontSize:
//                                   index == current_index ? 14 : 12,
//                                   fontWeight:
//                                   index == current_index
//                                       ? FontWeight.bold
//                                       : FontWeight.normal,
//                                   letterSpacing: 0.5,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//             ],
//           ),
//
//           const SizedBox(height: 32),
//
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 12),
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.9),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               children: [
//
//                 Slider(
//                   value: provider.getPosition.inMilliseconds.toDouble(),
//
//
//                   min: 0.0,
//                   max: provider.getDuration.inMilliseconds.toDouble(),
//                   thumbColor: Colors.black,
//                   inactiveColor: Colors.black26,
//                   activeColor: Colors.black,
//
//                   onChanged: (value) {
//                     provider.seekTo(Duration(milliseconds: value.toInt()));
//                   },
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       padding: EdgeInsets.all(12),
//                       onPressed: () {},
//                       icon: Icon(Ionicons.menu, size: 32, color: Colors.black),
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           padding: EdgeInsets.all(12),
//                           onPressed: () {},
//                           icon: Icon(
//                             Ionicons.play_skip_back,
//                             size: 32,
//                             color: Colors.black,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {},
//                           icon: Icon(
//                             Ionicons.pause,
//                             size: 32,
//                             color: Colors.black,
//                           ),
//                         ),
//                         IconButton(
//                           padding: EdgeInsets.all(12),
//                           onPressed: () {
//                             provider.next();
//                           },
//                           icon: Icon(
//                             Ionicons.play_skip_forward,
//                             size: 32,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: Icon(Ionicons.heart, color: Colors.redAccent),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 32),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
