import 'package:flutter/material.dart';
import '../../models/news_model.dart';
import 'package:wccm/constants.dart';
import 'package:date_format/date_format.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetail extends StatelessWidget {
  final NewsModel news;
  NewsDetail(this.news);

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Padding _createDateBox() {
    var parsedDate = DateTime.parse(news.dateOfCreation);

    Padding dateBox = Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.today,
            size: 20.0,
            color: Colors.white70,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            formatDate(parsedDate, [d, ' ', M, ' ', yyyy]),
            style: TextStyle(
              color: Colors.white70,
              height: 1.2,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );

    return dateBox;
  }

  Padding _createLinkBox() {
    Padding linkBox = Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Center(
        child: Row(
          children: <Widget>[
            GestureDetector(
              child: Text(
                (news.link == null) ? '' : 'More info',
                style: kNewsLinkStyle,
              ),
              onTap: () {
                if (news.link != null) _launchURL('${news.link}');
              },
            ),
          ],
        ),
      ),
    );

    return linkBox;
  }

  @override
  Widget build(BuildContext context) {
    _createLinkBox();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: kBackgroundColor,
          iconTheme: IconThemeData(color: Colors.white70),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Card(
              child: Image.network(news.imageUrl),
              elevation: 5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Text(
                news.title,
                style: kNewsDetailTitleStyle,
              ),
            ),
            _createDateBox(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                news.body,
                style: kNewsDetailTextStyle,
              ),
            ),
            _createLinkBox(),
          ],
        ),
      ),
    );
  }
}
