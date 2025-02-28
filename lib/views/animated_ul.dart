import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:sensor_recorder/views/file_location.dart';
import 'package:sensor_recorder/views/main_activity.dart';
import 'package:sensor_recorder/views/saved_activities.dart';
import 'package:sensor_recorder/views/sensors_check.dart';

class AnimatedUI extends StatefulWidget {
  @override
  State<AnimatedUI> createState() => _AnimatedUIState();
}

class _AnimatedUIState extends State<AnimatedUI> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _gradientAnimation;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    // Gradient color animation
    _gradientAnimation = ColorTween(
      begin: Colors.lightBlueAccent,
      end: Colors.blue,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Fade animations for buttons
    _fadeAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.2, 1, curve: Curves.easeInOut),
        ),
      );
    });

    // Scale animations for buttons
    _scaleAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 1, end: 1.1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.2, 1, curve: Curves.easeInOut),
        ),
      );
    });

    // Start the animations
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "HAR App",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.copy, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedButton(
              label: "Human Activities Recorder",
              icon: Icons.run_circle,
              fadeAnimation: _fadeAnimations[0],
              scaleAnimation: _scaleAnimations[0],
              onTap: () => Get.to(MainActivity()),
            ),
            SizedBox(height: 20),
            _buildAnimatedButton(
              label: "Sensors Check",
              icon: Icons.sensors,
              fadeAnimation: _fadeAnimations[1],
              scaleAnimation: _scaleAnimations[1],
              onTap: () => Get.to(SensorsCheck()),
            ),
            SizedBox(height: 20),
            _buildAnimatedButton(
              label: "Saved Activities",
              icon: Icons.save,
              fadeAnimation: _fadeAnimations[2],
              scaleAnimation: _scaleAnimations[2],
              onTap: () => Get.to(SavedActivitiesView()),
            ),
            SizedBox(height: 20),
            _buildAnimatedButton(
              label: "File Location",
              icon: Icons.folder,
              fadeAnimation: _fadeAnimations[3],
              scaleAnimation: _scaleAnimations[3],
              onTap: () => Get.to(FileLocationView()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton({
    required String label,
    required IconData icon,
    required Animation<double> fadeAnimation,
    required Animation<double> scaleAnimation,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
        _controller.forward(from: 0); // Restart animation on tap
      },
      child: ScaleTransition(
        scale: scaleAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_gradientAnimation.value!, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}