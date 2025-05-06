import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DynamicCachedNetworkImage extends StatelessWidget {
  const DynamicCachedNetworkImage({super.key,required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Image(image: CachedNetworkImageProvider(url));
  }
}
