class ApiEndPoint {
  static String DOMAIN_API = "https://openid.camid.app:8081";
  static String DOMAIN_API_DEV = "";
  static bool isDev = false;
  static String DOMAIN = isDev ? DOMAIN_API_DEV : DOMAIN_API;
  static String API_SIGN_UP = "$DOMAIN/camid-auth/api/v1/auth/signup";
  static String API_GET_OTP = "$DOMAIN/camid-auth/api/v1/otp";
  static String API_SIGN_IN = "$DOMAIN/camid-auth/api/v1/auth/signin";

}