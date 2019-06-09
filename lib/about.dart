import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  static final routeName = '/About';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tentang Gatra Bali'),
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Gatra Bali adalah sebuah layanan yang mengumpulkan berita dari berbagai sumber berita online dan dirangkum sedemikian rupa dalam sebuah aplikasi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Sumber berita Gatra Bali berasal dari RSS feed media-media online berikut ini:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0),
              ),
              Text(
                'balipost.com, metrobali.com',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(),
              SizedBox(height: 10.0),
              Text(
                'Gatra Bali merupakan sebuah proyek Open Source (Sumber Terbuka), apabila anda ingin berkontribusi dalam pengembangannya silahkan cek kodenya di website Github:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.0, color: Colors.grey),
              ),
              GestureDetector(
                  child: Text(
                    'https://github.com/apps4bali/gatrabali-app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.0, color: Colors.blueGrey),
                  ),
                  onTap: () {
                    launch('https://github.com/apps4bali/gatrabali-app',
                        forceSafariVC: false);
                  }),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Apabila anda menemukan bug, permintaan fitur, ingin memberikan saran juga bisa melalui situs tersebut atau langsung email ke ekaputra07@gmail.com.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.0, color: Colors.grey),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Gatra Bali v0.1.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}
