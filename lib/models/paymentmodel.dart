import 'dart:convert';

PaymentModel singlepaymentModelFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String singlepaymentModelToJson(PaymentModel data) =>
    json.encode(data.toJson());
List<PaymentModel> paymentModelFromJson(String str) => List<PaymentModel>.from(
    json.decode(str).map((x) => PaymentModel.fromJson(x)));

String paymentModelToJson(List<PaymentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentModel {
  PaymentModel({
    required this.id,
    required this.userid,
    required this.payment,
    required this.date,
    required this.khaltino,
    required this.remarks,
  });

  int id;
  String userid;
  String payment;
  DateTime date;
  String khaltino;
  String remarks;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json["id"],
        userid: json["userid"],
        payment: json["payment"],
        date: DateTime.parse(json["date"]),
        khaltino: json["khaltino"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "payment": payment,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "khaltino": khaltino,
        "remarks": remarks,
      };
}
