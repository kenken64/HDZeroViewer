import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HDZero Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        textTheme: const TextTheme(
            bodyLarge: TextStyle(),
            bodyMedium: TextStyle(),
            titleLarge: TextStyle(color: Colors.red),
            titleMedium: TextStyle(color: Colors.red),
            titleSmall: TextStyle(color: Colors.red),
        ).apply(
            bodyColor: Colors.black, 
            displayColor: Colors.red, 
        ),    
      ),
      home: const MyHomePage(title: 'HDZero Viewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> videoUrls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
    // Add more video URLs here
  ];

  showLiveStream(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, style: TextStyle(color: Colors.red),),
        leading: Icon(Icons.menu, color: Colors.red)
      ),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return VideoListItem(videoUrl: videoUrls[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showLiveStream,
        tooltip: 'show live stream',
        child: const Icon(Icons.camera_enhance_rounded),
      ), 
    );
  }
}

class VideoListItem extends StatefulWidget {
  final String videoUrl;

  VideoListItem({required this.videoUrl}) : super(key: ValueKey('VideoListItem: $videoUrl'));

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _iconVisible = false;

  Future<dynamic> _init() async {
    return await _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl))..setLooping(true);
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onIconTap() {
    if(_controller.value.isPlaying) {
        _controller.pause();
    }else{
        _controller.play();
    }
       
    
    setState(() {
      if(_controller.value.isPlaying) {
          _iconVisible = true;
      }else{
         _iconVisible = false;
      }
    });
  } 

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init(),
      builder: (context, snapshot) => AnimatedContainer(
        duration: const Duration(seconds: 1),
        height: _controller.value.size.height,
        width: _controller.value.size.width,
        child: !_iconVisible?
          GestureDetector(
          onTap: _onIconTap,
          child: Stack(children: [
            Align(child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            Align(
              child: _controller.value.isPlaying ? Icon(Icons.play_circle_fill, 
                size: 90.0,
                color: Colors.red) :SizedBox() 
            ),
          ])
        ): SizedBox(),
      ),
    );
  }
}