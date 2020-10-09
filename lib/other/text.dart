import 'package:intl/intl.dart';

String rupiah(int nominal) {
  return NumberFormat.currency(locale: "id", symbol: "Rp. ", decimalDigits: 0)
      .format(nominal);
}

caseSearch(String judul) {
  List<String> caseSearchList = List();
  String tmp = "";

  for (int i = 0; i < judul.length; i++) {
    tmp = tmp + judul[i].toLowerCase();
    caseSearchList.add(tmp);
  }
  return caseSearchList;
}
