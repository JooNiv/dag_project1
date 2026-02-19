import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NormalButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 81, 192, 7),
        //side: const BorderSide(color: Color.fromARGB(128, 29, 180, 255), width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Less rounded corners
        ),
        shadowColor: Colors.black,
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }
}

class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DangerButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        //side: const BorderSide(color: Colors.black, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Less rounded corners
        ),
        shadowColor: Colors.black,
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }
}

class WarningButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const WarningButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 243, 159, 69),
        //side: const BorderSide(color: Colors.black, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Less rounded corners
        ),
        shadowColor: Colors.black,
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }
}

class NavDrawerButtons extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Icon? icon;

  const NavDrawerButtons({super.key, this.text, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          //side: const BorderSide(color: Colors.grey, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          overlayColor: const Color.fromARGB(66, 0, 0, 0),
          shadowColor: Colors.transparent,
          elevation: 0
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox.shrink(),
            const SizedBox(width: 10),
            Text(text ?? "", style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}