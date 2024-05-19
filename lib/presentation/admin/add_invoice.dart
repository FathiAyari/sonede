import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sonede/presentation/ressources/colors.dart';

class AddInvoice extends StatefulWidget {
  final String counterId;
  final String userId;
  const AddInvoice({Key? key, required this.counterId, required this.userId}) : super(key: key);

  @override
  State<AddInvoice> createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  String? trimester;
  bool isLoading = false;
  String pdfFileName = "Choisir un pdf ";
  FilePickerResult? result;
  File? pdfFile;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une facture"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 225, 190, 231).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    icon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.confirmation_number_outlined,
                        color: Colors.purple[800],
                      ),
                    ),
                    hintText: 'Trimestre',
                    hintStyle: TextStyle(
                      fontSize: 18.0,
                      color: const Color.fromARGB(255, 109, 101, 115),
                    ),
                    border: InputBorder.none,
                  ),
                  value: trimester,
                  items: <String>[
                    'Premier',
                    'Deuxieme',
                    'Troisieme',
                    'Quatriéme',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      trimester = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner la trimestre';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          backgroundColor: AppColors.primary),
                      onPressed: () async {
                        result = (await FilePicker.platform
                            .pickFiles(type: FileType.custom, allowMultiple: false, allowedExtensions: ['pdf']))!;
                      },
                      icon: Icon(Icons.picture_as_pdf),
                      label: Text(
                        "${pdfFileName}",
                        style: TextStyle(color: Colors.white),
                      ))),
              Spacer(),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              backgroundColor: Colors.green),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (result != null) {
                                if (result!.files.single.extension == "pdf") {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  setState(() {
                                    pdfFile = File(result!.files.single.path!);
                                  });
                                  Reference reference = await FirebaseStorage.instance.ref().child(pdfFile!.path);
                                  print(reference);

                                  final UploadTask uploadTask = reference.putFile(pdfFile!);

                                  uploadTask.whenComplete(() async {
                                    var imageUpload = await uploadTask.snapshot.ref.getDownloadURL();

                                    var userCollection = FirebaseFirestore.instance.collection('invoices');
                                    var doc = userCollection.doc();
                                    await doc.set({
                                      "userId": widget.userId,
                                      "trimester": trimester,
                                      "uid": doc.id,
                                      "date": DateTime.now(),
                                      "counterId": widget.counterId,
                                      "urlPdf": imageUpload.split("pdf")[0] + "pdf" + imageUpload.split("pdf")[1],
                                    });
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Fluttertoast.showToast(
                                      msg: "Vous avez ajouté la facture",
                                      backgroundColor: Colors.grey,
                                    );
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "format de fichier doit être Pdf",
                                    backgroundColor: Colors.grey,
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Il faut choisir un fichier pdf",
                                  backgroundColor: Colors.grey,
                                );
                              }
                            }
                          },
                          child: Text(
                            "Ajouter",
                            style: TextStyle(color: Colors.white),
                          )))
            ],
          ),
        ),
      ),
    );
  }
}
