import 'ws_response_data.dart';

class WsResponse {
  final bool success;
  final String? errorCode;
  final String? message;
  final WsResponseData? data;

  WsResponse({required this.success, this.errorCode, this.message, this.data});

  factory WsResponse.fromJson(Map<String, dynamic> json) {
    return WsResponse(
      success: json['success'] as bool? ?? false,
      errorCode: json['errorCode'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? WsResponseData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'errorCode': errorCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
