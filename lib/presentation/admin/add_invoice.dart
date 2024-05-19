import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sonede/presentation/ressources/colors.dart';

class AddInvoice extends StatefulWidget {
  final String counterId;
  const AddInvoice({Key? key, required this.counterId}) : super(key: key);

  @override
  State<AddInvoice> createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  String? trimester;
  String pdfFileName = "Choisir un pdf ";
  late FilePickerResult result;
  File? pdfFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une facture"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    onPressed: () async{
                      result = (await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                          allowedExtensions: ['pdf']))!;
                    },
                    icon: Icon(Icons.picture_as_pdf),
                    label: Text(
                      "${pdfFileName}",
                      style: TextStyle(color: Colors.white),
                    ))),
            Spacer(),
            Container(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: Colors.green),
                    onPressed: () {},
                    child: Text(
                      "Ajouter",
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        ),
      ),
    );
  }
}
