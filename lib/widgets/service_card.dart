import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../theme/app_motion.dart';
import '../theme/app_theme.dart';
import '../utils/service_meta.dart';

class ServiceCard extends StatefulWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const ServiceCard({required this.service, required this.onTap, super.key});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  double _rx = 0;
  double _ry = 0;
  bool _pressed = false;

  void _updateTilt(Offset localPos, Size size) {
    final dx = ((localPos.dx / size.width) - 0.5).clamp(-0.5, 0.5);
    final dy = ((localPos.dy / size.height) - 0.5).clamp(-0.5, 0.5);
    final max = 0.10;
    setState(() {
      _ry = dx * max;
      _rx = -dy * max;
    });
  }

  void _resetTilt() {
    setState(() {
      _rx = 0;
      _ry = 0;
      _pressed = false;
    });
  }

  Color _surfaceColor(String name) {
    final colors = [
      const Color(0xFFEDF3FC),
      const Color(0xFFEAF4F2),
      const Color(0xFFFAF2EA),
      const Color(0xFFF1F6EF),
      const Color(0xFFF3F0F8),
    ];
    return colors[name.length % colors.length];
  }

  Color _accentColor(String name) {
    final colors = [
      const Color(0xFF2F5FA8),
      const Color(0xFF3E7A95),
      const Color(0xFFB07A3A),
      const Color(0xFF4A8663),
      const Color(0xFF766099),
    ];
    return colors[name.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final icon = IconData(
      int.parse(widget.service.iconCode, radix: 16),
      fontFamily: 'MaterialIcons',
    );
    final surface = _surfaceColor(widget.service.name);
    final accent = _accentColor(widget.service.name);
    final reduce = AppMotion.reduceMotion(context);
    final duration = AppMotion.maybe(AppMotion.normal, context);
    final curve = AppMotion.maybeCurve(AppMotion.standard(context), context);

    final card = Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.cardFor(context),
        borderRadius: BorderRadius.circular(AppRadii.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.deep.withValues(alpha: _pressed ? 0.14 : 0.08),
            blurRadius: _pressed ? 20 : 14,
            offset: Offset(0, _pressed ? 12 : 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    surface,
                    Colors.white,
                    AppColors.softBlueFor(context).withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -14,
                    right: -10,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: accent.withValues(alpha: 0.15),
                    ),
                  ),
                  Center(child: Icon(icon, size: 24, color: accent)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 2),
            child: Text(
              widget.service.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: Text(
              'Starts at INR ${ServiceMeta.startingPrice(widget.service)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.subtextFor(context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.softBlueFor(context),
                    AppColors.softBlueFor(context).withValues(alpha: 0.82),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                'Next: ${ServiceMeta.nextAvailableSlot(widget.service)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return SizedBox(
      width: 170,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Listener(
            onPointerDown: (event) {
              setState(() => _pressed = true);
              if (!reduce) {
                _updateTilt(event.localPosition, constraints.biggest);
              }
            },
            onPointerMove: (event) {
              if (!reduce) {
                _updateTilt(event.localPosition, constraints.biggest);
              }
            },
            onPointerUp: (_) => _resetTilt(),
            onPointerCancel: (_) => _resetTilt(),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadii.md),
              onTap: widget.onTap,
              child: AnimatedScale(
                duration: duration,
                curve: curve,
                scale: _pressed ? 0.97 : 1,
                child: TweenAnimationBuilder<double>(
                  duration: duration,
                  curve: curve,
                  tween: Tween<double>(
                    begin: 0,
                    end: reduce ? 0 : 1,
                  ),
                  builder: (context, value, child) {
                    final matrix = Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(_rx * value)
                      ..rotateY(_ry * value);
                    return Transform(
                      alignment: Alignment.center,
                      transform: matrix,
                      child: child,
                    );
                  },
                  child: card,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
