import "package:flutter/material.dart";
import "widgets/news_list.dart";

class Home extends StatelessWidget {

  final List news;

  Home({@required this.news});


  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('WCCM'),
       
      ),
      body: Text("Ciao"),
    );
  }
}