import 'package:flutter/material.dart';
import 'package:admin/data/api_service.dart';
import 'package:admin/model/nutri.dart';

class NutriScreen extends StatefulWidget {
  @override
  _NutriScreenState createState() => _NutriScreenState();
}

class _NutriScreenState extends State<NutriScreen> {
  final ApiService _apiService = ApiService('http://10.20.15.158:7059/');
  late Future<List<Nutri>> _nutriListFuture;

  @override
  void initState() {
    super.initState();
    _nutriListFuture = _apiService.fetchNutriList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nutri Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: FutureBuilder<List<Nutri>>(
        future: _nutriListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Nutri>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Nutri data available', style: TextStyle(fontSize: 18, color: Colors.grey)));
          } else {
            final nutriList = snapshot.data!;
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        columnSpacing: 16.0,
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.black),
                        dataRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[850]!),
                        dividerThickness: 2,
                        columns: [
                          DataColumn(
                            label: Text(
                              'No.',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Image',
                              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'ID',
                              style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Meal',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Calories',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Time Cook',
                              style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Ready',
                              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'How to Cook',
                              style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Edit',
                              style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Delete',
                              style: TextStyle(color: Colors.lime, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          nutriList.length,
                              (index) {
                            final nutri = nutriList[index];
                            final imagePath = 'assets/images/nutri/${nutri.meal.toLowerCase()}.png';

                            return DataRow(
                              cells: [
                                DataCell(Text(
                                  (index + 1).toString(),
                                  style: TextStyle(color: Colors.red),
                                )),
                                DataCell(
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
                                  ),
                                ),
                                DataCell(Text(
                                  nutri.id.toString(),
                                  style: TextStyle(color: Colors.yellow),
                                )),
                                DataCell(Text(
                                  nutri.meal,
                                  style: TextStyle(color: Colors.green),
                                )),
                                DataCell(Text(
                                  nutri.calo.toString(),
                                  style: TextStyle(color: Colors.blue),
                                )),
                                DataCell(Text(
                                  nutri.timeCook.toString(),
                                  style: TextStyle(color: Colors.purple),
                                )),
                                DataCell(Text(
                                  nutri.ready ? 'Yes' : 'No',
                                  style: TextStyle(color: Colors.teal),
                                )),
                                DataCell(Text(
                                  nutri.howToCook,
                                  style: TextStyle(color: Colors.indigo),
                                )),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.cyan),
                                    onPressed: () {
                                      _showEditDialog(context, nutri);
                                    },
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _confirmDelete(context, nutri);
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNutriDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddNutriDialog(BuildContext context) {
    final mealController = TextEditingController();
    final caloController = TextEditingController();
    final timeCookController = TextEditingController();
    final howToCookController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Nutri', style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: mealController,
                decoration: InputDecoration(labelText: 'Meal'),
              ),
              TextField(
                controller: caloController,
                decoration: InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: timeCookController,
                decoration: InputDecoration(labelText: 'Time Cook'),
              ),
              TextField(
                controller: howToCookController,
                decoration: InputDecoration(labelText: 'How to Cook'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _apiService.addNutri(
                  meal: mealController.text,
                  calo: int.parse(caloController.text),
                  timeCook: timeCookController.text,
                  imagenutri: 'default_image.png',
                  howToCook: howToCookController.text,
                );
                setState(() {
                  _nutriListFuture = _apiService.fetchNutriList();
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Nutri nutri) {
    final mealController = TextEditingController(text: nutri.meal);
    final caloController = TextEditingController(text: nutri.calo.toString());
    final timeCookController = TextEditingController(text: nutri.timeCook);
    final howToCookController = TextEditingController(text: nutri.howToCook);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Nutri', style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: mealController,
                decoration: InputDecoration(labelText: 'Meal'),
              ),
              TextField(
                controller: caloController,
                decoration: InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: timeCookController,
                decoration: InputDecoration(labelText: 'Time Cook'),
              ),
              TextField(
                controller: howToCookController,
                decoration: InputDecoration(labelText: 'How to Cook'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _apiService.editNutri(
                  id: nutri.id,
                  meal: mealController.text,
                  calo: int.parse(caloController.text),
                  timeCook: timeCookController.text,
                  imagenutri: nutri.imagenutri,
                  howToCook: howToCookController.text,
                );
                setState(() {
                  _nutriListFuture = _apiService.fetchNutriList();
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

  void _confirmDelete(BuildContext context, Nutri nutri) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete', style: TextStyle(color: Colors.red)),
          content: Text('Are you sure you want to delete ${nutri.meal}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _apiService.deleteNutri(nutri.id);
                setState(() {
                  _nutriListFuture = _apiService.fetchNutriList();
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
