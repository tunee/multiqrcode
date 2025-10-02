import 'dart:async';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'history_page.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-QR Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ScanPage(),
    );
  }
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  int _pendingCount = 0;
  String _status = 'App Ready';
  bool _isOnline = false;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadPendingCount();
  }

  void _loadPendingCount() async {
    try {
      final count = await _dbHelper.getPendingCount();
      setState(() {
        _pendingCount = count;
        _status = 'Ready - $count pending records';
      });
    } catch (e) {
      setState(() {
        _status = 'Database error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-QR Attendance'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: _isOnline ? Colors.green.shade100 : Colors.orange.shade100,
            child: Column(
              children: [
                Text(
                  _status,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (_pendingCount > 0)
                  Text('Pending sync: $_pendingCount records'),
              ],
            ),
          ),
          
          // Main content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 100,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Camera functionality disabled',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This is a basic version without camera/QR scanning.\nFull functionality requires camera dependencies.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _loadPendingCount,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Status'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}