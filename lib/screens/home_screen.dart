import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../providers/app_provider.dart';
import '../theme/app_motion.dart';
import '../theme/app_theme.dart';
import '../widgets/app_reveal.dart';
import '../widgets/booking_item.dart';
import '../widgets/offer_card.dart';
import '../widgets/service_card.dart';
import 'booking_form_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _localityKey = 'selected_locality';
  static const _areas = [
    'Perungudi',
    'OMR',
    'Velachery',
    'Adyar',
    'Thoraipakkam',
  ];
  int _index = 0;
  String _locality = 'Perungudi';
  bool _locationReady = false;
  bool _locationBlocked = false;
  String _locationMessage = 'Checking location permission...';

  @override
  void initState() {
    super.initState();
    _loadLocality();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _enforceLocation();
    });
  }

  Future<void> _loadLocality() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _locality = prefs.getString(_localityKey) ?? _locality);
  }

  Future<void> _pickLocality() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: _areas
            .map(
              (x) => ListTile(
                leading: Icon(Icons.location_on_rounded, size: 22),
                title: Text(x),
                trailing: x == _locality
                    ? Icon(
                        Icons.check_circle_rounded,
                        size: 22,
                        color: AppColors.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(context, x),
              ),
            )
            .toList(),
      ),
    );
    if (picked == null || picked == _locality) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localityKey, picked);
    if (!mounted) return;
    setState(() => _locality = picked);
  }

  Future<void> _enforceLocation() async {
    if (!mounted) return;
    final provider = Provider.of<AppProvider>(context, listen: false);

    setState(() {
      _locationMessage = 'Checking location permission...';
      _locationBlocked = false;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        if (!mounted) return;
        setState(() {
          _locationBlocked = true;
          _locationReady = false;
          _locationMessage =
              'Location service is off. Please enable it in settings.';
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        await Geolocator.openLocationSettings();
        if (!mounted) return;
        setState(() {
          _locationBlocked = true;
          _locationReady = false;
          _locationMessage =
              'Location permission is mandatory to use this app.';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 15));

      String formatted = 'Lat ${position.latitude}, Lng ${position.longitude}';
      String? locality;
      try {
        final places = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (places.isNotEmpty) {
          final place = places.first;
          locality = place.locality;
          formatted = [
            place.name,
            place.subLocality,
            place.locality,
            place.administrativeArea,
          ].where((e) => e != null && e.trim().isNotEmpty).join(', ');
        }
      } catch (_) {
        // Keep coordinates fallback if reverse-geocoding fails.
      }

      await provider.setCurrentLocationAddress(formatted);

      if (!mounted) return;
      setState(() {
        _locationReady = true;
        _locationBlocked = false;
        if (locality != null && locality.trim().isNotEmpty) {
          _locality = locality.trim();
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locationBlocked = true;
        _locationReady = false;
        _locationMessage =
            'Unable to access location on this device. Open settings and retry.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_locationReady) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 56,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Location Access Required',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _locationMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.subtextFor(context)),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _enforceLocation,
                      child: Text(
                        _locationBlocked ? 'Open Settings / Retry' : 'Continue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final tabs = [
      _HomeTab(
        locality: _locality,
        onPickLocality: _pickLocality,
        onOpenServices: () => setState(() => _index = 1),
      ),
      const _ServicesTab(),
      _BookingsTab(onOpenServices: () => setState(() => _index = 1)),
      const _SupportTab(),
      _ProfileTab(
        onLocalityChanged: (value) => setState(() => _locality = value),
      ),
    ];
    return Container(
      decoration: BoxDecoration(gradient: AppGradients.backgroundFor(context)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(index: _index, children: tabs),
        bottomNavigationBar: _BottomBar(
          index: _index,
          onChange: (x) => setState(() => _index = x),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChange;
  const _BottomBar({required this.index, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final reduce = AppMotion.reduceMotion(context);
    final duration = AppMotion.maybe(AppMotion.normal, context);
    final curve = AppMotion.maybeCurve(AppMotion.standard(context), context);
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.grid_view_rounded, 'Services'),
      (Icons.calendar_month_rounded, 'Bookings'),
      (Icons.support_agent_rounded, 'Support'),
      (Icons.person_rounded, 'Profile'),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cardFor(context),
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.strokeFor(context)),
        boxShadow: AppShadows.card(context),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth / items.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: duration,
                curve: curve,
                left: reduce ? w * index : (w * index),
                top: 0,
                bottom: 0,
                child: Container(
                  width: w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B6CB2), Color(0xFF5B948D)],
                    ),
                  ),
                ),
              ),
              Row(
                children: List.generate(items.length, (i) {
                  final active = i == index;
                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      onTap: () => onChange(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedScale(
                              duration: duration,
                              curve: curve,
                              scale: active ? 1.08 : 1,
                              child: Icon(
                                items[i].$1,
                                size: 22,
                                color: active
                                    ? Colors.white
                                    : AppColors.subtextFor(context),
                              ),
                            ),
                            AnimatedOpacity(
                              duration: duration,
                              opacity: active ? 1 : 0.72,
                              child: Text(
                                items[i].$2,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: active
                                      ? Colors.white
                                      : AppColors.subtextFor(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  final String locality;
  final VoidCallback onPickLocality;
  final VoidCallback onOpenServices;

  const _HomeTab({
    required this.locality,
    required this.onPickLocality,
    required this.onOpenServices,
  });

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _parallax;
  bool _chipPop = false;

  @override
  void initState() {
    super.initState();
    _parallax = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _HomeTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locality != widget.locality) {
      setState(() => _chipPop = true);
      Future.delayed(const Duration(milliseconds: 180), () {
        if (mounted) setState(() => _chipPop = false);
      });
    }
  }

  @override
  void dispose() {
    _parallax.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final name = provider.currentUser?.name.split(' ').first ?? 'there';
          final services = provider.services.take(4).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
            children: [
              AppReveal(
                child: _Hero(
                  controller: _parallax,
                  name: name,
                  locality: widget.locality,
                  pop: _chipPop,
                  onTapLocality: widget.onPickLocality,
                ),
              ),
              const SizedBox(height: 12),
              AppReveal(
                delayMs: 40,
                child: _RecentStrip(
                  bookings: provider.bookings.take(2).toList(),
                ),
              ),
              const SizedBox(height: 12),
              AppReveal(
                delayMs: 80,
                child: _SectionTitle(
                  title: 'Popular services',
                  action: 'View all',
                  onTap: widget.onOpenServices,
                ),
              ),
              const SizedBox(height: 10),
              AppReveal(
                delayMs: 120,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.92,
                  ),
                  itemBuilder: (_, i) => ServiceCard(
                    service: services[i],
                    onTap: () => _openBooking(context, services[i]),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const AppReveal(
                delayMs: 160,
                child: _SectionTitle(title: 'Offers'),
              ),
              const SizedBox(height: 8),
              AppReveal(
                delayMs: 180,
                child: SizedBox(
                  height: 126,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      OfferCard(
                        title: 'INR 50 Off',
                        subtitle: 'First booking discount for new users.',
                        buttonText: 'Apply',
                        color: AppColors.accent,
                        icon: Icons.local_offer_rounded,
                      ),
                      OfferCard(
                        title: 'Cash Friendly',
                        subtitle: 'Pay after service completion.',
                        buttonText: 'Know more',
                        color: AppColors.secondary,
                        icon: Icons.currency_rupee_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openBooking(BuildContext context, ServiceModel service) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: AppMotion.maybe(AppMotion.normal, context),
        reverseTransitionDuration: AppMotion.maybe(AppMotion.normal, context),
        pageBuilder: (routeContext, animation, secondaryAnimation) =>
            BookingFormScreen(service: service),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curve = AppMotion.maybeCurve(
            AppMotion.standard(context),
            context,
          );
          final curved = CurvedAnimation(parent: animation, curve: curve);
          final slide = Tween<Offset>(
            begin: const Offset(0.12, 0),
            end: Offset.zero,
          ).animate(curved);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final AnimationController controller;
  final String name;
  final String locality;
  final bool pop;
  final VoidCallback onTapLocality;

  const _Hero({
    required this.controller,
    required this.name,
    required this.locality,
    required this.pop,
    required this.onTapLocality,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final offset = (controller.value - 0.5) * 10;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.md),
            gradient: const LinearGradient(
              colors: [Color(0xFF2D5DA8), Color(0xFF4F8D87)],
            ),
            border: Border.all(color: const Color(0xFF7195C6)),
            boxShadow: AppShadows.card(context),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -12 + offset,
                top: -14 - offset,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedScale(
                        duration: AppMotion.maybe(AppMotion.fast, context),
                        curve: AppMotion.maybeCurve(
                          AppMotion.spring(context),
                          context,
                        ),
                        scale: pop ? 1.05 : 1,
                        child: InkWell(
                          onTap: onTapLocality,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  locality,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.notifications_none_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome, $name',
                    style: AppTheme.heroHeadline(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Book trusted local services with cash-on-completion flow.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecentStrip extends StatelessWidget {
  final List<BookingModel> bookings;
  const _RecentStrip({required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardFor(context),
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.strokeFor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent bookings',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          if (bookings.isEmpty)
            Text(
              'No recent bookings yet.',
              style: TextStyle(
                color: AppColors.subtextFor(context),
                fontSize: 12,
              ),
            )
          else
            ...bookings.map(
              (x) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${x.serviceName} • ${x.timeSlot}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;
  const _SectionTitle({required this.title, this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        if (action != null)
          InkWell(
            onTap: onTap,
            child: Text(
              action!,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _ServicesTab extends StatelessWidget {
  const _ServicesTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AppProvider>(
        builder: (context, p, _) {
          if (p.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            children: [
              Text(
                'Service List',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: p.services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.92,
                ),
                itemBuilder: (_, i) => AppReveal(
                  delayMs: 30 * i,
                  child: ServiceCard(
                    service: p.services[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BookingFormScreen(service: p.services[i]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BookingsTab extends StatelessWidget {
  final VoidCallback onOpenServices;
  const _BookingsTab({required this.onOpenServices});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AppProvider>(
        builder: (context, p, _) {
          if (p.bookings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 44,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No bookings yet',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Book your first service to start tracking here.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onOpenServices,
                        child: const Text('Browse Services'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
            children: [
              Text(
                'My Bookings',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              ...p.bookings.asMap().entries.map(
                (e) => AppReveal(
                  delayMs: 30 * e.key,
                  child: BookingItem(booking: e.value),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SupportTab extends StatelessWidget {
  const _SupportTab();

  Future<void> _launch(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) return;
    if (ok) {
      HapticFeedback.lightImpact();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this action')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        children: [
          Text(
            'Support',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Manual provider assignment is active in MVP, so live tracking is not available yet.',
            style: TextStyle(color: AppColors.subtextFor(context)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionChannelButton(
                  icon: Icons.call_rounded,
                  label: 'Call',
                  response: '~2 min',
                  onTap: () => _launch(
                    context,
                    Uri(scheme: 'tel', path: '+919000000000'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionChannelButton(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  response: '~5 min',
                  onTap: () => _launch(
                    context,
                    Uri.parse('https://wa.me/919000000000?text=Need%20support'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionChannelButton(
                  icon: Icons.mail_rounded,
                  label: 'Email',
                  response: '<24 hr',
                  onTap: () => _launch(
                    context,
                    Uri(
                      scheme: 'mailto',
                      path: 'support@fixmate.app',
                      query: 'subject=Fixmate Support',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChannelButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String response;
  final VoidCallback onTap;

  const _ActionChannelButton({
    required this.icon,
    required this.label,
    required this.response,
    required this.onTap,
  });

  @override
  State<_ActionChannelButton> createState() => _ActionChannelButtonState();
}

class _ActionChannelButtonState extends State<_ActionChannelButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.maybe(AppMotion.fast, context);
    final curve = AppMotion.maybeCurve(AppMotion.standard(context), context);
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: AnimatedScale(
          duration: duration,
          curve: curve,
          scale: _pressed ? 0.98 : 1,
          child: AnimatedContainer(
            duration: duration,
            curve: curve,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardFor(context),
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(color: AppColors.strokeFor(context)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deep.withValues(
                    alpha: _pressed ? 0.11 : 0.05,
                  ),
                  blurRadius: _pressed ? 14 : 8,
                  offset: Offset(0, _pressed ? 9 : 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(widget.icon, size: 22, color: AppColors.primary),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                Text(
                  widget.response,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.subtextFor(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatefulWidget {
  final ValueChanged<String> onLocalityChanged;
  const _ProfileTab({required this.onLocalityChanged});

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  static const _localityKey = 'selected_locality';
  static const _addressKey = 'profile_default_address';
  static const _timeWindowKey = 'profile_time_window';
  static const _areas = [
    'Perungudi',
    'OMR',
    'Velachery',
    'Adyar',
    'Thoraipakkam',
  ];
  static const _timeWindows = [
    'Morning (9-12)',
    'Afternoon (12-4)',
    'Evening (4-8)',
  ];

  String _locality = 'Perungudi';
  String _address = 'No default address';
  String _timeWindow = 'Evening (4-8)';
  bool _chipPop = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _locality = prefs.getString(_localityKey) ?? _locality;
      _address = prefs.getString(_addressKey) ?? _address;
      _timeWindow = prefs.getString(_timeWindowKey) ?? _timeWindow;
    });
  }

  Future<void> _editLocality() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: _areas
            .map(
              (area) => ListTile(
                leading: Icon(Icons.location_on_rounded, size: 22),
                title: Text(area),
                trailing: area == _locality
                    ? Icon(
                        Icons.check_circle_rounded,
                        size: 22,
                        color: AppColors.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(context, area),
              ),
            )
            .toList(),
      ),
    );
    if (picked == null || picked == _locality) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localityKey, picked);
    if (!mounted) return;
    setState(() {
      _locality = picked;
      _chipPop = true;
    });
    widget.onLocalityChanged(picked);
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) setState(() => _chipPop = false);
    });
  }

  Future<void> _editAddress() async {
    final controller = TextEditingController(
      text: _address == 'No default address' ? '' : _address,
    );
    final value = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter default service address',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: const Text('Save Address'),
              ),
            ),
          ],
        ),
      ),
    );
    if (value == null || value.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_addressKey, value);
    if (!mounted) return;
    setState(() => _address = value);
  }

  Future<void> _editTimeWindow() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: _timeWindows
            .map(
              (window) => ListTile(
                leading: Icon(Icons.schedule_rounded, size: 22),
                title: Text(window),
                trailing: window == _timeWindow
                    ? Icon(
                        Icons.check_circle_rounded,
                        size: 22,
                        color: AppColors.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(context, window),
              ),
            )
            .toList(),
      ),
    );
    if (picked == null || picked == _timeWindow) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timeWindowKey, picked);
    if (!mounted) return;
    setState(() => _timeWindow = picked);
  }

  Future<void> _openDeleteAccount() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@fixmate.app',
      query: 'subject=Delete%20Account%20Request',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to open mail app')));
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text(
          'You will need OTP login again to access bookings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (shouldLogout != true || !mounted) return;
    await Provider.of<AppProvider>(context, listen: false).logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _showPrivacyTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Legal & Trust'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We value your privacy. Your personal data (name, phone, address) is stored locally on your device. We do not sell your data. Booking details are shared with our operations team only when you initiate a booking via WhatsApp.',
              ),
              const SizedBox(height: 16),
              Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fixmate is a beta platform connecting valid service requests with local providers. \n\n1. "Fixmate" is an MVP pilot.\n2. Service quality is monitored but not guaranteed.\n3. Payments are cash-on-completion.\n4. We reserve the right to cancel bookings in unavailable areas.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Email: support@fixmate.app\nPhone: +91 90000 00000'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, p, _) {
        final u = p.currentUser;
        if (u == null) return const SizedBox.shrink();

        final bookings = p.bookings;
        final total = bookings.length;
        final completed = bookings.where((b) => b.status == 'completed').length;
        final joined = total == 0
            ? DateTime.now()
            : bookings
                  .map((b) => b.createdAt)
                  .reduce((a, b) => a.isBefore(b) ? a : b);

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            children: [
              AppReveal(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF304F83), Color(0xFF416DA9)],
                    ),
                    border: Border.all(color: const Color(0xFF7392C0)),
                    boxShadow: AppShadows.card(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            child: Text(u.name.characters.first.toUpperCase()),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  u.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  u.phoneNumber,
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          AnimatedScale(
                            duration: AppMotion.maybe(AppMotion.fast, context),
                            curve: AppMotion.maybeCurve(
                              AppMotion.spring(context),
                              context,
                            ),
                            scale: _chipPop ? 1.05 : 1,
                            child: InkWell(
                              onTap: _editLocality,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _locality,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Member since ${joined.month}/${joined.year}',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AppReveal(
                delayMs: 40,
                child: _ProfileStats(total: total, completed: completed),
              ),
              const SizedBox(height: 12),
              const AppReveal(
                delayMs: 70,
                child: _ProfileSectionTitle('How Service Works'),
              ),
              const SizedBox(height: 8),
              const AppReveal(
                delayMs: 90,
                child: _InfoBulletCard(
                  bullets: [
                    'Provider assignment is handled manually by support.',
                    'Live tracking is not available in this MVP stage.',
                    'Cash is collected after service completion.',
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const AppReveal(
                delayMs: 110,
                child: _ProfileSectionTitle('My Defaults'),
              ),
              const SizedBox(height: 8),
              AppReveal(
                delayMs: 130,
                child: _ProfileActionTile(
                  icon: Icons.location_city_rounded,
                  title: 'Preferred Locality',
                  subtitle: _locality,
                  onTap: _editLocality,
                ),
              ),
              AppReveal(
                delayMs: 145,
                child: _ProfileActionTile(
                  icon: Icons.home_work_rounded,
                  title: 'Default Address',
                  subtitle: _address,
                  onTap: _editAddress,
                ),
              ),
              AppReveal(
                delayMs: 160,
                child: _ProfileActionTile(
                  icon: Icons.schedule_rounded,
                  title: 'Preferred Time Window',
                  subtitle: _timeWindow,
                  onTap: _editTimeWindow,
                ),
              ),
              const SizedBox(height: 12),
              const AppReveal(
                delayMs: 180,
                child: _ProfileSectionTitle('Payments & Bills'),
              ),
              const SizedBox(height: 8),
              AppReveal(
                delayMs: 200,
                child: _ProfileActionTile(
                  icon: Icons.currency_rupee_rounded,
                  title: 'Payment Mode',
                  subtitle: 'Cash due on completion',
                  onTap: () {},
                ),
              ),
              AppReveal(
                delayMs: 215,
                child: _ProfileActionTile(
                  icon: Icons.receipt_long_rounded,
                  title: 'Invoices & History',
                  subtitle: 'Access past booking receipts',
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Use My Bookings tab for invoice history'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const AppReveal(
                delayMs: 235,
                child: _ProfileSectionTitle('Support & Safety'),
              ),
              const SizedBox(height: 8),
              AppReveal(
                delayMs: 250,
                child: _ProfileActionTile(
                  icon: Icons.support_agent_rounded,
                  title: 'Contact Support',
                  subtitle: 'Fast call/WhatsApp support',
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Use Support tab for channels'),
                    ),
                  ),
                ),
              ),
              AppReveal(
                delayMs: 265,
                child: _ProfileActionTile(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy & Terms',
                  subtitle: 'Read privacy policy and terms',
                  onTap: _showPrivacyTerms,
                ),
              ),
              const SizedBox(height: 12),
              const AppReveal(
                delayMs: 285,
                child: _ProfileSectionTitle('Account Actions'),
              ),
              const SizedBox(height: 8),
              AppReveal(
                delayMs: 300,
                child: _ProfileActionTile(
                  icon: Icons.delete_forever_rounded,
                  title: 'Request Account Deletion',
                  subtitle: 'Send deletion request by email',
                  onTap: _openDeleteAccount,
                ),
              ),
              const SizedBox(height: 10),
              AppReveal(
                delayMs: 320,
                child: OutlinedButton(
                  onPressed: _confirmLogout,
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  final String text;
  const _ProfileSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

class _ProfileStats extends StatelessWidget {
  final int total;
  final int completed;
  const _ProfileStats({required this.total, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardFor(context),
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.strokeFor(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'Bookings', value: '$total'),
          _StatItem(label: 'Completed', value: '$completed'),
          const _StatItem(label: 'Avg response', value: '~35m'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.subtextFor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _InfoBulletCard extends StatelessWidget {
  final List<String> bullets;
  const _InfoBulletCard({required this.bullets});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardFor(context),
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.strokeFor(context)),
      ),
      child: Column(
        children: bullets
            .map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(line)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ProfileActionTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ProfileActionTile> createState() => _ProfileActionTileState();
}

class _ProfileActionTileState extends State<_ProfileActionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.maybe(AppMotion.fast, context);
    final curve = AppMotion.maybeCurve(AppMotion.standard(context), context);
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: AnimatedScale(
          duration: duration,
          curve: curve,
          scale: _pressed ? 0.985 : 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.cardFor(context),
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(color: AppColors.strokeFor(context)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deep.withValues(
                    alpha: _pressed ? 0.10 : 0.05,
                  ),
                  blurRadius: _pressed ? 14 : 8,
                  offset: Offset(0, _pressed ? 9 : 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.softBlueFor(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.subtextFor(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: AppColors.subtextFor(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
