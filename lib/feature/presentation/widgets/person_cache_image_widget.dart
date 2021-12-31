import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonCacheImage extends StatelessWidget {
  final String imageUrl;
  final double? width, height;

  const PersonCacheImage(
      {Key? key, required this.imageUrl, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      imageBuilder: (context, imageProvider) {
        return _imageWidget(imageProvider);
      },
      placeholder: (context, url) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorWidget: (context, url, error) {
        return _imageWidget(const AssetImage('assets/image/noimage.jpg'));
      },
    );
  }

  Widget _imageWidget(ImageProvider imageProvider) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
    );
  }
}
