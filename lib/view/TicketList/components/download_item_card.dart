import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../constants.dart';
import '../../../models/get_ticket_model.dart';
import '../../../services/global.dart';

class TicketDownloadButton extends StatefulWidget {
  final AsyncSnapshot<GetTicketModel?> snapshot;
  final int index;
  const TicketDownloadButton({
    super.key,
    required this.snapshot,
    required this.index,
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

  Icon _leadingIcon() {
    var fileExt = widget.snapshot.data!.data!.files[widget.index].ext;
    if (fileExt == '.jpg' || fileExt == '.png' || fileExt == '.jpeg') {
      return const Icon(
        Icons.image_outlined,
        color: Colors.grey,
      );
    } else if (fileExt == '.mp4' ||
        fileExt == '.avi' ||
        fileExt == '.mov' ||
        fileExt == '.wmv' ||
        fileExt == '.flv' ||
        fileExt == '.mkv') {
      return Icon(
        Icons.video_library_outlined,
        color: Colors.purple.shade400,
      );
    } else if (fileExt == '.pdf') {
      return Icon(
        Icons.picture_as_pdf_outlined,
        color: Colors.red.shade300,
      );
    } else if (fileExt == '.docx' || fileExt == '.doc') {
      return Icon(
        Icons.description_outlined,
        color: Colors.blue.shade300,
      );
    } else {
      return const Icon(Icons.attach_file);
    }
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
        leading: _leadingIcon(),
        title: Text(
          "Ek Dosya:  ${widget.snapshot.data!.data!.files[widget.index].fileName}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
