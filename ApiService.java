import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin/model/user.dart';
import 'package:admin/model/plan.dart';
import 'package:admin/model/nutri.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Phương thức lấy danh sách người dùng
  Future<List<User>> fetchUsers() async {
    final url = Uri.parse('${baseUrl}api/Users');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<List<Plan>> fetchPlans() async {
    final url = Uri.parse('${baseUrl}api/Planlist');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Plan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load plans');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  
  Future<List<Nutri>> fetchNutriList() async {
    final url = Uri.parse('${baseUrl}api/NutriList');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(data);
        print('Fetched Nutri List: $data'); // In dữ liệu JSON trả về
        return data.map((json) => Nutri.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load nutri list');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
}
