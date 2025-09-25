// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class AssetWidgetBuilder extends StatelessWidget {
  const AssetWidgetBuilder({
    super.key,
    required this.entity,
    required this.isDisplayingDetail,
  });

  final AssetEntity entity;
  final bool isDisplayingDetail;

  Widget _audioAssetWidget(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).dividerColor,
      child: Stack(
        children: <Widget>[
          AnimatedPositionedDirectional(
            duration: kThemeAnimationDuration,
            top: 0.0,
            start: 0.0,
            end: 0.0,
            bottom: isDisplayingDetail ? 20.0 : 0.0,
            child: Center(
              child: Icon(
                Icons.audiotrack,
                size: isDisplayingDetail ? 24.0 : 16.0,
              ),
            ),
          ),
          AnimatedPositionedDirectional(
            duration: kThemeAnimationDuration,
            start: 0.0,
            end: 0.0,
            bottom: isDisplayingDetail ? 0.0 : -20.0,
            height: 20.0,
            child: Text(
              entity.title ?? '',
              style: const TextStyle(height: 1.0, fontSize: 10.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageAssetWidget(BuildContext context) {
    return Image(
      image: AssetEntityImageProvider(entity, isOriginal: false),
      fit: BoxFit.cover,
    );
  }

  Widget _videoAssetWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: _imageAssetWidget(context)),
        ColoredBox(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
          child: Center(
            child: Icon(
              Icons.play_circle,
              color: Colors.white,
              size: isDisplayingDetail ? 24.0 : 16.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (entity.type) {
      case AssetType.audio:
        return _audioAssetWidget(context);
      case AssetType.video:
        return _videoAssetWidget(context);
      case AssetType.image:
      case AssetType.other:
        return _imageAssetWidget(context);
    }
  }
}

class AssetSmallView extends StatelessWidget {
  const AssetSmallView({
    super.key,
    required this.urlStr,
    required this.type,
  });

  final String urlStr;
  final int type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 2:
        return _videoAssetWidget(context);
      case 1:
      default:
        return _imageAssetWidget(context);
    }
  }

  Widget _imageAssetWidget(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: urlStr,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget _videoAssetWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl: urlStr,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        )),
        ColoredBox(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
          child: const Center(
            child: Icon(
              Icons.play_circle,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
