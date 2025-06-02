import 'package:flutter/cupertino.dart';

class DesktopTabProvider extends ChangeNotifier {
  late int index = 0;

  void sNewIndex(int index) {
    this.index = index;
    notifyListeners();
  }
}
