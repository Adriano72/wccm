class NewsModel {
  int id;
  String title;
  String body;
  String imageId;
  String imageUrl;

  NewsModel(this.id, this.title, this.body, this.imageUrl);

  NewsModel.fromJson(Map<String, dynamic> jsonStr) {
    //print('JSONSTR $jsonStr');
    List<dynamic> allnews = jsonStr['items'];
    List allAssets = jsonStr['includes']['Asset'];
    //print('ALLASSETS $allAssets');
    
    allnews.forEach((news) {
      id = news['sys']['id'];
      title = news['fields']['title'];
      body = news['fields']['body'];
      imageId = news['fields']['image']['sys']['id'];
      Map<String, dynamic> urlNode = allAssets.firstWhere((imgValue) => imgValue['sys']['id'] == imageId, orElse: () => null);
      //print('__________URLNODE ${urlNode['fields']['file']['url']}');
      imageUrl = urlNode['fields']['file']['url'];
    });
  }
}