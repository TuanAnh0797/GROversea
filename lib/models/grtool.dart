


class DataInvoicetool {
  final String material;
  final double sumquantityinvoice;
  final double sumquantiyactual;

  const DataInvoicetool({
    required this.material,
    required this.sumquantityinvoice,
    required this.sumquantiyactual,
  });

  factory DataInvoicetool.fromJson(Map<String, dynamic> json) {
    return DataInvoicetool(
      material: json['Column2'],
      sumquantityinvoice: json['Column1'],
      sumquantiyactual: json['Column3'],
    );
  }
}

class DataBarcodetool {
  String po;
  String poitem;
  String material;
  double quantity;
  double quantitybox;
  int totalbox;
  String lotcode;
  String unitbox;

  DataBarcodetool(
      this.po, this.poitem, this.material, this.quantity,this.quantitybox,this.totalbox, this.lotcode,this.unitbox);
}

class InforStockCardtool {
  final String StockCardID;
  final String ActualTotalQty;
  final String Quantity;
  final String CTRLKEY;
  final String T;
  final String Pstgdate;

  const InforStockCardtool(
      {required this.StockCardID,
        required this.ActualTotalQty,
        required this.Quantity,
        required this.CTRLKEY,
        required this.T,
        required this.Pstgdate});

  factory InforStockCardtool.fromJson(Map<String, dynamic> json) {
    return InforStockCardtool(
      StockCardID: json['StockCardID'],
      ActualTotalQty: json['ActualTotalQty'],
      Quantity: json['Quantity'],
      CTRLKEY: json['CTRLKEY'],
      T: json['T'],
      Pstgdate: json['Pstgdate'],
    );
  }
}

class DataDetailtool {
  final String BoxNumber;
  final String Material;
  final double QtyBox_Act;
  final String PO;
  final String POItem;
  final int StockCardID;

  const DataDetailtool(
      {
        required this.BoxNumber,
        required this.Material,
        required this.QtyBox_Act,
        required this.PO,
        required this.POItem,
        required this.StockCardID});

  factory DataDetailtool.fromJson(Map<String, dynamic> json) {
    return DataDetailtool(
      BoxNumber: json['BoxNumber'],
      Material: json['Material'],
      QtyBox_Act: json['QtyBox_Act'],
      PO: json['PO'],
      POItem: json['POItem'],
      StockCardID: json['StockCardID'],
    );
  }
}
class BarcodeIDtool {
  final String mBarcodeID;
  const BarcodeIDtool({required this.mBarcodeID});
  factory BarcodeIDtool.fromJson(Map<String, dynamic> json) {
    return BarcodeIDtool(
      mBarcodeID: json['mBarcodeID'],
    );
  }
}
