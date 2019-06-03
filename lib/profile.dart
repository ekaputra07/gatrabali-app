import 'package:flutter/material.dart';
import 'package:gatrabali/auth.dart';

class Profile extends StatefulWidget {
  final BaseAuth auth;

  Profile({this.auth});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoggedIn = false;
  TextStyle _style = TextStyle(fontFamily: 'Montserrat');

  @override
  void initState() {
    widget.auth.currentUser().then((user) {
      print(user);
      setState(() {
        _isLoggedIn = true;
      });
    }).catchError((err) {
      print(err);
      setState(() {
        _isLoggedIn = false;
      });
    });
    super.initState();
  }

  void _googleSignin() {
    widget.auth.signIn().then((user) {
      print(user);
      setState(() {
        _isLoggedIn = true;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _signOut() {
    widget.auth.signOut().then((_) {
      setState(() {
        _isLoggedIn = false;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun'),
        elevation: 0,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext ctx) {
    if (_isLoggedIn) {
      final signOutButton = Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.black,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: _signOut,
          child: Text("Sign Out",
              textAlign: TextAlign.center,
              style: _style.copyWith(color: Colors.white, fontSize: 20)),
        ),
      );
      return Center(child: signOutButton);
    }

    final facebookButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff3b5998),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text("Facebook",
            textAlign: TextAlign.center,
            style: _style.copyWith(color: Colors.white, fontSize: 20)),
      ),
    );

    final googleButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xffDB4437),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _googleSignin,
        child: Text("Google",
            textAlign: TextAlign.center,
            style: _style.copyWith(color: Colors.white, fontSize: 20)),
      ),
    );

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Untuk membuat akun / login silahkan gunakan salah satu dari layanan media sosial berikut ini:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(height: 30.0),
          facebookButton,
          SizedBox(height: 15.0),
          SizedBox(
            height: 10.0,
          ),
          googleButton,
          SizedBox(height: 30.0),
          Divider(),
          SizedBox(height: 10.0),
          Text(
            'Aplikasi Gatra Bali hanya menggunakan layanan media sosial anda untuk proses login dan registrasi, Gatra Bali tidak akan memposting apapun di media sosial tanpa sepengetahuan anda.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
