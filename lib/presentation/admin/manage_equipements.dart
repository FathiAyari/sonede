import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umbrella/presentation/components/input_field/input_field.dart';
import 'package:umbrella/presentation/ressources/colors.dart';
import 'package:umbrella/presentation/ressources/dimensions/constants.dart';

class ManageEquiements extends StatefulWidget {
  const ManageEquiements({Key? key}) : super(key: key);

  @override
  State<ManageEquiements> createState() => _ManageEquiementsState();
}

class _ManageEquiementsState extends State<ManageEquiements> {
  TextEditingController sofaController = TextEditingController();
  TextEditingController bedController = TextEditingController();

  getData() async {
    var sofa = await FirebaseFirestore.instance
        .collection("equipement")
        .doc("sofa")
        .get();
    var bed = await FirebaseFirestore.instance
        .collection("equipement")
        .doc("bed")
        .get();
    setState(() {
      sofaController.text = sofa.get("price").toString();
      bedController.text = bed.get("price").toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Constants.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Modifier prix de location des equipements par jour ",
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 17,
                  fontStyle: FontStyle.italic),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Fauteuil : ",
                      style: TextStyle(color: AppColors.primary, fontSize: 20)),
                  Expanded(
                      child: InputField(
                          prefixWidget: Icon(Icons.euro),
                          label: "Prix",
                          textInputType: TextInputType.number,
                          controller: sofaController)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Lits : ",
                    style: TextStyle(color: AppColors.primary, fontSize: 20),
                  ),
                  Expanded(
                      child: InputField(
                          prefixWidget: Icon(Icons.euro),
                          label: "Prix",
                          textInputType: TextInputType.number,
                          controller: bedController)),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("equipement")
                            .doc("sofa")
                            .update(
                                {"price": double.parse(sofaController.text)});
                        await FirebaseFirestore.instance
                            .collection("equipement")
                            .doc("bed")
                            .update(
                                {"price": double.parse(bedController.text)});
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Text(
                        "Modifier",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
