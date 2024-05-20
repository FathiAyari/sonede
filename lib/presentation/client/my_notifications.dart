import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sonede/models/Notification.dart';

class MyNotifications extends StatefulWidget {
  const MyNotifications({Key? key}) : super(key: key);

  @override
  State<MyNotifications> createState() => _MyNotificationsState();
}

class _MyNotificationsState extends State<MyNotifications> {
  var user = GetStorage().read("user");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Notifications> bc = [];
                for (var data in snapshot.data!.docs.toList()) {
                  bc.add(Notifications.fromJson(data.data() as Map<String, dynamic>));
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
                                  BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue.withOpacity(0.5)),
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
                                          onPressed: (BuildContext ctx) {
                                            snapshot.data!.docs[index].reference.delete();
                                            Fluttertoast.showToast(
                                              msg: "Notification supprimé avec succès",
                                              backgroundColor: Colors.green,
                                            );
                                          },
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text("${bc[index].content}"),
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
                      children: [Lottie.asset("assets/lotties/empty.json"), Text("Pas de notifications pour le moment")],
                    ),
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
