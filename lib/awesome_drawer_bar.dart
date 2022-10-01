library awesome_drawer_bar;

import 'dart:math' show pi;

import 'package:flutter/material.dart';

class AwesomeDrawerBarController {
  /// callback function to open the drawer
  Function? open;

  /// callback function to close the drawer
  Function? close;

  /// callback function to toggle the drawer
  Function? toggle;

  /// callback function to determine the status of the drawer
  Function? isOpen;

  /// Drawer state notifier
  /// opening, closing, open, closed
  ValueNotifier<DrawerState>? stateNotifier;
}

class AwesomeDrawerBar extends StatefulWidget {
  AwesomeDrawerBar({
    this.type = StyleState.overlay,
    this.controller,
    required this.menuScreen,
    required this.mainScreen,
    this.slideHeight,
    this.borderRadius = 16.0,
    this.angle = 0.0,
    this.shadowColor = Colors.white,
    this.showShadow = false,
    this.openCurve,
    this.closeCurve,
    this.duration,
    this.isRTL = false,
  }) : assert(angle <= 0.0 && angle >= -30.0);

  // Layout style
  final StyleState type;

  /// controller to have access to the open/close/toggle function of the drawer
  final AwesomeDrawerBarController? controller;

  /// Screen containing the menu/bottom screen
  final Widget menuScreen;

  /// Screen containing the main content to display
  final Widget mainScreen;

  /// Sliding width of the drawer - defaults to 275.0
  final double? slideHeight;

  /// Border radius of the slided content - defaults to 16.0
  final double borderRadius;

  /// Rotation angle of the drawer - defaults to -12.0
  final double angle;

  final Color shadowColor;

  /// Boolean, whether to show the drawer shadows - defaults to false
  final bool showShadow;

  /// Drawer slide out curve
  final Curve? openCurve;

  /// Drawer slide in curve
  final Curve? closeCurve;

  /// Drawer Duration
  final Duration? duration;

  /// Static function to determine the device text direction RTL/LTR
  final bool isRTL;

  @override
  _AwesomeDrawerBarState createState() => new _AwesomeDrawerBarState();

  /// static function to provide the drawer state
  static _AwesomeDrawerBarState? of(BuildContext context) {
    return context.findAncestorStateOfType<State<AwesomeDrawerBar>>() as _AwesomeDrawerBarState?;
  }
}

class _AwesomeDrawerBarState extends State<AwesomeDrawerBar> with SingleTickerProviderStateMixin {
  final Curve _scaleDownCurve = Interval(0.0, 0.3, curve: Curves.easeOut);
  final Curve _scaleUpCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  final Curve _slideOutCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  final Curve _slideInCurve = Interval(0.0, 1.0, curve: Curves.easeOut); // Curves.bounceOut
  // static const Cubic slowMiddle = Cubic(0.19, 1, 0.22, 1);

  late AnimationController _animationController;
  late Animation<double> scaleAnimation;

  DrawerState _state = DrawerState.closed;

  double get _percentOpen => _animationController.value;

  /// Open drawer
  open() {
    _animationController.forward();
  }

  /// Close drawer
  close() {
    _animationController.reverse();
  }

  AnimationController? get animationController => _animationController;

  /// Toggle drawer
  toggle() {
    if (_state == DrawerState.open) {
      close();
    } else if (_state == DrawerState.closed) {
      open();
    }
  }

  /// check whether drawer is open
  bool isOpen() => _state == DrawerState.open; /* || _state == DrawerState.opening*/

  /// Drawer state
  final ValueNotifier<DrawerState> _stateNotifier = ValueNotifier(DrawerState.closed);

  /// Drawer state
  ValueNotifier<DrawerState> get stateNotifier => _stateNotifier;

  @override
  void initState() {
    super.initState();

    /// Initialize the animation controller
    /// add status listener to update the menuStatus
    _animationController = AnimationController(
        vsync: this, duration: widget.duration is Duration ? widget.duration : Duration(milliseconds: 250))
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = DrawerState.opening;
            _updateStatusNotifier();
            break;
          case AnimationStatus.reverse:
            _state = DrawerState.closing;
            _updateStatusNotifier();
            break;
          case AnimationStatus.completed:
            _state = DrawerState.open;
            _updateStatusNotifier();
            break;
          case AnimationStatus.dismissed:
            _state = DrawerState.closed;
            _updateStatusNotifier();
            break;
        }
      });
    scaleAnimation = new Tween(
      begin: 0.9,
      end: 1.0,
    ).animate(new CurvedAnimation(
      parent: _animationController,
      curve: Curves.slowMiddle,
    ));
    // CurvedAnimation(parent: _animationController, curve: Curves.easeIn); //Curves.easeIn Curves.linear
    /// assign controller function to the widget methods
    if (widget.controller != null) {
      widget.controller!.open = open;
      widget.controller!.close = close;
      widget.controller!.toggle = toggle;
      widget.controller!.isOpen = isOpen;
      widget.controller!.stateNotifier = stateNotifier;
    }
  }

  _updateStatusNotifier() {
    stateNotifier.value = _state;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stateNotifier.dispose();
    super.dispose();
  }

  /// Build the widget based on the animation value
  ///
  /// * [container] is the widget to be displayed
  ///
  /// * [angle] is the the Z rotation angle
  ///
  /// * [scale] is a string to help identify this animation during
  ///   debugging (used by [toString]).
  ///
  /// * [slide] is the sliding amount of the drawer
  ///
  Widget _zoomAndSlideContent(
    Widget? container, {
    double? scale,
    double slideW = 0,
    double slideHeight = 0,
    double scaleAngle = 0.0,
  }) {
    double slidePercent, scalePercent;
    int _rtlSlide = widget.isRTL ? -1 : 1;

    /// determine current slide percent based on the MenuStatus
    switch (_state) {
      case DrawerState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case DrawerState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case DrawerState.opening:
        slidePercent = (widget.openCurve ?? _slideOutCurve).transform(_percentOpen);
        scalePercent = _scaleDownCurve.transform(_percentOpen);
        break;
      case DrawerState.closing:
        slidePercent = (widget.closeCurve ?? _slideInCurve).transform(_percentOpen);
        scalePercent = _scaleUpCurve.transform(_percentOpen);
        break;
    }
    double widthDevice = MediaQuery.of(context).size.width;
    bool maxWidth = widthDevice >= 540;
    double desktop = widthDevice * (widget.isRTL ? 0.2 : 0.3);
    double mobile = widthDevice * (widget.isRTL ? 0.735 : 0.835);

    /// calculated sliding amount based on the RTL and animation value
    double slideAmountWidth = (maxWidth ? desktop : mobile - slideW) * slidePercent * _rtlSlide;
    double slideAmountHeight = (widget.slideHeight ?? slideHeight) * slidePercent * _rtlSlide;

    /// calculated scale amount based on the provided scale and animation value
    double contentScale = (scale ?? 1.0) - (0.1 * scalePercent);

    /// calculated radius based on the provided radius and animation value
    double cornerRadius = widget.borderRadius * _percentOpen;

    /// calculated rotation amount based on the provided angle and animation value
    double rotationAngle = (((scaleAngle) * pi * _rtlSlide) / 180) * _percentOpen;

    return Transform(
      transform: Matrix4.translationValues(slideAmountWidth, slideAmountHeight, 0.0)
        ..rotateZ(rotationAngle)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: container,
      ),
    );
  }

  Widget renderOverlay(double widthDevice) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double rightSlide = widthDevice >= 540 ? widthDevice * 0.3 : widthDevice * 0.75;
        double left = (1 - _animationController.value) * rightSlide;
        return dragClick(
            menuScreen: GestureDetector(
              child: Stack(
                children: [
                  widget.mainScreen,
                  if (_animationController.value > 0) ...[
                    Opacity(
                      opacity: _animationController.value * 0.5,
                      child: Container(
                        color: Colors.black,
                      ),
                    )
                  ],
                ],
              ),
              onTap: () {
                if (_state == DrawerState.open) {
                  toggle();
                }
              },
            ),
            mainScreen: Transform.translate(
              offset: Offset(widget.isRTL ? left : -left, 0),
              child: Container(
                width: rightSlide,
                child: widget.menuScreen,
              ),
            ));
      },
    );
  }

  Widget renderFixedStack(double widthDevice) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double rightSlide = widthDevice >= 540 ? widthDevice * 0.3 : widthDevice * 0.75;
        double slide = rightSlide * _animationController.value;
        return dragClick(
          menuScreen: widget.menuScreen,
          mainScreen: Transform(
            transform: Matrix4.identity()..translate(widget.isRTL ? -slide : slide),
            child: GestureDetector(
              child: Stack(
                children: [
                  widget.mainScreen,
                  if (_animationController.value > 0) ...[
                    Opacity(
                      opacity: _animationController.value * 0.5,
                      child: Container(
                        color: Colors.black,
                      ),
                    )
                  ],
                ],
              ),
              onTap: () {
                if (_state == DrawerState.open) {
                  toggle();
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget renderStack(double widthDevice) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double rightSlide = widthDevice >= 540 ? widthDevice * 0.3 : widthDevice * 0.75;
        double slide = rightSlide * _animationController.value;
        double left = (1 - _animationController.value) * rightSlide;
        return Stack(
          children: [
            Transform.translate(
              offset: Offset(widget.isRTL ? left : -left, 0),
              child: Container(
                width: rightSlide,
                child: widget.menuScreen,
              ),
            ),
            Stack(
              children: [
                Transform(
                  transform: Matrix4.identity()..translate(widget.isRTL ? -slide : slide),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      if ((details.delta.dx > 6 || details.delta.dx < 6 && _state == DrawerState.open) &&
                          !widget.isRTL) {
                        if (_state == DrawerState.open && details.delta.dx < -6) {
                          close();
                        }
                      }
                      if ((details.delta.dx < -6 || details.delta.dx > 6 && _state == DrawerState.open) &&
                          widget.isRTL) {
                        if (_state == DrawerState.open && details.delta.dx > 6) {
                          close();
                        }
                      }
                    },
                    child: Stack(
                      children: [
                        widget.mainScreen,
                        if (_animationController.value > 0) ...[
                          Opacity(
                            opacity: _animationController.value * 0.5,
                            child: Container(
                              color: Colors.black,
                            ),
                          )
                        ],
                      ],
                    ),
                    onTap: () {
                      if (_state == DrawerState.open) {
                        toggle();
                      }
                    },
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanUpdate: (details) {
                    if ((details.delta.dx > 6 || details.delta.dx < 6 && _state == DrawerState.open) && !widget.isRTL) {
                      if (_state == DrawerState.closed) {
                        open();
                      } else if (_state == DrawerState.open && details.delta.dx < -6) {
                        close();
                      }
                    }

                    if ((details.delta.dx < -6 || details.delta.dx > 6 && _state == DrawerState.open) && widget.isRTL) {
                      if (_state == DrawerState.closed) {
                        open();
                      } else if (_state == DrawerState.open && details.delta.dx > 6) {
                        close();
                      }
                    }
                  },
                  child: Container(
                    width: DrawerState.closed == _state ? 20 : 0,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget renderScaleRight(double widthDevice, {double slideHeight = 0.0, double scaleAngle = 0.0}) {
    double slidePercent = widget.isRTL ? widthDevice * .095 : 15.0;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return dragClick(
          menuScreen: widget.menuScreen,
          shadow: widget.showShadow == true
              ? [
                  /// Displaying the first shadow
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (_, w) => _zoomAndSlideContent(w,
                        slideHeight: slideHeight,
                        scaleAngle: scaleAngle == 0.0 ? 0.0 : scaleAngle - 8,
                        scale: .9,
                        slideW: slidePercent * 2),
                    child: Container(
                      color: widget.shadowColor.withOpacity(0.3),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (_, w) => _zoomAndSlideContent(w,
                        slideHeight: slideHeight,
                        scaleAngle: scaleAngle == 0.0 ? 0.0 : scaleAngle - 4.0,
                        scale: .95,
                        slideW: slidePercent),
                    child: Container(
                      color: widget.shadowColor.withOpacity(0.9),
                    ),
                  )
                ]
              : null,
          mainScreen: AnimatedBuilder(
            animation: _animationController,
            builder: (_, w) => _zoomAndSlideContent(w, slideHeight: slideHeight, scaleAngle: scaleAngle),
            child: GestureDetector(
              child: Stack(
                children: [
                  widget.mainScreen,
                  if (_animationController.value > 0) ...[
                    Opacity(
                      opacity: 0,
                      child: Container(
                        color: Colors.black,
                      ),
                    )
                  ]
                ],
              ),
              onTap: () {
                if (_state == DrawerState.open) {
                  toggle();
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget renderRotate3dIn(double widthDevice) {
    bool maxWidth = widthDevice >= 540;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double rightSlide = maxWidth ? widthDevice * 0.2 : widthDevice * 0.4;
        double x = _animationController.value * rightSlide;
        double scale = 1 - (_animationController.value * 0.01);
        double rotate = _animationController.value * (pi / (maxWidth ? 15 : 4));
        return dragClick(
          menuScreen: widget.menuScreen,
          mainScreen: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0009)
              ..translate(widget.isRTL ? -x : x)
              ..scale(scale)
              ..rotateY(widget.isRTL ? -rotate : rotate),
            alignment: widget.isRTL ? Alignment.centerLeft : Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                if (_state == DrawerState.open) {
                  toggle();
                }
              },
              child: Stack(
                children: [
                  widget.mainScreen,
                  if (_animationController.value > 0) ...[
                    Opacity(
                      opacity: 0,
                      child: Container(color: Colors.black),
                    )
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget renderRotate3dOut(double widthDevice) {
    bool maxWidth = widthDevice >= 540;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        double rightSlide = maxWidth ? widthDevice * 0.159 : widthDevice * 0.325;
        double x = _animationController.value * rightSlide;
        double scale = 1 - (_animationController.value * 0.25);
        double rotate = _animationController.value * (pi / (maxWidth ? 15 : 4));
        return dragClick(
          menuScreen: widget.menuScreen,
          mainScreen: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0009)
              ..translate(widget.isRTL ? -x : x)
              ..scale(scale)
              ..rotateY(widget.isRTL ? rotate : -rotate),
            alignment: widget.isRTL ? Alignment.centerLeft : Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                if (_state == DrawerState.open) {
                  toggle();
                }
              },
              child: Stack(
                children: [
                  widget.mainScreen,
                  if (_animationController.value > 0) ...[
                    Opacity(
                      opacity: 0,
                      child: Container(color: Colors.black),
                    )
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget renderPopUp() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            widget.mainScreen,
            if (_animationController.value > 0) ...[
              Opacity(
                opacity: _animationController.drive(CurveTween(curve: Curves.easeIn)).value, //Curves.easeOut
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      if ((details.delta.dx > 6 || details.delta.dx < 6 && _state == DrawerState.open) &&
                          !widget.isRTL) {
                        if (_state == DrawerState.open && details.delta.dx < -6) {
                          close();
                        }
                      }
                      if ((details.delta.dx < -6 || details.delta.dx > 6 && _state == DrawerState.open) &&
                          widget.isRTL) {
                        if (_state == DrawerState.open && details.delta.dx > 6) {
                          close();
                        }
                      }
                    },
                    child: Stack(
                      children: <Widget>[
                        widget.menuScreen,
                        Padding(
                          padding: EdgeInsets.only(right: 24, top: 24),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: FloatingActionButton(
                              onPressed: () {
                                if (_state == DrawerState.open) {
                                  toggle();
                                }
                              },
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                              child: Icon(Icons.close, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double getWidthDevice = MediaQuery.of(context).size.width;
    double slideHeight = MediaQuery.of(context).size.height * (widget.isRTL ? -0.19 : 0.19);
    switch (widget.type) {
      case StyleState.fixedStack:
        return renderFixedStack(getWidthDevice);
      case StyleState.stack:
        return renderStack(getWidthDevice);
      case StyleState.scaleRight:
        return renderScaleRight(getWidthDevice, scaleAngle: widget.angle, slideHeight: 0.0);
      case StyleState.scaleBottom:
        return renderScaleRight(getWidthDevice, scaleAngle: widget.angle, slideHeight: slideHeight);
      case StyleState.scaleTop:
        return renderScaleRight(getWidthDevice, scaleAngle: widget.angle, slideHeight: -slideHeight);
      case StyleState.scaleRotate:
        return renderScaleRight(getWidthDevice, scaleAngle: widget.angle - 3.0);
      case StyleState.rotate3dIn:
        return renderRotate3dIn(getWidthDevice);
      case StyleState.rotate3dOut:
        return renderRotate3dOut(getWidthDevice);
      case StyleState.popUp:
        return renderPopUp();
      default:
        return renderOverlay(getWidthDevice);
    }
  }

  Widget dragClick({required Widget menuScreen, required Widget mainScreen, List? shadow}) {
    return Stack(
      children: [
        menuScreen,
        if (shadow != null) ...shadow,
        Stack(
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                if ((details.delta.dx > 6 || details.delta.dx < 6 && _state == DrawerState.open) && !widget.isRTL) {
                  if (_state == DrawerState.open && details.delta.dx < -6) {
                    close();
                  }
                }

                if ((details.delta.dx < -6 || details.delta.dx > 6 && _state == DrawerState.open) && widget.isRTL) {
                  if (_state == DrawerState.open && details.delta.dx > 6) {
                    close();
                  }
                }
              },
              child: mainScreen,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: (details) {
                if ((details.delta.dx > 6 || details.delta.dx < 6 && _state == DrawerState.open) && !widget.isRTL) {
                  if (_state == DrawerState.closed) {
                    open();
                  }
                }

                if ((details.delta.dx < -6 || details.delta.dx > 6 && _state == DrawerState.open) && widget.isRTL) {
                  if (_state == DrawerState.closed) {
                    open();
                  }
                }
              },
              child: Container(
                width: DrawerState.closed == _state ? 20 : 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Drawer State enum
enum DrawerState { opening, closing, open, closed }

// Style State
enum StyleState {
  overlay,
  fixedStack,
  stack,
  scaleRight,
  scaleBottom,
  scaleTop,
  scaleRotate,
  rotate3dIn,
  rotate3dOut,
  popUp,
}
