class Constant {
  Constant._();
  // PAYMENT SEVICE
  static const String TOPUP = "Top-up";
  static const String PROFILE = "profile";
  static const String TOPUP_V2 = "Topup";
  static const String FTTH = "FTTH";
  static const String LUCKY_SPIN = "VASLUCKYSPIN";
  static const String LUCKY_TOPUP = "VASTOPUPSPIN";
  static const String ABA_ACCOUNT = "ABA_ACCOUNT";
  static const String ABA_CARD = "ABA_CARD";
  static const String ABA_KHQR = "ABA_KHQR";
  static const String ABA_ACCOUNT_APP = "ABA_ACCOUNT_APP";
  static const String CREDIT_CARD = "CREDIT_CARD";
  static const String EMONEY = "eMoney";
  static const String EMONEY_WEB = "eMoney_web";
  static const String EMONEY_WEBVIEW = "EMONEY_WEBVIEW";
  static const String WING = "Wing";
  static const String WECHAT = "WECHAT";
  static const String ALIPAY = "Alipay";
  static const String WS_CODE = "wsGetOtpForCamIdDetail";


  static String normalizePhone(String phone) {
    String p = phone.trim();

    if (p.startsWith('+855')) {
      p = p.substring(4);
    } else if (p.startsWith('855')) {
      p = p.substring(3);
    } else if (p.startsWith('0')) {
      p = p.substring(1);
    }

    return p;
  }

  static String normalizePhoneV2(String? phone) {
    if (phone == null || phone.isEmpty) return '';

    var result = phone.trim();

    if (result.startsWith('+855')) {
      result = result.replaceFirst('+855', '0');
    } else if (result.startsWith('855')) {
      result = result.replaceFirst('855', '0');
    } else if (!result.startsWith('0')) {
      result = '0$result';
    }

    return result;
  }

}
