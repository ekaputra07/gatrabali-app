import 'package:flutter/material.dart';

import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/view/single_news.dart';
import 'package:gatrabali/view/category_news.dart';

class MainCover extends StatefulWidget {
  @override
  _MainCover createState() => _MainCover();
}

class _MainCover extends State<MainCover> {
  Entry _entry;
  String _status = 'loading';

  @override
  void initState() {
    EntryService.fetchKriminalEntries(limit: 1).then((entries) {
      setState(() {
        _entry = entries.first;
        _status = 'loaded';
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
      child = _buildCover(context, _entry);
    }
    return Container(height: 250, width: double.infinity, child: child);
  }

  Widget _buildError() {
    return Center(
        child: Text("Ampura nggih, wenten gangguan :)",
            style: TextStyle(color: Colors.grey)));
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator(strokeWidth: 2));
  }

  void _onTitleTap(BuildContext context, String categoryName, Entry entry) {
    Navigator.of(context).pushNamed(SingleNews.routeName,
        arguments: SingleNewsArgs(categoryName, entry));
  }

  void _onCategoryTap() {
    Navigator.of(context).pushNamed(CategoryNews.routeName,
        arguments: CategoryNewsArgs(11, 'Hukum & Kriminal'));
  }

  Widget _buildCover(BuildContext context, Entry entry) {
    var categories = AppModel.of(context).categories;
    var categoryName = entry.getCategoryName(categories);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(entry.picture), fit: BoxFit.cover)),
        ),
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topLeft,
                  colors: const [Colors.black, Colors.transparent])),
          child: Padding(
              padding:
                  new EdgeInsets.only(top: 0, right: 25, bottom: 10, left: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        _onTitleTap(context, categoryName, entry);
                      },
                      child: Text(entry.title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600))),
                  SizedBox(height: 5),
                  Text("${entry.formattedDate}".toUpperCase(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.6), fontSize: 12)),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: Divider(
                        color: Colors.white.withOpacity(0.5), height: 1.0),
                  ),
                  FlatButton(
                      onPressed: _onCategoryTap,
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_right, color: Colors.yellow),
                          Text(
                            "Hukum & Kriminal".toUpperCase(),
                            style: TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ))
                ],
              )),
          alignment: Alignment.bottomLeft,
        )
      ],
    );
  }
}
