import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_reveal.dart';
import 'home_screen.dart';

class ProfileNameScreen extends StatefulWidget {
  const ProfileNameScreen({super.key});

  @override
  State<ProfileNameScreen> createState() => _ProfileNameScreenState();
}

class _ProfileNameScreenState extends State<ProfileNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _saving = false;

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid name')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await Provider.of<AppProvider>(context, listen: false).updateProfileName(name);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppGradients.backgroundFor(context)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppReveal(
                  child: Text(
                    'What should we call you?',
                    style: AppTheme.heroHeadline(context),
                  ),
                ),
                const SizedBox(height: 8),
                AppReveal(
                  delayMs: 60,
                  child: Text(
                    'Add your profile name to continue.',
                    style: TextStyle(
                      color: AppColors.subtextFor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                AppReveal(
                  delayMs: 120,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardFor(context),
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      boxShadow: AppShadows.card(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Profile Name',
                            hintText: 'Enter your full name',
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: _saving ? null : _save,
                          child: _saving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Continue'),
                        ),
                      ],
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
}
