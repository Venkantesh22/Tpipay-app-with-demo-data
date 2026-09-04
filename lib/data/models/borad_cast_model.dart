
class BroadCastModel {
    final String? heading;
    final String? imageUrl;
    final int? imgStatus;
    final String? message;
    final int? statusId;

    BroadCastModel({
        this.heading,
        this.imageUrl,
        this.imgStatus,
        this.message,
        this.statusId,
    });

    factory BroadCastModel.fromJson(Map<String, dynamic> json) => BroadCastModel(
        heading: json["heading"],
        imageUrl: json["image_url"],
        imgStatus: json["img_status"],
        message: json["message"],
        statusId: json["status_id"],
    );

    Map<String, dynamic> toJson() => {
        "heading": heading,
        "image_url": imageUrl,
        "img_status": imgStatus,
        "message": message,
        "status_id": statusId,
    };
}
