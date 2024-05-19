import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonede/presentation/components/input_field/input_field.dart';
import 'package:sonede/presentation/ressources/colors.dart';
import 'package:sonede/presentation/ressources/dimensions/constants.dart';

class AddCounter extends StatefulWidget {
  const AddCounter({Key? key}) : super(key: key);

  @override
  State<AddCounter> createState() => _AddCounterState();
}

class _AddCounterState extends State<AddCounter> {
  TextEditingController counterCode = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un compteur"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            InputField(label: "Code de compteur", textInputType: TextInputType.text, controller: counterCode),
            Spacer(),
            loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.001, horizontal: Constants.screenWidth * 0.07),
                    child: Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                backgroundColor: Colors.green),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                var doc = await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user['uid'])
                                    .collection("counters")
                                    .doc(counterCode.text);
                                doc.set({
                                  "code": counterCode.text,
                                  "createdAt": DateTime.now(),
                                });
                                Fluttertoast.showToast(
                                  msg: "Compteur ajouté avec succès",
                                  backgroundColor: Colors.green,
                                );
                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Ajouter",
                              style: TextStyle(color: Colors.white),
                            ))),
                  ),
          ],
        ),
      ),
    ));
  }
}
