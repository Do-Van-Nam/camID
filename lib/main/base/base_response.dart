class BaseResponse {
  String? message;
  String? code;
  dynamic data;
  int? status;
  String? errMessage;

  BaseResponse.success(
      {this.data, this.code, this.message, this.status, this.errMessage});

  BaseResponse.error(this.message, {this.data, this.code});

  bool get isSuccess => code != null && code == "00";
  bool get isStatusSuccess => status == 200;
}
