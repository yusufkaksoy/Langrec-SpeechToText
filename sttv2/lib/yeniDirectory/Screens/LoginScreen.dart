import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  String email, password;

  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  // ignore: deprecated_member_use
  FirebaseUser _user;

  bool isSignIn = false;
  bool google = false;
  bool signInState = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // ignore: non_constant_identifier_names
  Future<String> _GoogleSignIn() async {
    GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication signInAuthentication =
        await signInAccount.authentication;
    // ignore: deprecated_member_use
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken);
    // ignore: deprecated_member_use
    FirebaseUser users = (await _auth.signInWithCredential(credential)).user;
    print(users);

    setState(() {
      signInState = true;
    });
    return users.email.toString();
  }

  void kayitOl(email, password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  void girisYap(email, password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLoggedIn", true);
  }

  //GoogleSignIn _googleSignIn = GoogleSignIn(
   // scopes: [
     // 'email',
     // 'https://www.googleapis.com/auth/contacts.readonly',
   // ],
 // );

  LinearGradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,

      ///buradaki renk sınıfı ise arka plan rengi buradaki renkleri değiştirerek renk akışını değiştirebilirsin
      colors: [
        Color(0xffFFFFFF),
        Color(0xffF9F3F3),
        Color(0xffAECFDF),
        Color(0xff9F9FAD),
      ]);
  bool girisFontSize = true;
  bool kayitFontSize = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: size.height / 5,
                width: size.width / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/logo.png"),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        girisFontSize = true;
                        kayitFontSize = false;
                      });
                    },
                    child: Text(
                      "Giriş Yap    ",
                      style: TextStyle(
                          fontSize: (girisFontSize) ? 30 : 18,
                          color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        girisFontSize = false;
                        kayitFontSize = true;
                        /*try {
                          kayitOl(email, password);
                        } catch (e) {}*/
                      });
                    },
                    child: Text(
                      "    Kayıt Ol",
                      style: TextStyle(
                          fontSize: (kayitFontSize) ? 30 : 18,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              Column(
                ///todo kayıt vs.

                children: [
                  buildPadding(size, "E-Mail", (value) {
                    setState(() {
                      email = value;
                    });
                  }, TextInputType.emailAddress, false),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  buildPadding(size, "Password", (value) {
                    setState(() {
                      password = value;
                    });
                  }, TextInputType.name, true),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  if (girisFontSize) {
                    try {
                      await girisYap(email, password);
                      if (_auth.currentUser != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      }
                    } catch (e) {
                      print("hata");
                    }
                  } else {
                    try {
                      kayitOl(email, password);
                    } catch (e) {
                      ///buraya alert metodu
                      
                    }
                  }
                },
                child: Container(
                  height: 40,
                  width: size.width / 2,
                  decoration: BoxDecoration(
                    color: Colors.pink[300],
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Center(
                      child: Text(
                    (girisFontSize) ? "Giriş" : "Kayıt",
                    style: kDefaultSentenceTextStyle,
                  )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      iconSize: 30,
                      icon: Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                  IconButton(
                      iconSize: 30,
                      icon: Icon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        try {
                          // ignore: unused_local_variable
                          Future<String> users = _GoogleSignIn();

                          if (_auth.currentUser != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          }
                        } catch (e) {
                          print("hata");
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildPadding(Size size, text, onChanged, inputType, isObscure) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 10),
      child: TextField(
        showCursor: true,
        obscureText: isObscure,
        keyboardType: inputType,
        onChanged: onChanged,
        style: TextStyle(color: Colors.black),
        decoration: kTextFieldDecoration.copyWith(
          hintText: text,
        ),
      ),
    );
  }
}

var kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a Value.',
  hintStyle: kDefaultSentenceTextStyle,
  labelStyle: kDefaultSentenceTextStyle,
  focusColor: Colors.black87,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black87, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
TextStyle kDefaultSentenceTextStyle = TextStyle(
  fontFamily: "Raleway",
  fontSize: 15,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.2,
  fontStyle: FontStyle.normal,
  color: Colors.black,
);
