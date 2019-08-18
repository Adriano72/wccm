import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wccm/constants.dart';

class Resources extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          _createResourceCard(
            FontAwesomeIcons.lightbulb,
            'Daily Wisdom',
            'Inspiration for every day',
            kDailyWisdomURL,
          ),
          _createResourceCard(
            FontAwesomeIcons.book,
            'Weekly Readings',
            'For personal formation',
            kWeeklyReadingsURL,
          ),
          _createResourceCard(
            Icons.school,
            'Weekly Teachings',
            'For group formation',
            kWeeklyTeachingsURL,
          ),
          _createResourceCard(
            Icons.new_releases,
            'Monthly News',
            'Updates from the Community',
            kMonthlyNewsURL,
          ),
          _createResourceCard(
            Icons.group,
            'Online Groups',
            'Join an online meditation group',
            kOnlineGroupsURL,
          ),
        ],
      ),
    );
  }
}

_launchURL(String url) async {
  try {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } catch (error) {
    print('No internet!! cause of: $error');
  }
}

Card _createResourceCard(
    IconData cardIcon, String title, String subTitle, String resUrl) {
  Card createResCard = Card(
    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
    color: Colors.white,
    elevation: 2,
    child: GestureDetector(
      onTap: () {
        _launchURL(resUrl);
      },
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(color: Color(0xbb607D8B)),
              child: Padding(
                padding: const EdgeInsets.all(23.0),
                child: Icon(
                  cardIcon,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: kResourceCardTitleStyle,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    subTitle,
                    style: kResourceCartSubTitleStyle,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );

  return createResCard;
}

//http://wccm.org/sites/default/files/mobilefeedspages/2019/WeeklyReadingsArchive.html
//http://wccm.org/sites/default/files/mobilefeedspages/2019/DailyWisdomArchive.html
//http://wccm.org/sites/default/files/mobilefeedspages/2019/WeeklyTeachingsArchive.html
//http://wccm.org/sites/default/files/mobilefeedspages/2019/MonthlyNewsArchive.html
