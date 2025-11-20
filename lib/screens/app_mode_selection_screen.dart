import 'package:flutter/material.dart';
import 'package:todo_health_reminders/models/app_mode.dart';
import 'package:todo_health_reminders/screens/home_screen.dart';
import 'package:todo_health_reminders/screens/inspiration_home_screen.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';
import 'dart:math' as math;

class AppModeSelectionScreen extends StatelessWidget {
  const AppModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppHeader(context),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: ResponsiveLayout(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveBreakpoints.getHorizontalPadding(context),
                          vertical: 24.0,
                        ),
                        child: _buildCardLayout(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.5; // Half the page
    
    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: CustomPaint(
        painter: _AppHeaderPainter(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bubble-style painted "2do" logo
              CustomPaint(
                size: const Size(400, 180),
                painter: _BubbleTextPainter(),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: const Text(
                  'Välj din app',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardLayout(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.isMobile(context);
    
    if (isMobile) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildModeCard(
            context,
            AppMode.health,
            Icons.favorite,
            Colors.red.shade400,
            () => _navigateToMode(context, AppMode.health),
          ),
          const SizedBox(height: 24),
          _buildModeCard(
            context,
            AppMode.inspiration,
            Icons.palette,
            Colors.orange.shade400,
            () => _navigateToMode(context, AppMode.inspiration),
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildModeCard(
              context,
              AppMode.health,
              Icons.favorite,
              Colors.red.shade400,
              () => _navigateToMode(context, AppMode.health),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _buildModeCard(
              context,
              AppMode.inspiration,
              Icons.palette,
              Colors.orange.shade400,
              () => _navigateToMode(context, AppMode.inspiration),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildModeCard(
    BuildContext context,
    AppMode mode,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: color,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                mode.displayName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                mode.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Öppna',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMode(BuildContext context, AppMode mode) {
    Widget destination;
    
    switch (mode) {
      case AppMode.health:
        destination = const HomeScreen();
        break;
      case AppMode.inspiration:
        destination = const InspirationHomeScreen();
        break;
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}

// Custom painter for the header background representing both apps
class _AppHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Base gradient background
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.red.shade300,
        Colors.orange.shade400,
        Colors.yellow.shade300,
        Colors.orange.shade300,
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );
    
    paint.shader = gradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    
    // Draw abstract shapes representing health (left side - hearts theme)
    _drawHealthTheme(canvas, size);
    
    // Draw abstract shapes representing inspiration (right side - art/palette theme)
    _drawInspirationTheme(canvas, size);
    
    // Add some decorative dots/splatter effect
    _drawSplatterEffect(canvas, size);
  }
  
  void _drawHealthTheme(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.shade700.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    // Draw stylized hearts on the left
    for (int i = 0; i < 3; i++) {
      final x = size.width * 0.15 + i * 40;
      final y = size.height * 0.3 + i * 60;
      _drawHeart(canvas, Offset(x, y), 30 + i * 10.0, paint);
    }
    
    // Add some pulse lines
    paint
      ..color = Colors.red.shade400.withOpacity(0.4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    path.moveTo(size.width * 0.05, size.height * 0.7);
    path.lineTo(size.width * 0.15, size.height * 0.7);
    path.lineTo(size.width * 0.2, size.height * 0.6);
    path.lineTo(size.width * 0.25, size.height * 0.8);
    path.lineTo(size.width * 0.3, size.height * 0.7);
    canvas.drawPath(path, paint);
  }
  
  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.3);
    
    // Left curve
    path.cubicTo(
      center.dx - size * 0.5, center.dy - size * 0.3,
      center.dx - size * 0.8, center.dy + size * 0.1,
      center.dx, center.dy + size * 0.7,
    );
    
    // Right curve
    path.cubicTo(
      center.dx + size * 0.8, center.dy + size * 0.1,
      center.dx + size * 0.5, center.dy - size * 0.3,
      center.dx, center.dy + size * 0.3,
    );
    
    canvas.drawPath(path, paint);
  }
  
  void _drawInspirationTheme(Canvas canvas, Size size) {
    // Draw palette on the right side
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Palette base
    paint.color = Colors.brown.shade600.withOpacity(0.4);
    final palettePath = Path();
    final paletteX = size.width * 0.75;
    final paletteY = size.height * 0.4;
    
    palettePath.addOval(Rect.fromCenter(
      center: Offset(paletteX, paletteY),
      width: 80,
      height: 100,
    ));
    canvas.drawPath(palettePath, paint);
    
    // Paint dabs on palette
    final colors = [
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.purple.shade600,
      Colors.yellow.shade700,
      Colors.pink.shade400,
    ];
    
    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i].withOpacity(0.6);
      final angle = (i * math.pi * 2 / colors.length);
      final x = paletteX + 25 * math.cos(angle);
      final y = paletteY + 25 * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 8, paint);
    }
    
    // Draw paintbrush strokes
    paint
      ..color = Colors.orange.shade600.withOpacity(0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final brushPath = Path();
    brushPath.moveTo(size.width * 0.85, size.height * 0.25);
    brushPath.quadraticBezierTo(
      size.width * 0.88, size.height * 0.35,
      size.width * 0.82, size.height * 0.45,
    );
    canvas.drawPath(brushPath, paint);
  }
  
  void _drawSplatterEffect(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final random = math.Random(42); // Fixed seed for consistency
    for (int i = 0; i < 30; i++) {
      paint.color = [
        Colors.white.withOpacity(0.3),
        Colors.yellow.shade200.withOpacity(0.4),
        Colors.orange.shade200.withOpacity(0.3),
      ][i % 3];
      
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 2 + random.nextDouble() * 4;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for bubble-style "2do" text
class _BubbleTextPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Draw "2"
    _drawBubble2(canvas, Offset(40, size.height / 2), paint);
    
    // Draw "d"
    _drawBubbleD(canvas, Offset(170, size.height / 2), paint);
    
    // Draw "o"
    _drawBubbleO(canvas, Offset(290, size.height / 2), paint);
  }
  
  void _drawBubble2(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    
    // Create rounded "2" shape
    path.moveTo(center.dx + 10, center.dy - 60);
    path.cubicTo(
      center.dx + 10, center.dy - 80,
      center.dx + 30, center.dy - 90,
      center.dx + 50, center.dy - 90,
    );
    path.cubicTo(
      center.dx + 70, center.dy - 90,
      center.dx + 80, center.dy - 80,
      center.dx + 80, center.dy - 60,
    );
    path.cubicTo(
      center.dx + 80, center.dy - 45,
      center.dx + 70, center.dy - 30,
      center.dx + 50, center.dy - 15,
    );
    path.lineTo(center.dx + 10, center.dy + 20);
    path.cubicTo(
      center.dx + 5, center.dy + 30,
      center.dx + 0, center.dy + 40,
      center.dx + 0, center.dy + 50,
    );
    path.lineTo(center.dx + 80, center.dy + 50);
    path.cubicTo(
      center.dx + 90, center.dy + 50,
      center.dx + 95, center.dy + 60,
      center.dx + 95, center.dy + 70,
    );
    path.cubicTo(
      center.dx + 95, center.dy + 80,
      center.dx + 90, center.dy + 90,
      center.dx + 80, center.dy + 90,
    );
    path.lineTo(center.dx + 10, center.dy + 90);
    path.cubicTo(
      center.dx - 10, center.dy + 90,
      center.dx - 20, center.dy + 80,
      center.dx - 20, center.dy + 60,
    );
    path.cubicTo(
      center.dx - 20, center.dy + 40,
      center.dx - 10, center.dy + 20,
      center.dx + 10, center.dy,
    );
    path.lineTo(center.dx + 40, center.dy - 30);
    path.cubicTo(
      center.dx + 50, center.dy - 40,
      center.dx + 55, center.dy - 50,
      center.dx + 55, center.dy - 60,
    );
    path.cubicTo(
      center.dx + 55, center.dy - 70,
      center.dx + 50, center.dy - 75,
      center.dx + 40, center.dy - 75,
    );
    path.cubicTo(
      center.dx + 30, center.dy - 75,
      center.dx + 20, center.dy - 70,
      center.dx + 10, center.dy - 60,
    );
    path.close();
    
    _paintBubbleLetter(canvas, path, center);
  }
  
  void _drawBubbleD(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    
    // Create rounded "d" shape
    // Vertical line
    path.moveTo(center.dx + 50, center.dy - 90);
    path.lineTo(center.dx + 50, center.dy + 90);
    path.cubicTo(
      center.dx + 50, center.dy + 100,
      center.dx + 55, center.dy + 105,
      center.dx + 65, center.dy + 105,
    );
    path.cubicTo(
      center.dx + 75, center.dy + 105,
      center.dx + 80, center.dy + 100,
      center.dx + 80, center.dy + 90,
    );
    path.lineTo(center.dx + 80, center.dy - 90);
    path.cubicTo(
      center.dx + 80, center.dy - 100,
      center.dx + 75, center.dy - 105,
      center.dx + 65, center.dy - 105,
    );
    path.cubicTo(
      center.dx + 55, center.dy - 105,
      center.dx + 50, center.dy - 100,
      center.dx + 50, center.dy - 90,
    );
    path.close();
    
    // Bowl of "d"
    final bowlPath = Path();
    bowlPath.addOval(Rect.fromCenter(
      center: Offset(center.dx + 15, center.dy + 20),
      width: 80,
      height: 120,
    ));
    
    path.addPath(bowlPath, Offset.zero);
    
    _paintBubbleLetter(canvas, path, center);
  }
  
  void _drawBubbleO(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    
    // Create rounded "o" shape
    path.addOval(Rect.fromCenter(
      center: Offset(center.dx, center.dy + 20),
      width: 80,
      height: 120,
    ));
    
    // Inner hole
    final innerPath = Path();
    innerPath.addOval(Rect.fromCenter(
      center: Offset(center.dx, center.dy + 20),
      width: 40,
      height: 80,
    ));
    
    path = Path.combine(PathOperation.difference, path, innerPath);
    
    _paintBubbleLetter(canvas, path, center);
  }
  
  void _paintBubbleLetter(Canvas canvas, Path path, Offset center) {
    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.save();
    canvas.translate(5, 8);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();
    
    // Draw main letter with strong color
    final mainPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.deepOrange.shade600;
    canvas.drawPath(path, mainPaint);
    
    // Draw darker outline for depth
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.deepOrange.shade800
      ..strokeWidth = 3;
    canvas.drawPath(path, outlinePaint);
    
    // Draw shine/highlight on top
    final shinePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(path.getBounds());
    
    // Create a clipped shine area (top portion of letter)
    canvas.save();
    canvas.clipPath(path);
    
    final shineRect = Rect.fromLTWH(
      path.getBounds().left,
      path.getBounds().top,
      path.getBounds().width,
      path.getBounds().height * 0.4,
    );
    
    final shinePath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        shineRect,
        const Radius.circular(20),
      ));
    
    canvas.drawPath(shinePath, shinePaint);
    canvas.restore();
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
