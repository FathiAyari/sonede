import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonede/models/Invoice.dart';
import 'package:sonede/presentation/ressources/colors.dart';
import 'package:sonede/presentation/ressources/dimensions/constants.dart';

class MyInvoices extends StatefulWidget {
  const MyInvoices({Key? key}) : super(key: key);

  @override
  State<MyInvoices> createState() => _MyInvoicesState();
}

class _MyInvoicesState extends State<MyInvoices> {
  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {});
    });
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  var user = GetStorage().read('user');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: Constants.screenHeight * 0.1,
                width: Constants.screenWidth,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.primary.withOpacity(0.5)),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${user['name'].toString().toUpperCase()}  ${user['lastName'].toString().toUpperCase()}",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                      Spacer(),
                      Image.asset(user['role'] == "admin" ? "assets/images/admin.png" : "assets/images/user.png")
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('invoices').where('userId', isEqualTo: user['uid']).snapshots(),
                  builder: (context, snapshotData) {
                    if (snapshotData.hasData) {
                      List<Invoice> bc = [];
                      for (var data in snapshotData.data!.docs.toList()) {
                        bc.add(Invoice.fromJson(data.data() as Map<String, dynamic>));
                      }
                      if (bc.isNotEmpty) {
                        return ListView.builder(
                            itemCount: bc.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10), color: AppColors.primary.withOpacity(0.5)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Slidable(
                                          key: const ValueKey(0),
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
                                                onPressed: (BuildContext ctx) async {
                                                  var test = snapshotData.data!.docs[index]
                                                      .get("urlPdf")
                                                      .toString()
                                                      .split("file_picker%2F")[1];

                                                  var status = await Permission.storage.request();
                                                  if (status.isGranted) {
                                                    Directory dir = Directory('/storage/emulated/0/Download');
                                                    final path = Directory("/storage/emulated/0/Download/test");
                                                    path.create();
                                                    bool check = await File(
                                                      "/storage/emulated/0/Download/" +
                                                          test.split("pdf")[0].replaceAll("%20", "") +
                                                          "pdf",
                                                    ).exists();

                                                    if (!check) {
                                                      await FlutterDownloader.enqueue(
                                                        url: '${snapshotData.data!.docs[index].get("urlPdf")}',
                                                        fileName: test.split("pdf")[0].replaceAll("%20", "") + "pdf",

                                                        showNotification:
                                                            false, // show download progress in status bar (for Android)
                                                        openFileFromNotification: false,
                                                        saveInPublicStorage: true,
                                                        savedDir: dir
                                                            .path, // click on notification to open downloaded file (for Android)
                                                      );
                                                      Fluttertoast.showToast(
                                                        msg: "Facture telechargé",
                                                        backgroundColor: Colors.grey,
                                                        // fontSize: 25
                                                        // gravity: ToastGravity.TOP,
                                                        // textColor: Colors.pink
                                                      );
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg: "fichier deja existe , consulter le dossier de telechargement",
                                                        backgroundColor: Colors.grey,
                                                        // fontSize: 25
                                                        // gravity: ToastGravity.TOP,
                                                        // textColor: Colors.pink
                                                      );
                                                    }
                                                  }
                                                },
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                icon: Icons.download,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Date de création :${DateFormat("yyyy/MM/dd").format(bc[index].date)}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                Text(
                                                  "Facture de : ${bc[index].trimester} trimestre ",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                Text(
                                                  "Code de facture : ${bc[index].uid}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                Text(
                                                  "Compteur : ${bc[index].counterId}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: Column(
                            children: [Lottie.asset("assets/lotties/empty.json"), Text("Pas de facture pour le moment ")],
                          ),
                        );
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
