import 'package:flutter/material.dart';
import 'package:admin/data/api_service.dart';
import 'package:admin/model/plan.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final ApiService _apiService = ApiService('http://10.20.15.158:7059/');
  late Future<List<Plan>> _planListFuture;

  @override
  void initState() {
    super.initState();
    _planListFuture = _apiService.fetchPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: FutureBuilder<List<Plan>>(
        future: _planListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Plan>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Plan data available', style: TextStyle(fontSize: 18, color: Colors.grey)));
          } else {
            final planList = snapshot.data!;
            return SingleChildScrollView(
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
                  rows: _buildDataRows(planList),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPlanDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  List<DataColumn> _buildDataColumns() {
    return [
      DataColumn(label: _buildColumnHeader('No.', Colors.red)),
      DataColumn(label: _buildColumnHeader('Image', Colors.orange)),
      DataColumn(label: _buildColumnHeader('ID', Colors.yellow)),
      DataColumn(label: _buildColumnHeader('Name', Colors.green)),
      DataColumn(label: _buildColumnHeader('Level', Colors.blue)),
      DataColumn(label: _buildColumnHeader('Repeat', Colors.purple)),
      DataColumn(label: _buildColumnHeader('Time', Colors.teal)),
      DataColumn(label: _buildColumnHeader('Favorite', Colors.indigo)),
      DataColumn(label: _buildColumnHeader('YouTube ID', Colors.cyan)),
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

  List<DataRow> _buildDataRows(List<Plan> planList) {
    return List<DataRow>.generate(
      planList.length,
          (index) {
        final plan = planList[index];
        final imageUrl = plan.imageplan; // URL của hình ảnh

        return DataRow(
          cells: [
            DataCell(Text(
              (index + 1).toString(),
              style: TextStyle(color: Colors.red),
            )),
            DataCell(
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
              ),
            ),
            DataCell(Text(
              plan.id.toString(),
              style: TextStyle(color: Colors.yellow),
            )),
            DataCell(Text(
              plan.nameplan,
              style: TextStyle(color: Colors.green),
            )),
            DataCell(Text(
              plan.level,
              style: TextStyle(color: Colors.blue),
            )),
            DataCell(Text(
              plan.repeat,
              style: TextStyle(color: Colors.purple),
            )),
            DataCell(Text(
              plan.time,
              style: TextStyle(color: Colors.teal),
            )),
            DataCell(Text(
              plan.favorite ? 'Yes' : 'No',
              style: TextStyle(color: Colors.indigo),
            )),
            DataCell(Text(
              plan.idyoutube,
              style: TextStyle(color: Colors.cyan),
            )),
            DataCell(
              IconButton(
                icon: Icon(Icons.edit, color: Colors.cyan),
                onPressed: () => _showEditDialog(context, plan),
              ),
            ),
            DataCell(
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, plan),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddPlanDialog(BuildContext context) {
    final nameplanController = TextEditingController();
    final levelController = TextEditingController();
    final repeatController = TextEditingController();
    final timeController = TextEditingController();
    final idyoutubeController = TextEditingController();
    final imageplanController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Plan', style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildTextField(nameplanController, 'Name'),
              _buildTextField(levelController, 'Level'),
              _buildTextField(repeatController, 'Repeat'),
              _buildTextField(timeController, 'Time'),
              _buildTextField(idyoutubeController, 'YouTube ID'),
              _buildTextField(imageplanController, 'Image Plan URL'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _apiService.addPlan(
                  nameplan: nameplanController.text,
                  level: levelController.text,
                  repeat: repeatController.text,
                  time: timeController.text,
                  idyoutube: idyoutubeController.text,
                  imageplan: imageplanController.text,
                );
                setState(() {
                  _planListFuture = _apiService.fetchPlans();
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

  TextField _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  void _showEditDialog(BuildContext context, Plan plan) {
    final nameplanController = TextEditingController(text: plan.nameplan);
    final levelController = TextEditingController(text: plan.level);
    final repeatController = TextEditingController(text: plan.repeat);
    final timeController = TextEditingController(text: plan.time);
    final idyoutubeController = TextEditingController(text: plan.idyoutube);
    final imageplanController = TextEditingController(text: plan.imageplan);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Plan', style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildTextField(nameplanController, 'Name'),
              _buildTextField(levelController, 'Level'),
              _buildTextField(repeatController, 'Repeat'),
              _buildTextField(timeController, 'Time'),
              _buildTextField(idyoutubeController, 'YouTube ID'),
              _buildTextField(imageplanController, 'Image Plan URL'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _apiService.updatePlan(
                  id: plan.id,
                  nameplan: nameplanController.text,
                  level: levelController.text,
                  repeat: repeatController.text,
                  time: timeController.text,
                  idyoutube: idyoutubeController.text,
                  imageplan: imageplanController.text,
                );
                setState(() {
                  _planListFuture = _apiService.fetchPlans();
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

  void _confirmDelete(BuildContext context, Plan plan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete', style: TextStyle(color: Colors.black)),
          content: Text('Are you sure you want to delete this plan?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _apiService.deletePlan(plan.id);
                setState(() {
                  _planListFuture = _apiService.fetchPlans();
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
