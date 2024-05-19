import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umbrella/models/Umbrella.dart';
import 'package:umbrella/presentation/components/input_field/input_field.dart';
import 'package:umbrella/presentation/ressources/colors.dart';
import 'package:umbrella/presentation/ressources/dimensions/constants.dart';

class ManageUmbrellas extends StatefulWidget {
  Umbrella umbrella;
   ManageUmbrellas({required this.umbrella,Key? key}) : super(key: key);

  @override
  State<ManageUmbrellas> createState() => _ManageUmbrellasState();
}

class _ManageUmbrellasState extends State<ManageUmbrellas> {
  TextEditingController priceController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateControllerValue();
  }
  updateControllerValue(){
    setState(() {
      priceController.text=widget.umbrella.price.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Constants.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Modifier prix de location de parasols par jour ",style: TextStyle(
              color: AppColors.primary,
              fontSize: 17,
              fontStyle: FontStyle.italic
            ),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputField(prefixWidget: Icon(Icons.euro),label: "Prix", textInputType: TextInputType.number, controller: priceController),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(onPressed: (){
                    FirebaseFirestore
                        .instance
                        .collection(
                        "umbrellas")
                        .doc(widget.umbrella.idUmbrella).update({"price":double.parse(priceController.text)}).then((value) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                    });
                  },
                  
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  
                      ),
                      child: Text("Modifier",style: TextStyle(
                        color: Colors.white
                      ),)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
