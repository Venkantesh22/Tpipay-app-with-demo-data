class StateModel {
  final int? stateId;
  final String? stateName;

  StateModel({
    this.stateId,
    this.stateName,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        stateId: json["state_id"],
        stateName: json["state_name"],
      );

  Map<String, dynamic> toJson() => {
        "state_id": stateId,
        "state_name": stateName,
      };
}
