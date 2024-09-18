import 'package:flutter/material.dart';
import 'package:admin/data/api_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService('http://10.20.15.158:7059/');
  int _nutriCount = 0;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchNutriCount();
  }

  Future<void> _fetchNutriCount() async {
    try {
      final count = await _apiService.getNutriCount();
      setState(() {
        _nutriCount = count;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _hasError
            ? Text('Failed to load data', style: TextStyle(color: Colors.red))
            : Text(
          'Total Nutri Count: $_nutriCount',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
