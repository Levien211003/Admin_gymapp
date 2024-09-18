import 'package:flutter/material.dart';
import 'package:admin/data/api_service.dart';
import 'package:admin/model/user.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ApiService _apiService = ApiService('http://10.20.15.158:7059/');
  late Future<List<User>> _userListFuture;

  @override
  void initState() {
    super.initState();
    _userListFuture = _apiService.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: FutureBuilder<List<User>>(
        future: _userListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No User data available', style: TextStyle(fontSize: 18, color: Colors.grey)));
          } else {
            final userList = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: DataTable(
                    columnSpacing: 16.0,
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.black),
                    dataRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[850]!),
                    dividerThickness: 2,
                    columns: _buildDataColumns(),
                    rows: _buildDataRows(userList),
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  List<DataColumn> _buildDataColumns() {
    return [
      DataColumn(label: _buildColumnHeader('No.', Colors.red)),
      DataColumn(label: _buildColumnHeader('ID', Colors.yellow)),
      DataColumn(label: _buildColumnHeader('Username', Colors.green)),
      DataColumn(label: _buildColumnHeader('Email', Colors.blue)),
      DataColumn(label: _buildColumnHeader('Age', Colors.purple)),
      DataColumn(label: _buildColumnHeader('Height', Colors.teal)),
      DataColumn(label: _buildColumnHeader('Weight', Colors.indigo)),
      DataColumn(label: _buildColumnHeader('Gender', Colors.cyan)),
      DataColumn(label: _buildColumnHeader('MucTieu', Colors.lime)),
      DataColumn(label: _buildColumnHeader('Fullname', Colors.pink)),
      DataColumn(label: _buildColumnHeader('Nickname', Colors.orange)),
      DataColumn(label: _buildColumnHeader('MobileNumber', Colors.brown)),
      DataColumn(label: _buildColumnHeader('Image', Colors.redAccent)),
      DataColumn(label: _buildColumnHeader('Level', Colors.amber)),
      DataColumn(label: _buildColumnHeader('Edit', Colors.lime)),
      DataColumn(label: _buildColumnHeader('Delete', Colors.orange)),
    ];
  }

  Widget _buildColumnHeader(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  List<DataRow> _buildDataRows(List<User> userList) {
    return List<DataRow>.generate(
      userList.length,
          (index) {
        final user = userList[index];
        return DataRow(
          cells: [
            DataCell(Text(
              (index + 1).toString(),
              style: TextStyle(color: Colors.red),
            )),
            DataCell(Text(
              user.id.toString(),
              style: TextStyle(color: Colors.yellow),
            )),
            DataCell(Text(
              user.username,
              style: TextStyle(color: Colors.green),
            )),
            DataCell(Text(
              user.email,
              style: TextStyle(color: Colors.blue),
            )),
            DataCell(Text(
              user.age?.toString() ?? '',
              style: TextStyle(color: Colors.purple),
            )),
            DataCell(Text(
              user.height?.toString() ?? '',
              style: TextStyle(color: Colors.teal),
            )),
            DataCell(Text(
              user.weight?.toString() ?? '',
              style: TextStyle(color: Colors.indigo),
            )),
            DataCell(Text(
              user.gender ?? '',
              style: TextStyle(color: Colors.cyan),
            )),
            DataCell(Text(
              user.mucTieu ?? '',
              style: TextStyle(color: Colors.lime),
            )),
            DataCell(Text(
              user.fullname ?? '',
              style: TextStyle(color: Colors.pink),
            )),
            DataCell(Text(
              user.nickname ?? '',
              style: TextStyle(color: Colors.orange),
            )),
            DataCell(Text(
              user.mobileNumber ?? '',
              style: TextStyle(color: Colors.brown),
            )),
            DataCell(Text(
              user.image ?? '',
              style: TextStyle(color: Colors.redAccent),
            )),
            DataCell(Text(
              user.level ?? '',
              style: TextStyle(color: Colors.amber),
            )),
            DataCell(
              IconButton(
                icon: Icon(Icons.edit, color: Colors.cyan),
                onPressed: () => _showEditDialog(context, user),
              ),
            ),
            DataCell(
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, user),
              ),
            ),
          ],
        );
      },
    );
  }

  TextField _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: label == 'Age' || label == 'Height' || label == 'Weight'
          ? TextInputType.number
          : TextInputType.text,
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final ageController = TextEditingController();
    final heightController = TextEditingController();
    final weightController = TextEditingController();
    final genderController = TextEditingController();
    final mucTieuController = TextEditingController();
    final fullnameController = TextEditingController();
    final nicknameController = TextEditingController();
    final mobileNumberController = TextEditingController();
    final imageController = TextEditingController();
    final levelController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add User', style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTextField(usernameController, 'Username'),
                _buildTextField(emailController, 'Email'),
                _buildTextField(passwordController, 'Password'),
                _buildTextField(ageController, 'Age'),
                _buildTextField(heightController, 'Height'),
                _buildTextField(weightController, 'Weight'),
                _buildTextField(genderController, 'Gender'),
                _buildTextField(mucTieuController, 'MucTieu'),
                _buildTextField(fullnameController, 'Fullname'),
                _buildTextField(nicknameController, 'Nickname'),
                _buildTextField(mobileNumberController, 'Mobile Number'),
                _buildTextField(imageController, 'Image'),
                _buildTextField(levelController, 'Level'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = User(
                  id: 0, // ID sẽ được tự động tạo bởi server khi thêm mới
                  username: usernameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  age: int.tryParse(ageController.text) ?? 0, // default to 0 if null
                  height: double.tryParse(heightController.text) ?? 0.0, // default to 0.0 if null
                  weight: double.tryParse(weightController.text) ?? 0.0,
                  gender: genderController.text,
                  mucTieu: mucTieuController.text,
                  fullname: fullnameController.text,
                  nickname: nicknameController.text,
                  mobileNumber: mobileNumberController.text,
                  image: imageController.text,
                  level: levelController.text,
                );
                await _apiService.addUser(user);
                setState(() {
                  _userListFuture = _apiService.fetchUsers();
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, User user) {
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);
    final passwordController = TextEditingController(); // Leaving this empty for editing
    final ageController = TextEditingController(text: user.age?.toString() ?? '');
    final heightController = TextEditingController(text: user.height?.toString() ?? '');
    final weightController = TextEditingController(text: user.weight?.toString() ?? '');
    final genderController = TextEditingController(text: user.gender ?? '');
    final mucTieuController = TextEditingController(text: user.mucTieu ?? '');
    final fullnameController = TextEditingController(text: user.fullname ?? '');
    final nicknameController = TextEditingController(text: user.nickname ?? '');
    final mobileNumberController = TextEditingController(text: user.mobileNumber ?? '');
    final imageController = TextEditingController(text: user.image ?? '');
    final levelController = TextEditingController(text: user.level ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User', style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTextField(usernameController, 'Username'),
                _buildTextField(emailController, 'Email'),
                _buildTextField(passwordController, 'Password'),
                _buildTextField(ageController, 'Age'),
                _buildTextField(heightController, 'Height'),
                _buildTextField(weightController, 'Weight'),
                _buildTextField(genderController, 'Gender'),
                _buildTextField(mucTieuController, 'MucTieu'),
                _buildTextField(fullnameController, 'Fullname'),
                _buildTextField(nicknameController, 'Nickname'),
                _buildTextField(mobileNumberController, 'Mobile Number'),
                _buildTextField(imageController, 'Image'),
                _buildTextField(levelController, 'Level'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedUser = User(
                  id: user.id,
                  username: usernameController.text,
                  email: emailController.text,
                  password: passwordController.text.isEmpty ? user.password : passwordController.text,
                  age: int.tryParse(ageController.text) ?? user.age,
                  height: double.tryParse(heightController.text) ?? user.height,
                  weight: double.tryParse(weightController.text) ?? user.weight,
                  gender: genderController.text,
                  mucTieu: mucTieuController.text,
                  fullname: fullnameController.text,
                  nickname: nicknameController.text,
                  mobileNumber: mobileNumberController.text,
                  image: imageController.text,
                  level: levelController.text,
                );
                await _apiService.updateUser(user.id,updatedUser);
                setState(() {
                  _userListFuture = _apiService.fetchUsers();
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _apiService.deleteUser(user.id);
                setState(() {
                  _userListFuture = _apiService.fetchUsers();
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
