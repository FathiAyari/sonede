import 'package:flutter/material.dart';
import 'package:umbrella/models/Umbrella.dart';
import 'package:umbrella/presentation/admin/manage_Umbrellas.dart';
import 'package:umbrella/presentation/admin/manage_equipements.dart';
import 'package:umbrella/presentation/ressources/colors.dart';

class ManagementScreen extends StatefulWidget {
final  Umbrella umbrella;
  const ManagementScreen({required this.umbrella,Key? key}) : super(key: key);

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0)
      ..addListener(() {
        setState(() {});
      });
  }
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // change this to your desired color
        ),
        backgroundColor: AppColors.primary,
        title: Text("${widget.umbrella.idUmbrella}",style: TextStyle(color: Colors.white),),),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 10),
          child: Container(
            alignment: Alignment.center,
            child: TabBar(
              indicatorColor: Colors.transparent,
              physics: NeverScrollableScrollPhysics(),
              labelColor: Colors.white,
              splashBorderRadius: BorderRadius.circular(10),
              unselectedLabelColor: Colors.blueAccent,
              indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primary),
              controller: _tabController,
              tabs: [

                Container(
                  width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Text("Parasols")),
                Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Text(" Equipements")),
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
                    ManageUmbrellas(umbrella: widget.umbrella,),
                    ManageEquiements(),

                  ],
                ),
              ),
            ))
      ],),
    );
  }
}
