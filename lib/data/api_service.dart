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

  // Phương thức thêm người dùng
  Future<void> addUser(User user) async {
    final url = Uri.parse('${baseUrl}api/Users');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<void> updateUser(int id, User user) async {
    final url = Uri.parse('${baseUrl}api/Users/$id');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }


  // Phương thức xóa người dùng
  Future<void> deleteUser(int id) async {
    final url = Uri.parse('${baseUrl}api/Users/$id');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  // Phương thức lấy danh sách kế hoạch
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
  // Thêm phương thức để thêm, cập nhật, và xóa kế hoạch
  Future<void> addPlan({
    required String nameplan,
    required String level,
    required String repeat,
    required String time,
    required String idyoutube,
    required String imageplan,
  }) async {
    final url = Uri.parse('${baseUrl}api/Planlist');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nameplan': nameplan,
        'level': level,
        'repeat': repeat,
        'time': time,
        'idyoutube': idyoutube,
        'imageplan': imageplan,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add plan');
    }
  }

  Future<void> updatePlan({
    required int id,
    required String nameplan,
    required String level,
    required String repeat,
    required String time,
    required String idyoutube,
    required String imageplan,
  }) async {
    final url = Uri.parse('${baseUrl}api/Planlist/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nameplan': nameplan,
        'level': level,
        'repeat': repeat,
        'time': time,
        'idyoutube': idyoutube,
        'imageplan': imageplan,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update plan');
    }
  }

  Future<void> deletePlan(int id) async {
    final url = Uri.parse('${baseUrl}api/Planlist/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete plan');
    }
  }


  //đếm nutri
  Future<int> getNutriCount() async {
    final response = await http.get(Uri.parse('$baseUrl/api/NutriList/count'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'];
    } else {
      throw Exception('Failed to get Nutri count');
    }
  }
  // Phương thức lấy danh sách Nutri
  Future<List<Nutri>> fetchNutriList() async {
    final url = Uri.parse('${baseUrl}api/NutriList');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Nutri.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load nutri list');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  // Phương thức thêm mới Nutri
  Future<void> addNutri({
    required String meal,
    required int calo,
    required String timeCook,
    required String imagenutri,
    required String howToCook,
    bool ready = true,
    bool favorite = false,
  }) async {
    final url = Uri.parse('${baseUrl}api/NutriList');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'meal': meal,
        'calo': calo,
        'timeCook': timeCook,
        'imagenutri': imagenutri,
        'howToCook': howToCook,
        'ready': ready,
        'favorite': favorite,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add nutri');
    }
  }
  // Phương thức chỉnh sửa Nutri
  Future<void> editNutri({
    required int id,
    required String meal,
    required int calo,
    required String timeCook,
    required String imagenutri,
    required String howToCook,
    bool ready = true,
    bool favorite = false,
  }) async {
    final url = Uri.parse('${baseUrl}api/NutriList/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'meal': meal,
        'calo': calo,
        'timeCook': timeCook,
        'imagenutri': imagenutri,
        'howToCook': howToCook,
        'ready': ready,
        'favorite': favorite,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit nutri');
    }
  }

  // Phương thức xóa Nutri
  Future<void> deleteNutri(int id) async {
    final url = Uri.parse('${baseUrl}api/NutriList/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete nutri');
    }
  }
}
