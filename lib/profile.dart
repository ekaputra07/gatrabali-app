import 'package:flutter/material.dart';
import 'package:gatrabali/auth.dart';
import 'package:gatrabali/models/user.dart';

class Profile extends StatefulWidget {
  final Auth auth;

  Profile({this.auth});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User _user;
  bool _isLoggedIn = false;
  TextStyle _style = TextStyle(fontFamily: 'Montserrat');

  @override
  void initState() {
    widget.auth.currentUser().then((user) {
      setState(() {
        _user = user;
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

  void _googleSignIn() {
    widget.auth.googleSignIn().then((user) {
      setState(() {
        _user = user;
        _isLoggedIn = true;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _facebookSignIn() {
    widget.auth.facebookSignIn().then((user) {
      setState(() {
        _user = user;
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
        _user = null;
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
      body: _isLoggedIn
          ? _buildProfileScreen(context)
          : _buildLoginScreen(context),
    );
  }

  Widget _buildProfileScreen(BuildContext ctx) {
    final logoutButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.teal,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _signOut,
        child: Text("Logout / Keluar",
            textAlign: TextAlign.center,
            style: _style.copyWith(color: Colors.white, fontSize: 20)),
      ),
    );

    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(_user.avatar),
              radius: 50.0),
          SizedBox(height: 10.0),
          Text(
            _user.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30.0),
          Divider(),
          SizedBox(height: 30.0),
          Text(
            'Terima kasih telah membuat akun di aplikasi Gatra Bali. Dengan membuat akun anda bisa menyimpan/bookmark berita dan otomatis tersingkronisasi dengan perangkat lain apabila anda login dengan akun yang sama.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, color: Colors.blueGrey),
          ),
          SizedBox(height: 30.0),
          logoutButton
        ],
      ),
    );
  }

  Widget _buildLoginScreen(BuildContext ctx) {
    final facebookButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff3b5998),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _facebookSignIn,
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
        onPressed: _googleSignIn,
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
