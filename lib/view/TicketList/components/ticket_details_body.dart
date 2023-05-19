import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';
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

  bool isFileExists = false;
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
                                    return TicketDownloadButton(
                                      isFileExists: isFileExists,
                                      index: index,
                                      snapshot: snapshot,
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

class TicketDownloadButton extends StatefulWidget {
  final bool isFileExists;
  final AsyncSnapshot<GetTicketModel?> snapshot;
  final int index;
  const TicketDownloadButton({
    super.key,
    required this.snapshot,
    required this.index,
    required this.isFileExists,
  });

  @override
  State<TicketDownloadButton> createState() => _TicketDownloadButtonState();
}

class _TicketDownloadButtonState extends State<TicketDownloadButton> {
  static bool _isDownloading = false;
  void _downloadBar() {
    setState(() {
      _isDownloading = !_isDownloading;
    });
  }

  late File? _downloadedFile;

  @override
  void initState() {
    super.initState();
    _setDownloadedFile();
  }

  Future<void> _setDownloadedFile() async {
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    }
    _downloadedFile = File(
        '${directory?.path}/${widget.snapshot.data!.data!.files[widget.index].fileName}${widget.snapshot.data!.data!.files[widget.index].ext}');
  }

  @override
  Widget build(BuildContext context) {
    var url =
        '${Globals.mediaBaseUrl}${widget.snapshot.data!.data!.files[widget.index].path}';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onTap: () async {
          final dio = Dio();

          if (_downloadedFile!.existsSync()) {
            // ignore: use_build_context_synchronously
            QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              title: "Dosya Mevcut",
              text:
                  "Dosya zaten mevcut. İndirmeyi iptal edip açmak veya yeniden indirmek istiyor musunuz?",
              confirmBtnText: "Dosyayı Aç",
              cancelBtnText: "Kapat",
              confirmBtnColor: kPrimaryColor,
              showCancelBtn: true,
              cancelBtnTextStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              onConfirmBtnTap: () async {
                await OpenFilex.open(_downloadedFile?.path);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              onCancelBtnTap: () async {
                Navigator.pop(context);
              },
            );
            return;
          } else if (_downloadedFile?.existsSync() == false) {
            _downloadBar();
            try {
              Response response =
                  await dio.download(url, _downloadedFile?.path);
              if (response.statusCode == 200) {
                await OpenFilex.open(_downloadedFile?.path);
                _downloadBar();
              } else {
                _downloadBar();
                // print("Dosya indirilemedi");
              }
            } catch (e) {
              _downloadBar();
              if (kDebugMode) {
                print(e);
              }
            }
          }
        },
        trailing: _isDownloading
            ? Lottie.asset(
                'assets/lottie/downloadprogress.json',
                height: 50,
                width: 50,
              )
            : _downloadedFile!.existsSync() == false
                ? const Icon(Icons.download_rounded)
                : const Icon(Icons.download_done_rounded, color: Colors.green),
        leading: const Icon(Icons.attach_file),
        title: Text(
          "Ek Dosya:  ${widget.snapshot.data!.data!.files[widget.index].fileName}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
