import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  final List news;

  ListPage(this.news);

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return ListView.builder(
        itemCount: news.length,
        itemBuilder: (BuildContext content, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("${news[index].imageUrl}"),
            ),
            title: Text(news[index].title),
            subtitle: Text(news[index].body),
          );
        });
  }
}
/*
class NewsListTile extends ListTile {
  NewsListTile(singleNews)
      : super(
    title: Text(singleNews.title),
    subtitle: Text(singleNews.body),
    //leading: CircleAvatar(child: Text(singleNews.name)),
  );
}
*/