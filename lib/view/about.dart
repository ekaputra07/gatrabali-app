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
        "Dapatkan berita bali terkini dengan aplikasi BaliFeed. Download disini http://bit.ly/balifeed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tentang BaliFeed'),
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
                'BaliFeed mengumpulkan berita dari berbagai sumber berita online membuatnya mudah dibaca hanya dengan satu aplikasi.',
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
              Text('Dukung BaliFeed:',
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
                    color: Colors.orange,
                  ),
                  Text('Berikan Rating')
                ]),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      iconSize: 40,
                      onPressed: _share,
                      color: Colors.green,
                    ),
                    Text('Bagikan')
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.feedback),
                      iconSize: 40,
                      onPressed: () async {
                        await launch(
                            'https://docs.google.com/forms/d/e/1FAIpQLSehiyEcmkX_FHpG4tkAtmdP0CrAK0UpdAOf7DJc8_PBdDI3Yw/viewform?usp=sf_link',
                            forceSafariVC: false);
                      },
                      color: Colors.blue,
                    ),
                    Text('Beri Masukan')
                  ],
                )
              ]),
              SizedBox(
                height: 10.0,
              ),
              Divider(),
              SizedBox(height: 10.0),
              Text(
                'BaliFeed merupakan sebuah proyek Open Source (Sumber Terbuka), apabila anda ingin berkontribusi dalam pengembangannya silahkan cek kodenya di:',
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
                'BaliFeed v$APP_VERSION',
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
