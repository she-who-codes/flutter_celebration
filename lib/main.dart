import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'artboard_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static Map<int, Color> customColor =
  {
    50:Color.fromRGBO(2,86,155, .1),
    100:Color.fromRGBO(2,86,155, .2),
    200:Color.fromRGBO(2,86,155, .3),
    300:Color.fromRGBO(2,86,155, .4),
    400:Color.fromRGBO(2,86,155, .5),
    500:Color.fromRGBO(2,86,155, .6),
    600:Color.fromRGBO(2,86,155, .7),
    700:Color.fromRGBO(2,86,155, .8),
    800:Color.fromRGBO(2,86,155, .9),
    900:Color.fromRGBO(2,86,155, 1),
  };//#02569B == 2,86,155
  MaterialColor myMaterialColor = MaterialColor(0xFF02569B, customColor);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Home',
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

        primarySwatch: myMaterialColor,
      ),
      home: MyHomePage(title: 'Flutter Celebration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ArtboardController _artboardController;

  void initState(){
    _artboardController = ArtboardController();

    super.initState();
  }
  void _didTapScreen() {
    _artboardController.play("Pressed", mix: 0);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title, style: Theme.of(context).textTheme.title
              .merge(TextStyle(color: Colors.white),)),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: RawMaterialButton(
            constraints: BoxConstraints.tight(Size(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height)),
            onPressed: _didTapScreen,
            shape: Border(),
            highlightColor: Colors.white,
            splashColor: Colors.white,
            elevation: 0.0,
            child: FlareActor(
              "assets/Flutter_Twitter_Celebration.flr",
              controller: _artboardController,
              fit: BoxFit.contain,
              artboard: "Artboard",
            ),
          ),
        )
    );
  }
}
