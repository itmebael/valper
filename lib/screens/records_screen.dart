import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final profileResponse = await supabase
        .from('profiles')
        .select('username')
        .eq('id', user.id)
        .single();

    final username = profileResponse['username'];

    final data = await supabase
        .from('license_verify')
        .select()
        .eq('name', username)
        .order('created_at', ascending: false);

    setState(() {
      _records = List<Map<String, dynamic>>.from(data);
      _isLoading = false;
    });
  }

  Widget _buildRecordTile(Map<String, dynamic> record) {
    final date = DateTime.parse(record['created_at']);
    final formattedDate = DateFormat('MM/dd/yyyy h:mm a').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[700],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('IN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(formattedDate, style: const TextStyle(color: Colors.white)),
            Text(record['name'], style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Image.asset('assets/valper_logo.png', height: 60),
                        const SizedBox(height: 10),
                        const Text(
                          'Records',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _records.length,
                        itemBuilder: (context, index) {
                          return _buildRecordTile(_records[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Records'),
          BottomNavigationBarItem(icon: Icon(Icons.local_parking), label: 'Parking Slot'),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Support'),
        ],
        onTap: (index) {
          // Add your navigation logic here
        },
      ),
    );
  }
}
