class DataInvoiceStd {
  final String material;
  final double sumquantityinvoice;
  final double sumquantiyactual;

  const DataInvoiceStd({
    required this.material,
    required this.sumquantityinvoice,
    required this.sumquantiyactual,
  });

  factory DataInvoiceStd.fromJson(Map<String, dynamic> json) {
    return DataInvoiceStd(
      material: json['Column2'],
      sumquantityinvoice: json['Column1'],
      sumquantiyactual: json['Column3'],
    );
  }
}

class DataBarcodeStd {
  String po;
  String poitem;
  String material;
  double quantity;
  String lotcode;

  DataBarcodeStd(
      this.po, this.poitem, this.material, this.quantity, this.lotcode);
}

class InforStockCardStd {
  final String StockCardID;
  final String ActualTotalQty;
  final String Quantity;
  final String CTRLKEY;
  final String T;
  final String Pstgdate;

  const InforStockCardStd(
      {required this.StockCardID,
      required this.ActualTotalQty,
      required this.Quantity,
      required this.CTRLKEY,
      required this.T,
      required this.Pstgdate});

  factory InforStockCardStd.fromJson(Map<String, dynamic> json) {
    return InforStockCardStd(
      StockCardID: json['StockCardID'],
      ActualTotalQty: json['ActualTotalQty'],
      Quantity: json['Quantity'],
      CTRLKEY: json['CTRLKEY'],
      T: json['T'],
      Pstgdate: json['Pstgdate'],
    );
  }
}

class DataDetailStd {
  final String Material;
  final double QtyBox_Act;
  final String PO;
  final String POItem;
  final int StockCardID;

  const DataDetailStd(
      {
      required this.Material,
      required this.QtyBox_Act,
      required this.PO,
      required this.POItem,
      required this.StockCardID});

  factory DataDetailStd.fromJson(Map<String, dynamic> json) {
    return DataDetailStd(

      Material: json['Material'],
      QtyBox_Act: json['QtyBox_Act'],
      PO: json['PO'],
      POItem: json['POItem'],
      StockCardID: json['StockCardID'],
    );
  }
}
class BarcodeID {
  final String mBarcodeID;
  const BarcodeID({required this.mBarcodeID});
  factory BarcodeID.fromJson(Map<String, dynamic> json) {
    return BarcodeID(
      mBarcodeID: json['mBarcodeID'],
    );
  }
}
