class DetialStockCard {
  final String IsPrintPanacim;
  final String BarcodeID;
  final double ActualTotalQty;
  final double Quantity;
  final String market;
  final String Material;
  final String T;
  final String CTRLKEY;
  final String Plant;
  final String Reference;
  final String PO;
  final String POItem;
  final double QuantityInvoice;
  final double QuantityInvoiceAct;
  final String PstgDate;
  final String Note_status;
  final String Sloc;
  final String Vendor;
  final String Postion;
  final String Barcode;

  DetialStockCard({
    required this.IsPrintPanacim,
    required this.BarcodeID,
    required this.ActualTotalQty,
    required this.Quantity,
    required this.market,
    required this.Material,
    required this.T,
    required this.CTRLKEY,
    required this.Plant,
    required this.Reference,
    required this.PO,
    required this.POItem,
    required this.QuantityInvoice,
    required this.QuantityInvoiceAct,
    required this.PstgDate,
    required this.Note_status,
    required this.Sloc,
    required this.Vendor,
    required this.Postion,
    required this.Barcode,
  });

  factory DetialStockCard.fromJson(Map<String, dynamic> json) {
    return DetialStockCard(
      IsPrintPanacim: json['IsPrintPanacim'],
      BarcodeID: json['BarcodeID'],
      ActualTotalQty: json['ActualTotalQty'],
      Quantity: json['Quantity'],
      market: json['market'],
      Material: json['Material'],
      T: json['T'],
      CTRLKEY: json['CTRLKEY'],
      Plant: json['Plant'],
      Reference: json['Reference'],
      PO: json['PO'],
      POItem: json['POItem'],
      QuantityInvoice: json['QuantityInvoice'],
      QuantityInvoiceAct: json['QuantityInvoiceAct'],
      PstgDate: json['PstgDate'],
      Note_status: json['Note_status'],
      Sloc: json['Sloc'],
      Vendor: json['Vendor'],
      Postion: json['Postion'],
      Barcode: json['Barcode'],
    );
  }
}
class HangThieuStt {
  final int number1;
  final String BarcodeID;
  final String StockCardID;

  const HangThieuStt(
      {required this.number1,
        required this.BarcodeID,
        required this.StockCardID});

  factory HangThieuStt.fromJson(Map<String, dynamic> json) {
    return HangThieuStt(
      number1: json['number1'],
      BarcodeID: json['BarcodeID'],
      StockCardID: json['StockCardID'],
    );
  }
}
class DataPrintpanacim {
  final String sReelID;
  final String QuantityPrint;

  const DataPrintpanacim({required this.sReelID,required this.QuantityPrint});

  factory DataPrintpanacim.fromJson(Map<String, dynamic> json) {
    return DataPrintpanacim(
      sReelID: json['sReelID'],
      QuantityPrint: json['QuantityPrint'],
    );
  }
}