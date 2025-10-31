import 'package:flutter/material.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class PrintTestPage extends StatefulWidget {
  const PrintTestPage({super.key});

  @override
  State<PrintTestPage> createState() => _PrintTestPageState();
}

class _PrintTestPageState extends State<PrintTestPage> {
  String printerStatus = "Not Connected";

  @override
  void initState() {
    super.initState();
    initPrinter();
  }

  Future<void> initPrinter() async {
    await SunmiPrinter.bindingPrinter();
  }

  Future<void> printInvoice() async {
    await SunmiPrinter.startTransactionPrint(true);

    // 🧍‍♂️ Add space at the top of the paper
    await SunmiPrinter.lineWrap(2);

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText(
      'BONG BROS POS\n',
      style: SunmiTextStyle(
        bold: true,
        fontSize: 24,
        align: SunmiPrintAlign.CENTER,
      ),
    );

    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Customer: General Customer');
    await SunmiPrinter.printText('Invoice No: POS25/1482');
    await SunmiPrinter.printText('Date: 2025-10-18 08:53:39');
    await SunmiPrinter.lineWrap(1);

    await SunmiPrinter.printText('--------------------------------');
    await SunmiPrinter.printText('Description       Qty     Amount');
    await SunmiPrinter.printText('--------------------------------');
    await SunmiPrinter.printText('Vital 500ML        1       \$4.50');
    await SunmiPrinter.printText('--------------------------------');
    await SunmiPrinter.printText('Total: \$4.50');
    await SunmiPrinter.printText('Grand Total: \$4.50');
    await SunmiPrinter.printText('Total Riel: 16000.00');
    await SunmiPrinter.printText('Rate: \$1 = 4000៛');
    await SunmiPrinter.lineWrap(1);

    // 🧾 Move “Paid by” down slightly
    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
    await SunmiPrinter.printText('Paid by: ABA');
    await SunmiPrinter.lineWrap(2);

    // 🙏 Center and add spacing for the thank-you message
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText(
      '*** Thank You For Shopping ***',
      style: SunmiTextStyle(
        bold: true,
        fontSize: 14,
        align: SunmiPrintAlign.CENTER,
      ),
    );

    // 🧍‍♀️ Add extra blank paper at bottom
    await SunmiPrinter.lineWrap(4);

    await SunmiPrinter.exitTransactionPrint(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sunmi Printer Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              printerStatus,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: printInvoice,
              icon: const Icon(Icons.print),
              label: const Text('Print Test Invoice'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: initPrinter,
              icon: const Icon(Icons.refresh),
              label: const Text('Reconnect Printer'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
