import 'package:flutter/material.dart';
import 'package:gatrabali/latest_news.dart';
import 'package:gatrabali/regencies_news.dart';
import 'package:gatrabali/bookmarks.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Gatra Bali', home: GatraBali());
  }
}

class GatraBali extends StatefulWidget {
  final _appBarTitles = [
    Text("Berita Terbaru"),
    Text("Berita Kabupaten"),
    Text("Berita Disimpan")
  ];

  @override
  _GatraBaliState createState() {
    return _GatraBaliState();
  }
}

class _GatraBaliState extends State<GatraBali> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
          title: widget._appBarTitles[_selectedIndex],
          backgroundColor: Colors.teal),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        fixedColor: Colors.teal,
        onTap: _onMenuTapped,
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

  void _onMenuTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return LatestNews();
      case 1:
        return RegenciesNews();
      case 2:
        return Bookmarks();
      default:
        return LatestNews();
    }
  }
}
