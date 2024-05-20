import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sonede/models/Counter.dart';
import 'package:sonede/presentation/client/add_counter.dart';
import 'package:sonede/presentation/client/add_reclamation.dart';
import 'package:sonede/presentation/ressources/colors.dart';

class MyCounters extends StatefulWidget {
  const MyCounters({Key? key}) : super(key: key);

  @override
  State<MyCounters> createState() => _MyCountersState();
}

class _MyCountersState extends State<MyCounters> {
  var user = GetStorage().read("user");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(AddCounter());
          },
          backgroundColor: AppColors.primary,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(user['uid']).collection('counters').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Counter> bc = [];
                for (var data in snapshot.data!.docs.toList()) {
                  bc.add(Counter.fromJson(data.data() as Map<String, dynamic>));
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
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10), color: AppColors.primary.withOpacity(0.5)),
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
                                            Get.to(AddReclamation(counterId: bc[index].code));
                                          },
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          icon: Icons.add,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text("${bc[index].code}"),
                                      subtitle: Text(" Creé le : ${DateFormat("yyyy/MM/dd").format(bc[index].createdAt)} "),
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
                      children: [Lottie.asset("assets/lotties/empty.json"), Text("Pas de compteurs pour le moment")],
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
