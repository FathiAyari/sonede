import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonede/presentation/ressources/colors.dart';
import 'package:sonede/presentation/ressources/dimensions/constants.dart';

class AddReclamation extends StatefulWidget {
  final String counterId;
  const AddReclamation({Key? key, required this.counterId}) : super(key: key);

  @override
  State<AddReclamation> createState() => _AddReclamationState();
}

class _AddReclamationState extends State<AddReclamation> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  var user = GetStorage().read("user");
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ajouter une reclamation"),
        ),
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Champ obligatoire";
                    }
                  },
                  controller: contentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                      label: Text("Reclamation"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                )),
              ),
            ),
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
                                var doc = FirebaseFirestore.instance.collection("reclamations").doc();
                                doc.set({
                                  "counterId": widget.counterId,
                                  "userId": user['uid'],
                                  "status": 0,
                                  "uid": doc.id,
                                  "content": contentController.text,
                                  "date": DateTime.now(),
                                });
                                Fluttertoast.showToast(
                                  msg: "Reclamation ajouté avec succès",
                                  backgroundColor: Colors.green,
                                );
                                setState(() {
                                  contentController.text = "";
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
    );
  }
}
