import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
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
/// import 'l10n/app_localizations.dart';
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
    Locale('vi'),
  ];

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// Section header for language settings
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get settingSectionHeader;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Netmu'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Netmu'**
  String get welcomeTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back.'**
  String get loginSubtitle;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginFooter.
  ///
  /// In en, this message translates to:
  /// **'Do not have an account?'**
  String get loginFooter;

  /// No description provided for @loginFooterAction.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginFooterAction;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started today.'**
  String get registerSubtitle;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerButton;

  /// No description provided for @registerFooter.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get registerFooter;

  /// No description provided for @registerFooterAction.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get registerFooterAction;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @oldPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. JohnDoe'**
  String get usernameHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'abc@gmail.com'**
  String get emailHint;

  /// No description provided for @requiredUsername.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get requiredUsername;

  /// No description provided for @minUsername.
  ///
  /// In en, this message translates to:
  /// **'At least 3 characters required'**
  String get minUsername;

  /// No description provided for @requiredEmail.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get requiredEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @requiredPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get requiredPassword;

  /// No description provided for @minPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get minPassword;

  /// No description provided for @confirmPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Confirm password must match new password'**
  String get confirmPasswordMismatch;

  /// No description provided for @requiredOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password is required'**
  String get requiredOldPassword;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @synopsis.
  ///
  /// In en, this message translates to:
  /// **'Synopsis'**
  String get synopsis;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @infoDirector.
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get infoDirector;

  /// No description provided for @infoDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get infoDuration;

  /// No description provided for @infoGenres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get infoGenres;

  /// No description provided for @watchNow.
  ///
  /// In en, this message translates to:
  /// **'Watch Now'**
  String get watchNow;

  /// No description provided for @directedBy.
  ///
  /// In en, this message translates to:
  /// **'Directed by {director}'**
  String directedBy(String director);

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordButton;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get sectionAccount;

  /// No description provided for @sectionSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sectionSettings;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @updateProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Update profile'**
  String get updateProfileButton;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurs'**
  String get unexpectedError;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @emptyNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get emptyNotifications;

  /// No description provided for @emptyNotificationsSub.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up. Check back later.'**
  String get emptyNotificationsSub;

  /// No description provided for @failedLoadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get failedLoadNotifications;

  /// No description provided for @videoPlayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Video Player'**
  String get videoPlayerTitle;

  /// No description provided for @popularSectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popularSectionHeader;

  /// No description provided for @discoverSectionHeader.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverSectionHeader;
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
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
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
