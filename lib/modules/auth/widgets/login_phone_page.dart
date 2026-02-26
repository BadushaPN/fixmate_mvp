import 'package:flutter/material.dart';

class PhonePage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onNext;

  const PhonePage({super.key, required this.controller, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),

          const SizedBox(height: 20),

          const Text(
            "Enter Your\nMobile Number",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 10),
          const Text(
            "We will send you a confirmation code",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),

          const SizedBox(height: 30),

          // ---------------- PHONE FIELD ----------------
          Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                const Text("(+91)", style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintText: "Phone Number",
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------------- BUTTON ----------------
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Next",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // const SizedBox(height: 30),

          // ---------------- KEYPAD ----------------
          // Expanded(
          //   child: GridView.builder(
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: 12,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 3,
          //       mainAxisSpacing: 16,
          //       crossAxisSpacing: 16,
          //     ),
          //     itemBuilder: (_, i) {
          //       if (i == 9) return const SizedBox(); // empty

          //       if (i == 11) {
          //         return GestureDetector(
          //           onTap: () {
          //             if (controller.text.isNotEmpty) {
          //               controller.text = controller.text.substring(
          //                 0,
          //                 controller.text.length - 1,
          //               );
          //             }
          //           },
          //           child: const Icon(Icons.close, size: 32),
          //         );
          //       }

          //       int number = (i == 10) ? 0 : i + 1;

          //       return GestureDetector(
          //         onTap: () {
          //           if (controller.text.length < 10) {
          //             controller.text += number.toString();
          //           }
          //         },
          //         child: Container(
          //           alignment: Alignment.center,
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             border: Border.all(color: Colors.black26),
          //           ),
          //           child: Text(
          //             number.toString(),
          //             style: const TextStyle(
          //               fontSize: 26,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
