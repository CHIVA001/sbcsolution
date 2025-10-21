// lib/core/services/sunmi_print_service.dart
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import '../../controllers/cart_controller.dart';
import 'package:get/get.dart';


class SunmiPrintService {
  /// Initialize printer binding before printing
  static Future<void> initPrinter() async {
    await SunmiPrinter.bindingPrinter();
  }

  /// Helper to print blank lines (line feed)
  static Future<void> _feedLines(int n) async {
    for (int i = 0; i < n; i++) {
      await SunmiPrinter.printText('');
    }
  }

  /// Helper to print divider line
  static Future<void> _divider() async {
    await SunmiPrinter.printText('--------------------------------');
  }

  /// Main invoice print
  static Future<void> printInvoice({
    required String company,
    required String customer,
    required String biller,
    required String cashier,
    required List<Map<String, dynamic>> items,
    required double total,
    required double grandTotal,
    required double exchangeRate,
    required String paymentMethod,
  }) async {
    await SunmiPrinter.startTransactionPrint(true);

    // --- Header ---
    await _feedLines(1);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText(
      company,
      style: SunmiTextStyle(
        bold: true,
        fontSize: 24,
        align: SunmiPrintAlign.CENTER,
      ),
    );
    await _feedLines(1);

    // --- Info ---
    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
    await SunmiPrinter.printText('Customer: $customer');
    await SunmiPrinter.printText('Biller: $biller');
    await SunmiPrinter.printText('Cashier: $cashier');
    await SunmiPrinter.printText('Date: ${DateTime.now()}');
    await _feedLines(1);
    await SunmiPrinter.printText(
      'INVOICE',
      style: SunmiTextStyle(
        underline: true,
        bold: true,
        fontSize: 24,
        align: SunmiPrintAlign.CENTER,
      ),
    );
    // --- Items ---
    await _divider();
    await SunmiPrinter.printText('Item              Qty     Amount');
    await _divider();

    for (final item in items) {
      final name = (item['name'] ?? '').toString();
      final qty = (item['qty'] ?? 0).toString();
      final amount = (item['amount'] ?? 0.0) as double;

      final nameFormatted = name.length > 16
          ? name.substring(0, 16)
          : name.padRight(16);
      final qtyFormatted = qty.padLeft(3);
      final amountFormatted = '\$${amount.toStringAsFixed(2)}';

      await SunmiPrinter.printText(
        '$nameFormatted $qtyFormatted     $amountFormatted',
      );
    }

    await _divider();

    // --- Totals ---
    await SunmiPrinter.printText('Total: \$${total.toStringAsFixed(2)}');
    await SunmiPrinter.printText(
      'Grand Total: \$${grandTotal.toStringAsFixed(2)}',
    );
    await SunmiPrinter.printText(
      'Total Riel: ${(grandTotal * exchangeRate).toStringAsFixed(2)}៛',
    );
    await SunmiPrinter.printText(
      'Rate: \$1 = ${exchangeRate.toStringAsFixed(0)}៛',
    );
    await _feedLines(1);

    // --- Payment ---
    await SunmiPrinter.printText('Paid by: $paymentMethod');
    await _feedLines(6);

    // --- Footer ---;
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText(
      '*** Thank You For Shopping ***',
      style: SunmiTextStyle(
        bold: true,
        fontSize: 24,
        align: SunmiPrintAlign.CENTER,
      ),
    );
    await _feedLines(4);

    try {
      await SunmiPrinter.cutPaper();
    } catch (_) {}

    await SunmiPrinter.exitTransactionPrint(true);
  }
}

class EscPosPrintService {
  static Future<void> printInvoice({
    required String printerAddress,
    required CartController cartController,
    required String customer,
    required String biller,
    required String cashier,
    required String paymentMethod,
    required double exchangeRate,
  }) async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm58, profile); // mm80 for larger

    final connectResult = await printer.connect(printerAddress, port: 9100); // Bluetooth may need another approach
    if (connectResult != PosPrintResult.success) {
      Get.snackbar('Error', 'Failed to connect printer: $connectResult');
      return;
    }

    // --- Header ---
    printer.setStyles(PosStyles(align: PosAlign.center, bold: true));
    printer.text('SBC SOLUTION', styles: PosStyles(bold: true, height: PosTextSize.size2, width: PosTextSize.size2));
    printer.text('INVOICE\n\n');

    // --- Info ---
    printer.setStyles(PosStyles(align: PosAlign.left, bold: false));
    printer.text('Customer: $customer');
    printer.text('Biller: $biller');
    printer.text('Cashier: $cashier');
    printer.text('Date: ${DateTime.now()}\n');

    // --- Items ---
    printer.hr();
    printer.text('Item              Qty   Amount');
    printer.hr();

    for (var item in cartController.cartItems) {
      final name = item.name.padRight(16).substring(0, 16);
      final qty = item.qty.toString().padLeft(3);
      final amount = item.total.toStringAsFixed(2).padLeft(7);
      printer.text('$name $qty $amount');
    }

    printer.hr();

    // --- Totals ---
    printer.text('Total: ${cartController.grandTotal.toStringAsFixed(2)}');
    printer.text('Grand Total: ${cartController.grandTotal.toStringAsFixed(2)}');
    printer.text('Total Riel: ${(cartController.grandTotal * exchangeRate).toStringAsFixed(2)}៛');
    printer.text('Rate: \$1 = ${exchangeRate.toStringAsFixed(0)}៛\n');

    // --- Payment ---
    printer.text('Paid by: $paymentMethod\n');

    // --- Footer ---
    printer.setStyles(PosStyles(align: PosAlign.center, bold: true));
    printer.text('*** Thank You For Shopping ***\n\n');

    printer.cut();
    printer.disconnect();
  }
}
