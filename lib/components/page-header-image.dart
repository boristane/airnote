import 'package:airnote/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class PageHeader extends StatelessWidget {
  final String imageUrl;

  PageHeader({Key key, this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => _PageHeaderImage(
        imageProvider: imageProvider,
      ),
      placeholder: (context, url) => _PageHeaderImage(
        imageProvider: AssetImage("assets/images/placeholder.png"),
      ),
      errorWidget: (context, url, error) => _PageHeaderImage(
        imageProvider: AssetImage("assets/images/placeholder.png"),
      ),
    );
  }
}

class _PageHeaderImage extends StatelessWidget {
  final ImageProvider imageProvider;

  _PageHeaderImage({Key key, this.imageProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 299,
          decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
        ),
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AirnoteColors.backgroundColor.withOpacity(0.0),
              AirnoteColors.backgroundColor
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ],
    );
  }
}