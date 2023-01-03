import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class AdaptiveLayoutCustom extends StatelessWidget {
  /// Main screen
  final Widget child;

  /// Screen containing the tab screen
  final Widget? tabs;

  /// Screen containing the menu/bottom screen
  final Widget menuScreen;

  /// Screen containing the main content to display
  final Widget mainScreen;

  /// [Color] view content left in large adaptive to display
  final Color? backgroundMenu;

  /// [Color] view content left in large adaptive to display
  final Color? shadowMenu;

  const AdaptiveLayoutCustom({
    Key? key,
    required this.menuScreen,
    required this.mainScreen,
    required this.child,
    this.tabs,
    this.backgroundMenu,
    this.shadowMenu,
  }) : super(key: key);

  Widget buildBox({Widget? child}) {
    return Card(
      color: backgroundMenu,
      margin: EdgeInsets.zero,
      elevation: shadowMenu != null ? 3 : 0,
      shadowColor: shadowMenu,
      child: child,
    );
  }

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
              padding: EdgeInsets.only(left: padding, right: 20),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: CustomScrollView(
                  clipBehavior: Clip.none,
                  slivers: [
                    if (tabs != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: buildBox(child: tabs),
                        ),
                      ),
                    SliverFillRemaining(
                      child: buildBox(child: menuScreen),
                    )
                  ],
                ),
              ),
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
                  builder: (_) => Padding(padding: EdgeInsets.only(right: padding), child: mainScreen),
                )
              },
            )
          : null,
    );
  }
}
