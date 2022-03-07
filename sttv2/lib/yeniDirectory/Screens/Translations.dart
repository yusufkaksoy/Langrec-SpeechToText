import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sttv2/yeniDirectory/Screens/Stats.dart';
import 'package:translator/translator.dart';
import 'dart:math';

import 'package:sttv2/constants/style/styles.dart';
import 'package:sttv2/utils/helpers.dart';
import 'package:sttv2/utils/screen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:sttv2/providers/appstate1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fluttertoast/fluttertoast.dart';

class Translation extends StatefulWidget {
  @override
  _TranslationState createState() => _TranslationState();
}

class _TranslationState extends State<Translation>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  TabController _tabbarController;
  var gelenYaziBasligi = " ";
  var gelenYaziIcerigi = " ";
  var gelenYaziBasligi1 = " ";
  var gelenYaziIcerigi1 = " ";

  @override
  void initState() {
    yaziGetirr();

    super.initState();
    _tabbarController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabbarController.addListener(_handleTabIndex);
  }

  void _handleTabIndex() {
    setState(() {});
  }

  yaziGetirr() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection("YaziZaman")
        .doc(_auth.currentUser.uid)
        .collection("datas")
        .doc(sharedPreferences.getString("lastText"))
        .get()
        .then((gelenVeri) {
      setState(() {
        gelenYaziBasligi = gelenVeri.data()['sesAd'];
        gelenYaziIcerigi = gelenVeri.data()['sesKayit'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Screen().init(context);

    var speech = stt.SpeechToText();
    var appState = context.watch<AppState>();
    var _wordList = "abi ne yapıyorsun bugün çorba mı içiyorsun";
    var _wordList2 = gelenYaziIcerigi;
    var _wordList3 = gelenYaziIcerigi1;

    void ceviri() async {
      appState.isListening = appState.isListening ? false : true;
      if (appState.isListening) {
        var available = await speech.initialize(
            onStatus: (val) => print(val), onError: (val) => print(val));

        if (available) {
          print("listening");
          speech.listen(onResult: (val) {
            print(val.recognizedWords);
            _wordList2 += val.recognizedWords;
          });
        } else {
          speech.stop();
        }
      } else {
        if (!Helpers.isNullOrEmpty(_wordList2))
          appState.translator
              .translate(_wordList2, from: 'tr', to: 'en')
              .then((val) {
            appState.translatedText = val.text;
          });
      }
    }

    ceviri();
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.pink[600],
          bottom: TabBar(
            controller: _tabbarController,
            tabs: [
              Tab(
                text: "Türkçe",
              ),
              Tab(text: "İngilizce"),
          
            ],
          ),
        ),
        
        body: TabBarView(
          controller: _tabbarController,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 10, 8, 120),
                child: Wrap(
                  spacing: 5,
                  children: _wordList2
                      .split(' ')
                      .map((e) => GestureDetector(
                            child: Text(
                              e,
                              style: TextStyle(fontSize: Screen.size(20)),
                            ),
                            onTap: () async {
                              sleep(const Duration(seconds: 1));
                              await appState.translator
                                  .translate(e, from: 'tr', to: 'en')
                                  .then((val) {
                                Fluttertoast.showToast(
                                    msg: val.text,
                                    backgroundColor: Colors.deepPurple,
                                    textColor: Colors.white,
                                    fontSize: 20.0);
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                  padding: Styles.defaultPadding,
                  child: !Helpers.isNullOrEmpty(appState.translatedText)
                      ? Text(
                          appState.translatedText,
                          style: TextStyle(fontSize: Screen.size(20)),
                        )
                      : Center(child: CircularProgressIndicator())),
            ),
          ],
        ),
        floatingActionButton: _tabbarController.index == 3
            ? AvatarGlow(
                animate: appState.isListening,
                glowColor: Theme.of(context).primaryColor,
                duration: Duration(milliseconds: 1500),
                repeatPauseDuration: Duration(milliseconds: 100),
                repeat: true,
                endRadius: Screen.height(7),
                child: FloatingActionButton(
                  onPressed: () async {
                    appState.isListening = appState.isListening ? false : true;
                    if (appState.isListening) {
                      var available = await speech.initialize(
                          onStatus: (val) => print(val),
                          onError: (val) => print(val));

                      if (available) {
                        print("listening");
                        speech.listen(onResult: (val) {
                          print(val.recognizedWords);
                          _wordList2 += val.recognizedWords;
                        });
                      } else {
                        speech.stop();
                      }
                    } else {
                      if (!Helpers.isNullOrEmpty(_wordList2))
                        appState.translator
                            .translate(_wordList2, from: 'tr', to: 'en')
                            .then((val) {
                          appState.translatedText = val.text;
                        });
                    }
                  },
                  child: Icon(
                      appState.isListening 
                      ? Icons.translate 
                      : Icons.translate, 
                      color: Colors.white,
                      ),
                ),
              )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
      ),
      builder: (BuildContext context, Widget child) {
        return FlutterEasyLoading(
            child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: child,
        ));
      },
    );
  }
}

