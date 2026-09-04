class DisputeReasonModel {
  final int? reasonId;
  final String? reason;

  DisputeReasonModel({
    this.reasonId,
    this.reason,
  });

  factory DisputeReasonModel.fromJson(Map<String, dynamic> json) =>
      DisputeReasonModel(
        reasonId: json["reason_id"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "reason_id": reasonId,
        "reason": reason,
      };
}
