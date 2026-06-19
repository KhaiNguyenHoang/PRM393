// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get language => 'Việt Nam';

  @override
  String get settingSectionHeader => 'NGÔN NGỮ';

  @override
  String get appTitle => 'Netmu';

  @override
  String get welcomeTitle => 'Chào mừng đến với Netmu';

  @override
  String get loginTitle => 'Đăng nhập';

  @override
  String get loginSubtitle => 'Chào mừng trở lại.';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get loginFooter => 'Chưa có tài khoản?';

  @override
  String get loginFooterAction => 'Tạo tài khoản';

  @override
  String get registerTitle => 'Tạo tài khoản';

  @override
  String get registerSubtitle => 'Đăng ký để bắt đầu ngay hôm nay.';

  @override
  String get registerButton => 'Tạo tài khoản';

  @override
  String get registerFooter => 'Đã có tài khoản?';

  @override
  String get registerFooterAction => 'Đăng nhập';

  @override
  String get usernameLabel => 'Tên đăng nhập';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get oldPasswordLabel => 'Mật khẩu cũ';

  @override
  String get newPasswordLabel => 'Mật khẩu mới';

  @override
  String get confirmPasswordLabel => 'Xác nhận mật khẩu';

  @override
  String get usernameHint => 'VD: JohnDoe';

  @override
  String get emailHint => 'abc@gmail.com';

  @override
  String get requiredUsername => 'Vui lòng nhập tên đăng nhập';

  @override
  String get minUsername => 'Tối thiểu 3 ký tự';

  @override
  String get requiredEmail => 'Vui lòng nhập email';

  @override
  String get invalidEmail => 'Vui lòng nhập email hợp lệ';

  @override
  String get requiredPassword => 'Vui lòng nhập mật khẩu';

  @override
  String get minPassword => 'Mật khẩu tối thiểu 8 ký tự';

  @override
  String get confirmPasswordMismatch => 'Mật khẩu xác nhận phải khớp';

  @override
  String get requiredOldPassword => 'Vui lòng nhập mật khẩu cũ';

  @override
  String get navProfile => 'Hồ sơ';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get synopsis => 'Tóm tắt';

  @override
  String get readMore => 'Đọc thêm';

  @override
  String get showLess => 'Thu gọn';

  @override
  String get details => 'Chi tiết';

  @override
  String get infoDirector => 'Đạo diễn';

  @override
  String get infoDuration => 'Thời lượng';

  @override
  String get infoGenres => 'Thể loại';

  @override
  String get watchNow => 'Xem ngay';

  @override
  String directedBy(String director) {
    return 'Đạo diễn: $director';
  }

  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get changePasswordButton => 'Đổi mật khẩu';

  @override
  String get logOut => 'Đăng xuất';

  @override
  String get sectionAccount => 'Tài khoản';

  @override
  String get sectionSettings => 'Cài đặt';

  @override
  String get retry => 'Thử lại';

  @override
  String get updateProfileButton => 'Cập nhật hồ sơ';

  @override
  String get unexpectedError => 'Có lỗi xảy ra';

  @override
  String get notificationsTitle => 'Thông báo';

  @override
  String get emptyNotifications => 'Chưa có thông báo nào';

  @override
  String get emptyNotificationsSub => 'Bạn đã xem hết. Hãy quay lại sau.';

  @override
  String get failedLoadNotifications => 'Không thể tải thông báo';

  @override
  String get videoPlayerTitle => 'Trình phát video';

  @override
  String get popularSectionHeader => 'Đang nổi';

  @override
  String get discoverSectionHeader => 'Khám phá';
}
