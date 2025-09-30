class SliderModel {
  final String? image;
  final String? link;
  final String? caption;

  SliderModel({
    this.image,
    this.link,
    this.caption,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      image: json['image'],
      link: json['link'],
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'link': link,
      'caption': caption,
    };
  }
}