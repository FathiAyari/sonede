import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:sonede/models/Reclamation.dart';

class AdminTratedReclamations extends StatefulWidget {
  const AdminTratedReclamations({Key? key}) : super(key: key);

  @override
  State<AdminTratedReclamations> createState() => _AdminTratedReclamationsState();
}

class _AdminTratedReclamationsState extends State<AdminTratedReclamations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('reclamations').where("status", isEqualTo: 1).snapshots(),
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
                                BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue.withOpacity(0.4)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Slidable(
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        icon: Icons.cancel,
                                        onPressed: (BuildContext ctx) {},
                                      ),
                                      SlidableAction(
                                        onPressed: (BuildContext ctx) {
                                          snapshot.data!.docs[index].reference.update({'status': 0});
                                          var notifColl = FirebaseFirestore.instance.collection('notifications');

                                          var notifDoc = notifColl.doc();
                                          notifDoc.set({
                                            "userId": bc[index].userId,
                                            "content": "Un admin a annulé la traitement de votre reclamation",
                                            "date": DateTime.now(),
                                            "id": notifDoc.id
                                          });
                                          Fluttertoast.showToast(
                                            msg: "Reclamation changé en cours avec succès",
                                            backgroundColor: Colors.green,
                                          );
                                        },
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        icon: Icons.undo,
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
                    children: [Lottie.asset("assets/lotties/empty.json"), Text("Pas de reclamations en cours")],
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
