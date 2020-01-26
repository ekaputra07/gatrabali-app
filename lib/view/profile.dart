import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:gatrabali/auth.dart';
import 'package:gatrabali/models/user.dart';

class Profile extends StatefulWidget {
  static final routeName = 'Profile';
  final Auth auth;
  final bool closeAfterLogin;

  Profile({this.auth, this.closeAfterLogin = false});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User _user;
  bool _isLoggedIn = false;
  bool _loggingOut = false;
  bool _loading = false;
  String _loginWith = "";
  TextStyle _style = TextStyle(color: Colors.white, fontSize: 20);

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

  // --- LOGIN & LOGOUT METHODS --- //

  // Start Anonymous Signin
  void _anonymousSignIn() async {
    if (_loading) return;

    setState(() {
      _loading = true;
      _loginWith = "anonymous";
    });
    try {
      var user = await widget.auth.anonymousSignIn();
      setState(() {
        _loading = false;
        _loginWith = "";
        _user = user;
        _isLoggedIn = true;
      });
      _toast(context, "Login sebagai Anonim berhasil", Colors.black);
      if (widget.closeAfterLogin) {
        Navigator.of(context).pop(true);
      }
    } catch (err) {
      print(err);
      _toast(context, 'Gagal membuat akun anonim', Colors.red);
    } finally {
      setState(() {
        _loginWith = "";
        _loading = false;
      });
    }
  }

  // Start Google Signin
  void _googleSignIn({bool linkAccount = false}) async {
    if (_loading) return;

    setState(() {
      _loading = true;
      _loginWith = "google";
    });
    try {
      var user = await widget.auth.googleSignIn(linkAccount: linkAccount);
      setState(() {
        _loading = false;
        _loginWith = "";
        _user = user;
        _isLoggedIn = true;
      });
      _toast(context, "Login dengan Google berhasil", Colors.black);
      if (widget.closeAfterLogin) {
        Navigator.of(context).pop(true);
      }
    } catch (err) {
      print(err);
      _toast(context, 'Gagal login dengan Google', Colors.red);
    } finally {
      setState(() {
        _loginWith = "";
        _loading = false;
      });
    }
  }

  // Start Facebook Signin
  void _facebookSignIn({bool linkAccount = false}) async {
    if (_loading) return;

    setState(() {
      _loading = true;
      _loginWith = "facebook";
    });
    try {
      var user = await widget.auth.facebookSignIn(linkAccount: linkAccount);
      setState(() {
        _loading = false;
        _loginWith = "";
        _user = user;
        _isLoggedIn = true;
      });
      _toast(context, "Login dengan Facebook berhasil", Colors.black);
      if (widget.closeAfterLogin) {
        Navigator.of(context).pop(true);
      }
    } catch (err) {
      print(err);
      setState(() {
        _loginWith = "";
        _loading = false;
      });
      _toast(context, 'Gagal login dengan Facebook', Colors.red);
    }
  }

  // Link anon account to Google
  void _googleLinkAccount() async {
    _googleSignIn(linkAccount: true);
  }

  // Link anon account to facebook
  void _facebookLinkAccount() async {
    _facebookSignIn(linkAccount: true);
  }

  // Start Signout
  void _signOut() async {
    if (_loading) return;

    if (_user.isAnonymous) {
      var confirm = await showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: new Text("Konfirmasi"),
              content: new Text(
                  "Anda akan logout dari akun Anonim, semua berita yang anda simpan akan hilang."),
              actions: [
                new FlatButton(
                  child: new Text("BATALKAN"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                new FlatButton(
                  textColor: Colors.red,
                  child: new Text("LOGOUT"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          });

      if (!confirm) {
        return;
      }
    }

    setState(() {
      _loggingOut = true;
    });
    try {
      await widget.auth.signOut();
      setState(() {
        _isLoggedIn = false;
        _loggingOut = false;
        _user = null;
        _toast(context, 'Anda berhasil logout', Colors.black);
      });
    } catch (err) {
      print(err);
      _toast(context, 'Logout gagal', Colors.red);
    } finally {
      setState(() {
        _loggingOut = false;
      });
    }
  }
  // -- END LOGIN & LOGOUT METHODS -- //

  // -- BUTTONS -- //
  Widget _anonymousButton(VoidCallback cb) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.black,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: cb,
        child: Text("Buat Akun Anonim",
            textAlign: TextAlign.center, style: _style),
      ),
    );
  }

  Widget _facebookButton(VoidCallback cb) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff3b5998),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: cb,
        child: Text("Facebook", textAlign: TextAlign.center, style: _style),
      ),
    );
  }

  Widget _googleButton(VoidCallback cb) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xffDB4437),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: cb,
        child: Text("Google", textAlign: TextAlign.center, style: _style),
      ),
    );
  }

  Widget _signOutButton(VoidCallback cb) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.grey,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: cb,
        child: Text("Log out", textAlign: TextAlign.center, style: _style),
      ),
    );
  }
  // -- END BUTTONS --//

  // Display toast
  void _toast(BuildContext ctx, String message, Color color) {
    Toast.show(message, ctx,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: color,
        backgroundRadius: 5.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
              child:
                  _isLoggedIn ? _buildProfileScreen() : _buildLoginScreen())),
    );
  }

  // Profile screeen for loggedin user
  Widget _buildProfileScreen() {
    final logoutLoading = CircularProgressIndicator(strokeWidth: 2);

    return Container(
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
          SizedBox(height: 20.0),
          !_user.isAnonymous
              ? Text(
                  'Terima kasih telah membuat akun di Balikabar. Anda bisa menyimpan, mengaktifkan notifikasi berita serta otomatis tersingkronisasi dengan perangkat lain apabila anda login dengan akun yang sama.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                )
              : _buildAccountLinker(),
          SizedBox(height: 20.0),
          Divider(),
          SizedBox(height: 30.0),
          (_loggingOut ? logoutLoading : _signOutButton(_signOut))
        ],
      ),
    );
  }

  Widget _buildAccountLinker() {
    return Column(
      children: [
        Text("Hubungkan Akun",
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w600)),
        SizedBox(height: 10),
        Text(
          'Akun anda adalah akun anonim, untuk dapat menggunakan fitur Komentar, Komunitas, dll. (akan hadir di versi berikutnya) silahkan hubungkan akun Anonim anda dengan salah satu akun berikut ini:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        SizedBox(height: 25.0),
        _loginButton('google', _googleButton(_googleLinkAccount)),
        SizedBox(height: 15.0),
        _loginButton('facebook', _facebookButton(_facebookLinkAccount)),
        SizedBox(height: 15.0),
      ],
    );
  }

  // Screen for non loggedin user
  Widget _buildLoginScreen() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/icon.png', width: 80, height: 80),
          SizedBox(height: 30.0),
          Text(
            'Untuk dapat menyimpan berita, menerima notifikasi, silahkan buat akun terlebih dahulu:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 30.0),
          _loginButton('anonymous', _anonymousButton(_anonymousSignIn)),
          SizedBox(height: 15.0),
          Text(
            'Akun Anonim adalah akun yang bisa anda buat tanpa perlu data pribadi seperti Nama, Email dan Foto.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.0, color: Colors.grey),
          ),
          SizedBox(height: 30.0),
          Text(
            'Atau dengan akun media sosial berikut ini:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 25.0),
          _loginButton('google', _googleButton(_googleSignIn)),
          SizedBox(height: 25.0),
          _loginButton('facebook', _facebookButton(_facebookSignIn)),
          SizedBox(height: 15.0),
          Text(
            'Login dengan akun Facebook atau Google membuat anda secara otomatis bisa menggunakan fitur Komentar, Komunitas, dll. yang akan hadir di versi Balikabar berikutnya.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.0, color: Colors.grey),
          )
        ],
      ),
    );
  }

  Widget _loginButton(String provider, Widget btn) {
    if (_loading && _loginWith == provider) {
      return CircularProgressIndicator(strokeWidth: 2);
    }
    return btn;
  }
}
