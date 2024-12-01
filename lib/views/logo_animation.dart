import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sensor_recorder/views/animated_ul.dart';
import '../controllers/animationL_controller.dart';



class LogoAnimation extends StatelessWidget {
  const LogoAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final LogoAnimationController controller = Get.put(LogoAnimationController());

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Center(
          child: Obx(() => GestureDetector(
            onTap: () {
              Get.to(  AnimatedUI());
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 777),
                  curve: Curves.decelerate,
                  width: controller.shouldAnimate.value
                      ? size.width * .55
                      : size.width * .41,
                  height: controller.shouldAnimate.value
                      ? size.width * .55
                      : size.width * .41,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 555),
                  curve: Curves.decelerate,
                  width: controller.shouldAnimate.value
                      ? size.width * .48
                      : size.width * .41,
                  height: controller.shouldAnimate.value
                      ? size.width * .48
                      : size.width * .41,
                  decoration: BoxDecoration(
                    color: const Color(0xff4b4b4b),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
                Container(
                  width: size.width * .41,
                  height: size.width * .41,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.decelerate,
                  opacity: controller.shouldAnimate.value ? 1 : 0,
                  child: const Text(
                    "GO",
                    style: TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}