import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicine/helpers/utility.dart';
import 'package:medicine/models/userModel.dart';

class Database {
  static Future<String> createUser(CurrUser _user) async {
    String retVal = "error";

    try {
      await FirebaseFirestore.instance.collection('Users').doc(_user.uid).set({
        'fullName': _user.fullName,
        'email': _user.email,
        'uid': _user.uid,
        'createdOn': Timestamp.now(),
        'telephone': _user.tele,
        'accType': _user.accType,
      });
      retVal = "success";
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    return retVal;
  }

  static Future<Map> getUserDoc(String currUserID) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currUserID)
        .get();

    var data = snap.data() as Map;
    CurrUser user = CurrUser.fromJson(data);
    Utility().setCurrUser(user);
    return data;
  }
}
