import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  final List fetched_news;

  ListPage({Key key, this.fetched_news}) : super(key: key)

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return ListView.builder(
        itemCount: fetched_news.length,
        itemBuilder: (BuildContext content, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("${fetched_news[index].imageUrl}"),
            ),
            title: Text(fetched_news[index].title),
            subtitle: Text(fetched_news[index].body),
          );
        });
  }
}
