import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wccm/constants.dart';
import 'package:wccm/pages/john_main_talks.dart';

class Resources extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
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
            _createLocalAudioCard(
              FontAwesomeIcons.playCircle,
              'John Main Talks',
              'For personal or group meditation',
              JohnMainTalks(),
              context,
            ),
            _createResourceCard(
              FontAwesomeIcons.podcast,
              'Podcasts',
              'Contemplative Revolution',
              kPodcastsURL,
            ),
            _createResourceCard(
              Icons.school,
              'Online Courses',
              'Courses Designed for You',
              kOnlineCoursesURL,
            ),
            _createResourceCard(
              Icons.group,
              'Online Groups',
              'Join an online meditation group',
              kOnlineGroupsURL,
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
          ],
        ),
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
    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    color: Colors.white,
    elevation: 2,
    child: GestureDetector(
      onTap: () {
        _launchURL(resUrl);
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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

Card _createLocalAudioCard(IconData cardIcon, String title, String subTitle,
    Widget route, BuildContext context) {
  Card createLocalAudioCard = Card(
    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    color: Colors.white,
    elevation: 2,
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => route,
          ),
        );
      },
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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

  return createLocalAudioCard;
}

//http://wccm.org/sites/default/files/mobilefeedspages/2019/WeeklyReadingsArchive.html
//http://wccm.org/sites/default/files/mobilefeedspages/2019/DailyWisdomArchive.html
//http://wccm.org/sites/default/files/mobilefeedspages/2019/WeeklyTeachingsArchive.html
//http://wccm.org/sites/default/files/mobilefeedspages/2019/MonthlyNewsArchive.html
