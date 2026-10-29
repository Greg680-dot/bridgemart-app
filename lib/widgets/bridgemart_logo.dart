import 'package:flutter/material.dart';
import '../config/theme.dart';

class BridgeMartLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isDark;

  const BridgeMartLogo({
    Key? key,
    this.size = 36,
    this.showText = true,
    this.isDark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Emblème Arched Bridge
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppTheme.bridgeGreen,
            borderRadius: BorderRadius.circular(size * 0.28),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Red diamond
              Positioned(
                top: size * 0.16,
                child: Container(
                  width: size * 0.16,
                  height: size * 0.16,
                  decoration: const BoxDecoration(
                    color: AppTheme.signalRed,
                    shape: BoxShape.rectangle,
                  ),
                  transform: Matrix4.rotationZ(0.785398), // 45 degrees
                ),
              ),
              // White Arch
              Positioned(
                top: size * 0.36,
                child: Container(
                  width: size * 0.54,
                  height: size * 0.32,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white, width: size * 0.09),
                      left: BorderSide(color: Colors.white, width: size * 0.09),
                      right: BorderSide(color: Colors.white, width: size * 0.09),
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(size * 0.3)),
                  ),
                ),
              ),
              // Yellow Road Bar
              Positioned(
                bottom: size * 0.22,
                child: Container(
                  width: size * 0.6,
                  height: size * 0.09,
                  decoration: BoxDecoration(
                    color: AppTheme.marketYellow,
                    borderRadius: BorderRadius.circular(size * 0.04),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (showText) ...[
          SizedBox(width: size * 0.25),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Bridge',
                    style: TextStyle(
                      fontSize: size * 0.48,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AppTheme.ink,
                      letterSpacing: -0.5,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    'Mart',
                    style: TextStyle(
                      fontSize: size * 0.48,
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppTheme.marketYellow : AppTheme.deepGreen,
                      letterSpacing: -0.5,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size * 0.05),
              Text(
                'BENIN · NIGERIA MARKETPLACE',
                style: TextStyle(
                  fontSize: size * 0.18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white70 : AppTheme.textSecondary,
                  letterSpacing: 0.8,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
