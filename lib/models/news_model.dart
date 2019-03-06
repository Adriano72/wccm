class NewsModel {
  int id;
  String title;
  String body;
  String imageId;
  String imageUrl;

  NewsModel(this.id, this.title, this.body, this.imageUrl);

  NewsModel.fromJson(Map<String, dynamic> jsonStr) {
    print('JSONSTR $jsonStr');
    List<dynamic> allnews = jsonStr['items'];
    List<Map<String, dynamic>> allAssets = jsonStr['includes']['Asset'];
    print('ALLASSETS $allAssets');
    
    allnews.forEach((news) {
      id = 
      title = news['fields']['title'];
      body = news['fields']['body'];
      imageId = news['fields']['image']['sys']['id'];
      imageUrl = allAssets.firstWhere((imgValue) => imgValue['sys']['id'] == imageId, orElse: () => null);
    });
  }

}

/*
(news as Map<String, dynamic>).forEach((key, value) {
        print(key);
        //print(value);
      });
      */