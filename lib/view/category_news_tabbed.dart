import 'package:flutter/material.dart';
import 'package:gatrabali/view/widgets/category_entries.dart';
import 'package:gatrabali/scoped_models/app.dart';

class CategoryNewsTabbed extends StatefulWidget {
  @override
  _CategoryNewsTabbedState createState() => _CategoryNewsTabbedState();
}

class _CategoryNewsTabbedState extends State<CategoryNewsTabbed> {
  @override
  Widget build(BuildContext context) {
    var preferredHeight = 50.0;
    List<Tab> tabs = <Tab>[];
    List<Widget> tabViews = <Widget>[];
    AppModel.of(context).categories.forEach((id, name) {
      if (id <= 10) {
        tabs.add(Tab(child: Text(name)));
        tabViews.add(CategoryEntries(id, name));
      }
    });

    return DefaultTabController(
      length: 9,
      child: new Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(preferredHeight),
            child: new Container(
              color: Colors.white,
              child: new SafeArea(
                child: Column(
                  children: [
                    new TabBar(
                        isScrollable: true,
                        tabs: tabs,
                        labelColor: Colors.black),
                    Divider(height: 1)
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(children: tabViews)),
    );
  }
}
