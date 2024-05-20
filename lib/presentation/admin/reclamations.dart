import 'package:flutter/material.dart';
import 'package:sonede/presentation/admin/admin_pending_reclamations.dart';
import 'package:sonede/presentation/admin/admin_treated_reclamations.dart';
import 'package:sonede/presentation/ressources/dimensions/constants.dart';

class Reclamations extends StatefulWidget {
  const Reclamations({Key? key}) : super(key: key);

  @override
  State<Reclamations> createState() => _ReclamationsState();
}

class _ReclamationsState extends State<Reclamations> with TickerProviderStateMixin {
  late TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
              child: Container(
                alignment: Alignment.center,
                child: TabBar(
                  isScrollable: true,
                  unselectedLabelStyle: TextStyle(color: Colors.purple),
                  indicatorColor: Colors.purple,
                  unselectedLabelColor: Colors.purple,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.purple),
                  controller: _tabController,
                  tabAlignment: TabAlignment.center,
                  labelColor: Colors.white,
                  tabs: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: Constants.screenHeight * 0.009,
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "En cours",
                          style: TextStyle(
                            fontSize: Constants.screenHeight * 0.015,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: Constants.screenHeight * 0.009,
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "Traités",
                          style: TextStyle(
                            fontSize: Constants.screenHeight * 0.015,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    AdminPendingReclamations(),
                    AdminTratedReclamations(),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

/*StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('reclamations').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Reclamation> bc = [];
                      for (var data in snapshot.data!.docs.toList()) {
                        bc.add(Reclamation.fromJson(data.data() as Map<String, dynamic>));
                      }
                      if (bc.isNotEmpty) {
                        return ListView.builder(
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
                                    child: StreamBuilder(
                                        stream: FirebaseFirestore.instance.collection("users").doc(bc[index].userId).snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshotUser) {
                                          if (snapshotUser.hasData) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nom et Prénom :  ${snapshotUser.data!.get("name")} ${snapshotUser.data!.get("lastName")}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                Text(
                                                  "Email: ${snapshotUser.data!.get("email")}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                Text(
                                                  "Compteur: ${bc[index].counterId}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                Text(
                                                  "Date de création :${DateFormat("yyyy/MM/dd").format(bc[index].date)}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                Text(
                                                  "Reclamation : ${bc[index].content}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Text("");
                                          }
                                        }),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: Column(
                            children: [Lottie.asset("assets/lotties/empty.json"), Text("Pas de reclamation pour le moment ")],
                          ),
                        );
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  })*/
