import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'model/sale_model.dart';

class SaleDetailPage extends StatelessWidget {
  const SaleDetailPage({super.key, required this.sale});

  final SaleModel sale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Details'),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSummaryCard(context),
          const SizedBox(height: 16),
          // _buildItemsCard(context),
          const SizedBox(height: 16),
          _buildPaymentCard(context),
          const SizedBox(height: 16),
          _buildBillerCard(context),
          const SizedBox(height: 16),
          _buildSalespersonCard(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return _buildCard(
      context,
      title: 'Sale Summary',
      children: [
        _infoRow('Date', sale.date.substring(0, 10)),
        _infoRow('Customer', sale.customer),
        _infoRow('Sale Status', sale.saleStatus),
        _infoRow('Payment Status', sale.paymentStatus),
        _infoRow('Grand Total', '\$${sale.grandTotal.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildPaymentCard(BuildContext context) {
    return _buildCard(
      context,
      title: 'Payment Information',
      children: [
        _infoRow('Method', sale.payment.method),
        _infoRow('Amount Paid', '\$${sale.payment.amount.toStringAsFixed(2)}'),
        _infoRow(
          'Change Returned',
          '\$${sale.payment.change.toStringAsFixed(2)}',
        ),
      ],
    );
  }

  /// 🟢 Biller Card
  Widget _buildBillerCard(BuildContext context) {
    return _buildCard(
      context,
      title: 'Biller Information',
      children: [
        _infoRow('Company', sale.biller.company),
        _infoRow('Contact Person', sale.biller.name),
        _infoRow('Phone', sale.biller.phone),
        _infoRow('Email', sale.biller.email),
        _infoRow('Address', sale.biller.address),
      ],
    );
  }

  /// 🟢 Salesperson Card
  Widget _buildSalespersonCard(BuildContext context) {
    return _buildCard(
      context,
      title: 'Created By',
      children: [
        _infoRow('Username', sale.createdBy.username),
        _infoRow(
          'Full Name',
          '${sale.createdBy.firstName} ${sale.createdBy.lastName}',
        ),
        _infoRow('Email', sale.createdBy.email),
      ],
    );
  }

  /// 🔹 Reusable Card
  Widget _buildCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      color: AppColors.bgColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.darkGrey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  /// 🔹 Info Row
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
