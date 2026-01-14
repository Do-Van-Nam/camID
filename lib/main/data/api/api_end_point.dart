class ApiEndPoint {
  static String DOMAIN_API = "https://openid.camid.app:8081";
  static String DOMAIN_API_DEV = "";
  static String DOMAIN_API_GATEWAY =
      "https://apigw.camid.app:8423/ApiGateway/CoreService";
  static bool isDev = false;
  static String DOMAIN = isDev ? DOMAIN_API_DEV : DOMAIN_API;
  static String API_KEY =
      "5E648E0585B500A5CB8F0B392D4965A8176E352E1DC3A4FE31186CEB0EA5BE46";
  static String API_KEY_V2 = "6CB8FC45D491D87CECB53428D79423BD";

  static String API_SIGN_UP = "$DOMAIN/camid-auth/api/v1/auth/signup";
  static String API_GET_OTP = "$DOMAIN/camid-auth/api/v1/otp";
  static String API_SIGN_IN = "$DOMAIN/camid-auth/api/v1/auth/signin";
  static String API_GET_USER_INFO =
      "$DOMAIN/camid-auth/api/v1/user/get-user-v2";
  static String API_USER_ROUTING = "$DOMAIN_API_GATEWAY/UserRouting";
  static String API_UPDATE_AVATAR =
      "$DOMAIN/camid-auth/api/v1/user/update-avatar";
  static String API_UPDATE_USER =
      "$DOMAIN/camid-auth/api/v1/user/update-user-v2";

  // chatbot
}

class WSCode {
  static String wsHistoryChargeV2 = "wsHistoryChargeV2";
  static String wsHistoryChargeDetailV2 = "wsHistoryChargeDetailV2";
  static String wsGetAccountsOcsDetailV2 = "wsGetAccountsOcsDetailV2";
  static String wsGetAllApps = "wsGetAllApps";
  static String wsGetServicesByGroup = "wsGetServicesByGroup";
  static String wsDetectOCRFromImage = "wsDetectOCRFromImage";
  static String getPackageInforV2 = "getPackageInforV2";
  static String wsInitLinkedPayment = "wsInitLinkedPayment";
  static String wsCheckLinkedPaymentEmoney = "wsCheckLinkedPaymentEmoney";
  static String wsGetListPaymentMethod = "wsGetListPaymentMethod";
  static String wsGenerateQRCodeFTTHCommission =
      "wsGenerateQRCodeFTTHCommission";
  static String wsAbaCheckAbaCard = "wsAbaCheckAbaCard";
  static String wsGetOTPByService = "wsGetOTPByService";
  static String wsConfirmOTP = "wsConfirmOTP";
  static String getListPaperType = "getListPaperType";
  static String wsPaymentHistory = "wsPaymentHistory";
  static String wsGetListAutoRenew = "wsGetListAutoRenew";
  static String wsGetCurrentUsedServices = "wsGetCurrentUsedServices";
  static String wsGetServices = "wsGetServices";
  static String wsDoActionService = "wsDoActionService";
  static String wsGetAccountsOcsDetail = "wsGetAccountsOcsDetail";
  //chat bot
  static String wsGetMenu = "get-menu";
  static String wsSuggestQuestion = "suggest-question";
  static String wsSuggestMenu = "suggest-menu";
  static String wsFaqQuery = "faq-query";
}
