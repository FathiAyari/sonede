import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sonede/models/Reclamation.dart';
import 'package:sonede/presentation/ressources/colors.dart';
import 'package:sonede/presentation/ressources/dimensions/constants.dart';

class EditReclamation extends StatefulWidget {
  final Reclamation reclamation;
  const EditReclamation({Key? key, required this.reclamation}) : super(key: key);

  @override
  State<EditReclamation> createState() => _EditReclamationState();
}

class _EditReclamationState extends State<EditReclamation> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController contentController = TextEditingController();
  forceData() {
    setState(() {
      contentController.text = widget.reclamation.content;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forceData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Modifier une reclamation"),
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
                                FirebaseFirestore.instance
                                    .collection('reclamations')
                                    .doc(widget.reclamation.uid)
                                    .update({"content": contentController.text});
                                Fluttertoast.showToast(
                                  msg: "Reclamation modifié avec succès",
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
