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

  /// No description provided for @phone_number_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'Phone number is not valid!'**
  String get phone_number_is_not_valid;

  /// No description provided for @aaaaaaaaaaaaaaaaaaaaaaaaaaa.
  ///
  /// In en, this message translates to:
  /// **'aaaaaaaaaaaaaaaaaaaaaaaaaaa'**
  String get aaaaaaaaaaaaaaaaaaaaaaaaaaa;

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

  /// No description provided for @notificationClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get notificationClearAll;

  /// No description provided for @loyaltyCamID.
  ///
  /// In en, this message translates to:
  /// **'CamID'**
  String get loyaltyCamID;

  /// Display accumulated points
  ///
  /// In en, this message translates to:
  /// **'{points} Points'**
  String loyaltyPoints(Object points);

  /// Points needed to next tier
  ///
  /// In en, this message translates to:
  /// **'{points} Points more to rank up Silver'**
  String loyaltyNextTier(Object points);

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

  /// No description provided for @loyaltyReward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get loyaltyReward;

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

  /// Number of exchanged coupons
  ///
  /// In en, this message translates to:
  /// **'Exchanged: {exchanged}'**
  String loyaltyExchanged(Object exchanged, Object total);

  /// No description provided for @loyaltyRedeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get loyaltyRedeem;

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

  /// No description provided for @wifiFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Help us improve CamID\'s WiFi service. Your experience matters to us!'**
  String get wifiFeedbackTitle;

  /// No description provided for @rateYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate your experience'**
  String get rateYourExperience;

  /// No description provided for @satisfactionLevel.
  ///
  /// In en, this message translates to:
  /// **'Satisfaction level'**
  String get satisfactionLevel;

  /// No description provided for @satisfied.
  ///
  /// In en, this message translates to:
  /// **'Satisfied'**
  String get satisfied;

  /// No description provided for @speedOfInternet.
  ///
  /// In en, this message translates to:
  /// **'Speed of internet'**
  String get speedOfInternet;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @customerService.
  ///
  /// In en, this message translates to:
  /// **'Customer service'**
  String get customerService;

  /// No description provided for @technicalSupport.
  ///
  /// In en, this message translates to:
  /// **'Technical support'**
  String get technicalSupport;

  /// No description provided for @enterYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Enter your experience...'**
  String get enterYourExperience;

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

  /// No description provided for @loyaltyBannerText.
  ///
  /// In en, this message translates to:
  /// **'Accommodation & Hotels up to 30% off\nBest stays'**
  String get loyaltyBannerText;

  /// No description provided for @loyaltyPlazaPremiumGroup.
  ///
  /// In en, this message translates to:
  /// **'Plaza Premium Group'**
  String get loyaltyPlazaPremiumGroup;

  /// No description provided for @loyaltyFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get loyaltyFree;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get used;

  /// No description provided for @telecommunications.
  ///
  /// In en, this message translates to:
  /// **'Telecommunications'**
  String get telecommunications;

  /// No description provided for @pointsPlus.
  ///
  /// In en, this message translates to:
  /// **'+{count} points'**
  String pointsPlus(Object count);

  /// No description provided for @pointsMinus.
  ///
  /// In en, this message translates to:
  /// **'-{count} points'**
  String pointsMinus(Object count);

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

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

  /// No description provided for @informationTitle.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get informationTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameHint;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// No description provided for @accountFtthLabel.
  ///
  /// In en, this message translates to:
  /// **'Account FTTH'**
  String get accountFtthLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneNumberHint;

  /// No description provided for @accountFtthHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your account FTTH'**
  String get accountFtthHint;

  /// No description provided for @feedbackSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Successfully sent feedback'**
  String get feedbackSuccessTitle;

  /// No description provided for @feedbackSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback, we have noted your feedback.'**
  String get feedbackSuccessMessage;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @readAll.
  ///
  /// In en, this message translates to:
  /// **'Read all'**
  String get readAll;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @noNotiTitle.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet'**
  String get noNotiTitle;

  /// No description provided for @suggestionsForYou.
  ///
  /// In en, this message translates to:
  /// **'Suggestions for you'**
  String get suggestionsForYou;

  /// No description provided for @ftth.
  ///
  /// In en, this message translates to:
  /// **'FTTH'**
  String get ftth;

  /// No description provided for @esim.
  ///
  /// In en, this message translates to:
  /// **'Esim'**
  String get esim;

  /// No description provided for @myServices.
  ///
  /// In en, this message translates to:
  /// **'My services'**
  String get myServices;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @topUp.
  ///
  /// In en, this message translates to:
  /// **'Top Up'**
  String get topUp;

  /// No description provided for @exchangeDamagedCard.
  ///
  /// In en, this message translates to:
  /// **'Exchange damaged card'**
  String get exchangeDamagedCard;

  /// No description provided for @chatbot.
  ///
  /// In en, this message translates to:
  /// **'Chatbot'**
  String get chatbot;

  /// No description provided for @networkTest.
  ///
  /// In en, this message translates to:
  /// **'Network test'**
  String get networkTest;

  /// No description provided for @mostSearched.
  ///
  /// In en, this message translates to:
  /// **'Most searched'**
  String get mostSearched;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @getNow.
  ///
  /// In en, this message translates to:
  /// **'Get Now'**
  String get getNow;

  /// No description provided for @prizeList.
  ///
  /// In en, this message translates to:
  /// **'Prize List'**
  String get prizeList;

  /// No description provided for @myPrize.
  ///
  /// In en, this message translates to:
  /// **'My Prize'**
  String get myPrize;

  /// No description provided for @prize.
  ///
  /// In en, this message translates to:
  /// **'Prize'**
  String get prize;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'Wifi'**
  String get wifi;

  /// No description provided for @emoney.
  ///
  /// In en, this message translates to:
  /// **'E-Money'**
  String get emoney;

  /// No description provided for @mobileVasEmoney.
  ///
  /// In en, this message translates to:
  /// **'Mobile/VAS/e-Money'**
  String get mobileVasEmoney;

  /// No description provided for @ftthTv360.
  ///
  /// In en, this message translates to:
  /// **'FTTH/TV360'**
  String get ftthTv360;

  /// No description provided for @enterAccountToVerify.
  ///
  /// In en, this message translates to:
  /// **'Please enter Account number to verify'**
  String get enterAccountToVerify;

  /// No description provided for @enterAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter account number'**
  String get enterAccountNumber;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP has been sent to'**
  String get otpSentTo;

  /// No description provided for @didNotReceiveOtp.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive a OTP?'**
  String get didNotReceiveOtp;

  /// No description provided for @requestProcessed.
  ///
  /// In en, this message translates to:
  /// **'Request in processed'**
  String get requestProcessed;

  /// No description provided for @noHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}, there is no historical information reflecting your experience with the {service} service.'**
  String noHistoryFound(Object name, Object service);

  /// No description provided for @changeAccount.
  ///
  /// In en, this message translates to:
  /// **'Change Account'**
  String get changeAccount;

  /// No description provided for @addFeedback.
  ///
  /// In en, this message translates to:
  /// **'Add Feedback'**
  String get addFeedback;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get selectType;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get customerName;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get accountNumber;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @complaintType.
  ///
  /// In en, this message translates to:
  /// **'Complaint type'**
  String get complaintType;

  /// No description provided for @enterFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your feedback here'**
  String get enterFeedbackHint;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get uploadPhoto;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @successfully.
  ///
  /// In en, this message translates to:
  /// **'Successfully'**
  String get successfully;

  /// No description provided for @feedbackSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'We will review it within 2 days then let you know by notification. Please login to your Camid account to get notification about your feedback'**
  String get feedbackSuccessMsg;

  /// No description provided for @statusReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get statusReceived;

  /// No description provided for @statusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get statusProcessing;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get statusClosed;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service type'**
  String get serviceType;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmChangeAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to change account feedback services?'**
  String get confirmChangeAccount;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @feedbackDetail.
  ///
  /// In en, this message translates to:
  /// **'Feedback Detail'**
  String get feedbackDetail;

  /// No description provided for @receiveDate.
  ///
  /// In en, this message translates to:
  /// **'Receive date'**
  String get receiveDate;

  /// No description provided for @expectedDeadline.
  ///
  /// In en, this message translates to:
  /// **'Expected deadline'**
  String get expectedDeadline;

  /// No description provided for @evaluateQuality.
  ///
  /// In en, this message translates to:
  /// **'Evaluate quality of feedback'**
  String get evaluateQuality;

  /// No description provided for @satisfy.
  ///
  /// In en, this message translates to:
  /// **'Satisfy'**
  String get satisfy;

  /// No description provided for @notSatisfy.
  ///
  /// In en, this message translates to:
  /// **'Not satisfy'**
  String get notSatisfy;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @tierBenefits.
  ///
  /// In en, this message translates to:
  /// **'Tier Benefits'**
  String get tierBenefits;

  /// No description provided for @bronzeMember.
  ///
  /// In en, this message translates to:
  /// **'BRONZE MEMBER'**
  String get bronzeMember;

  /// No description provided for @usedPoints.
  ///
  /// In en, this message translates to:
  /// **'Used points'**
  String get usedPoints;

  /// No description provided for @upgradeToGold.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Gold'**
  String get upgradeToGold;

  /// No description provided for @needPoints.
  ///
  /// In en, this message translates to:
  /// **'Need {count} Points'**
  String needPoints(Object count);

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get viewHistory;

  /// No description provided for @bronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get bronze;

  /// No description provided for @silver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get silver;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @diamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond'**
  String get diamond;

  /// No description provided for @requirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirements;

  /// No description provided for @pointsNeeded.
  ///
  /// In en, this message translates to:
  /// **'Points Needed'**
  String get pointsNeeded;

  /// No description provided for @activePeriod.
  ///
  /// In en, this message translates to:
  /// **'Active Period'**
  String get activePeriod;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'{count} Months'**
  String months(Object count);

  /// No description provided for @exclusivePrivileges.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Privileges'**
  String get exclusivePrivileges;

  /// No description provided for @privilege1.
  ///
  /// In en, this message translates to:
  /// **'Receive 100,000 reward points on your birthday.'**
  String get privilege1;

  /// No description provided for @privilege2.
  ///
  /// In en, this message translates to:
  /// **'Prioritize prompt resolution of customer issues and complaints.'**
  String get privilege2;

  /// No description provided for @privilege3.
  ///
  /// In en, this message translates to:
  /// **'Redeem points for rewards and partner programs.'**
  String get privilege3;

  /// No description provided for @privilege4.
  ///
  /// In en, this message translates to:
  /// **'Deposit fee waived when increasing your credit limit up to 10 million VND.'**
  String get privilege4;

  /// No description provided for @privilege5.
  ///
  /// In en, this message translates to:
  /// **'Dedicated customer service hotline'**
  String get privilege5;

  /// No description provided for @aaaaaaaaaaaaaaaaaaaaaaaaaaaa.
  ///
  /// In en, this message translates to:
  /// **'aaaaaaaaaaaaaaaaaaaaaaaaaaa'**
  String get aaaaaaaaaaaaaaaaaaaaaaaaaaaa;

  /// No description provided for @take_a_photo.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get take_a_photo;

  /// No description provided for @front_side.
  ///
  /// In en, this message translates to:
  /// **'Front side'**
  String get front_side;

  /// No description provided for @back_side.
  ///
  /// In en, this message translates to:
  /// **'Back side'**
  String get back_side;

  /// No description provided for @visa.
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get visa;

  /// No description provided for @portrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get portrait;

  /// No description provided for @text_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get text_continue;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get full_name;

  /// No description provided for @enter_your_full_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enter_your_full_name;

  /// No description provided for @enter_your_id.
  ///
  /// In en, this message translates to:
  /// **'Enter your ID'**
  String get enter_your_id;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @enter_your_full_address.
  ///
  /// In en, this message translates to:
  /// **'Enter your full address'**
  String get enter_your_full_address;

  /// No description provided for @my_services.
  ///
  /// In en, this message translates to:
  /// **'My services'**
  String get my_services;

  /// No description provided for @payment_history.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get payment_history;

  /// No description provided for @services_for_you.
  ///
  /// In en, this message translates to:
  /// **'Services for you'**
  String get services_for_you;

  /// No description provided for @my_usage.
  ///
  /// In en, this message translates to:
  /// **'My Usage'**
  String get my_usage;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @roaming.
  ///
  /// In en, this message translates to:
  /// **'Roaming'**
  String get roaming;

  /// No description provided for @top_up.
  ///
  /// In en, this message translates to:
  /// **'Top Up'**
  String get top_up;

  /// No description provided for @exchanged_damaged_card.
  ///
  /// In en, this message translates to:
  /// **'Exchange damaged card'**
  String get exchanged_damaged_card;

  /// No description provided for @ftth_package.
  ///
  /// In en, this message translates to:
  /// **'FTTH Package'**
  String get ftth_package;

  /// No description provided for @mobile_package.
  ///
  /// In en, this message translates to:
  /// **'Mobile Package'**
  String get mobile_package;

  /// No description provided for @charge_history.
  ///
  /// In en, this message translates to:
  /// **'Charge history'**
  String get charge_history;

  /// No description provided for @scan_card.
  ///
  /// In en, this message translates to:
  /// **'Scan card'**
  String get scan_card;

  /// No description provided for @account_detail.
  ///
  /// In en, this message translates to:
  /// **'Account detail'**
  String get account_detail;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get remaining;

  /// No description provided for @due_date.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get due_date;

  /// No description provided for @account_balance.
  ///
  /// In en, this message translates to:
  /// **'Account Balance'**
  String get account_balance;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @internet_wifi.
  ///
  /// In en, this message translates to:
  /// **'Internet Wifi'**
  String get internet_wifi;

  /// No description provided for @buy_e_sim.
  ///
  /// In en, this message translates to:
  /// **'Buy e-SIM'**
  String get buy_e_sim;

  /// No description provided for @metfone_services.
  ///
  /// In en, this message translates to:
  /// **'Metfone services'**
  String get metfone_services;

  /// No description provided for @scan_scratch_card.
  ///
  /// In en, this message translates to:
  /// **'Scan scratch card'**
  String get scan_scratch_card;

  /// No description provided for @account_details.
  ///
  /// In en, this message translates to:
  /// **'Account details'**
  String get account_details;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get view_details;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'message'**
  String get message;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'messages'**
  String get messages;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'second'**
  String get second;

  /// No description provided for @service_.
  ///
  /// In en, this message translates to:
  /// **'service'**
  String get service_;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'services'**
  String get services;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get last30Days;

  /// No description provided for @customDay.
  ///
  /// In en, this message translates to:
  /// **'Custom day'**
  String get customDay;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet_connection;

  /// No description provided for @auto_renew.
  ///
  /// In en, this message translates to:
  /// **'Auto renew'**
  String get auto_renew;

  /// No description provided for @service_for_you.
  ///
  /// In en, this message translates to:
  /// **'Service for you'**
  String get service_for_you;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @confirm_off_service_title.
  ///
  /// In en, this message translates to:
  /// **'Do you want to OFF auto-renew?'**
  String get confirm_off_service_title;

  /// No description provided for @confirm_on_service_title.
  ///
  /// In en, this message translates to:
  /// **'Do you want to cancel the old package and sign up a new one?'**
  String get confirm_on_service_title;

  /// No description provided for @account_status.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get account_status;

  /// No description provided for @until_date.
  ///
  /// In en, this message translates to:
  /// **'Until date'**
  String get until_date;

  /// No description provided for @from_date.
  ///
  /// In en, this message translates to:
  /// **'From date'**
  String get from_date;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @expired_validity.
  ///
  /// In en, this message translates to:
  /// **'Expired validity'**
  String get expired_validity;

  /// No description provided for @temporarily_suspended.
  ///
  /// In en, this message translates to:
  /// **'Temporarily suspended'**
  String get temporarily_suspended;

  /// No description provided for @free_call_to_hotline.
  ///
  /// In en, this message translates to:
  /// **'Free call to hotline'**
  String get free_call_to_hotline;

  /// No description provided for @police.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get police;

  /// No description provided for @fire_truck.
  ///
  /// In en, this message translates to:
  /// **'Fire Truck'**
  String get fire_truck;

  /// No description provided for @ambulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get ambulance;

  /// No description provided for @until.
  ///
  /// In en, this message translates to:
  /// **'until'**
  String get until;

  /// No description provided for @text_active_1.
  ///
  /// In en, this message translates to:
  /// **'Make outgoing/incoming calls, send SMS and access data as normal'**
  String get text_active_1;

  /// No description provided for @text_active_2.
  ///
  /// In en, this message translates to:
  /// **'Your main balance can use for register any packages or any services or you can call/sms off-net or call overseas'**
  String get text_active_2;

  /// No description provided for @text_expired_1.
  ///
  /// In en, this message translates to:
  /// **'Get incoming call and receive sms as normal'**
  String get text_expired_1;

  /// No description provided for @text_expired_2.
  ///
  /// In en, this message translates to:
  /// **'Your main balance cannot be used'**
  String get text_expired_2;

  /// No description provided for @text_expired_3.
  ///
  /// In en, this message translates to:
  /// **'Your package for using internet, outgoing calls, SMS is temporarily suspended'**
  String get text_expired_3;

  /// No description provided for @text_suspended_1.
  ///
  /// In en, this message translates to:
  /// **'Incoming/outgoing calls, SMS is temporarily suspended'**
  String get text_suspended_1;

  /// No description provided for @text_suspended_2.
  ///
  /// In en, this message translates to:
  /// **'Your package for using internet or using main balance is temporarily suspended'**
  String get text_suspended_2;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @top_up_number.
  ///
  /// In en, this message translates to:
  /// **'Top-up number'**
  String get top_up_number;

  /// No description provided for @content_auto_renew_FTTH.
  ///
  /// In en, this message translates to:
  /// **'Auto renew at the end of validity date'**
  String get content_auto_renew_FTTH;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// No description provided for @choose_an_option.
  ///
  /// In en, this message translates to:
  /// **'Choose an option'**
  String get choose_an_option;

  /// No description provided for @internet_wifi_account.
  ///
  /// In en, this message translates to:
  /// **'Internet Wifi account'**
  String get internet_wifi_account;

  /// No description provided for @enter_your_internet_wifi_account.
  ///
  /// In en, this message translates to:
  /// **'Enter your Internet wifi account'**
  String get enter_your_internet_wifi_account;

  /// No description provided for @change_package.
  ///
  /// In en, this message translates to:
  /// **'Change Package'**
  String get change_package;

  /// No description provided for @package.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get package;

  /// No description provided for @refer_friend.
  ///
  /// In en, this message translates to:
  /// **'Refer Friend'**
  String get refer_friend;

  /// No description provided for @speed_test.
  ///
  /// In en, this message translates to:
  /// **'Speed Test'**
  String get speed_test;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @my_order.
  ///
  /// In en, this message translates to:
  /// **'My Order'**
  String get my_order;

  /// No description provided for @recommend_for_you.
  ///
  /// In en, this message translates to:
  /// **'Recommend for you'**
  String get recommend_for_you;
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
