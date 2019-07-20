import 'package:flutter/material.dart';
import 'package:gatrabali/widgets/balebengong_entries.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/repository/subscriptions.dart';
import 'package:gatrabali/models/subscription.dart';
import 'package:gatrabali/profile.dart';

class BaleBengong extends StatefulWidget {
  @override
  _BaleBengongState createState() => _BaleBengongState();
}

class _BaleBengongState extends State<BaleBengong> {
  String _subscriptionTopic = 'balebengong';
  Subscription _subscription;
  bool _showDescription = true;
  final String _spShowDescriptionKey = 'balebengong.description.show';

  @override
  void initState() {
    _loadSharedPreferences();

    // Listen for auth state changes
    AppModel.of(context).addListener(() {
      if (!mounted) return;
      final model = AppModel.of(context);
      if (model.whatIsChanged == 'currentUser') {
        if (model.currentUser == null) {
          setState(() {
            _subscription = null;
          });
        } else {
          _loadSubscription();
        }
      }
    });

    _loadSubscription();
    super.initState();
  }

  void _loadSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var showDesc = prefs.getBool(_spShowDescriptionKey);
      _showDescription = (showDesc == null || showDesc == true) ? true : false;
    });
  }

  bool _allowSubscription() {
    if (AppModel.of(context).currentUser == null) return false;
    return true;
  }

  void _loadSubscription() {
    if (!_allowSubscription()) return;

    var currentUser = AppModel.of(context).currentUser;
    SubscriptionService.getCategorySubscription(
            currentUser.id, _subscriptionTopic)
        .then((sub) {
      setState(() {
        _subscription = sub;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _subscribe() async {
    if (!_allowSubscription()) {
      var isLogin = await Navigator.of(context)
          .pushNamed(Profile.routeName, arguments: true);
      if (isLogin == true) {
        _loadSubscription();
      }
      return;
    }

    var currentUser = AppModel.of(context).currentUser;
    var delete = _subscription != null;
    setState(() {
      if (delete) {
        _subscription = null;
      } else {
        _subscription = Subscription();
      }
    });

    SubscriptionService.subscribeToCategory(currentUser.id, _subscriptionTopic,
            delete: delete)
        .then((_) {
      if (!delete) {
        Toast.show('Notifikasi diaktifkan', context,
            backgroundColor: Colors.black);
      } else {
        Toast.show('Notifikasi dinonaktifkan', context,
            backgroundColor: Colors.black);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _openLink() async {
    await launch("https://balebengong.id/about/", forceSafariVC: false);
  }

  void _toggleDescription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var showDesc = _showDescription ? false : true;
    await prefs.setBool(_spShowDescriptionKey, showDesc);
    setState(() {
      _showDescription = showDesc;
    });
  }

  @override
  Widget build(BuildContext context) {
    var preferredHeight = 280.0;

    if (!_showDescription) {
      preferredHeight = 108;
    }
    var headerHeight = preferredHeight - 50.0;

    return DefaultTabController(
      length: 9,
      child: new Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(preferredHeight),
          child: new Container(
            child: new SafeArea(
              child: Column(
                children: [
                  Container(
                    height: headerHeight,
                    width: double.infinity,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        _header(),
                        Positioned(
                            right: 0,
                            top: 5,
                            child: IconButton(
                                icon: Icon(
                                    _showDescription
                                        ? Icons.close
                                        : Icons.arrow_drop_down_circle,
                                    color: Colors.green),
                                onPressed: _toggleDescription))
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  new TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(
                          child: Text("Semua",
                              style: TextStyle(color: Colors.black87))),
                      Tab(
                          child: Text("Opini",
                              style: TextStyle(color: Colors.black87))),
                      Tab(
                          child: Text("Sosial",
                              style: TextStyle(color: Colors.black87))),
                      Tab(
                          child: Text("Budaya",
                              style: TextStyle(color: Colors.black87))),
                      Tab(
                          child: Text("Lingkungan",
                              style: TextStyle(color: Colors.black87))),
                      Tab(
                          child: Text("Sosok",
                              style: TextStyle(color: Colors.black87))),
                      Tab(
                          child: Text("Teknologi",
                              style: TextStyle(color: Colors.black87))),
                      Tab(
                          child: Text("Agenda",
                              style: TextStyle(color: Colors.black87))),
                      Tab(
                          child: Text("Travel",
                              style: TextStyle(color: Colors.black87))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            BalebengongEntries(0, "Semua"),
            BalebengongEntries(13, "Opini"),
            BalebengongEntries(18, "Sosial"),
            BalebengongEntries(17, "Budaya"),
            BalebengongEntries(15, "Lingkungan"),
            BalebengongEntries(16, "Sosok"),
            BalebengongEntries(14, "Teknologi"),
            BalebengongEntries(19, "Agenda"),
            BalebengongEntries(20, "Travel"),
          ],
        ),
      ),
    );
  }

  Widget _description() {
    return Column(children: [
      SizedBox(height: 30),
      Image.asset('assets/images/balebengong.png', width: 255),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Text(
              "BaleBengong adalah portal media jurnalisme warga di Bali. Warga terlibat aktif untuk menulis atau sekadar merespon sebuah kabar.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400))),
    ]);
  }

  Widget _header() {
    var notificationText = "Notifikasi ";
    var notificationColor = Colors.grey;
    var notificationIcon = Icons.notifications_none;

    if (_subscription != null) {
      notificationText = "Notifikasi aktif ";
      notificationColor = Colors.green;
      notificationIcon = Icons.notifications_active;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _showDescription ? _description() : Container(),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: _showDescription
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
                  children: [
                    FlatButton(
                        child: Row(children: [
                          Icon(Icons.link, color: Colors.blue),
                          Text(" balebengong.id",
                              style: TextStyle(color: Colors.blue))
                        ]),
                        onPressed: _openLink),
                    Container(
                        color: Colors.grey.withOpacity(0.5),
                        height: 20,
                        width: 1),
                    FlatButton(
                        child: Row(children: [
                          Text(notificationText,
                              style: TextStyle(color: notificationColor)),
                          Icon(notificationIcon, color: notificationColor)
                        ]),
                        onPressed: _subscribe)
                  ],
                )
              ],
            ))
      ],
    );
  }
}
