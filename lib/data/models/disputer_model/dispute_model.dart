import 'package:lekra/services/constants.dart';

class DisputeModel {
  final int? ticketId;
  final String? user;
  final DateTime? date;
  final String? provider;
  final String? number;
  final String? reason;
  final String? message;
  final String? status;

  DisputeModel({
    this.ticketId,
    this.user,
    this.date,
    this.provider,
    this.number,
    this.reason,
    this.message,
    this.status,
  });

  factory DisputeModel.fromJson(Map<String, dynamic> json) => DisputeModel(
        ticketId: json["ticket_id"],
        user: capitalize(json["user"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        provider: json["provider"],
        number: json["number"],
        reason: json["reason"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "ticket_id": ticketId,
        "user": user,
        "date": date?.toIso8601String(),
        "provider": provider,
        "number": number,
        "reason": reason,
        "message": message,
        "status": status,
      };

  bool get isStatusPending => status != "Pending";
}
