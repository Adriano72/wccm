class NewsModel {
  String id;
  String dateOfCreation;
  String title;
  String blurb;
  String body;
  bool inEvidence;
  String imageId;
  String imageUrl;

  NewsModel(this.id, this.dateOfCreation, this.title, this.blurb, this.body,
      this.inEvidence, this.imageUrl);

  NewsModel.fromJson(
      Map<String, dynamic> jsonStr, Map<String, dynamic> imageURL) {
    id = jsonStr['sys']['id'];
    title = jsonStr['fields']['title'];
    dateOfCreation = jsonStr['fields']['dateOfCreation'];
    blurb = jsonStr['fields']['blurb'];
    body = jsonStr['fields']['body'];
    inEvidence = jsonStr['fields']['inEvidence'];
    imageId = jsonStr['fields']['image']['sys']['id'];
    imageUrl = 'https:${imageURL['fields']['file']['url']}';
    print("IMAGEURL $imageUrl");
  }
}
