import 'package:medicine/models/userModel.dart';

class Utility {
  static CurrUser? _currUser;

  CurrUser? getCurrUser() {
    return _currUser;
  }

  CurrUser? setCurrUser(CurrUser currUser) {
    _currUser = currUser;
    return _currUser;
  }
}
