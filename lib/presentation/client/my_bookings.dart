import 'package:flutter/material.dart';
import 'package:umbrella/presentation/client/confirmed_bookings.dart';
import 'package:umbrella/presentation/client/pending_bookings.dart';
import 'package:umbrella/presentation/client/refused_bookings.dart';
import 'package:umbrella/presentation/ressources/colors.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> with TickerProviderStateMixin {
  late TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            child: Container(
              alignment: Alignment.center,
              child: TabBar(
                physics: NeverScrollableScrollPhysics(),
                labelColor: Colors.white,
                splashBorderRadius: BorderRadius.circular(10),
                unselectedLabelColor: Colors.blueAccent,
                indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primary),
                controller: _tabController,
                tabs: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: Text("Refusés")),
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      child: Text("En cours")),
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      child: Text(" Confirmés")),
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
                  RefusedBookings(),
                  PendingBookings(),
                  ConfirmedBookings(),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
