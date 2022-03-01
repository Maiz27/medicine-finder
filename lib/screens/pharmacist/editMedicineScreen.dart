import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/screens/pharmacist/main/medicineListScreen.dart';
import 'package:provider/provider.dart';

import '../../helpers/appInfo.dart';
import '../../helpers/deviceDimensions.dart';
import '../../models/medicineModel.dart';
import '../../services/database.dart';
import '../../splachScreen.dart';
import '../../widgets/IconFont.dart';
import '../../widgets/brandNames.dart';

// String name = "";
// bool inStock = true;
// double price = 0.0;
// List<String> brandnames = [];

class EditMedicineScreen extends StatefulWidget {
  const EditMedicineScreen(
      {Key? key, this.medicine, required this.isEdit, required this.index})
      : super(key: key);
  final Medicine? medicine;
  final String isEdit;
  final int index;

  @override
  _EditMedicineScreenState createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  Medicine? _medicine;
  late String _isEdit;
  final TextEditingController _genericNameController =
      new TextEditingController();
  final TextEditingController _priceController = new TextEditingController();
  List _brandnames = [];
  List _removedBrandnames = [];
  bool _inStock = true;
  int _index = 0;
  String newName = "";
  List<bool> operations = [false, false];

  @override
  void initState() {
    super.initState();
    _isEdit = widget.isEdit;
    _medicine = widget.medicine;
    _index = widget.index;
    if (isEditOperation()) {
      _inStock = _medicine!.inStock;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceDimensions = Provider.of<Dimension>(context);

    double height = deviceDimensions.getDeviceHeight();
    double width = deviceDimensions.getDeviceWidth();
    setFields();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppInfo.MAIN_COLOR,
        title: _isEdit.isNotEmpty
            ? Text(
                "Edit Medicine",
                style: TextStyle(
                  fontSize: width * 0.025,
                  fontWeight: FontWeight.bold,
                  letterSpacing: width * 0.0005,
                ),
              )
            : Text(
                "Add New Medicine",
                style: TextStyle(
                  fontSize: width * 0.025,
                  fontWeight: FontWeight.bold,
                  letterSpacing: width * 0.0005,
                ),
              ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.035,
                ),
                child: TextField(
                  controller: _genericNameController,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: AppInfo.MAIN_COLOR,
                    letterSpacing: 1.5,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(maxWidth: width * 0.45),
                    labelText: 'Generic name',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: height * 0.01,
                        right: height * 0.01,
                      ),
                      child: IconFont(
                        color: AppInfo.MAIN_COLOR,
                        iconName: IConFontHelper.CAN,
                        size: 0.045,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: height * 0.03,
                      color: AppInfo.MAIN_COLOR,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.035,
                ),
                child: TextField(
                  controller: _priceController,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: AppInfo.MAIN_COLOR,
                    letterSpacing: 1.5,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(maxWidth: width * 0.45),
                    labelText: 'Price SSD',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: height * 0.01,
                        right: height * 0.01,
                        top: height * 0.005,
                      ),
                      child: IconFont(
                        color: AppInfo.MAIN_COLOR,
                        iconName: IConFontHelper.CASH,
                        size: 0.043,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: height * 0.03,
                      color: AppInfo.MAIN_COLOR,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.02,
                  bottom: height * 0.005,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "In-Stock:",
                      style: TextStyle(
                        fontSize: height * 0.03,
                        color: AppInfo.MAIN_COLOR,
                      ),
                    ),
                    Switch(
                        activeColor: AppInfo.MAIN_COLOR,
                        value: _inStock,
                        onChanged: (value) {
                          setState(() {
                            _inStock = value;
                          });
                        }),
                  ],
                ),
              ),
              Divider(
                color: AppInfo.ACCENT,
                thickness: 2,
                indent: height * 0.01,
                endIndent: height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: height * 0.008,
                ),
                child: Text(
                  "Brand Name:",
                  style: TextStyle(
                    fontSize: height * 0.03,
                    color: AppInfo.MAIN_COLOR,
                  ),
                ),
              ),
              Stack(children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.008,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width * 0.03),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset.zero,
                          )
                        ]),
                    height: height * 0.3,
                    width: width * 0.45,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.015,
                        bottom: height * 0.015,
                      ),
                      child: ListView.builder(
                          itemCount: _brandnames.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return BrandNamesWidget(
                                brandName: _brandnames[index].toString(),
                                index: index);
                          }),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.00002,
                  right: width * 0.07,
                  child: IconButton(
                    icon: IconFont(
                      color: AppInfo.MAIN_COLOR,
                      iconName: IConFontHelper.ADD,
                      size: 0.041,
                    ),
                    onPressed: () {
                      if (!_brandnames.contains(_medicine!.brandNames)) {
                        operations[0] = true;
                      }
                      setState(() {
                        _brandnames.add("");
                      });
                    },
                    tooltip: "Add new brand names",
                  ),
                ),
                Positioned(
                  top: height * 0.00002,
                  right: width * 0.01,
                  child: IconButton(
                    icon: IconFont(
                      color: AppInfo.MAIN_COLOR,
                      iconName: IConFontHelper.REMOVE,
                      size: 0.041,
                    ),
                    onPressed: () {
                      if (_medicine!.brandNames.contains(_brandnames.last)) {
                        operations[1] = true;
                        _removedBrandnames.add(_brandnames.last);
                      }
                      setState(() {
                        _brandnames.removeLast();
                      });
                    },
                    tooltip: "Remove Last Entry",
                  ),
                ),
              ]),
              Padding(
                padding: EdgeInsets.only(top: height * 0.02),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppInfo.MAIN_COLOR,
                    onPrimary: AppInfo.ACCENT,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(width * 0.5)),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(height * 0.014),
                    child: Text(
                      'Discard Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.02),
                child: ElevatedButton(
                  onPressed: () {
                    if (_genericNameController.text != "" &&
                        _priceController.text != "" &&
                        _brandnames.isNotEmpty) {
                      _medicine!.name = _genericNameController.text;
                      _medicine!.price = int.parse(_priceController.text);
                      _medicine!.inStock = _inStock;
                      _medicine!.brandNames = _brandnames;

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => SplachScreen(
                                    duration: 2,
                                    function: Database.updateMedicineDoc(
                                      medicine: _medicine,
                                      localListIndex: _index,
                                      operation: operations,
                                      removedBrandNames: _removedBrandnames,
                                    ),
                                    goTopage: MedicineListScreen(),
                                  )));
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please fill out the fields correctly!');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppInfo.MAIN_COLOR,
                    onPrimary: AppInfo.ACCENT,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(width * 0.5)),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(height * 0.014),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isEditOperation() {
    if (_isEdit.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  void setFields() {
    if (isEditOperation()) {
      //Add the data from the medicine object to the variables used in the fields
      _genericNameController.text = _medicine!.name;
      _priceController.text = _medicine!.price.toString();

      //The UI needs to update appropriately for both editting & adding,
      //Since _brandnames can only have data when the operation is editing,
      //and this Function is executed only when its editting,add data to list
      if (_brandnames.isEmpty) {
        _brandnames.addAll(_medicine!.brandNames);
      }
    }
  }
}
