import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';

class RegisterLicensePlateScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const RegisterLicensePlateScreen({super.key, required this.cameras});

  @override
  State<RegisterLicensePlateScreen> createState() =>
      _RegisterLicensePlateScreenState();
}

class _RegisterLicensePlateScreenState
    extends State<RegisterLicensePlateScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? _capturedImage;
  Uint8List? _webImageBytes;
  bool _isCameraActive = true;
  final TextEditingController _plateController = TextEditingController();
  bool _submitted = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _controller =
        CameraController(widget.cameras.first, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _capturedImage = image;
          _webImageBytes = bytes;
          _isCameraActive = false;
          isChecked = false;
        });
      } else {
        setState(() {
          _capturedImage = image;
          _isCameraActive = false;
          isChecked = false;
        });
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  void _recapture() {
    setState(() {
      _capturedImage = null;
      _webImageBytes = null;
      _isCameraActive = true;
      isChecked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Image.asset('assets/valper_logo.png', height: 160),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Register License Plate',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _plateController,
              decoration: InputDecoration(
                hintText: 'Enter your License Plate Number',
                filled: true,
                fillColor: Colors.blue[800],
                hintStyle: GoogleFonts.poppins(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.poppins(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Capture clearly your License Plate Number',
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Colors.blue[800],
                      height: 180,
                      width: double.infinity,
                      child: _isCameraActive
                          ? FutureBuilder<void>(
                              future: _initializeControllerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return CameraPreview(_controller);
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            )
                          : _capturedImage != null
                              ? kIsWeb
                                  ? Image.memory(
                                      _webImageBytes!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(_capturedImage!.path),
                                      fit: BoxFit.cover,
                                    )
                              : const Center(
                                  child: Text(
                                    'No Image Captured',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Capture'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue[800],
                        ),
                        onPressed: _isCameraActive ? _takePicture : null,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.replay),
                        label: const Text('Recapture'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue[800],
                        ),
                        onPressed: !_isCameraActive ? _recapture : null,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Check'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              !_isCameraActive ? Colors.green : Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: !_isCameraActive
                            ? () {
                                setState(() {
                                  isChecked = true;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isChecked ? Colors.blue[800] : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: isChecked
                  ? () {
                      setState(() {
                        _submitted = true;
                      });
                      Navigator.pop(context, true);
                    }
                  : null,
              child: Text(
                'Submit',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: 'Records'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_parking), label: 'Parking Slot'),
          BottomNavigationBarItem(icon: Icon(Icons.support), label: 'Support'),
        ],
      ),
    );
  }
}
