class AppUrl {
  //
  static const String baseUrl = 'http://178.128.24.212:9876/cyspharma/api/v1';
  static const String apiKey = "000osk04w4ow0ogs0c8s84w44048cgkw4cgoskkc";
  static const String authApiKey = "000osk04w4ow0ogs0c8s84w44048cgkw4cgoskkc";

  // login
  static const String loginUrl = '$baseUrl/auth/login';
  static const String getProfile = '$baseUrl/auth/profile';
  static const String getCompanies = '$baseUrl/companies';
  // get salary
  static const String getSalary = '$baseUrl/payrolls/get_salary';
  // attendance
  static const String postChekinOut = '$baseUrl/attendance/check_in_check_out';
  static const String getApplyLeave = '$baseUrl/attendance/get_apply_leave';
  static const String getLeaveType = '$baseUrl/attendance/get_take_leave_type';
  static const String getDayOff = '$baseUrl/attendance/get_apply_dayoff';
  static const String addDayOff = '$baseUrl/attendance/apply_dayoff';
  static const String postApplyLeave = '$baseUrl/attendance/apply_leave';
  static const String getAttendance =
      '$baseUrl/attendance/get_checkin_checkout';
  static const String getProduct = '$baseUrl/products';
  static const String getCustomer = '$baseUrl/companies';
  static const String getSale = '$baseUrl/sales';
  static const String timeLeave = '$baseUrl/attendance/get_apply_leave';
  static const String getDispatch = '$baseUrl/deliveries/getDispatch';
  static const String updateDispatch = '$baseUrl/deliveries/delivery_status';

  // attendance
  static const String getShift = '$baseUrl/attendance/get_currentshift';
}
