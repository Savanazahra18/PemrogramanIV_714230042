import 'package:flutter/material.dart';
import 'user.dart';

class UserCard extends StatelessWidget {
  final UserCreate usrCreate;

  const UserCard({super.key, required this.usrCreate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      // Menggunakan constraints lebih baik daripada width kaku agar responsif
      constraints: const BoxConstraints(maxWidth: 400), 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.lightBlue[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow('ID', usrCreate.id),
          _buildRow('Name', usrCreate.name),
          _buildRow('Job', usrCreate.job),
          _buildRow('Created At', usrCreate.createdAt),
        ],
      ),
    );
  }

  // Parameter 'value' dijadikan String? agar tidak error saat ID atau Date null
  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90, 
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(': ${value ?? "-"}'), // Jika null, tampilkan tanda strip
          ),
        ],
      ),
    );
  }
}