class ImageKycModel {
  String? imageFront;
  String? imageBack;
  String? imageSelfie;
  void fromJson(Map<String, dynamic> json) {
    imageFront = json['image_front'] ?? "";
    imageBack = json['image_back'] ?? "";
    imageSelfie = json['image_selfie'] ?? "";
  }
}