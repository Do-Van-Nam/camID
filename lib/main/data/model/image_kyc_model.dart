class ImageKycModel {
  String imageFront = "";
  String imageBack = "";
  String imageSelfie = "";

  ImageKycModel();

  factory ImageKycModel.fromJson(Map<String, dynamic> json) {
    final model = ImageKycModel();
    model.imageFront = json['image_front'] ?? "";
    model.imageBack = json['image_back'] ?? "";
    model.imageSelfie = json['image_selfie'] ?? "";
    return model;
  }
}