import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicine/helpers/iconHelper.dart';
import 'package:medicine/screens/pharmacist/main/medicineListScreen.dart';
import 'package:provider/provider.dart';

import '../../helpers/appInfo.dart';
import '../../helpers/deviceDimensions.dart';
import '../../models/medicineModel.dart';
import '../../services/database.dart';
import '../splachScreen.dart';
import '../../widgets/IconFont.dart';
import '../../widgets/brandNames.dart';

List<bool> _inStockList = [];
List<bool> operations = [false, false];
List brandList = [];

class EditMedicineScreen extends StatefulWidget {
  const EditMedicineScreen(
      {Key? key, this.medicine, required this.isEdit, required this.index})
      : super(key: key);
  final Medicine? medicine;
  final String isEdit;
  final int index;

  @override
  _EditMedicineScreenState createState() => _EditMedicineScreenState();

  static void setinStock(int index, bool value) {
    _inStockList[index] = value;
  }
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  Medicine? _medicine;
  late String _isEdit;
  final TextEditingController _genericNameController =
      new TextEditingController();
  final TextEditingController _descController = new TextEditingController();
  List _brandnames = [];
  List _removedBrandnames = [];
  bool _inStock = true;
  int _localListIndex = 0;
  final List _brandControllers = [];

  @override
  void initState() {
    super.initState();
    _isEdit = widget.isEdit;
    _medicine = widget.medicine;
    _localListIndex = widget.index;
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
                  controller: _descController,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: AppInfo.MAIN_COLOR,
                    letterSpacing: 1.5,
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(maxWidth: width * 0.45),
                    labelText: 'Description',
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
                          _brandControllers.clear();
                          _inStockList.clear();

                          _brandnames.forEach((element) {
                            element['inStock'] = value;
                          });

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
                    height: height * 0.4,
                    width: width * 0.45,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.015,
                        bottom: height * 0.015,
                      ),
                      child: ListView.builder(
                          itemCount: _brandnames.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            TextEditingController nctrl =
                                TextEditingController();
                            TextEditingController pctrl =
                                TextEditingController();
                            bool inStock = _brandnames[index]['inStock'];
                            _inStockList.add(inStock);
                            _brandControllers.add({
                              'nameCtrl': nctrl,
                              'priceCtrl': pctrl,
                              'inStock': inStock
                            });
                            return BrandNamesWidget(
                              brandName: _brandnames[index],
                              index: index,
                              nameController: nctrl,
                              priceController: pctrl,
                              inStock: inStock,
                            );
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
                      if (isEditOperation()) {
                        if (!_brandnames.contains(_medicine!.brandNames)) {
                          operations[0] = true;
                        }
                      }
                      _inStockList.clear();
                      _brandControllers.clear();
                      setState(() {
                        _brandnames.add({
                          "name": "New brand name",
                          "price": 0,
                          "inStock": true
                        });
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
                      if (isEditOperation()) {
                        if (_medicine!.brandNames.contains(_brandnames.last)) {
                          operations[1] = true;
                          _removedBrandnames.add(_brandnames.last);
                        }
                      }

                      _brandControllers.clear();
                      _inStockList.clear();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.02,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_genericNameController.text != "" &&
                            _brandnames.isNotEmpty) {
                          _brandnames.clear();
                          brandList.clear();
                          int x = 0;
                          _brandControllers.forEach((item) => {
                                _brandnames.add({
                                  'name': item['nameCtrl'].text,
                                  'price': int.parse(item['priceCtrl'].text),
                                  'inStock': _inStockList[x],
                                }),
                                brandList.add(
                                  item['nameCtrl'].text,
                                ),
                                x++,
                              });
                          //Check if the its an edit or creation
                          if (isEditOperation()) {
                            _medicine!.name = _genericNameController.text;
                            _medicine!.inStock = _inStock;
                            _medicine!.desc = _descController.text;
                            _medicine!.brandNames.clear();
                            _medicine!.brandNames.addAll(_brandnames);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SplachScreen(
                                          duration: 2,
                                          function: Database.updateMedicineDoc(
                                            medicine: _medicine,
                                            localListIndex: _localListIndex,
                                            operation: operations,
                                            removedBrandNames:
                                                _removedBrandnames,
                                            brandList: brandList,
                                          ),
                                          goTopage: MedicineListScreen(),
                                        )));
                          } else {
                            Medicine med = Medicine(
                              brandNames: _brandnames,
                              id: '',
                              inStock: _inStock,
                              pharmacyId: '',
                              name: _genericNameController.text,
                              brandList: brandList,
                              desc: _descController.text,
                            );
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SplachScreen(
                                          duration: 2,
                                          function: Database.createMedicineDoc(
                                            medicine: med,
                                          ),
                                          goTopage: MedicineListScreen(),
                                        )));
                          }
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
                  Visibility(
                    visible: isEditOperation(),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.02, left: width * 0.03),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SplachScreen(
                                        duration: 2,
                                        function: Database.deleteMedcineDoc(
                                            _medicine!.id),
                                        goTopage: MedicineListScreen(),
                                      )));
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
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
      _descController.text = _medicine!.desc;
      //The UI needs to update appropriately for both editting & adding,
      //Since _brandnames can only have data when the operation is editing,
      //and this Function is executed only when its editting,add data to list
      if (_brandnames.isEmpty) {
        _brandnames.addAll(_medicine!.brandNames);
      }
    }
  }
}
