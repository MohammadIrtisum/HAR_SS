import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:sensor_recorder/views/main_activity.dart';

class AnimatedUI extends StatefulWidget {
  @override
  State<AnimatedUI> createState() => _AnimatedUIState();
}

class _AnimatedUIState extends State<AnimatedUI> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(Icons.menu, color: Colors.white),
        title: Text("HAR App", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.copy, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background dots
          Container(
            color: Colors.grey[200],
          ),
          // Circular Profile Icon
          Positioned(
            top: 20,
            right: 20,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.lightBlue,
              child: Text(
                "AI",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          // Centered Buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedButton(
                  label: "Human Activities Recorder",
                  onTap: () {
                    Get.to(MainActivity());
                  },
                ),
                SizedBox(height: 20),
                AnimatedButton(
                  label: "Sensors Check",
                  onTap: () => print("Sensors Check tapped"),
                ),
                SizedBox(height: 20),
                AnimatedButton(
                  label: "Saved Activities",
                  onTap: () => print("Saved Activities tapped"),
                ),
                SizedBox(height: 20),
                AnimatedButton(
                  label: "File location",
                  onTap: () => print("File location tapped"),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            label: 'Navigation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: 'Text',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy),
            label: 'Copy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_align_left),
            label: 'Format',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Image',
          ),
        ],
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const AnimatedButton({required this.label, required this.onTap});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.9,
      upperBound: 1.0,
    );
    _scaleAnimation = _controller.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) {
        _controller.forward();
        widget.onTap();
      },
      onTapCancel: () => _controller.forward(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}