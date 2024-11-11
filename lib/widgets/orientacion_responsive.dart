import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final List<Widget> Function(BuildContext) buildBlocks;
  final Color backgroundColor;

  const ResponsiveContainer({
    super.key,
    required this.buildBlocks,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: OrientationBuilder(
            builder: (context, orientation) {
              // Detectar si el teléfono está en modo portrait o landscape
              bool isPortrait = orientation == Orientation.portrait;

              return isPortrait
                  ? Column(
                      children: buildBlocks(context),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildBlocks(context),
                    );
            },
          ),
        ),
      ),
    );
  }
}
