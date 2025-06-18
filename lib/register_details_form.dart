import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterDetailsForm extends StatefulWidget {
  final bool isStudent;

  const RegisterDetailsForm({super.key, required this.isStudent});

  @override
  State<RegisterDetailsForm> createState() => _RegisterDetailsFormState();
}

class _RegisterDetailsFormState extends State<RegisterDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();

  // Student-specific
  final _birthdayController = TextEditingController();
  final _ssuIdController = TextEditingController();
  final _collegeController = TextEditingController();

  // Faculty-specific
  final _designationController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    _ssuIdController.dispose();
    _collegeController.dispose();
    _designationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = widget.isStudent;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isStudent ? 'Student Details' : 'Faculty Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/valper_logo.png',
                  height: 200,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(_fullNameController, 'Full Name'),
              const SizedBox(height: 16),

              if (isStudent) ...[
                _buildTextField(_birthdayController, 'Birthday (MM/DD/YYYY)'),
                const SizedBox(height: 16),
                _buildTextField(_ssuIdController, 'SSU ID'),
                const SizedBox(height: 16),
                _buildTextField(_contactController, 'Contact Number'),
                const SizedBox(height: 16),
                _buildTextField(_emailController, 'Email Account'),
                const SizedBox(height: 16),
                _buildTextField(_collegeController, 'College (e.g. COENG-MAIN)'),
              ] else ...[
                _buildTextField(_contactController, 'Contact Number'),
                const SizedBox(height: 16),
                _buildTextField(_emailController, 'Email Account'),
                const SizedBox(height: 16),
                _buildTextField(_designationController, 'Designation'),
              ],

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        border: const OutlineInputBorder(),
      ),
      style: GoogleFonts.poppins(),
      validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
    );
  }
}
