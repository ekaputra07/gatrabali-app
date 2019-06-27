import 'package:flutter/material.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:gatrabali/auth.dart';
import 'package:gatrabali/repository/feeds.dart';
import 'package:gatrabali/repository/subscriptions.dart';
import 'package:gatrabali/repository/remote_config.dart';
import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/models/feed.dart';
import 'package:gatrabali/models/user.dart';

import 'package:gatrabali/profile.dart';
import 'package:gatrabali/latest_news.dart';
import 'package:gatrabali/categories_summary.dart';
import 'package:gatrabali/bookmarks.dart';
import 'package:gatrabali/category_news.dart';
import 'package:gatrabali/single_news.dart';
import 'package:gatrabali/about.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final AppModel _model = AppModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gatra Bali',
        theme: ThemeData(primarySwatch: Colors.green),
        onGenerateRoute: _generateRoute,
        home: ScopedModel<AppModel>(
          model: _model,
          child: FutureBuilder<List<Feed>>(
            future: FeedService.fetchFeeds(),
            builder: (ctx, result) {
              if (result.hasData) {
                AppModel.of(ctx).setFeeds(result.data);
              }
              return GatraBali();
            },
          ),
        ));
  }

  // We use this so we can pass _model to the widget.
  Route<dynamic> _generateRoute(settings) {
    // handles /CategoryNews
    if (settings.name == CategoryNews.routeName) {
      final CategoryNewsArgs args = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => CategoryNews(
              categoryId: args.id, categoryName: args.name, model: _model));
    }

    // handles /SingleNews
    if (settings.name == SingleNews.routeName) {
      final SingleNewsArgs args = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => SingleNews(
              title: args.title,
              entry: args.entry,
              model: _model,
              id: args.id));
    }
    // handles /Profile
    if (settings.name == Profile.routeName) {
      var closeAfterLogin = settings.arguments as bool == true;
      return MaterialPageRoute(
          builder: (context) =>
              Profile(auth: Auth(_model), closeAfterLogin: closeAfterLogin),
          fullscreenDialog: true);
    }
    // handles /About
    if (settings.name == About.routeName) {
      return MaterialPageRoute(
          builder: (context) => About(), fullscreenDialog: true);
    }
    return null;
  }
}

class GatraBali extends StatefulWidget {
  final _appBarTitles = [
    Text("Berita Terbaru"),
    Text("Berita Daerah"),
    Text("Berita Disimpan")
  ];

  @override
  _GatraBaliState createState() => _GatraBaliState();
}

class _GatraBaliState extends State<GatraBali> {
  int _selectedIndex;
  List<Widget> _pages;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    _selectedIndex = 0;
    _pages = [
      LatestNews(),
      CategoriesSummary(),
      Bookmarks(),
    ];

    // Get remote config and store it to model
    setupRemoteConfig().then((config) {
      AppModel.of(context).setRemoteConfig(config);
    });

    // Listen for Firebase auth changed
    Auth.onAuthStateChanged((User user) {
      AppModel.of(context).setUser(user);
      if (user != null) {
        _enableMessaging(user);
      }
    });

    super.initState();
  }

  // TODO: Move this code to its own package
  void _enableMessaging(User user) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _handleMessagingData(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _handleMessagingData(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("IosNotificationSettings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) async {
      if (token != null) {
        try {
          await SubscriptionService.updateMessagingToken(user.id, token);
          user.fcmToken = token;
          AppModel.of(context).setUser(user);
        } catch (err) {
          print(err);
        }
      }
    });
  }

  // TODO: Move this code to its own package
  void _handleMessagingData(Map<String, dynamic> message) {
    // final dataType = message["data_type"];
    final entryId = int.parse(message["entry_id"]);
    final entryTitle = message["entry_title"];
    final categoryId = int.parse(message["category_id"]);
    final categoryTitle = message["category_title"];
    final feedId = int.parse(message["feed_id"]);
    final publishedAt = int.parse(message["published_at"]);

    var entry = Entry();
    entry.categoryId = categoryId;
    entry.feedId = feedId;
    entry.publishedAt = publishedAt;
    entry.title = entryTitle;

    Navigator.of(context).pushNamed(SingleNews.routeName,
        arguments: SingleNewsArgs(categoryTitle, entry, id: entryId));
  }

  @override
  Widget build(BuildContext ctx) {
    var user = AppModel.of(ctx).currentUser;
    Widget profileIcon = Icon(Icons.account_circle);
    if (user != null) {
      profileIcon =
          CircleAvatar(backgroundImage: NetworkImage(user.avatar), radius: 12);
    }

    return Scaffold(
        appBar: AppBar(
            title: widget._appBarTitles[_selectedIndex],
            elevation: 0,
            actions: [
              IconButton(
                  icon: profileIcon,
                  onPressed: () {
                    Navigator.of(ctx).pushNamed(Profile.routeName);
                  }),
              Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: IconButton(
                      icon: Icon(Icons.help),
                      onPressed: () {
                        Navigator.of(ctx).pushNamed(About.routeName);
                      })),
            ]),
        body: IndexedStack(
          children: _pages,
          index: _selectedIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
              AppModel.of(ctx).setSelectedTabIndex(index);
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Terbaru")),
            BottomNavigationBarItem(
                icon: Icon(Icons.grain), title: Text("Daerah")),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark), title: Text("Disimpan")),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: _drawerItems(),
          ),
        ));
  }

  List<Widget> _drawerItems() {
    var items = <Widget>[];

    AppModel.of(context).categories.forEach((id, title) {
      items.add(Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 1.0),
          child: ListTile(
            leading: Icon(Icons.folder_open, color: Colors.green),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            title: Text('Berita $title'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(CategoryNews.routeName,
                  arguments: CategoryNewsArgs(id, title));
            },
          )));
    });
    return items;
  }
}
