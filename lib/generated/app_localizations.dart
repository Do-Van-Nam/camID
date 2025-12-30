import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('km'),
    Locale('vi'),
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'CamID'**
  String get app_name;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @reward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get reward;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @help_center.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get help_center;

  /// No description provided for @metfone.
  ///
  /// In en, this message translates to:
  /// **'Metfone'**
  String get metfone;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone_number;

  /// No description provided for @enter_your_otp.
  ///
  /// In en, this message translates to:
  /// **'Enter your OTP'**
  String get enter_your_otp;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip now'**
  String get skip;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @title_drawer.
  ///
  /// In en, this message translates to:
  /// **'Click here to log in'**
  String get title_drawer;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @khmer.
  ///
  /// In en, this message translates to:
  /// **'ខ្មែរ'**
  String get khmer;

  /// No description provided for @telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegram;

  /// No description provided for @messenger.
  ///
  /// In en, this message translates to:
  /// **'Messenger'**
  String get messenger;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @enterSearch.
  ///
  /// In en, this message translates to:
  /// **'Enter search...'**
  String get enterSearch;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @voice_call.
  ///
  /// In en, this message translates to:
  /// **'Voice call'**
  String get voice_call;

  /// No description provided for @video_call.
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get video_call;

  /// No description provided for @network_test.
  ///
  /// In en, this message translates to:
  /// **'Network test'**
  String get network_test;

  /// No description provided for @stores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get stores;

  /// No description provided for @find_stores.
  ///
  /// In en, this message translates to:
  /// **'Find stores'**
  String get find_stores;

  /// No description provided for @title_search_find_stores.
  ///
  /// In en, this message translates to:
  /// **'Search for the showroom you want!'**
  String get title_search_find_stores;

  /// No description provided for @tv360.
  ///
  /// In en, this message translates to:
  /// **'Tv 360'**
  String get tv360;

  /// No description provided for @game.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// No description provided for @vasService.
  ///
  /// In en, this message translates to:
  /// **'VAS Services'**
  String get vasService;

  /// No description provided for @feedbackPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback & Rating'**
  String get feedbackPageTitle;

  /// No description provided for @feedbackRatingQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many stars would you rate the app?'**
  String get feedbackRatingQuestion;

  /// No description provided for @feedbackTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackTitleLabel;

  /// No description provided for @feedbackContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Detailed Feedback'**
  String get feedbackContentLabel;

  /// No description provided for @feedbackSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get feedbackSubmitButton;

  /// No description provided for @feedbackUpdateAppButton.
  ///
  /// In en, this message translates to:
  /// **'Update App'**
  String get feedbackUpdateAppButton;

  /// No description provided for @feedbackStartKycButton.
  ///
  /// In en, this message translates to:
  /// **'Start KYC'**
  String get feedbackStartKycButton;

  /// No description provided for @feedbackThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get feedbackThankYou;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get no_data;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'Error occurred, please try again later.'**
  String get error_occurred;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @your_information.
  ///
  /// In en, this message translates to:
  /// **'Your Information'**
  String get your_information;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get date_of_birth;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @id_passport_no.
  ///
  /// In en, this message translates to:
  /// **'ID/Passport No'**
  String get id_passport_no;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @link_bank_account.
  ///
  /// In en, this message translates to:
  /// **'LINK BANK ACCOUNT'**
  String get link_bank_account;

  /// No description provided for @link_aba_account_credit_debit_card.
  ///
  /// In en, this message translates to:
  /// **'Link ABA account or Credit/Debit Card'**
  String get link_aba_account_credit_debit_card;

  /// No description provided for @add_another.
  ///
  /// In en, this message translates to:
  /// **'+ add another'**
  String get add_another;

  /// No description provided for @choose_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Choose a payment method'**
  String get choose_payment_method;

  /// No description provided for @by_adding_.
  ///
  /// In en, this message translates to:
  /// **'By adding account or card, I hereby acknowledge that I have read, understand and agree with '**
  String get by_adding_;

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions.'**
  String get terms_and_conditions;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @otp_sent_to.
  ///
  /// In en, this message translates to:
  /// **'OTP has been sent to'**
  String get otp_sent_to;

  /// No description provided for @didn_t_otp.
  ///
  /// In en, this message translates to:
  /// **'Didn’t receive a OTP?'**
  String get didn_t_otp;

  /// No description provided for @resend_otp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resend_otp;

  /// No description provided for @incorrect_pin_otp.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN code'**
  String get incorrect_pin_otp;

  /// No description provided for @identity_verified.
  ///
  /// In en, this message translates to:
  /// **'Identity Verified'**
  String get identity_verified;

  /// No description provided for @identity_verifying.
  ///
  /// In en, this message translates to:
  /// **'Identity Verifying'**
  String get identity_verifying;

  /// No description provided for @identity_rejected.
  ///
  /// In en, this message translates to:
  /// **'Identity Rejected'**
  String get identity_rejected;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @select_id_type.
  ///
  /// In en, this message translates to:
  /// **'Select ID type'**
  String get select_id_type;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @title_verifying.
  ///
  /// In en, this message translates to:
  /// **'Let’s start verifying your personal information'**
  String get title_verifying;

  /// No description provided for @cambodia_id_card.
  ///
  /// In en, this message translates to:
  /// **'Cambodia ID Card'**
  String get cambodia_id_card;

  /// No description provided for @passport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get passport;

  /// No description provided for @army_id.
  ///
  /// In en, this message translates to:
  /// **'Army ID'**
  String get army_id;

  /// No description provided for @police_id.
  ///
  /// In en, this message translates to:
  /// **'Police ID'**
  String get police_id;

  /// No description provided for @monk_id.
  ///
  /// In en, this message translates to:
  /// **'Monk ID'**
  String get monk_id;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @title_update_version.
  ///
  /// In en, this message translates to:
  /// **'The lastest version is already installed'**
  String get title_update_version;

  /// No description provided for @qr_code.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qr_code;

<<<<<<< HEAD
  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get name;

  /// No description provided for @loyaltyPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'031 3828606'**
  String get loyaltyPhoneNumber;

  /// Current points
  ///
  /// In en, this message translates to:
  /// **'{points} Points'**
  String loyaltyPoints(Object points);

  /// No description provided for @loyaltyReward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get loyaltyReward;

  /// No description provided for @loyaltyTierBenefits.
  ///
  /// In en, this message translates to:
  /// **'Tier Benefits'**
  String get loyaltyTierBenefits;

  /// No description provided for @loyaltyHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get loyaltyHistory;

  /// No description provided for @loyaltyBannerText.
  ///
  /// In en, this message translates to:
  /// **'Accommodation & Hotels up to 30% off\nBest stays'**
  String get loyaltyBannerText;

  /// No description provided for @loyaltyRewardCoupon.
  ///
  /// In en, this message translates to:
  /// **'Reward - Coupon'**
  String get loyaltyRewardCoupon;

  /// No description provided for @loyaltyVoucher.
  ///
  /// In en, this message translates to:
  /// **'Voucher'**
  String get loyaltyVoucher;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @loyaltyPlazaPremiumGroup.
  ///
  /// In en, this message translates to:
  /// **'Plaza Premium Group'**
  String get loyaltyPlazaPremiumGroup;

  /// Number of exchanged coupons
  ///
  /// In en, this message translates to:
  /// **'Exchanged {exchanged}/{total}'**
  String loyaltyExchanged(Object exchanged, Object total);

  /// No description provided for @loyaltyFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get loyaltyFree;

  /// No description provided for @loyaltyRedeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get loyaltyRedeem;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationTitle;

  /// No description provided for @notificationTabNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get notificationTabNews;

  /// No description provided for @notificationTabComplain.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get notificationTabComplain;

  /// No description provided for @notificationEmptyNews.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationEmptyNews;

  /// No description provided for @notificationEmptyComplain.
  ///
  /// In en, this message translates to:
  /// **'No complaints'**
  String get notificationEmptyComplain;

  /// No description provided for @notificationReadAll.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationReadAll;

  /// No description provided for @notificationClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get notificationClearAll;

  /// No description provided for @phone_number_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'Phone number is not valid!'**
  String get phone_number_is_not_valid;

=======
>>>>>>> origin/main
  /// No description provided for @chatbotTitle.
  ///
  /// In en, this message translates to:
  /// **'CamID ChatBot'**
  String get chatbotTitle;

  /// No description provided for @chatbotGreeting.
  ///
  /// In en, this message translates to:
  /// **'How may I help you today!'**
  String get chatbotGreeting;

  /// No description provided for @chatbotDescription.
  ///
  /// In en, this message translates to:
  /// **'This AI chatbot is for customer service, wishing to support customers in the best way!'**
  String get chatbotDescription;

  /// No description provided for @chatbotStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get chatbotStart;

  /// No description provided for @chatbotContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get chatbotContinue;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get online;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @mainMenu.
  ///
  /// In en, this message translates to:
  /// **'Main menu'**
  String get mainMenu;

  /// No description provided for @changePhoneNumberLogin.
  ///
  /// In en, this message translates to:
  /// **'Change phone number login'**
  String get changePhoneNumberLogin;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get newChat;

  /// No description provided for @callTheStaffs.
  ///
  /// In en, this message translates to:
  /// **'Call the staffs'**
  String get callTheStaffs;

<<<<<<< HEAD
  /// No description provided for @loyaltyCamID.
  ///
  /// In en, this message translates to:
  /// **'CamID'**
  String get loyaltyCamID;

  /// Points needed to next tier
  ///
  /// In en, this message translates to:
  /// **'{points} Points more to rank up Silver'**
  String loyaltyNextTier(Object points);

  /// No description provided for @loyaltyShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get loyaltyShopping;

  /// No description provided for @loyaltyRestaurantHotel.
  ///
  /// In en, this message translates to:
  /// **'Restaurant - Hotel'**
  String get loyaltyRestaurantHotel;

  /// No description provided for @loyaltyHealthCare.
  ///
  /// In en, this message translates to:
  /// **'Health Care'**
  String get loyaltyHealthCare;

  /// No description provided for @loyaltyTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get loyaltyTravel;

  /// No description provided for @loyaltyBannerPromotion.
  ///
  /// In en, this message translates to:
  /// **'1\$ = 2500\$'**
  String get loyaltyBannerPromotion;

  /// No description provided for @connectWithUs.
  ///
  /// In en, this message translates to:
  /// **'Connect with us'**
  String get connectWithUs;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @clickHereToLogin.
  ///
  /// In en, this message translates to:
  /// **'Click here to login'**
  String get clickHereToLogin;

  /// No description provided for @myGift.
  ///
  /// In en, this message translates to:
  /// **'My Gift'**
  String get myGift;

  /// No description provided for @ranking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @trendingNow.
  ///
  /// In en, this message translates to:
  /// **'Trending now'**
  String get trendingNow;

  /// No description provided for @specialGame.
  ///
  /// In en, this message translates to:
  /// **'Special Game'**
  String get specialGame;

  /// No description provided for @theUltimateRacer.
  ///
  /// In en, this message translates to:
  /// **'The Ultimate Racer'**
  String get theUltimateRacer;

  /// No description provided for @playerCount.
  ///
  /// In en, this message translates to:
  /// **'player'**
  String get playerCount;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;
=======
  /// No description provided for @login_des.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the CamID, your digital passport.'**
  String get login_des;

  /// No description provided for @enter_your_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enter_your_phone_number;

  /// No description provided for @identity_verification.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get identity_verification;
>>>>>>> origin/main
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'km', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
