import '../models/register_response_model.dart';

extension ErrorToString on List<ApiError>? {
  String errorToString() {
    String error = '';
    List<ApiError>? errors = this;
    if (errors != null && errors.isNotEmpty) {
      for (int i = 0; i < errors.length; i++) {
        var element = errors[i];
        error +=
            ' ${element.property} : ${element.error}${i == errors.length ? '\n' : ""}';
      }
    } else {
      error = "Beklenmeyen bir hata oluştu, lütfen tekrar deneyiniz";
    }
    return error;
  }
}
