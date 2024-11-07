import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final List<Widget> Function(BuildContext) buildBlocks;

  const ResponsiveContainer({
    super.key,
    required this.buildBlocks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 243, 180),
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
