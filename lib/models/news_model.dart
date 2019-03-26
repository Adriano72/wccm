class NewsModel {
  String id;
  String title;
  String body;
  String imageId;
  String imageUrl;

  NewsModel(this.id, this.title, this.body, this.imageUrl);

  NewsModel.fromJson(
    Map<String, dynamic> jsonStr, Map<String, dynamic> imageURL) {
    id = jsonStr['sys']['id'];
    title = jsonStr['fields']['title'];
    body = jsonStr['fields']['body'];
    imageId = jsonStr['fields']['image']['sys']['id'];
    imageUrl = 'https:${imageURL['fields']['file']['url']}';
    print("IMAGEURL $imageUrl");
  }
}
