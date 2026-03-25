import 'package:flutter/material.dart';
import '../../models/word.dart';
import 'package:video_player/video_player.dart';

class SignDescriptionScreen extends StatefulWidget {
  final Word word;

  const SignDescriptionScreen({super.key, required this.word});

  @override
  SignDescriptionScreenState createState() => SignDescriptionScreenState();
}

class SignDescriptionScreenState extends State<SignDescriptionScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Use networkUrl instead of deprecated network
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.word.video),
    )
      ..initialize().then((_) {
        setState(() {}); // Rebuild after initialization
        _controller.play(); // Auto-play video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.word.word)),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}








// import 'package:flutter/material.dart';
// import '../../models/word.dart';
// import 'package:video_player/video_player.dart';

// class SignDescriptionScreen extends StatefulWidget {
//   final Word word;

//   const SignDescriptionScreen({super.key, required this.word});

//   @override
//     SignDescriptionScreenState createState() =>   SignDescriptionScreenState();
// }

// class   SignDescriptionScreenState extends State<SignDescriptionScreen> {
//   VideoPlayerController? _controller;
//   int currentVideoIndex = 0;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.word.videos.isNotEmpty) {
//       _controller = VideoPlayerController.networkUrl(
//         Uri.parse(widget.word.videos[0]),
//       )
//         ..initialize().then((_) {
//           setState(() {});
//           _controller!.play();
//         });
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   void playVideo(int index) {
//     _controller?.pause();
//     _controller?.dispose();

//     _controller = VideoPlayerController.networkUrl(
//       Uri.parse(widget.word.videos[index]),
//     )
//       ..initialize().then((_) {
//         setState(() {
//           currentVideoIndex = index;
//         });
//         _controller!.play();
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // If no videos
//     if (widget.word.videos.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(title: Text(widget.word.word)),
//         body: const Center(
//           child: Text("No videos available"),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text(widget.word.word)),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _controller != null && _controller!.value.isInitialized
//                 ? AspectRatio(
//                     aspectRatio: _controller!.value.aspectRatio,
//                     child: VideoPlayer(_controller!),
//                   )
//                 : Container(
//                     height: 200,
//                     color: Colors.black,
//                     child: const Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),

//             const SizedBox(height: 16),

//             SizedBox(
//               height: 80,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: widget.word.videos.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () => playVideo(index),
//                     child: Container(
//                       width: 100,
//                       margin: const EdgeInsets.symmetric(horizontal: 8),
//                       color: currentVideoIndex == index
//                           ? Colors.blue[200]
//                           : Colors.grey[300],
//                       child: Center(
//                         child: Text('Video ${index + 1}'),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }