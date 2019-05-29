import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:gatrabali/repository/feeds.dart';
import 'package:gatrabali/scoped_models/news.dart';
import 'package:gatrabali/models/feed.dart';

import 'package:gatrabali/latest_news.dart';
import 'package:gatrabali/categories_summary.dart';
import 'package:gatrabali/bookmarks.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gatra Bali',
        home: ScopedModel<News>(
          model: new News(),
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
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
          title: widget._appBarTitles[_selectedIndex],
          backgroundColor: Colors.teal,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                    icon: Icon(Icons.account_circle), onPressed: () {}))
          ]),
      body: IndexedStack(
        children: _pages,
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        fixedColor: Colors.teal,
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
