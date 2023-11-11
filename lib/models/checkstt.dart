class InforStockCardCheckStt {
  final int StockCardID;
  final String Reference;

  const InforStockCardCheckStt(
      {required this.StockCardID, required this.Reference});

  factory InforStockCardCheckStt.fromJson(Map<String, dynamic> json) {
    return InforStockCardCheckStt(
      StockCardID: json['StockCardID'],
      Reference: json['Reference'],
    );
  }
}


