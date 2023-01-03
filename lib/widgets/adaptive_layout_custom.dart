import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class AdaptiveLayoutCustom extends StatelessWidget {
  /// Main screen
  final Widget child;

  /// Screen containing the menu/bottom screen
  final Widget? tabs;

  /// Screen containing the menu/bottom screen
  final Widget menuScreen;

  /// Screen containing the main content to display
  final Widget mainScreen;

  const AdaptiveLayoutCustom({
    Key? key,
    required this.menuScreen,
    required this.mainScreen,
    required this.child,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidebarWidth = 300;
    double contentWidth = 840 - sidebarWidth;
    double padding = (screenWidth - (sidebarWidth + contentWidth)) / 2;

    return AdaptiveLayout(
      bodyRatio: (300 + padding) / screenWidth,
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
                padding: EdgeInsets.only(left: padding),
                child: Column(
                  children: [
                    if (tabs != null) tabs!,
                    menuScreen,
                  ],
                )),
          )
        },
      ),
      secondaryBody: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.large: SlotLayout.from(
            key: const Key('Secondary Large'),
            inAnimation: null,
            outAnimation: null,
            builder: (_) => Padding(padding: EdgeInsets.only(right: padding), child: mainScreen),
          )
        },
      ),
    );
  }
}
