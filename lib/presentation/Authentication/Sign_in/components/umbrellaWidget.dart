import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umbrella/models/Umbrella.dart';
import 'package:umbrella/presentation/client/umbrella_details.dart';

class UmbrellaWidget extends StatelessWidget {
  final Umbrella umbrella;
  const UmbrellaWidget({required this.umbrella, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(UmbrellaDetails(umbrella: umbrella));
      },
      child: Container(
          decoration: BoxDecoration(color: Colors.green.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/chair.png"),
          )),
    );
  }
}
