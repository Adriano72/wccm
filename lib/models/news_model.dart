class NewsModel {
  int id;
  String title;
  String body;
  String imageUrl;   

  NewsModel(this.id, this.title, this.body, this.imageUrl);

  NewsModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    imageUrl = parsedJson['url'];
    title = parsedJson['title'];
  }

}