class UserModel {
  final String id;
  final String empId;
  final String firstName;
  final String lastName;
  final String username;
  final String gender;
  final String company;
  final String phone;
  final String email;
  final String billerId;
  final String active;
  final String? avatar;
  final String? nationality;
  final String position;
  final String? employedDate;
  final String? userType;
  final String basicSalary;
  final String isRemoteAllow;
  final String? candidate;
  final String? photo;
  final String companyName;
  final String? departmentName;
  final String? positionName;
  final String? policyName;
  final String image;

  UserModel({
    required this.id,
    required this.empId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.gender,
    required this.company,
    required this.phone,
    required this.email,
    required this.billerId,
    required this.active,
    this.avatar,
    this.nationality,
    required this.position,
    this.employedDate,
    this.userType,
    required this.basicSalary,
    required this.isRemoteAllow,
    this.candidate,
    this.photo,
    required this.companyName,
    this.departmentName,
    this.positionName,
    this.policyName,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? "",
      empId: json['emp_id'] ?? "",
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      username: json['username'] ?? "",
      gender: json['gender'] ?? "",
      company: json['company'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      billerId: json['biller_id'] ?? "",
      active: json['active'] ?? "",
      avatar: json['avatar'],
      nationality: json['nationality'],
      position: json['position'] ?? "",
      employedDate: json['employeed_date'],
      userType: json['user_type'],
      basicSalary: json['basic_salary'] ?? "0",
      isRemoteAllow: json['is_remote_allow'] ?? "0",
      candidate: json['candidate'],
      photo: json['photo'],
      companyName: json['company_name'] ?? "",
      departmentName: json['department_name'],
      positionName: json['position_name'],
      policyName: json['policy_name'],
      image: json['image'] ?? "",
    );
  }
}
