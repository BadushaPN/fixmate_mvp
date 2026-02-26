import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String time;
  final bool isClosed;

  const TaskTile({
    super.key,
    required this.title,
    required this.time,
    this.isClosed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                isClosed ? Icons.check_circle : Icons.access_time,
                size: 18,
                color: isClosed ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                time,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
