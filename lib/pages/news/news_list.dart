import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import '../../models/news_model.dart';
import 'news_detail.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'dart:convert';
import 'dart:async';
import 'package:wccm/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewsListPage extends StatefulWidget {
  final Function goToTimerTab;

  NewsListPage(this.goToTimerTab);

  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<NewsListPage> {
  final apiURL =
      'https://cdn.contentful.com/spaces/4ptr806dzbcu/environments/master/entries?access_token=2e6a171e4a838eb9d8050a26f653c02c11124f24643eab62ff4d390cc914d9b8&order=-sys.createdAt&include=1';
  List<NewsModel> allTheNews = [];
  List<NewsModel> highlights = [];
  bool isConnected = false;

  void _showNoNetworkAlert() {
    showAlert(
      context: context,
      title: "Warning",
      body:
          "It looks like there's no connection available to fetch the News, please check if you have connection or if your phone is set to airplane mode. Until then the news tab will be disabled",
      actions: [
        AlertAction(
          text: "Got it",
          isDestructiveAction: false,
          onPressed: () {
            widget.goToTimerTab();
          },
        ),
      ],
      cancelable: false,
    );
  }

  Future checkConn() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
      setState(() {
        isConnected = true;
      });
      fetchAllNews();
    } else {
      //widget.goToTimerTab();
      print('No internet :( Reason:');
      setState(() {
        isConnected = false;
      });
      _showNoNetworkAlert();
      print(DataConnectionChecker().lastTryResults);
    }
  }

  void fetchAllNews() async {
    print('_______IS CONNECTED: $isConnected');

    var response = await get(apiURL);
//    print('RESPONSE ${json.decode(response.body)}');
    var decodedResponse = json.decode(response.body);
    List itemsNode = decodedResponse['items'];
    List allAssets = decodedResponse['includes']['Asset'];

    itemsNode.forEach((item) {
//      print('ASSETS: $item');
      var imageId = item['fields']['image']['sys']['id'];
      Map<String, dynamic> urlNode = allAssets.firstWhere(
          (imgValue) => imgValue['sys']['id'] == imageId,
          orElse: () => null);
      var itemModel = NewsModel.fromJson(item, urlNode);
      setState(() {
        if (itemModel.inEvidence == true) {
          highlights.add(itemModel);
        }
        allTheNews.add(itemModel);
//        print('ALL THE NEWS $allTheNews');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkConn();
  }

  @override
  Widget build(BuildContext context) {
    if (allTheNews.length == 0) {
      return Scaffold(
        body: Center(
          child: SpinKitFadingGrid(
            color: Colors.blueGrey,
            size: 100.0,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          CarouselSlider(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 2.0,
              items: highlights.map(
                (item) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetail(item),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(children: <Widget>[
                          Image.network(
                            item.imageUrl,
                            fit: BoxFit.contain,
                            width: 1000.0,
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blueGrey,
                                    Colors.white,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              child: Text(
                                item.title,
                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5.0,
                                      color: Colors.black,
                                      offset: Offset(1.0, 1.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              ).toList()),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allTheNews.length,
              itemBuilder: (BuildContext content, int index) {
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                  dense: true,
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage("${allTheNews[index].imageUrl}"),
                  ),
                  title: Text(
                    allTheNews[index].title,
                    style: kListTitle,
                  ),
                  subtitle: Text(
                    allTheNews[index].blurb,
                    overflow: TextOverflow.ellipsis,
                    style: kListBlurb,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetail(allTheNews[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
