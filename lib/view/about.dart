import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';

import 'package:gatrabali/config.dart';

class About extends StatelessWidget {
  static final routeName = 'About';

  void _rate() {
    LaunchReview.launch(androidAppId: ANDROID_APP_ID, iOSAppId: IOS_APP_ID);
  }

  void _share() {
    Share.share(
        "Dapatkan berita bali terkini dengan aplikasi Balikabar. Download disini http://bit.ly/balikabar");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tentang Balikabar'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            children: [
              Image.asset('assets/images/icon.png', width: 80, height: 80),
              SizedBox(height: 20),
              Text(
                'Balikabar mengumpulkan berita dari berbagai sumber berita online membuatnya mudah dibaca hanya dengan satu aplikasi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Sumber berita:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0),
              ),
              Text(
                FEED_SOURCES,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Divider(),
              SizedBox(
                height: 10.0,
              ),
              Text('Dukung Balikabar:',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              SizedBox(
                height: 10.0,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Column(children: [
                  IconButton(
                    icon: Icon(Icons.star),
                    iconSize: 40,
                    onPressed: _rate,
                  ),
                  Text('Berikan Rating')
                ]),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      iconSize: 40,
                      onPressed: _share,
                    ),
                    Text('Bagikan')
                  ],
                )
              ]),
              SizedBox(
                height: 10.0,
              ),
              Divider(),
              SizedBox(height: 10.0),
              Text(
                'Balikabar merupakan sebuah proyek Open Source (Sumber Terbuka), apabila anda ingin berkontribusi dalam pengembangannya silahkan cek kodenya di:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.0, color: Colors.grey),
              ),
              GestureDetector(
                  child: Text(
                    'https://github.com/apps4bali/gatrabali-app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.0, color: Colors.green),
                  ),
                  onTap: () async {
                    await launch('https://github.com/apps4bali/gatrabali-app',
                        forceSafariVC: false);
                  }),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Anda menemukan bug/kendala, permintaan fitur dan memberi saran juga bisa melalui situs tersebut atau langsung email ke ekaputra07@gmail.com.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.0, color: Colors.grey),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Balikabar v$APP_VERSION',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )));
  }
}
