import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sound_stream/sound_stream.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sttv2/yeniDirectory/Screens/LoginScreen.dart';

class Microphone extends StatefulWidget {
  @override
  _MicrophoneState createState() => _MicrophoneState();
}

class _MicrophoneState extends State<Microphone> {
  final RecorderStream _recorder = RecorderStream();
  final _auth = FirebaseAuth.instance;

  bool recognizing = false;
  bool recognizeFinished = false;
  String text = ' ';
  String text2 = '';
  String text3 = '';
  String denememetni =
      "Güzel dünyamızın bize en güzel armağanlarından biri de ormanlarımız. Yeşilin binbir tonuyla toprakların üzerini örten ormanlar, bir yandan tüm canlı yaşam için gerekli olan oksijeni sağlarken bir yandan da yüzlerce farklı tür canlıya ev sahipliği yapıyor. Maalesef biz insanların elinin değmesiyle yüzbinlerce yıldır varlığını devam ettiren ormanlarımız ise bugün tehlike altında. Dünyanın her yerinde biz insanlar, ormanları hiç düşünmeden kesiyor ya da kirletiyoruz. Geleceğimiz için çok önemli olan ormanlara ve ağaçlara karşı olan bu tutumumuzu değiştirmek ise yine bizim elimizde.";
  var gelenYaziBasligi = "";
  var gelenYaziIcerigi = "";
  var gelenKelimeBasligi = "";
  var gelenKelimeIcerigi1 = "";
  var kontrolKayit = "";
  var list1 = new List();
  var list2 = new List();
  var kontroldb = "";
  int kelime_sayac = 0;

  List<String> kelimelereAyirma;
  StreamSubscription<List<int>> _audioStreamSubscription;
  BehaviorSubject<List<int>> _audioStream;

  void setLastText(text) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("lastText", text);
  }

  @override
  void initState() {
    super.initState();

    _recorder.initialize();
  }

  void streamingRecognize() async {
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream.add(event);
    });
    await _recorder.start();
    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/test_service_account.json'))}');
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        _audioStream);

    responseStream.listen((data) {
      setState(() {
        text =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');
        recognizeFinished = true;
      });
    }, onDone: () {
      setState(() {
        text2 += text;
        text3 += text;
        recognizing = false;
        dialog();
        yaziGetir();
      });
    });
  }

  void stopRecording() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    setState(() {
      recognizing = false;
    });
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'tr-TR');

  yaziEkle() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM').format(now);

    // ignore: deprecated_member_use
    await Firestore.instance
        .collection("YaziZaman")
        .doc(_auth.currentUser.uid)
        .collection("datas")
        .doc(text2)
        .set({
      "time": FieldValue.serverTimestamp(),
      "tarih": formattedDate,
      "sesAd": 'Kayıt',
      "sesKayit": text2,
      "kelimesayisi": kelime_sayac,
    });
    setLastText(text2);
  }

  yaziGetir() {
    FirebaseFirestore.instance
        .collection("YaziZaman")
        .doc(_auth.currentUser.uid)
        .collection("datas")
        .doc(text2)
        .get()
        .then((gelenVeri) {
      setState(() {
        gelenYaziBasligi = gelenVeri.data()['baslik'];
        gelenYaziIcerigi = gelenVeri.data()['icerik'];
      });
    });
  }

  kelimeGetir() {
    FirebaseFirestore.instance
        .collection("Kelimeler")
        .doc("kelimelerdb")
        .get()
        .then((gelenVeri) {
      setState(() {
        gelenKelimeBasligi = gelenVeri.data()['baslik'];
        list2 = gelenVeri.data()['icerik1'];
      });
    });
  }

  List kelimeBol2() {
    String str = text2;
    var strList = str.split(' ');
    print(strList[1]);
    print(strList.length);
    list1 = strList;
    return strList;
  }

  kelimesayac() {
    String str = text2;
    var strList = str.split(' ');
    //var regExp = new RegExp(r"\w+(\'\w+)?");
    //int wordscount = regExp.allMatches(text2).length;
    setState(() {
      kelime_sayac = strList.length;
    });
  }

  dialog() {
    kelimesayac();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Konuşmalarınızı kaydetmek ister misiniz?"),
            actions: <Widget>[
              
              MaterialButton(
                  child: Text("Hayır"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              MaterialButton(
                  child: Text("Evet"),
                  onPressed: () {
                    yaziEkle();
                    Navigator.of(context).pop();
                    
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () async {
            await _auth.signOut();
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.setBool("isLoggedIn", false);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()),
            );
          },
          child: Icon(
            FontAwesomeIcons.signOutAlt,
            color: Colors.red[300],
            size: 35,
          ),
        ),
      ),
      body: Column(
        ///Buradaki Column yapısı dik şekilde widgetları sıralar
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ///Burada kullandığım SizedBoxlar alanı ayarlamamı sağlıyorlar
          ///Expanded ise verdiğim değerlere göre ekranı bölgelere bölüyor
          Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 4,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width / 5),

                ///Logoyu çekiyorum.
                child: Image.asset("images/logo.png"),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 8),
                  child: Text(
                    text,
                    style: TextStyle(

                        ///Yazı sitilini buradan yapabilirsin
                        ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                        onPressed:
                            recognizing ? stopRecording : streamingRecognize,
                        child: recognizing
                            ? Icon(Icons.mic_rounded)
                            : Icon(Icons.mic_off)),
                    //Text(text.length.toString(),
                    //style: TextStyle(color: Colors.white)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
