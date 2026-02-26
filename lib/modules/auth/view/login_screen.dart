import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixmate/core/constants/app_colors.dart';
import 'package:fixmate/modules/auth/widgets/login_phone_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fixmate/core/routes/app_routes.dart';
// import 'login_phone_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  Future<void> onNext() async {
    if (phoneCtrl.text.length != 10) {
      Get.snackbar("Invalid", "Enter valid 10-digit number");
      return;
    }

    final confirmed = await _confirmPhoneDialog();
    if (!confirmed) return;

    final name = await _askNameDialog();
    if (name == null || name.trim().isEmpty) return;

    await _saveUser(phoneCtrl.text, name);
    Get.offAllNamed(AppRoutes.home);
  }

  // ---------------- DIALOGS ----------------

  Future<bool> _confirmPhoneDialog() async {
    return await Get.dialog<bool>(
          Dialog(
            backgroundColor: AppColors.brandBackgroundLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirm Mobile Number",
                    style: GoogleFonts.sora(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brandTextDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "+91 ${phoneCtrl.text}",
                    style: GoogleFonts.sora(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brandPrimary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(result: false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.brandPrimary,
                            side: const BorderSide(
                              color: AppColors.brandBorder,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Edit"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandSecondary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Confirm",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }

  Future<String?> _askNameDialog() async {
    nameCtrl.clear();

    return await Get.dialog<String>(
      Dialog(
        backgroundColor: AppColors.brandBackgroundLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Profile",
                style: GoogleFonts.sora(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandTextDark,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: nameCtrl,
                autofocus: true,
                style: GoogleFonts.sora(
                  fontSize: 16,
                  color: AppColors.brandTextDark,
                ),
                decoration: InputDecoration(
                  hintText: "Your name",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.brandBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.brandBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.brandPrimary),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.trim().isNotEmpty) {
                      Get.back(result: nameCtrl.text.trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandSecondary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- DATA ----------------

  Future<void> _saveUser(String phone, String name) async {
    final prefs = await SharedPreferences.getInstance();

    // LOCAL SAVE
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userid', phone);
    await prefs.setString('username', name);
    await prefs.setString('usermobile', phone);

    // FIRESTORE UPSERT
    final doc = FirebaseFirestore.instance.collection('customers').doc(phone);

    await doc.set({
      'userid': phone,
      'username': name,
      'usermobile': phone,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PhonePage(controller: phoneCtrl, onNext: onNext),
    );
  }
}
