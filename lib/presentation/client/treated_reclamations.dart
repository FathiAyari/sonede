import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:sonede/models/Reclamation.dart';

class TreatedReclamations extends StatefulWidget {
  const TreatedReclamations({Key? key}) : super(key: key);

  @override
  State<TreatedReclamations> createState() => _TreatedReclamationsState();
}

class _TreatedReclamationsState extends State<TreatedReclamations> {
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('reclamations')
              .where("userId", isEqualTo: user['uid'])
              .where("status", isEqualTo: 1)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Reclamation> bc = [];
              for (var data in snapshot.data!.docs.toList()) {
                bc.add(Reclamation.fromJson(data.data() as Map<String, dynamic>));
              }
              if (bc.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: bc.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            width: double.infinity,
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.withOpacity(0.5)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Slidable(
                                  startActionPane: ActionPane(
                                    // A motion is a widget used to control how the pane animates.
                                    motion: const ScrollMotion(),

                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        icon: Icons.cancel,
                                        onPressed: (BuildContext ctx) {},
                                      ),
                                      SlidableAction(
                                        onPressed: (BuildContext ctx) {},
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: ReadMoreText(
                                      "${bc[index].content} ",
                                      trimMode: TrimMode.Line,
                                      trimLines: 2,
                                      colorClickableText: Colors.white,
                                      trimCollapsedText: 'Afficher plus',
                                      trimExpandedText: 'Afficher moins',
                                      moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(" Creé le : ${DateFormat("yyyy/MM/dd").format(bc[index].date)} "),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Lottie.asset("assets/lotties/empty.json"), Text("Pas de reclamations traité")],
                  ),
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
