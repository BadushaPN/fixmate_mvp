import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fixmate/core/constants/app_colors.dart';

class OtpPage extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onVerify;
  final VoidCallback onBack;

  const OtpPage({
    super.key,
    required this.controller,
    required this.onVerify,
    required this.onBack,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  void initState() {
    super.initState();

    // 🔥 Automatically open keyboard on OTP screen
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          IconButton(
            iconSize: 30,
            onPressed: widget.onBack,
            icon: Icon(Icons.arrow_back),
          ),

          const SizedBox(height: 20),

          const Text(
            "Enter Code Sent\nTo Your Number",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 10),
          const Text(
            "We sent a 4-digit code to your mobile",
            style: TextStyle(fontSize: 15, color: AppColors.brandTextSubtle),
          ),

          const SizedBox(height: 30),

          // ---------------- OTP FIELDS ----------------
          OtpTextField(
            numberOfFields: 4,
            fieldWidth: 60,
            borderRadius: BorderRadius.circular(12),
            showFieldAsBox: true,
            autoFocus: true,
            cursorColor: AppColors.brandPrimary,

            enabledBorderColor: AppColors.brandPrimary,
            focusedBorderColor: AppColors.brandSecondary,
            borderWidth: 2,

            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.brandBackgroundDark,
            ),

            onCodeChanged: (code) {
              // Update controller so you can use it outside
              widget.controller.text = code;
            },

            onSubmit: (code) {
              widget.controller.text = code;
              widget.onVerify();
            },
          ),

          const SizedBox(height: 20),

          // ---------------- VERIFY BUTTON ----------------
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.onVerify,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Verify",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
