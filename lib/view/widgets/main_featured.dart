import 'package:flutter/material.dart';

import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/view/widgets/featured_card.dart';
import 'package:gatrabali/view/category_news.dart';

class MainFeatured extends StatefulWidget {
  @override
  _MainFeatured createState() => _MainFeatured();
}

class _MainFeatured extends State<MainFeatured> {
  double _height = 100.0;
  List<Entry> _entries = [];
  String _status = 'loading';

  @override
  void initState() {
    EntryService.fetchBaliUnitedEntries(limit: 3).then((entries) {
      setState(() {
        _status = 'loaded';
        _entries = entries;
      });
    }).catchError((err) {
      print(err);
      setState(() {
        _status = 'error';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var child = _buildLoading();
    if (_status == 'error') {
      child = _buildError();
    } else if (_status == 'loaded') {
      child = _buildEntries(context, _entries);
    }
    return Container(
        height: _height,
        width: double.infinity,
        child: Container(
            color: Colors.green,
            height: _height,
            width: double.infinity,
            child: child));
  }

  Widget _buildError() {
    return Center(
        child: Text("Ampura nggih, wenten gangguan :)",
            style: TextStyle(color: Colors.white)));
  }

  Widget _buildLoading() {
    return Center(
        child: CircularProgressIndicator(
            strokeWidth: 2, backgroundColor: Colors.white));
  }

  Widget _buildEntries(BuildContext context, List<Entry> entries) {
    final sWidth = MediaQuery.of(context).size.width * 0.8;

    var items = entries.map((e) {
      return Container(
          width: sWidth,
          height: _height,
          child: FeaturedCard(maxLines: 2, key: ValueKey(e.id), entry: e));
    }).toList();

    return Container(
      color: Colors.green,
      height: _height,
      width: double.infinity,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        children: items +
            [
              Container(
                  width: sWidth,
                  height: 100,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(CategoryNews.routeName,
                            arguments: CategoryNewsArgs(12, 'Bali United'));
                      },
                      child: Center(
                          child: Text("Berita Bali United lainnya...",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)))))
            ],
      ),
    );
  }
}
