import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:umbrella/models/Umbrella.dart';
import 'package:umbrella/models/booking.dart';

class RefusedBookings extends StatefulWidget {
  const RefusedBookings({Key? key}) : super(key: key);

  @override
  State<RefusedBookings> createState() => _RefusedBookingsState();
}

class _RefusedBookingsState extends State<RefusedBookings> {
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('booking')
              .where("clientId", isEqualTo: user['uid'])
              .where("status", isEqualTo: -1)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Booking> bc = [];
              for (var data in snapshot.data!.docs.toList()) {
                bc.add(Booking.fromJson(data.data() as Map<String, dynamic>));
              }
              if (bc.isNotEmpty) {
                return ListView.builder(
                    itemCount: bc.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red.withOpacity(0.5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date de debut :  ${DateFormat("yyyy/MM/dd").format(bc[index].startDate)}",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  "Date de fin : ${DateFormat("yyyy/MM/dd").format(bc[index].endDate)}",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  "Date de depot :${DateFormat("yyyy/MM/dd").format(bc[index].DepositDate)}",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                StreamBuilder(
                                    stream:
                                        FirebaseFirestore.instance.collection('umbrellas').doc(bc[index].umbrellaId).snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
                                      if (userSnapshot.hasData) {
                                        Umbrella tt = Umbrella.fromJson(userSnapshot.data!.data() as Map<String, dynamic>);
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Code de parasol  :${tt.idUmbrella} ",
                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                            ),
                                            Text(
                                              "Prix de jour :${tt.price} ",
                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                            ),
                                            Text(
                                              "Prix total :${bc[index].totalPrice}  Euros",
                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    }),
                                Text(
                                  "Lits :${bc[index].bed}",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  "Fauteuils :${bc[index].sofa}",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance.collection("booking").doc(bc[index].id).delete();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                          child: Text(
                                            "Supprimer",
                                            style: TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: Lottie.asset("assets/lotties/empty.json"),
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
