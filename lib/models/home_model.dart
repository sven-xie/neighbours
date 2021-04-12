class MenuInfo {
  String title;
  String imagePath;
  String url;

  MenuInfo({
    this.title,
    this.imagePath,
    this.url,
  });

  MenuInfo.fromJson(Map data) {
    title = data['title'];
    imagePath = data['imagePath'];
    url = data['url'];
  }
}
