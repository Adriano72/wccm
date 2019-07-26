import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import '../../models/news_model.dart';
import 'news_detail.dart';
import 'dart:convert';
import 'package:wccm/constants.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<ListPage> {
  final apiURL =
      'https://cdn.contentful.com/spaces/4ptr806dzbcu/environments/master/entries?access_token=2e6a171e4a838eb9d8050a26f653c02c11124f24643eab62ff4d390cc914d9b8&order=-sys.createdAt&include=1';
  List<NewsModel> allTheNews = [];

  void fetchAllNews() async {
    var response = await get(apiURL);

    print('RESPONSE ${json.decode(response.body)}');

    var decodedResponse = json.decode(response.body);

    List itemsNode = decodedResponse['items'];

    List allAssets = decodedResponse['includes']['Asset'];

    itemsNode.forEach((item) {
      print('ASSETS: $item');
      var imageId = item['fields']['image']['sys']['id'];
      Map<String, dynamic> urlNode = allAssets.firstWhere(
          (imgValue) => imgValue['sys']['id'] == imageId,
          orElse: () => null);
      var itemModel = NewsModel.fromJson(item, urlNode);
      setState(() {
        allTheNews.add(itemModel);
        print('ALL THE NEWS $allTheNews');
      });
    });
  }

  @override
  void initState() {
    fetchAllNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Scaffold(
      backgroundColor: Color(0xFFd3d3d3),
      body: ListView.builder(
        itemCount: allTheNews.length,
        itemBuilder: (BuildContext content, int index) {
          return ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundImage: NetworkImage("${allTheNews[index].imageUrl}"),
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
    );
  }
}
