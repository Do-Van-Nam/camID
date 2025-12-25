class ApiEndPoint {
  static String DOMAIN_API = "https://openid.camid.app:8081";
  static String DOMAIN_API_DEV = "";
  static String DOMAIN_API_GATEWAY =
      "https://apigw.camid.app:8423/ApiGateway/CoreService";
  static bool isDev = false;
  static String DOMAIN = isDev ? DOMAIN_API_DEV : DOMAIN_API;

  static String API_SIGN_UP = "$DOMAIN/camid-auth/api/v1/auth/signup";
  static String API_GET_OTP = "$DOMAIN/camid-auth/api/v1/otp";
  static String API_SIGN_IN = "$DOMAIN/camid-auth/api/v1/auth/signin";
  static String API_GET_USER_INFO =
      "$DOMAIN/camid-auth/api/v1/user/get-user-v2";
  static String API_USER_ROUTING = "$DOMAIN_API_GATEWAY/UserRouting";
  static String API_UPDATE_AVATAR =
      "$DOMAIN/camid-auth/api/v1/user/update-avatar";
}
