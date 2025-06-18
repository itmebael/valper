import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterFaceScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const RegisterFaceScreen({super.key, required this.cameras});

  @override
  State<RegisterFaceScreen> createState() => _RegisterFaceScreenState();
}

class _RegisterFaceScreenState extends State<RegisterFaceScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? _capturedImage;
  Uint8List? _webImageBytes;
  bool _isCameraActive = true;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras.first, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
        });
      }

      setState(() {
        _capturedImage = image;
        _isCameraActive = false;
        _isChecked = false;
      });
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  void _recapture() {
    setState(() {
      _capturedImage = null;
      _webImageBytes = null;
      _isCameraActive = true;
      _isChecked = false;
    });
  }

  void _checkFacePosition() {
    setState(() {
      _isChecked = true;
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
        title: Image.asset(
          'assets/valper_logo.png',
          height: 80,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Register Face',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
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
                    'Align your face within the frame',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.black,
                          child: _isCameraActive
                              ? FutureBuilder<void>(
                                  future: _initializeControllerFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      return CameraPreview(_controller);
                                    } else {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                  },
                                )
                              : _capturedImage != null
                                  ? kIsWeb
                                      ? Image.memory(_webImageBytes!, fit: BoxFit.cover)
                                      : Image.file(File(_capturedImage!.path), fit: BoxFit.cover)
                                  : const Center(child: Text('No Image')),
                        ),

                        // Face alignment frame
                        if (_isCameraActive || _capturedImage != null)
                          Positioned(
                            width: 140,
                            height: 160,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _isChecked ? Colors.greenAccent : Colors.white,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                      ],
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
                        icon: const Icon(Icons.check),
                        label: const Text('Check'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              !_isCameraActive && _capturedImage != null ? Colors.orange : Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: !_isCameraActive && _capturedImage != null
                            ? _checkFacePosition
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isChecked ? Colors.green : Colors.grey,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _isChecked ? () => Navigator.pop(context, true) : null,
            ),
          ],
        ),
      ),
    );
  }
}
