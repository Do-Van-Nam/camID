import 'package:cam_id/main/data/model/linked_payment_method_model.dart';
import 'package:cam_id/main/data/model/other_payment_method_model.dart';
class PaymentMethodResult {
  final String? errorCode;
  final String? message;
  final dynamic object;
  final String? userMsg;
  final PaymentMethodResponse? wsResponse;

  PaymentMethodResult({
    this.errorCode,
    this.message,
    this.object,
    this.userMsg,
    this.wsResponse,
  });

  factory PaymentMethodResult.fromJson(Map<String, dynamic> json) {
    return PaymentMethodResult(
      errorCode: json['errorCode'],
      message: json['message'],
      object: json['object'],
      userMsg: json['userMsg'],
      wsResponse: json['wsResponse'] != null
          ? PaymentMethodResponse.fromJson(
          json['wsResponse'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PaymentMethodResponse {
  final List<OtherPaymentMethodModel>? otherLinkPaymentMethodList;
  final List<OtherPaymentMethodModel>? syntheticMethodList;
  final List<OtherPaymentMethodModel>? otherPaymentMethodsList;
  final List<LinkedPaymentMethodModel>? linkedPaymentMethodList;
  final String? termsAndCondition;

  PaymentMethodResponse({
    this.otherLinkPaymentMethodList,
    this.syntheticMethodList,
    this.otherPaymentMethodsList,
    this.linkedPaymentMethodList,
    this.termsAndCondition,
  });

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    return PaymentMethodResponse(
      otherLinkPaymentMethodList:
      (json['ortherLinkPaymentMethods'] as List<dynamic>?)
          ?.map((e) => OtherPaymentMethodModel.fromJson(
          e as Map<String, dynamic>))
          .toList(),

      syntheticMethodList:
      (json['syntheticMethods'] as List<dynamic>?)
          ?.map((e) => OtherPaymentMethodModel.fromJson(
          e as Map<String, dynamic>))
          .toList(),

      otherPaymentMethodsList:
      (json['ortherPaymentMethods'] as List<dynamic>?)
          ?.map((e) => OtherPaymentMethodModel.fromJson(
          e as Map<String, dynamic>))
          .toList(),

      linkedPaymentMethodList:
      (json['linkedPaymentMethods'] as List<dynamic>?)
          ?.map((e) => LinkedPaymentMethodModel.fromJson(
          e as Map<String, dynamic>))
          .toList(),

      termsAndCondition: json['termsAndCondition'],
    );
  }
}
