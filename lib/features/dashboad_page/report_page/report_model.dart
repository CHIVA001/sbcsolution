import 'dart:convert';

class SalaryResponse {
  final bool status;
  final List<SalaryData> data;

  SalaryResponse({required this.status, required this.data});

  factory SalaryResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];

    return SalaryResponse(
      status: json['status'] ?? false,
      data: raw is List
          ? raw.map((e) => SalaryData.fromJson(e)).toList()
          : [SalaryData.fromJson(raw)],
    );
  }
}

class SalaryData {
  final String? id;
  final String? approvedAttId;
  final String? salaryId;
  final String? employeeId;
  final String? workingDay;
  final String? absent;
  final String? permission;
  final String? late;
  final String? normalOt;
  final String? weekendOt;
  final String? holidayOt;
  final String? basicSalary;
  final String? absentAmount;
  final String? permissionAmount;
  final String? lateAmount;
  final String? deduction;
  final String? overtime;
  final String? addition;
  final List<SalaryAddition> additions;
  final String? additionAmount;
  final List<SalaryDeduction> deductions;
  final String? deductionAmount;
  final String? seniority;
  final String? seniorityResponseTax;
  final String? severance;
  final String? indemnity;
  final String? severanceRiel;
  final String? indemnityRiel;
  final String? nssfSalaryUsd;
  final String? nssfSalaryRiel;
  final String? contributoryNssf;
  final String? pensionByStaff;
  final String? pensionByCompany;
  final String? healthNssf;
  final String? accidentNssf;
  final String? grossSalary;
  final String? grossSalaryRiel;
  final String? spouse;
  final String? children;
  final String? spouseChildrenReduction;
  final String? taxBaseSalary;
  final String? preSalary;
  final String? cashAdvanced;
  final String? taxDeclaration;
  final String? taxPercent;
  final String? taxPayment;
  final String? taxPaymentRiel;
  final String? netSalary;
  final String? netPay;
  final String? taxPaid;
  final String? salaryPaid;
  final String? paymentStatus;
  final String? normalOtAmount;
  final String? weekendOtAmount;
  final String? holidayOtAmount;
  final String? netCommission;
  final String? userId;
  final String? fingerId;
  final String? nricNo;
  final String? empcode;
  final String? candidate;
  final String? candidateStatus;
  final String? firstname;
  final String? lastname;
  final String? firstnameKh;
  final String? lastnameKh;
  final String? photo;
  final String? dob;
  final String? retirement;
  final String? gender;
  final String? phone;
  final String? email;
  final String? address;
  final String? nationality;
  final String? maritalStatus;
  final String? nonResident;
  final String? nssf;
  final String? nssfNumber;
  final String? createdAt;
  final String? createdBy;
  final String? updatedAt;
  final String? updatedBy;
  final String? note;
  final String? bookType;
  final String? workPermitNumber;
  final String? workbookNumber;
  final String? type;
  final String? pob;
  final String? moduleType;
  final String? operator;
  final String? commissionRate;
  final String? date;
  final String? fromDate;
  final String? toDate;
  final String? month;
  final String? year;
  final String? billerId;
  final String? positionId;
  final String? departmentId;
  final String? groupId;
  final String? attachment;
  final String? totalGrossSalary;
  final String? totalOvertime;
  final String? totalAddition;
  final String? totalCashAdvanced;
  final String? totalTaxPayment;
  final String? totalNetSalary;
  final String? totalNetPay;
  final String? totalTaxPaid;
  final String? totalSalaryPaid;
  final String? totalPaid;
  final String? status;
  final String? khRate;
  final String? nssfRate;
  final String? nssfStatus;

  SalaryData({
    this.id,
    this.approvedAttId,
    this.salaryId,
    this.employeeId,
    this.workingDay,
    this.absent,
    this.permission,
    this.late,
    this.normalOt,
    this.weekendOt,
    this.holidayOt,
    this.basicSalary,
    this.absentAmount,
    this.permissionAmount,
    this.lateAmount,
    this.deduction,
    this.overtime,
    this.addition,
    this.additions = const [],
    this.additionAmount,
    this.deductions = const [],
    this.deductionAmount,
    this.seniority,
    this.seniorityResponseTax,
    this.severance,
    this.indemnity,
    this.severanceRiel,
    this.indemnityRiel,
    this.nssfSalaryUsd,
    this.nssfSalaryRiel,
    this.contributoryNssf,
    this.pensionByStaff,
    this.pensionByCompany,
    this.healthNssf,
    this.accidentNssf,
    this.grossSalary,
    this.grossSalaryRiel,
    this.spouse,
    this.children,
    this.spouseChildrenReduction,
    this.taxBaseSalary,
    this.preSalary,
    this.cashAdvanced,
    this.taxDeclaration,
    this.taxPercent,
    this.taxPayment,
    this.taxPaymentRiel,
    this.netSalary,
    this.netPay,
    this.taxPaid,
    this.salaryPaid,
    this.paymentStatus,
    this.normalOtAmount,
    this.weekendOtAmount,
    this.holidayOtAmount,
    this.netCommission,
    this.userId,
    this.fingerId,
    this.nricNo,
    this.empcode,
    this.candidate,
    this.candidateStatus,
    this.firstname,
    this.lastname,
    this.firstnameKh,
    this.lastnameKh,
    this.photo,
    this.dob,
    this.retirement,
    this.gender,
    this.phone,
    this.email,
    this.address,
    this.nationality,
    this.maritalStatus,
    this.nonResident,
    this.nssf,
    this.nssfNumber,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.note,
    this.bookType,
    this.workPermitNumber,
    this.workbookNumber,
    this.type,
    this.pob,
    this.moduleType,
    this.operator,
    this.commissionRate,
    this.date,
    this.fromDate,
    this.toDate,
    this.month,
    this.year,
    this.billerId,
    this.positionId,
    this.departmentId,
    this.groupId,
    this.attachment,
    this.totalGrossSalary,
    this.totalOvertime,
    this.totalAddition,
    this.totalCashAdvanced,
    this.totalTaxPayment,
    this.totalNetSalary,
    this.totalNetPay,
    this.totalTaxPaid,
    this.totalSalaryPaid,
    this.totalPaid,
    this.status,
    this.khRate,
    this.nssfRate,
    this.nssfStatus,
  });

  String get fullName => "$firstname $lastname";

  factory SalaryData.fromJson(Map<String, dynamic> json) {
    return SalaryData(
      id: json['id'],
      approvedAttId: json['approved_att_id'],
      salaryId: json['salary_id'],
      employeeId: json['employee_id'],
      workingDay: json['working_day'],
      absent: json['absent'],
      permission: json['permission'],
      late: json['late'],
      normalOt: json['normal_ot'],
      weekendOt: json['weekend_ot'],
      holidayOt: json['holiday_ot'],
      basicSalary: json['basic_salary'],
      absentAmount: json['absent_amount'],
      permissionAmount: json['permission_amount'],
      lateAmount: json['late_amount'],
      deduction: json['deduction'],
      overtime: json['overtime'],
      addition: json['addition'],
      additions: json['additions'] != null
          ? (jsonDecode(json['additions']) as List)
              .map((e) => SalaryAddition.fromJson(e))
              .toList()
          : [],
      additionAmount: json['addition_amount'],
      deductions: json['deductions'] != null
          ? (jsonDecode(json['deductions']) as List)
              .map((e) => SalaryDeduction.fromJson(e))
              .toList()
          : [],
      deductionAmount: json['deduction_amount'],
      seniority: json['seniority'],
      seniorityResponseTax: json['seniority_response_tax'],
      severance: json['severance'],
      indemnity: json['indemnity'],
      severanceRiel: json['severance_riel'],
      indemnityRiel: json['indemnity_riel'],
      nssfSalaryUsd: json['nssf_salary_usd'],
      nssfSalaryRiel: json['nssf_salary_riel'],
      contributoryNssf: json['contributory_nssf'],
      pensionByStaff: json['pension_by_staff'],
      pensionByCompany: json['pension_by_company'],
      healthNssf: json['health_nssf'],
      accidentNssf: json['accident_nssf'],
      grossSalary: json['gross_salary'],
      grossSalaryRiel: json['gross_salary_riel'],
      spouse: json['spouse'],
      children: json['children'],
      spouseChildrenReduction: json['spouse_children_reduction'],
      taxBaseSalary: json['Taxbasesalary'],
      preSalary: json['pre_salary'],
      cashAdvanced: json['cash_advanced'],
      taxDeclaration: json['tax_declaration'],
      taxPercent: json['tax_percent'],
      taxPayment: json['tax_payment'],
      taxPaymentRiel: json['tax_payment_riel'],
      netSalary: json['net_salary'],
      netPay: json['net_pay'],
      taxPaid: json['tax_paid'],
      salaryPaid: json['salary_paid'],
      paymentStatus: json['payment_status'],
      normalOtAmount: json['normal_ot_amount'],
      weekendOtAmount: json['weekend_ot_amount'],
      holidayOtAmount: json['holiday_ot_amount'],
      netCommission: json['net_commission'],
      userId: json['user_id'],
      fingerId: json['finger_id'],
      nricNo: json['nric_no'],
      empcode: json['empcode'],
      candidate: json['candidate'],
      candidateStatus: json['candidate_status'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      firstnameKh: json['firstname_kh'],
      lastnameKh: json['lastname_kh'],
      photo: json['photo'],
      dob: json['dob'],
      retirement: json['retirement'],
      gender: json['gender'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      nationality: json['nationality'],
      maritalStatus: json['marital_status'],
      nonResident: json['non_resident'],
      nssf: json['nssf'],
      nssfNumber: json['nssf_number'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
      updatedAt: json['updated_at'],
      updatedBy: json['updated_by'],
      note: json['note'],
      bookType: json['book_type'],
      workPermitNumber: json['work_permit_number'],
      workbookNumber: json['workbook_number'],
      type: json['type'],
      pob: json['pob'],
      moduleType: json['module_type'],
      operator: json['operator'],
      commissionRate: json['commission_rate'],
      date: json['date'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
      month: json['month'],
      year: json['year'],
      billerId: json['biller_id'],
      positionId: json['position_id'],
      departmentId: json['department_id'],
      groupId: json['group_id'],
      attachment: json['attachment'],
      totalGrossSalary: json['total_gross_salary'],
      totalOvertime: json['total_overtime'],
      totalAddition: json['total_addition'],
      totalCashAdvanced: json['total_cash_advanced'],
      totalTaxPayment: json['total_tax_payment'],
      totalNetSalary: json['total_net_salary'],
      totalNetPay: json['total_net_pay'],
      totalTaxPaid: json['total_tax_paid'],
      totalSalaryPaid: json['total_salary_paid'],
      totalPaid: json['total_paid'],
      status: json['status'],
      khRate: json['kh_rate'],
      nssfRate: json['nssf_rate'],
      nssfStatus: json['nssf_status'],
    );
  }
}

class SalaryAddition {
  final String name;
  final String value;

  SalaryAddition({required this.name, required this.value});

  factory SalaryAddition.fromJson(Map<String, dynamic> json) {
    return SalaryAddition(
      name: json['name'] ?? '',
      value: json['value'] ?? '0',
    );
  }
}

class SalaryDeduction {
  final String name;
  final String value;

  SalaryDeduction({required this.name, required this.value});

  factory SalaryDeduction.fromJson(Map<String, dynamic> json) {
    return SalaryDeduction(
      name: json['name'] ?? '',
      value: json['value'] ?? '0',
    );
  }
}
