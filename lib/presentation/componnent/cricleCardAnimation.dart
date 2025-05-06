import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Criclecardanimation extends StatefulWidget {
  const Criclecardanimation({
    super.key,
    required this.url,
    required this.height,
    required this.width,
  });

  final double height, width;
  final String url;

  @override
  State<Criclecardanimation> createState() => _CriclecardanimationState();
}

class _CriclecardanimationState extends State<Criclecardanimation>
    with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  late final Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: Curves.linear,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      filterQuality: FilterQuality.high,
      turns: animation,
      alignment: Alignment.center,
      child: CachedNetworkImage(
        imageUrl: widget.url,
        imageBuilder: (context, imageProvider) => Container(
          height: widget.height,width: widget.width,
          decoration: BoxDecoration(shape: BoxShape.circle,
            image: DecorationImage(

              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
