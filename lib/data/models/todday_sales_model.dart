
class TodaySalesModel {
    final String? todaySale;
    final String? todayProfit;

    TodaySalesModel({
        this.todaySale,
        this.todayProfit,
    });

    factory TodaySalesModel.fromJson(Map<String, dynamic> json) => TodaySalesModel(
        todaySale: json["today_sale"],
        todayProfit: json["today_profit"],
    );

    Map<String, dynamic> toJson() => {
        "today_sale": todaySale,
        "today_profit": todayProfit,
    };
}
