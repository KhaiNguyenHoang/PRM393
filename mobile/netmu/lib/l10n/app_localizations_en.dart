// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get settingSectionHeader => 'LANGUAGE';

  @override
  String get appTitle => 'Netmu';

  @override
  String get welcomeTitle => 'Welcome to Netmu';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginSubtitle => 'Welcome back.';

  @override
  String get loginButton => 'Login';

  @override
  String get loginFooter => 'Do not have an account?';

  @override
  String get loginFooterAction => 'Create account';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Sign up to get started today.';

  @override
  String get registerButton => 'Create account';

  @override
  String get registerFooter => 'Already have an account?';

  @override
  String get registerFooterAction => 'Login';

  @override
  String get usernameLabel => 'Username';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get oldPasswordLabel => 'Old password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get usernameHint => 'e.g. JohnDoe';

  @override
  String get emailHint => 'abc@gmail.com';

  @override
  String get requiredUsername => 'Username is required';

  @override
  String get minUsername => 'At least 3 characters required';

  @override
  String get requiredEmail => 'Email is required';

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String get requiredPassword => 'Password is required';

  @override
  String get minPassword => 'Password must be at least 8 characters';

  @override
  String get confirmPasswordMismatch =>
      'Confirm password must match new password';

  @override
  String get requiredOldPassword => 'Old password is required';

  @override
  String get navProfile => 'Profile';

  @override
  String get navHome => 'Home';

  @override
  String get navSettings => 'Settings';

  @override
  String get synopsis => 'Synopsis';

  @override
  String get readMore => 'Read more';

  @override
  String get showLess => 'Show less';

  @override
  String get details => 'Details';

  @override
  String get infoDirector => 'Director';

  @override
  String get infoDuration => 'Duration';

  @override
  String get infoGenres => 'Genres';

  @override
  String get watchNow => 'Watch Now';

  @override
  String directedBy(String director) {
    return 'Directed by $director';
  }

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordButton => 'Change password';

  @override
  String get logOut => 'Log Out';

  @override
  String get sectionAccount => 'Account';

  @override
  String get sectionSettings => 'Settings';

  @override
  String get retry => 'Retry';

  @override
  String get updateProfileButton => 'Update profile';

  @override
  String get unexpectedError => 'Unexpected error occurs';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get emptyNotifications => 'No notifications yet';

  @override
  String get emptyNotificationsSub =>
      'You\'re all caught up. Check back later.';

  @override
  String get failedLoadNotifications => 'Failed to load notifications';

  @override
  String get videoPlayerTitle => 'Video Player';

  @override
  String get popularSectionHeader => 'Popular';

  @override
  String get discoverSectionHeader => 'Discover';
}
