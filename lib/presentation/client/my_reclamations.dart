import 'package:flutter/material.dart';
import 'package:sonede/presentation/client/pending_reclamations.dart';
import 'package:sonede/presentation/client/treated_reclamations.dart';
import 'package:sonede/presentation/ressources/dimensions/constants.dart';

class MyReclamations extends StatefulWidget {
  const MyReclamations({Key? key}) : super(key: key);

  @override
  State<MyReclamations> createState() => _MyReclamationsState();
}

class _MyReclamationsState extends State<MyReclamations> with TickerProviderStateMixin {
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
                    PendingReclamations(),
                    TreatedReclamations(),
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
