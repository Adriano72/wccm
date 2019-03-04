class NewsModel {
  int id;
  String title;
  String body;
  String imageUrl;

  NewsModel(this.id, this.title, this.body, this.imageUrl);

  NewsModel.fromJson(Map<String, dynamic> jsonStr) {
    print('JSONSTR $jsonStr');
    List<dynamic> allnews = jsonStr['items'];
    dynamic prof = jsonStr["items"][0];
    print("PROF $prof");
    allnews.forEach((news) {
      (news as Map<String, dynamic>).forEach((key, value) {
        print(key);
        //print(value);
      });
    });
  }

}