import 'package:flutter/material.dart';
import 'customer_model.dart'; // avatar colors

class CustomerDetailPage extends StatelessWidget {
  CustomerDetailPage({super.key, required this.customer});
  final CustomerModel customer;
  Map<String, Color> letterColors = {
    "A": Colors.red,
    "B": Colors.blue,
    "C": Colors.green,
    "D": Colors.orange,
    "E": Colors.purple,
    "F": Colors.teal,
    "G": Colors.pink,
    "H": Colors.indigo,
    "I": Colors.cyan,
    "J": Colors.brown,
    "K": Colors.deepOrange,
    "L": Colors.lightGreen,
    "M": Colors.amber,
    "N": Colors.deepPurple,
    "O": Colors.lime,
    "P": Colors.blueGrey,
    "Q": Colors.yellow,
    "R": Colors.redAccent,
    "S": Colors.blueAccent,
    "T": Colors.greenAccent,
    "U": Colors.orangeAccent,
    "V": Colors.purpleAccent,
    "W": Colors.tealAccent,
    "X": Colors.pinkAccent,
    "Y": Colors.indigoAccent,
    "Z": Colors.cyanAccent,
  };
  @override
  Widget build(BuildContext context) {
    final color = letterColors[customer.name[0].toUpperCase()] ?? Colors.blue;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Customer Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeaderCard(customer, color),
            const SizedBox(height: 16),
            _buildInfoCard('General Information', [
              _buildDetailRow('ID', customer.id.toString(), Icons.credit_card),
              _buildDetailRow('Code', customer.code, Icons.qr_code),
              _buildDetailRow('Gender', customer.gender ?? 'N/A', Icons.wc),
              _buildDetailRow('Age', customer.age.toString(), Icons.cake),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('Contact Information', [
              _buildDetailRow('Email', customer.email ?? 'N/A', Icons.email),
              _buildDetailRow('Phone', customer.phone ?? 'N/A', Icons.phone),
              _buildDetailRow(
                'Address',
                customer.address ?? 'N/A',
                Icons.location_on,
              ),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('Other Details', [
              _buildDetailRow(
                'Customer Group',
                customer.customerGroupName,
                Icons.group,
              ),
              _buildDetailRow(
                'Status',
                customer.status,
                Icons.check_circle_outline,
                isStatus: true,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(CustomerModel customer, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 40,
              child: Text(
                customer.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              customer.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (customer.nameKh != null)
              Text(
                customer.nameKh!,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> details) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black12),
            ...details,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    bool isStatus = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey.shade400),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
            child: isStatus
                ? Align(
                    alignment: Alignment.centerRight,
                    child: _buildStatusChip(value),
                  )
                : Text(
                    value,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = status.toLowerCase() == 'active' ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
