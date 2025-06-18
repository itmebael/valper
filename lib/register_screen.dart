import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'register_details_form.dart';
import 'register_license_plate_screen.dart';
import 'register_face_screen.dart';
import 'widgets/bottom_nav_bar.dart';

class RegisterStepsScreen extends StatefulWidget {
  final bool isStudent;

  const RegisterStepsScreen({super.key, required this.isStudent});

  @override
  State<RegisterStepsScreen> createState() => _RegisterStepsScreenState();
}

class _RegisterStepsScreenState extends State<RegisterStepsScreen> {
  bool isDetailsComplete = false;
  bool isLicensePlateRegistered = false;
  bool isFaceRegistered = false;

  int _selectedIndex = 0;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    try {
      _cameras = await availableCameras();
      setState(() {});
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _checkRegistrationComplete() {
    if (isDetailsComplete && isLicensePlateRegistered && isFaceRegistered) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Complete'),
          content: const Text('You are registered!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _openDetailsForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterDetailsForm(isStudent: widget.isStudent),
      ),
    );

    if (result == true) {
      setState(() {
        isDetailsComplete = true;
      });
      _checkRegistrationComplete();
    }
  }

  Future<void> _openLicensePlateScreen() async {
    if (_cameras.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No cameras available')),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterLicensePlateScreen(cameras: _cameras),
      ),
    );

    if (result == true) {
      setState(() {
        isLicensePlateRegistered = true;
      });
      _checkRegistrationComplete();
    }
  }

  Future<void> _openFaceRegistration() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterFaceScreen(cameras: _cameras),
      ),
    );

    if (result == true) {
      setState(() {
        isFaceRegistered = true;
      });
      _checkRegistrationComplete();
    }
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/records');
        break;
      case 2:
        Navigator.pushNamed(context, '/parking');
        break;
      case 3:
        Navigator.pushNamed(context, '/support');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
      appBar: AppBar(
        title: Text(
          'Vehicle Registration',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset('assets/valper_logo.png', height: 160),
            const SizedBox(height: 20),
            Text(
              'Complete the details below to Register Vehicle Access!',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            buildStepButton(
              title: 'Complete Details',
              icon: isDetailsComplete ? Icons.check_circle : Icons.info,
              color: isDetailsComplete ? Colors.green : Colors.blue[800]!,
              onTap: _openDetailsForm,
            ),
            const SizedBox(height: 12),
            buildStepButton(
              title: 'Register License Plate',
              icon: isLicensePlateRegistered ? Icons.check_circle : Icons.warning,
              color: isLicensePlateRegistered ? Colors.green : Colors.red,
              onTap: _openLicensePlateScreen,
            ),
            const SizedBox(height: 12),
            buildStepButton(
              title: 'Register Face',
              icon: isFaceRegistered ? Icons.check_circle : Icons.warning,
              color: isFaceRegistered ? Colors.green : Colors.red,
              onTap: _openFaceRegistration,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStepButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}
