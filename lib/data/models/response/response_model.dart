class ResponseModel {
  final bool _isSuccess;
  final String _message;
  final dynamic _data;
  ResponseModel(this._isSuccess, this._message,[this._data]);

  String get message => _message;
  bool get isSuccess => _isSuccess;
  dynamic get data => _data;


  Map<String, dynamic> toJson() => {
    "isSuccess": _isSuccess,
    "message": _message,
    "data": _data,
  };

}


class ErrorMessages {
    final List<String>? mobile;

    ErrorMessages({
        this.mobile,
    });

    factory ErrorMessages.fromJson(Map<String, dynamic> json) => ErrorMessages(
        mobile: json["mobile"] == null ? [] : List<String>.from(json["mobile"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "mobile": mobile == null ? [] : List<dynamic>.from(mobile!.map((x) => x)),
    };
}
