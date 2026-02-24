import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../theme/app_theme.dart';

class BookingItem extends StatelessWidget {
  final BookingModel booking;

  const BookingItem({required this.booking, super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF099250);
      case 'cancelled':
        return const Color(0xFFD92D20);
      case 'assigned':
        return AppColors.primary;
      default:
        return const Color(0xFFB54708);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(booking.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardFor(context),
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.strokeFor(context)),
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.serviceName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 15,
                color: AppColors.subtextFor(context),
              ),
              const SizedBox(width: 6),
              Text(DateFormat('MMM dd, yyyy').format(booking.date)),
              const SizedBox(width: 14),
              Icon(
                Icons.schedule_rounded,
                size: 15,
                color: AppColors.subtextFor(context),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(booking.timeSlot, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            booking.addressLine,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.subtextFor(context),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          if (booking.imagePaths.isNotEmpty)
            Row(
              children: [
                Icon(
                  Icons.photo_library_rounded,
                  size: 15,
                  color: AppColors.subtextFor(context),
                ),
                const SizedBox(width: 6),
                Text(
                  '${booking.imagePaths.length} image(s) attached',
                  style: TextStyle(
                    color: AppColors.subtextFor(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          if (booking.imagePaths.isNotEmpty) const SizedBox(height: 8),
          Text(
            'Price: INR ${booking.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
