import 'package:animations/maker.dart';
import 'package:drawing_animation/drawing_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Draw animation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Path> paths = [];
  AnimationController? controller;
  Animation<Offset>? offset;
  bool isRunning = true;

  animateTextLogo() {
    switch (controller!.status) {
      case AnimationStatus.completed:
        controller!.reverse();
        break;
      case AnimationStatus.dismissed:
        controller!.forward();
        break;
      default:
    }
  }

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset(-2.0, 0.0), end: Offset(0.0, 0.0))
        .animate(controller!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    paths = AnimationMaker().createMetatron();
    Size s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: s.width * 0.8,
              child: AnimatedDrawing.paths(
                paths,
                paints: List<Paint>.generate(
                    paths.length, AnimationMaker().colorize),
                run: isRunning,
                height: 250,
                width: s.width,
                duration: Duration(seconds: 2),
                lineAnimation: LineAnimation.oneByOne,
                animationCurve: Curves.easeInSine,
                onFinish: () => setState(() {
                  isRunning = false;
                  animateTextLogo();
                }),
                //Uncomment this to write each frame to file
                // debug: DebugOptions(
                //   fileName: this.projectName,
                //   showBoundingBox: false,
                //   showViewPort: false,
                //   recordFrames: true,
                //   resolutionFactor: 2.0,
                //   outPutDir: this.storageDir.path,
                // ),
              ),
            ),
            logoText(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          animateTextLogo();
          setState(() {
            isRunning = true;
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget logoText() {
    if (isRunning) {
      return SizedBox(
        height: 100,
      );
    } else {
      return SlideTransition(
        position: offset!,
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset("assets/audi.png"),
        ),
      );
    }
  }
}
