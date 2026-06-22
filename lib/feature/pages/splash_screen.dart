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
  bool isVideoInitialized = false;

  @override
  void initState() {
    _initializeVideo();
    super.initState();
  }

  void _initializeVideo() {
    videoPlayerController = VideoPlayerController.asset(
      'assets/videos/splash_screen_animation.mp4',
    );

    videoPlayerController
        .initialize()
        .then((_) async {
          if (!mounted) return;

          setState(() => isVideoInitialized = true);

          await videoPlayerController.setVolume(0);
          await videoPlayerController.play();

          if (!mounted) return;

          await videoPlayerController
              .play()
              .then((_) {
                debugPrint('video executed successfully');
              })
              .catchError((_) {
                debugPrint('Error playing video');
              });

          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;
            debugPrint('handle home page.');
            context.go(Routes.home);
          });
        })
        .catchError((_) {
          debugPrint('Video initialization error.');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: videoPlayerController.value.isInitialized
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
}
