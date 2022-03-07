import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sttv2/utils/locator.dart';
import 'package:sttv2/yeniDirectory/Screens/LoginScreen.dart';
import 'package:sttv2/yeniDirectory/Screens/Microphone.dart';
import 'package:sttv2/yeniDirectory/Screens/Stats.dart';
import 'package:sttv2/yeniDirectory/Screens/Translations.dart';
import 'package:provider/provider.dart';
import 'providers/appstate1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        home: isLoggedIn ? MyHomePage() : LoginScreen(),
         debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> pages = [Microphone(), Translation(), Stats()];

  ///Arka plandaki renk akışını burda tanımlıyoruz.
  LinearGradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,

      ///buradaki renk sınıfı ise arka plan rengi buradaki renkleri değiştirerek renk akışını değiştirebilirsin
      colors: [
        Color(0xffFFFFFF),
        Color(0xffF9F3F3),
        Color(0xffFFFFFF),
        Color(0xff8D57A8),
      ]);
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    ///Bu size değişkeni uygulamanın açıldığı telefonun boyutunu alıyor.
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,

            ///Buradaki renk alt barın rengi
            color: Colors.white.withOpacity(0.85),
            backgroundColor: Colors.transparent,
            items: <Widget>[
              Icon(FontAwesomeIcons.microphone, size: size.width / 15),
              Icon(Icons.translate, size: size.width / 15),
              Icon(FontAwesomeIcons.chartBar, size: size.width / 15),
            ],
            letIndexChange: (index) => true,
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
          ),
          body: Center(
            child: pages[_page],
          ),
        ),
      ),
    );
  }
}
