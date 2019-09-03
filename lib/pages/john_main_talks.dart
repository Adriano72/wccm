import 'package:flutter/material.dart';
import 'package:wccm/constants.dart';

class JohnMainTalks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text(
            'John Main Talks',
            style: TextStyle(color: Colors.white70),
          ),
          backgroundColor: kBackgroundColor,
          iconTheme: IconThemeData(color: Colors.white70),
        ),
      ),
      body: Text('John Main Talks'),
    );
  }
}
