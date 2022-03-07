import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sttv2/widget/common_widgets.dart';
import 'dart:ui' as ui;
import 'package:sort/sort.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'dart:convert' show utf8;

final FirebaseAuth auth = FirebaseAuth.instance;

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  List userProfilesList = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var listKelime = new List();

  String userID = "";
  final double _borderRadius = 24;
  var items = [
    PlaceInfo('Dubai Mall Food Court', Color(0xff6DC8F3), Color(0xff73A1F9),
        4.4, 'Dubai · In The Dubai Mall', 'Cosy · Casual · Good for kids'),
    PlaceInfo('Hamriyah Food Court', Color(0xffFFB157), Color(0xffFFA057), 3.7,
        'Sharjah', 'All you can eat · Casual · Groups'),
    PlaceInfo('Gate of Food Court', Color(0xffFF5B95), Color(0xffF8556D), 4.5,
        'Dubai · Near Dubai Aquarium', 'Casual · Groups'),
    PlaceInfo('Express Food Court', Color(0xffD76EF5), Color(0xff8F7AFE), 4.1,
        'Dubai', 'Casual · Good for kids · Delivery'),
    PlaceInfo('BurJuman Food Court', Color(0xff42E695), Color(0xff3BB2B8), 4.2,
        'Dubai · In BurJuman', '...'),
    PlaceInfo('Dubai Mall Food Court', Color(0xff6DC8F3), Color(0xff73A1F9),
        4.4, 'Dubai · In The Dubai Mall', 'Cosy · Casual · Good for kids'),
    PlaceInfo('Hamriyah Food Court', Color(0xffFFB157), Color(0xffFFA057), 3.7,
        'Sharjah', 'All you can eat · Casual · Groups'),
    PlaceInfo('Gate of Food Court', Color(0xffFF5B95), Color(0xffF8556D), 4.5,
        'Dubai · Near Dubai Aquarium', 'Casual · Groups'),
    PlaceInfo('Express Food Court', Color(0xffD76EF5), Color(0xff8F7AFE), 4.1,
        'Dubai', 'Casual · Good for kids · Delivery'),
    PlaceInfo('BurJuman Food Court', Color(0xff42E695), Color(0xff3BB2B8), 4.2,
        'Dubai · In BurJuman', '...'),
    PlaceInfo('Dubai Mall Food Court', Color(0xff6DC8F3), Color(0xff73A1F9),
        4.4, 'Dubai · In The Dubai Mall', 'Cosy · Casual · Good for kids'),
    PlaceInfo('Hamriyah Food Court', Color(0xffFFB157), Color(0xffFFA057), 3.7,
        'Sharjah', 'All you can eat · Casual · Groups'),
    PlaceInfo('Gate of Food Court', Color(0xffFF5B95), Color(0xffF8556D), 4.5,
        'Dubai · Near Dubai Aquarium', 'Casual · Groups'),
    PlaceInfo('Express Food Court', Color(0xffD76EF5), Color(0xff8F7AFE), 4.1,
        'Dubai', 'Casual · Good for kids · Delivery'),
    PlaceInfo('BurJuman Food Court', Color(0xff42E695), Color(0xff3BB2B8), 4.2,
        'Dubai · In BurJuman', '...'),
  ];

  void setLastText(text) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("lastText", text);
  }

  @override
  void initState() {
    super.initState();
  }

  bool historyChecker(List<DateTime> list, DateTime theTime) {
    if (list != null) {
      if (theTime.isBefore(list[1])) {
        if (theTime.isAfter(list[0])) return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  int kacFarkliKelime(String metin) {
    String yeniMetin = metin.replaceAll(RegExp(r'[^\w\s]+'), "");
    List<String> liste = yeniMetin.split(
      " ",
    );
    List farklilar = [];
    liste.forEach((element) {
      String sorgulanan = element.toLowerCase();
      if (!farklilar.contains(sorgulanan)) {
        farklilar.add(sorgulanan);
      }
    });
    return farklilar.length;
  }

  String encokKelime(String metin) {
    //String yeniMetin = metin.replaceAll(RegExp(r'[^\p{L}\s]+'), "",);
    
    String yeniMetin = metin.replaceAll(RegExp(r'[^\w\s]+'), "");
   

    List<String> liste = yeniMetin.split(
      " ",
    );

    var words = liste;
    var count = <String, int>{};

    for (final w in words) {
      count[w] = 1 + (count[w] ?? 0);
    }
    var ordered = count.keys.toList();
    ordered.sort((a, b) => count[b].compareTo(count[a]));
    List enCokKelimeListesi = ordered.take(9).toList();
    listKelime = enCokKelimeListesi;
    return listKelime.take(5).toString();

    //return ordered[0].toString();
  }

  List<DateTime> pickedTrh = [
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().add(new Duration(days: 7))
  ];
  CollectionReference cards = FirebaseFirestore.instance
      .collection('YaziZaman')
      .doc(auth.currentUser.uid)
      .collection("datas");
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      ///Buradaki Column yapısı dik şekilde widgetları sıralar
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ///Burada kullandığım SizedBoxlar alanı ayarlamamı sağlıyorlar
        ///Expanded ise verdiğim değerlere göre ekranı bölgelere bölüyor
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 3,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 5),

                  ///Logoyu çekiyorum.
                  child: Image.asset("images/logo.png"),
                ),
                FlatButton(
                  onPressed: () async {
                    final List<DateTime> picked =
                        await DateRangePicker.showDatePicker(
                            context: context,
                            initialFirstDate: new DateTime.now(),
                            initialLastDate:
                                (new DateTime.now()).add(new Duration(days: 7)),
                            firstDate: new DateTime(2021),
                            lastDate: new DateTime(DateTime.now().year + 2));
                    if (picked != null && picked.length == 2) {
                      print(picked);
                      setState(() {
                        pickedTrh = picked;
                      });

                      print(pickedTrh);
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Icon(
                      FontAwesomeIcons.calendarWeek,
                      color: Colors.red[300],
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: StreamBuilder<QuerySnapshot>(
              stream: cards
                  .orderBy("time", descending: true)
                  .where("time", isLessThanOrEqualTo: pickedTrh[1])
                  .where("time", isGreaterThanOrEqualTo: pickedTrh[0])
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print("hata");

                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("hata");
                  return Container(
                    decoration: BoxDecoration(),
                    child: Center(),
                  );
                }
                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: snapshot.data.docs.map((DocumentSnapshot doc) {
                    return ListTile(
                      onTap: () {
                        //Fluttertoast.showToast(
                        //  msg: doc.data()["sesKayit"],
                        //);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              Size size = MediaQuery.of(context).size;
                              return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: gradient,
                                    ),
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Container(
                                          height: size.height / 1.8,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 70, 10, 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                /* Text(
                                                  "${doc.data()["sesAd"]}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),*/
                                                //for (String s in listKelime)
                                                /*Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Sık Kullanılan Kelimeler:${encokKelime(doc.data()["sesKayit"].toString())} ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),*/
                                                  Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Sık Kullanılan Kelimeler:7 kez korkunç ,  5 kez sabah, 4 kez biliyordum, 4 kez hatice ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${kacFarkliKelime(doc.data()["sesKayit"].toString())} Farklı Kelime",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  height: size.height / 5,
                                                  child: SingleChildScrollView(
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 10),
                                                    child: Text(
                                                      "${doc.data()["sesKayit"]}",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                ),
                                                RaisedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  color: Colors.redAccent,
                                                  child: Text(
                                                    'OK',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            top: -60,
                                            child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 60,
                                                child: Image.asset(
                                                    "images/logo.png"))),
                                      ],
                                    ),
                                  ));
                              ;
                            });
                      },
                      title: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(_borderRadius),
                                gradient: LinearGradient(
                                    colors: [Colors.pink, Colors.blue],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white70,
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              top: 0,
                              child: CustomPaint(
                                size: Size(100, 150),
                                painter: CustomCardShapePainter(_borderRadius,
                                    Colors.black, Colors.blueAccent),
                              ),
                            ),
                            Positioned.fill(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Image.asset(
                                      'assets/icon.png',
                                      height: 64,
                                      width: 64,
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          doc.data()["tarih"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Avenir',
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          doc.data()['sesAd'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                  doc.data()['sesKayit'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                  ),
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          doc.data()['kelimesayisi'].toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Avenir',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        RatingBar(rating: 4),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
        Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }
}

class PlaceInfo {
  final String name;
  final String category;
  final String location;
  final double rating;
  final Color startColor;
  final Color endColor;

  PlaceInfo(this.name, this.startColor, this.endColor, this.rating,
      this.location, this.category);
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

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
