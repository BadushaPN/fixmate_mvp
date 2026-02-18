import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/service_model.dart';
import '../providers/app_provider.dart';
import '../theme/app_motion.dart';
import '../theme/app_theme.dart';
import '../utils/service_meta.dart';
import '../widgets/app_reveal.dart';

class BookingFormScreen extends StatefulWidget {
  final ServiceModel service;

  const BookingFormScreen({required this.service, super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  final TextEditingController _addressController = TextEditingController();
  bool _isBooking = false;
  bool _buttonPressed = false;

  final List<String> _timeSlots = const [
    '09:00 AM - 11:00 AM',
    '11:00 AM - 01:00 PM',
    '02:00 PM - 04:00 PM',
    '04:00 PM - 06:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final servicePrice = ServiceMeta.startingPrice(widget.service);
    final serviceIcon = IconData(
      int.parse(widget.service.iconCode, radix: 16),
      fontFamily: 'MaterialIcons',
    );
    final duration = AppMotion.maybe(AppMotion.fast, context);
    final curve = AppMotion.maybeCurve(AppMotion.standard(context), context);

    return Container(
      decoration: BoxDecoration(gradient: AppGradients.backgroundFor(context)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text('Book ${widget.service.name}')),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppReveal(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0E5BFF), Color(0xFF17C7A5)],
                        ),
                        boxShadow: AppShadows.card(context),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(serviceIcon, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.service.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Starting from INR $servicePrice',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.92)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const AppReveal(
                    delayMs: 40,
                    child: _CashNote(),
                  ),
                  const SizedBox(height: 20),
                  AppReveal(
                    delayMs: 80,
                    child: Text(
                      'Select Date',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppReveal(
                    delayMs: 100,
                    child: InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.cardFor(context),
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          border: Border.all(color: AppColors.strokeFor(context)),
                          boxShadow: AppShadows.card(context),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'Choose date'
                                  : DateFormat('EEE, MMM d, yyyy').format(_selectedDate!),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: _selectedDate == null ? AppColors.subtextFor(context) : AppColors.inkFor(context),
                              ),
                            ),
                            const Icon(Icons.calendar_today_rounded, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppReveal(
                    delayMs: 120,
                    child: Text(
                      'Select Time Slot',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppReveal(
                    delayMs: 140,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _timeSlots.map((slot) {
                        final selected = _selectedTimeSlot == slot;
                        return AnimatedScale(
                          duration: duration,
                          curve: AppMotion.maybeCurve(AppMotion.spring(context), context),
                          scale: selected ? 1.03 : 1,
                          child: ChoiceChip(
                            label: Text(slot),
                            selected: selected,
                            onSelected: (_) => setState(() => _selectedTimeSlot = slot),
                            side: BorderSide(
                              color: selected ? AppColors.primary : const Color(0xFFE4E7EC),
                            ),
                            selectedColor: AppColors.softBlueFor(context),
                            showCheckmark: false,
                            labelStyle: TextStyle(
                              color: selected ? AppColors.primary : AppColors.ink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppReveal(
                    delayMs: 160,
                    child: Text(
                      'Service Address',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppReveal(
                    delayMs: 180,
                    child: TextField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(hintText: 'Enter your full address'),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Cash due on completion. No online prepayment in MVP.',
                    style: TextStyle(color: AppColors.subtextFor(context), fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  AppReveal(
                    delayMs: 220,
                    child: AnimatedScale(
                      duration: duration,
                      curve: curve,
                      scale: _buttonPressed ? 0.98 : 1,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isBooking ? null : () => _confirmBooking(servicePrice),
                          child: const Text('Confirm Booking'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: duration,
              opacity: _isBooking ? 1 : 0,
              child: IgnorePointer(
                ignoring: !_isBooking,
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.2),
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2.6)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _confirmBooking(int servicePrice) async {
    if (_selectedDate == null || _selectedTimeSlot == null || _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all details')));
      return;
    }
    final app = Provider.of<AppProvider>(context, listen: false);
    setState(() {
      _buttonPressed = true;
      _isBooking = true;
    });
    await Future.delayed(AppMotion.maybe(AppMotion.fast, context));
    if (mounted) setState(() => _buttonPressed = false);

    try {
      await app.createBooking(
        service: widget.service,
        date: _selectedDate!,
        timeSlot: _selectedTimeSlot!,
        price: servicePrice.toDouble(),
      );
      if (!mounted) return;
      await _showSuccessDialog();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to book service')));
      }
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  Future<void> _showSuccessDialog() async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'booking_success',
      barrierColor: Colors.black45,
      transitionDuration: AppMotion.maybe(AppMotion.normal, context),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.md),
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Booking Confirmed', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                  const SizedBox(height: 8),
                  const Text(
                    'Your request is placed. Provider assignment is manual for this MVP, so live tracking is not available yet.',
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: AppMotion.maybeCurve(AppMotion.spring(context), context),
        );
        final slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(position: slide, child: ScaleTransition(scale: curved, child: child)),
        );
      },
    );
  }
}

class _CashNote extends StatelessWidget {
  const _CashNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2ED),
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: const Color(0xFFFFDCCD)),
      ),
      child: const Row(
        children: [
          Icon(Icons.currency_rupee_rounded, color: AppColors.accent, size: 22),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'MVP Payment Mode: Cash on Service',
              style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
