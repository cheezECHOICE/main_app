import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LaunchingSoonPage extends StatefulWidget {
  @override
  _LaunchingSoonPageState createState() => _LaunchingSoonPageState();
}

class _LaunchingSoonPageState extends State<LaunchingSoonPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the video player controller with your video asset or network URL
    _controller = VideoPlayerController.asset('assets/launching_soon.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
        // Start playing the video automatically
        _controller.play();
        // Set the video to loop
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    // Dispose of the video player controller to free up resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('Launching Soon'),
      ),
      backgroundColor: Colors.black, // Set the background color to black
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}