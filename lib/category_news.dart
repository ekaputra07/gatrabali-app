import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/repository/subscriptions.dart';

import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/models/subscription.dart';
import 'package:gatrabali/widgets/single_news_card.dart';
import 'package:gatrabali/widgets/single_news_nocard.dart';
import 'package:gatrabali/profile.dart';

class CategoryNewsArgs {
  int id;
  String name;

  CategoryNewsArgs(this.id, this.name);
}

class CategoryNews extends StatefulWidget {
  static final String routeName = '/CategoryNews';
  final int categoryId;
  final String categoryName;
  final AppModel model;

  CategoryNews({this.categoryId, this.categoryName, this.model});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<Entry> _entries;
  int _cursor;
  StreamSubscription _sub; // entries
  RefreshController _refreshController;

  // notification
  Subscription _subscription;
  StreamSubscription _subNotification;

  @override
  void initState() {
    _refreshEntries();
    _refreshController = RefreshController(initialRefresh: false);
    _loadSubscription();

    super.initState();
  }

  @override
  void dispose() {
    if (_sub != null) {
      _sub.cancel();
    }
    if (_subNotification != null) {
      _subNotification.cancel();
    }
    _refreshController.dispose();
    super.dispose();
  }

  bool _allowSubscription() {
    if (widget.model.currentUser == null) return false;
    return true;
  }

  void _loadSubscription() {
    if (!_allowSubscription()) return;

    _subNotification = SubscriptionService.getCategorySubscription(
            widget.model.currentUser.id, widget.categoryId)
        .asStream()
        .listen((sub) {
      setState(() {
        _subscription = sub;
      });
    });
    _subNotification.onError((err) {
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

    var delete = _subscription != null;
    setState(() {
      if (delete) {
        _subscription = null;
      } else {
        _subscription = Subscription();
      }
    });

    SubscriptionService.subscribeToCategory(
            widget.model.currentUser.id, widget.categoryId,
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

  void _refreshEntries() {
    _sub = EntryService.fetchEntries(categoryId: widget.categoryId)
        .asStream()
        .listen((entries) {
      setState(() {
        if (entries.isNotEmpty) {
          _cursor = entries.last.publishedAt;
          _entries = entries;
        }
        _refreshController.refreshCompleted();
      });
    });
    _sub.onError((err) {
      print(err);
      _refreshController.refreshFailed();
    });
  }

  void _loadMoreEntries() {
    _sub = EntryService.fetchEntries(
            categoryId: widget.categoryId, cursor: _cursor)
        .asStream()
        .listen((entries) {
      setState(() {
        if (entries.isNotEmpty) {
          _cursor = entries.last.publishedAt;
          _entries.addAll(entries);
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      });
    });
    _sub.onError((err) => print(err));
  }

  @override
  Widget build(BuildContext ctx) {
    var notificationIcon = Icons.notifications;
    var notificationIconColor = Colors.white;

    if (_subscription != null) {
      notificationIcon = Icons.notifications_active;
      notificationIconColor = Colors.yellow;
    }

    return ScopedModel<AppModel>(
        model: widget.model,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Berita ${widget.categoryName}'),
              elevation: 0,
              actions: [
                Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                        icon: Icon(notificationIcon),
                        color: notificationIconColor,
                        onPressed: _subscribe))
              ],
            ),
            body: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                _refreshEntries();
              },
              onLoading: () {
                _loadMoreEntries();
              },
              child: _buildList(ctx),
            )));
  }

  Widget _buildList(BuildContext ctx) {
    final cloudinaryFetchUrl = widget.model.getCloudinaryUrl();

    var entries = _entries == null
        ? []
        : _entries
            .map<Entry>((e) => e.setCloudinaryPicture(cloudinaryFetchUrl))
            .toList();
    return ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        children: entries
            .asMap()
            .map(
                (index, entry) => MapEntry(index, _listItem(ctx, index, entry)))
            .values
            .toList());
  }

  Widget _listItem(BuildContext ctx, int index, Entry entry) {
    return Padding(
      padding: new EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: index > 0 // the first 2 items use card
          ? SingleNewsNoCard(
              key: ValueKey(entry.id), entry: entry, showCategoryName: false)
          : SingleNewsCard(
              key: ValueKey(entry.id), entry: entry, showCategoryName: false),
    );
  }
}
