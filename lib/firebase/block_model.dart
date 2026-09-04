class BlockModel {
  final String? id;
  final String? heading;
  final String? desc;
  final bool? isBlock;
  final bool? timeBlock;

  BlockModel({
    this.id,
    this.heading,
    this.desc,
    this.isBlock,
    this.timeBlock,
  });

  factory BlockModel.fromJson(Map<String, dynamic> json) => BlockModel(
        id: json["id"],
        heading: json["Heading"],
        desc: json["desc"],
        isBlock: json["isBlock"],
        timeBlock: json["timeBlock"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Heading": heading,
        "desc": desc,
        "isBlock": isBlock,
        "timeBlock": timeBlock,
      };
}
