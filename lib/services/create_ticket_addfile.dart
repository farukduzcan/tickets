import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tickets/view/CreateTicket/components/body.dart';

import '../models/user_model.dart';
import 'create_ticket_services.dart';
import 'global.dart';

class CreateTicketServicesFileAdd {
  Future<void> sendFiles(List<File> filePaths) async {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ${UserModel.userToken}';
    List<MultipartFile> multipartFileList = [];
    for (var file in filePaths) {
      String fileName = file.path.split('/').last;
      multipartFileList
          .add(await MultipartFile.fromFile(file.path, filename: fileName));
    }
    FormData formData = FormData.fromMap({
      "Files": multipartFileList,
      "Id": CreateTicketServices.fileUploadId,
    });
    var response = await dio.post('${Globals.apiBaseUrl}ticket/fileUpload',
        data: formData);
    if (response.statusCode == 200) {
      CreateTicketBody.isComplated = true;
    } else {
      throw Exception('Görseller yüklenemedi.');
    }
  }
}
