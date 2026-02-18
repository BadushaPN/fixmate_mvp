import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/address_model.dart';
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
  AddressModel? _selectedAddress;
  final TextEditingController _receiverName = TextEditingController();
  final TextEditingController _receiverPhone = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<String> _savedImagePaths = [];
  bool _isBooking = false;
  bool _buttonPressed = false;

  final List<String> _timeSlots = const [
    '09:00 AM - 11:00 AM',
    '11:00 AM - 01:00 PM',
    '02:00 PM - 04:00 PM',
    '04:00 PM - 06:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    final app = Provider.of<AppProvider>(context, listen: false);
    if (app.addresses.isNotEmpty) {
      _selectedAddress = app.currentLocationAddress ?? app.addresses.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final servicePrice = ServiceMeta.startingPrice(widget.service);
    final serviceIcon = IconData(
      int.parse(widget.service.iconCode, radix: 16),
      fontFamily: 'MaterialIcons',
    );
    final duration = AppMotion.maybe(AppMotion.fast, context);
    final curve = AppMotion.maybeCurve(AppMotion.standard(context), context);
    final addresses = app.addresses;
    final selected = _selectedAddress;
    final nonCurrentSelected = selected != null && !selected.isCurrentLocation;

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
                  const AppReveal(delayMs: 30, child: _CashNote()),
                  const SizedBox(height: 18),
                  AppReveal(
                    delayMs: 60,
                    child: Text(
                      'Select Date',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppReveal(
                    delayMs: 80,
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
                            ),
                            const Icon(Icons.calendar_today_rounded, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  AppReveal(
                    delayMs: 100,
                    child: Text(
                      'Select Time Slot',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppReveal(
                    delayMs: 120,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _timeSlots.map((slot) {
                        final selectedSlot = _selectedTimeSlot == slot;
                        return AnimatedScale(
                          duration: duration,
                          curve: AppMotion.maybeCurve(AppMotion.spring(context), context),
                          scale: selectedSlot ? 1.03 : 1,
                          child: ChoiceChip(
                            label: Text(slot),
                            selected: selectedSlot,
                            onSelected: (_) => setState(() => _selectedTimeSlot = slot),
                            showCheckmark: false,
                            selectedColor: AppColors.softBlueFor(context),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  AppReveal(
                    delayMs: 140,
                    child: Text(
                      'Select Address',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (addresses.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cardFor(context),
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        border: Border.all(color: AppColors.strokeFor(context)),
                      ),
                      child: const Text('No address available yet. Add a new address.'),
                    )
                  else
                    ...addresses.map(
                      (a) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: AppColors.cardFor(context),
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          border: Border.all(
                            color: _selectedAddress?.id == a.id
                                ? AppColors.primary
                                : AppColors.strokeFor(context),
                          ),
                        ),
                        child: ListTile(
                          onTap: () => setState(() => _selectedAddress = a),
                          leading: Icon(
                            _selectedAddress?.id == a.id
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            color: _selectedAddress?.id == a.id
                                ? AppColors.primary
                                : AppColors.subtextFor(context),
                          ),
                          title: Text(a.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(a.addressLine, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _addNewAddress,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add New Address'),
                    ),
                  ),
                  if (nonCurrentSelected) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _receiverName,
                      decoration: const InputDecoration(
                        hintText: 'Receiver name (optional)',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _receiverPhone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Receiver phone (optional)',
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  AppReveal(
                    delayMs: 180,
                    child: Text(
                      'Add Reference Images',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickFromGallery,
                          icon: const Icon(Icons.photo_library_rounded),
                          label: const Text('Gallery'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickFromCamera,
                          icon: const Icon(Icons.camera_alt_rounded),
                          label: const Text('Camera'),
                        ),
                      ),
                    ],
                  ),
                  if (_savedImagePaths.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 84,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, i) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(_savedImagePaths[i]),
                            width: 84,
                            height: 84,
                            fit: BoxFit.cover,
                          ),
                        ),
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemCount: _savedImagePaths.length,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
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

  Future<void> _pickFromGallery() async {
    final files = await _picker.pickMultiImage();
    if (files.isEmpty) return;
    for (final file in files) {
      final path = await _persistImage(file);
      _savedImagePaths.add(path);
    }
    if (mounted) setState(() {});
  }

  Future<void> _pickFromCamera() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return;
    final path = await _persistImage(file);
    _savedImagePaths.add(path);
    if (mounted) setState(() {});
  }

  Future<String> _persistImage(XFile file) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/booking_images');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    final ext = file.path.split('.').last;
    final target = '${dir.path}/${const Uuid().v4()}.$ext';
    final copied = await File(file.path).copy(target);
    return copied.path;
  }

  Future<void> _addNewAddress() async {
    final app = Provider.of<AppProvider>(context, listen: false);
    final labelController = TextEditingController();
    final addressController = TextEditingController();
    final receiverNameController = TextEditingController();
    final receiverPhoneController = TextEditingController();

    final result = await showModalBottomSheet<AddressModel>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelController,
              decoration: const InputDecoration(hintText: 'Label (Home, Office, etc.)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Address line'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: receiverNameController,
              decoration: const InputDecoration(hintText: 'Receiver name (optional)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: receiverPhoneController,
              decoration: const InputDecoration(hintText: 'Receiver phone (optional)'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (labelController.text.trim().isEmpty ||
                      addressController.text.trim().isEmpty) {
                    return;
                  }
                  Navigator.pop(
                    context,
                    AddressModel(
                      id: const Uuid().v4(),
                      label: labelController.text.trim(),
                      addressLine: addressController.text.trim(),
                      receiverName: receiverNameController.text.trim().isEmpty
                          ? null
                          : receiverNameController.text.trim(),
                      receiverPhone: receiverPhoneController.text.trim().isEmpty
                          ? null
                          : receiverPhoneController.text.trim(),
                    ),
                  );
                },
                child: const Text('Save Address'),
              ),
            ),
          ],
        ),
      ),
    );

    if (result == null) return;
    await app.saveAddress(result);
    if (!mounted) return;
    setState(() => _selectedAddress = result);
  }

  Future<void> _confirmBooking(int servicePrice) async {
    if (_selectedDate == null || _selectedTimeSlot == null || _selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date, slot and address')),
      );
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
        addressLine: _selectedAddress!.addressLine,
        receiverName: _selectedAddress!.isCurrentLocation
            ? null
            : (_receiverName.text.trim().isEmpty
                ? _selectedAddress!.receiverName
                : _receiverName.text.trim()),
        receiverPhone: _selectedAddress!.isCurrentLocation
            ? null
            : (_receiverPhone.text.trim().isEmpty
                ? _selectedAddress!.receiverPhone
                : _receiverPhone.text.trim()),
        imagePaths: _savedImagePaths,
      );
      if (!mounted) return;
      await _showSuccessDialog();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to book service')),
        );
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
