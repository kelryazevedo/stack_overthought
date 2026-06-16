import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stack_overthought/core/app_router/routes.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    videoPlayerController = VideoPlayerController.asset(
      'assets/videos/splash_screen_animation.mp4',
    );
    videoPlayerController
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() {});
          videoPlayerController
            ..play()
            ..setLooping(false)
            ..addListener(_onVideoFinished);
        })
        .catchError((stackTrace) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading video : $stackTrace')),
          );
          Future.delayed(const Duration(milliseconds: 2000), () {
            if (!mounted) return;

            context.go(Routes.home);
          });
        });
  }

  void _onVideoFinished() {
    if (videoPlayerController.value.position >=
        videoPlayerController.value.duration) {
      if (!mounted) return;
      context.go(Routes.home);
    }
  }

  @override
  void dispose() {
    videoPlayerController.removeListener(_onVideoFinished);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.minPositive,
        height: double.minPositive,
        color: Colors.black,
        child: videoPlayerController.value.isInitialized
            ? Center(
                child: AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
