import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:suncloudm/generated/l10n.dart';

class PreviewNetworkWidget extends StatefulWidget {
  const PreviewNetworkWidget(this.strUrl, this.type, {super.key});

  final String strUrl;
  final int type;
  @override
  State<PreviewNetworkWidget> createState() => _PreviewNetworkWidgetState();
}

class _PreviewNetworkWidgetState extends State<PreviewNetworkWidget> {
  bool get _isVideo => widget.type == 2;
  Object? _error;
  VideoPlayerController? _playerController;

  @override
  void initState() {
    super.initState();
    if (_isVideo) {
      _initializeController();
    }
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }

  Future<void> _initializeController() async {
    final String? url = await widget.strUrl;
    if (url == null) {
      _error = StateError('图像地址不正确');
      return;
    }
    final VideoPlayerController controller;
    final Uri uri = Uri.parse(url);
    controller = VideoPlayerController.networkUrl(uri);
    _playerController = controller;
    try {
      await controller.initialize();
      controller
        ..setLooping(true)
        ..play();
    } catch (e) {
      _error = e;
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Widget _buildImage(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: widget.strUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _buildVideo(BuildContext context) {
    final VideoPlayerController? controller = _playerController;
    if (controller == null) {
      return const CircularProgressIndicator();
    }
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      // return Text('$_error', style: const TextStyle(color: Colors.white));
      return Text(S.current.video_play_failed,
          style: const TextStyle(color: Colors.white));
    }
    if (_isVideo) {
      return _buildVideo(context);
    }
    return _buildImage(context);
  }
}
