import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 600,
      child:  MaterialApp(
          title: 'HDZero Viewer',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.black,
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
        ),
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
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    // Add more video URLs here
  ];

  showLiveStream() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          backgroundColor: Colors.black,
          child: ListView(padding: EdgeInsets.zero, children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: SizedBox(
                height: 30, // Adjust the height as needed
                child: Center(
                  child: Text(
                    'HDZero Viewer',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.computer), // Icon to the left
              title: const Text('Local',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.webhook_sharp),
              title: const Text('Published',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_applications_sharp),
              title: const Text('Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('v1.0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.right,
                ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
              contentPadding: EdgeInsets.only(right: 12.0), // Adjust the padding as needed
              trailing: Icon(Icons.arrow_forward), // Optionally, add a trailing icon
              horizontalTitleGap: 0, // Optionally, reduce the title gap
              dense: true, // Optionally, reduce the height of the ListTile
              visualDensity: VisualDensity(horizontal: 0, vertical: -4), // Optionally, adjust visual density
            )
          ])
        ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.red),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.red),
        ),
        //leading: const Icon(Icons.menu, color: Colors.red)
      ),
      body: ListView.separated(
        padding: MediaQuery.of(context).padding.copyWith(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
            ),
        separatorBuilder: (context, index) => CustomPaint(
          size: const Size(50, 15),
          painter: ZigZagPainter(),
        ),
        itemCount: videoUrls.length,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: false,
        cacheExtent: double.infinity,
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

  VideoListItem({required this.videoUrl})
      : super(key: ValueKey('VideoListItem: $videoUrl'));

  @override
  // ignore: library_private_types_in_public_api
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  late VideoPlayerController _controller;

  Future<dynamic> _init() async {
    return await _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onIconTap() {
    if (kDebugMode) {
      print("tap !");
    }
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init(),
      builder: (context, snapshot) => AnimatedContainer(
        duration: const Duration(seconds: 1),
        child: GestureDetector(
          onTap: _onIconTap,
          behavior: HitTestBehavior.translucent,
          child: AbsorbPointer(
              child: Align(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )),
        ),
      ),
    );
  }
}

class ZigZagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    final double width = size.width;
    //final double height = size.height;

    const double segmentWidth = 20;
    const double segmentHeight = 8;

    for (double x = 0; x < width; x += segmentWidth) {
      if (x % (2 * segmentWidth) == 0) {
        path.moveTo(x, 0);
        path.lineTo(x + segmentWidth, segmentHeight);
      } else {
        path.moveTo(x + segmentWidth, 0);
        path.lineTo(x, segmentHeight);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
