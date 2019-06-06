import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:gatrabali/auth.dart';
import 'package:gatrabali/repository/feeds.dart';
import 'package:gatrabali/scoped_models/news.dart';
import 'package:gatrabali/models/feed.dart';

import 'package:gatrabali/profile.dart';
import 'package:gatrabali/latest_news.dart';
import 'package:gatrabali/categories_summary.dart';
import 'package:gatrabali/bookmarks.dart';

import 'package:gatrabali/category_news.dart';
import 'package:gatrabali/single_news.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final News _model = News();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gatra Bali',
        theme: ThemeData(primarySwatch: Colors.teal),
        onGenerateRoute: _generateRoute,
        home: ScopedModel<News>(
          model: _model,
          child: FutureBuilder<List<Feed>>(
            future: FeedService.fetchFeeds(),
            builder: (ctx, result) {
              if (result.hasData) {
                News.of(ctx).setFeeds(result.data);
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
          builder: (context) =>
              SingleNews(title: args.title, entry: args.entry, model: _model));
    }
    // handles /Profile
    if (settings.name == Profile.routeName) {
      var closeAfterLogin = settings.arguments as bool == true;
      return MaterialPageRoute(
          builder: (context) =>
              Profile(auth: Auth(), closeAfterLogin: closeAfterLogin),
          fullscreenDialog: true);
    }
    return null;
  }
}

class GatraBali extends StatefulWidget {
  final _appBarTitles = [
    Text("Berita Terbaru"),
    Text("Berita Kabupaten / Kota"),
    Text("Berita Disimpan")
  ];

  @override
  _GatraBaliState createState() => _GatraBaliState();
}

class _GatraBaliState extends State<GatraBali> {
  int _selectedIndex;
  List<Widget> _pages;

  @override
  void initState() {
    _selectedIndex = 0;
    _pages = [
      LatestNews(),
      CategoriesSummary(),
      Bookmarks(),
    ];

    Auth.onAuthStateChanged((user) {
      News.of(context).setUser(user);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
          title: widget._appBarTitles[_selectedIndex],
          elevation: 0,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                    icon: Icon(Icons.account_circle),
                    onPressed: () {
                      Navigator.of(ctx).pushNamed(Profile.routeName);
                    }))
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
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text("Terbaru")),
          BottomNavigationBarItem(
              icon: Icon(Icons.grain), title: Text("Kabupaten")),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), title: Text("Disimpan")),
        ],
      ),
    );
  }
}
