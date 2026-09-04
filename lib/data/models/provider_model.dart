
class ProviderModel {
    final int? stateId;
    final String? stateName;
    final int? providerId;
    final String? providerName;

    ProviderModel({
        this.stateId,
        this.stateName,
        this.providerId,
        this.providerName,
    });

    factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
        stateId: json["state_id"],
        stateName: json["state_name"],
        providerId: json["provider_id"],
        providerName: json["provider_name"],
    );

    Map<String, dynamic> toJson() => {
        "state_id": stateId,
        "state_name": stateName,
        "provider_id": providerId,
        "provider_name": providerName,
    };
}
