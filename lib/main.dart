import 'package:admin/screens/nutri_screen.dart';
import 'package:admin/screens/plan_screen.dart';
import 'package:admin/screens/settings_screen.dart';
import 'package:admin/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'components/sidebar.dart';
import 'components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black87,
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: Scaffold(
        appBar: Navbar(),
        drawer: Sidebar(),
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBackground(),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Admin Dashboard!',
                  style: TextStyle(
                    fontSize: 40, // Đặt kích thước chữ nếu cần
                    color: Colors.yellow, // Đặt màu chữ là màu vàng
                    fontWeight: FontWeight.bold, // Đặt độ đậm nếu cần
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      routes: {
        '/users': (context) => UsersScreen(),
        '/plans': (context) => PlanScreen(),
        '/nutris': (context) => NutriScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Offset> _starPositions;
  late List<Color> _starColors;
  late List<Offset> _giftPositions;
  late List<Color> _giftColors;

  final int _numStars = 40;
  final int _numGifts = 8;
  final double _giftSpeed = 0.5; // Tốc độ bay của hộp quà

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Thay đổi thời gian để làm chậm tốc độ
    )..addListener(_updateStarsAndGifts)
      ..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _starPositions = List.generate(_numStars, (index) => Offset(
            Random().nextDouble() * MediaQuery.of(context).size.width,
            Random().nextDouble() * MediaQuery.of(context).size.height
        ));
        _starColors = List.generate(_numStars, (index) => Colors.white);

        _giftPositions = List.generate(_numGifts, (index) => Offset(
            Random().nextDouble() * MediaQuery.of(context).size.width,
            Random().nextDouble() * MediaQuery.of(context).size.height
        ));
        _giftColors = List.generate(_numGifts, (index) => Colors.yellow);
      });
    });
  }

  void _updateStarsAndGifts() {
    setState(() {
      for (int i = 0; i < _numStars; i++) {
        _starColors[i] = Random().nextBool() ? Colors.yellow : Colors.white;
      }

      for (int i = 0; i < _numGifts; i++) {
        _giftPositions[i] = Offset(
          (_giftPositions[i].dx + _giftSpeed) % MediaQuery.of(context).size.width,
          (_giftPositions[i].dy + _giftSpeed) % MediaQuery.of(context).size.height,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarryBackgroundPainter(_starPositions, _starColors, _giftPositions, _giftColors),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class StarryBackgroundPainter extends CustomPainter {
  final List<Offset> starPositions;
  final List<Color> starColors;
  final List<Offset> giftPositions;
  final List<Color> giftColors;

  StarryBackgroundPainter(this.starPositions, this.starColors, this.giftPositions, this.giftColors);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill;

    // Vẽ nền đen
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint..color = Colors.black);

    final double starSize = 8.0; // Kích thước của biểu tượng sao

    for (int i = 0; i < starPositions.length; i++) {
      paint.color = starColors[i];
      _drawStar(canvas, starPositions[i], starSize, paint);
    }

    // Vẽ mặt trăng
    paint.color = Colors.yellow;
    canvas.drawCircle(Offset(size.width - 50, 50), 40, paint);

    // Vẽ dãy nhà
    _drawStaticBuildings(canvas, size);

    // Vẽ hộp quà
    _drawGifts(canvas, size);
  }

  void _drawStar(Canvas canvas, Offset position, double size, Paint paint) {
    final double halfSize = size / 2;
    final double quarterSize = size / 4;

    final Path path = Path()
      ..moveTo(position.dx, position.dy - halfSize)
      ..lineTo(position.dx + quarterSize, position.dy - quarterSize)
      ..lineTo(position.dx + halfSize, position.dy)
      ..lineTo(position.dx + quarterSize, position.dy + quarterSize)
      ..lineTo(position.dx, position.dy + halfSize)
      ..lineTo(position.dx - quarterSize, position.dy + quarterSize)
      ..lineTo(position.dx - halfSize, position.dy)
      ..lineTo(position.dx - quarterSize, position.dy - quarterSize)
      ..close();

    canvas.drawPath(path, paint);
  }


  void _drawStaticBuildings(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill;

    final List<Size> buildingSizes = [
      Size(40, 80), // 1x2
      Size(60, 80), // 2x2
      Size(60, 120), // 2x3
      Size(80, 120), // 2x4
    ];

    double x = 0.0;
    double y = size.height - 80; // Vị trí bắt đầu của các ngôi nhà

    for (int i = 0; x < size.width; i = (i + 1) % buildingSizes.length) {
      final Size buildingSize = buildingSizes[i];
      final Color buildingColor = Colors.blueGrey;
      final Color roofColor = Colors.red;

      // Vẽ thân nhà
      paint.color = buildingColor;
      canvas.drawRect(Rect.fromLTWH(x, y, buildingSize.width, buildingSize.height), paint);

      // Vẽ cửa sổ
      paint.color = Colors.black;
      for (double windowY = y + 10; windowY < y + buildingSize.height - 10; windowY += 20) {
        canvas.drawRect(Rect.fromLTWH(x + 10, windowY, 10, 10), paint);
      }

      // Vẽ mái nhà
      paint.color = roofColor;
      final Path roofPath = Path()
        ..moveTo(x, y)
        ..lineTo(x + buildingSize.width / 2, y - 20)
        ..lineTo(x + buildingSize.width, y)
        ..close();
      canvas.drawPath(roofPath, paint);

      x += buildingSize.width + 20; // Khoảng cách giữa các ngôi nhà
    }
  }

  void _drawGifts(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill;

    final double giftSize = 20.0;

    for (int i = 0; i < giftPositions.length; i++) {
      paint.color = giftColors[i];
      canvas.drawRect(Rect.fromLTWH(giftPositions[i].dx, giftPositions[i].dy, giftSize, giftSize), paint);

      // Vẽ dây quà
      paint.color = Colors.red;
      canvas.drawLine(
        Offset(giftPositions[i].dx + giftSize / 2, giftPositions[i].dy),
        Offset(giftPositions[i].dx + giftSize / 2, giftPositions[i].dy - 10),
        paint..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Admin Dashboard'),
      backgroundColor: Colors.blueAccent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blueAccent),
            title: Text('Users'),
            onTap: () {
              Navigator.pushNamed(context, '/users');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.blueAccent),
            title: Text('Plans'),
            onTap: () {
              Navigator.pushNamed(context, '/plans');
            },
          ),
          ListTile(
            leading: Icon(Icons.fastfood, color: Colors.blueAccent),
            title: Text('Nutri'),
            onTap: () {
              Navigator.pushNamed(context, '/nutris');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blueAccent),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}