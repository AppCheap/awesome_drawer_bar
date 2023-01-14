import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class AdaptiveLayoutCustom extends StatelessWidget {
  /// Main screen
  final Widget child;

  /// Screen containing the menu/bottom screen
  final Widget menuScreen;

  /// Screen containing the main content to display
  final Widget mainScreen;

  const AdaptiveLayoutCustom({
    Key? key,
    required this.menuScreen,
    required this.mainScreen,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidebarWidth = 270;
    double contentWidth = 840 - sidebarWidth;
    double padding = (screenWidth - (sidebarWidth + contentWidth)) / 2;

    return AdaptiveLayout(
      bodyRatio: (sidebarWidth + padding) / screenWidth,
      body: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.standard: SlotLayout.from(
            inAnimation: null,
            outAnimation: null,
            key: const Key('Standard Large'),
            builder: (_) => child,
          ),
          Breakpoints.large: SlotLayout.from(
            key: const Key('Body Large'),
            builder: (_) => Padding(
              padding: EdgeInsetsDirectional.only(start: padding, end: 20),
              child: menuScreen,
            ),
          )
        },
      ),
      secondaryBody: Breakpoints.large.isActive(context)
          ? SlotLayout(
              config: <Breakpoint, SlotLayoutConfig>{
                Breakpoints.large: SlotLayout.from(
                  key: const Key('Secondary Large'),
                  inAnimation: null,
                  outAnimation: null,
                  builder: (_) => Padding(padding: EdgeInsetsDirectional.only(end: padding), child: mainScreen),
                )
              },
            )
          : null,
    );
  }
}
