import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tickets/models/get_ticket_model.dart';
import 'package:tickets/services/get_ticket_services.dart';

import '../../../constants.dart';
import '../../../services/global.dart';

class TicketDetailsBody extends StatefulWidget {
  final String id;
  const TicketDetailsBody({super.key, required this.id});

  @override
  State<TicketDetailsBody> createState() => _TicketDetailsBodyState();
}

class _TicketDetailsBodyState extends State<TicketDetailsBody> {
  Future<GetTicketModel?>? ticketDetails;
  @override
  void initState() {
    super.initState();
    ticketDetails = getTicket();
  }

  // api isteği
  Future<GetTicketModel?> getTicket() async {
    try {
      GetTicketServices ticketdetails = GetTicketServices();
      return ticketdetails.getItem(id: widget.id);
    } catch (e) {
      if (kDebugMode) {
        print("itemler çekilirken hata oluştu");
      }
    }
    return null;
  }

  String? dosyayolu;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: kPrimaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(29),
            bottomRight: Radius.circular(29),
          ),
        ),
        backgroundColor: kPrimaryColor,
        title: Text(kTicketListDetailsTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder<GetTicketModel?>(
            future: ticketDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: kCardBoxShodow,
                  ),
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          //boxShadow: kCardBoxShodow,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              kPrimaryColor,
                              kDarkPrimaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Konu Başlığı:  ${snapshot.data!.data!.subject!.toUpperCase()}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(20.0),
                            //   child: Text(
                            //       "Destek Katagorisi:  ${snapshot.data!.data!.categoryName!}"),
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text("Mesaj:  \n${snapshot.data!.data!.body!}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                            "Katagori:  ${snapshot.data!.data!.categoryName!}\n"
                            "Oluşturan:  ${snapshot.data!.data!.createUserName!}"),
                      ),
                      snapshot.data!.data!.files.isEmpty
                          ? const SizedBox()
                          : Container(
                              margin: const EdgeInsets.all(10),
                              height: 65 *
                                  snapshot.data!.data!.files.length.toDouble(),
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.data!.files.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        onTap: () async {
                                          final dio = Dio();

                                          Directory? directory;
                                          if (Platform.isIOS) {
                                            directory =
                                                await getApplicationDocumentsDirectory();
                                          } else if (Platform.isAndroid) {
                                            directory = Directory(
                                                '/storage/emulated/0/Download');
                                            // directory =
                                            //     await getExternalStorageDirectory();
                                          }
                                          File downloadedFile = File(
                                              '${directory?.path}/${snapshot.data!.data!.files[index].fileName}${snapshot.data!.data!.files[index].ext}');
                                          var url =
                                              '${Globals.mediaBaseUrl}${snapshot.data!.data!.files[index].path}';

                                          // final saveDir =
                                          //     await getApplicationDocumentsDirectory();
                                          // final savePath =
                                          //     '${saveDir.path}/${snapshot.data!.data!.files[index].fileName}${snapshot.data!.data!.files[index].ext}';

                                          try {
                                            Response response =
                                                await dio.download(
                                                    url, downloadedFile.path);
                                            if (response.statusCode == 200) {
                                              // print(
                                              //     "Dosya indi: ${downloadedFile.path}");
                                              dosyayolu = downloadedFile.path;
                                              var result = await OpenFilex.open(
                                                  dosyayolu!);
                                              // print(result.message);
                                            } else {
                                              // print("Dosya indirilemedi");
                                            }
                                          } catch (e) {
                                            // print('Dosya indirme hatası: $e');
                                          }
                                        },
                                        leading: const Icon(Icons.attach_file),
                                        title: Text(
                                          "Ek Dosya:  ${snapshot.data!.data!.files[index].fileName}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
