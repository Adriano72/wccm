import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'constants.dart';
import 'home.dart';
import 'models/audio_data.dart';

//import 'package:flutter/rendering.dart';
// Import flutter helper library

void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintBaselinesEnabled = true;
  //debugPaintPointersEnabled = true;

  runApp(
    ChangeNotifierProvider<AudioData>(
      builder: (context) => AudioData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: AfterSplash(),
      title: Text(
        'The World Community for Christian Meditation',
        style: kSplashTextStyle,
      ),
      image: Image.asset(
        'assets/images/logo.png',
        height: 130.0,
      ),
      gradientBackground: LinearGradient(
          colors: [Colors.blueGrey, Colors.teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 100.0,
      onClick: () => print("Flutter Egypt"),
      loaderColor: Colors.white70,
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowMaterialGrid: true,
      theme: ThemeData(
        backgroundColor: kBackgroundColor,
        //canvasColor: Colors.transparent,
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        accentColor: Colors.amber,
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: Home(),
    );
  }
}
