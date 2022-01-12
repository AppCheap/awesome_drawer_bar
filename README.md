# Flutter Awesome Drawer Bar

[![pub package](https://img.shields.io/pub/v/awesome_drawer_bar.svg)](https://pub.dev/packages/awesome_drawer_bar) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter package with custom implementation of the Side Menu (Drawer)

## Getting Started

To start using this package, add `awesome_drawer_bar` dependency to your `pubspec.yaml`

```yaml
dependencies:
  awesome_drawer_bar: '<latest_release>'
```

## Features

* Simple sliding drawer
* Sliding drawer with shadows
* Sliding drawer with rotation
* Sliding drawer with rotation and shadows
* Support for both LTR & RTL


## Documentation

```dart
    AwesomeDrawerBar(
      controller: AwesomeDrawerBarController,
      menuScreen: MENU_SCREEN,
      mainScreen: MAIN_SCREEN,
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      backgroundColor: Colors.grey[300],
      slideWidth: MediaQuery.of(context).size.width*.65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    )
```

| Parameters         | Value                  | Required  | Docs                                                                        |
| ------------------ |----------------------- | :-------: | --------------------------------------------------------------------------- |
| `controller`       | `AwesomeDrawerBarController` |    No     | Controller to have access to the open/close/toggle function of the drawer   |
| `mainScreen`       | `Widget`               |   Yes     | Screen containing the main content to display                               |
| `menuScreen`       | `Widget`               |   Yes     | Screen containing the menu/bottom screen                                    |
| `slideWidth`       | `double`               |    No     | Sliding width of the drawer - defaults to 275.0                             |
| `borderRadius`     | `double`               |    No     | Border radius of the slided content - defaults to 16.0                      |
| `angle`            | `double`               |    No     | Rotation angle of the drawer - defaults to -12.0 - should be 0.0 to -30.0   |
| `backgroundColor`  | `Color`                |    No     | Background color of the drawer shadows - defaults to white                  |
| `showShadow`       | `bool`                 |    No     | Boolean, whether to show the drawer shadows - defaults to false             |
| `openCurve`        | `Curve`                |    No     | open animation curve - defaults to `Curves.easeOut`                  |
| `closeCurve`       | `Curve`                |    No     | close animation curve - defaults to `Curves.easeOut`             |


### Controlling the drawer

To get access to the drawer, and be able to control it, there are 2 ways:

* Using a `AwesomeDrawerBarController` inside the main widget where ou have the `AwesomeDrawerBar` widget and providing it to the widget, which will allow you to trigger the open/close/toggle methods.
```dart
    final _drawerController = AwesomeDrawerBarController();

    _drawerController.open();
    _drawerController.close();
    _drawerController.toggle();
    _drawerController.isOpen();
    _drawerController.stateNotifier;
```

* Using the static method inside ancestor widgets to get access to the `AwesomeDrawerBar`.
```dart
  AwesomeDrawerBar.of(context).open();
  AwesomeDrawerBar.of(context).close();
  AwesomeDrawerBar.of(context).toggle();
  AwesomeDrawerBar.of(context).isOpen();
  AwesomeDrawerBar.of(context).stateNotifier;
```

## Screens

![Example app Demo](https://drive.google.com/uc?export=view&id=1xc6XwVVtpl0RK9IJEdheagM4d1ychQms)

![Example RTL Demo](https://drive.google.com/uc?export=view&id=1YLC60zJ6N637PB6IQDo4TIXY1qGSJ2ET)

* Drawer Sliding

```dart
    AwesomeDrawerBar(
      controller: AwesomeDrawerBarController,
      menuScreen: MENU_SCREEN,
      mainScreen: MAIN_SCREEN,
      borderRadius: 24.0,
      showShadow: false,
      angle: 0.0,
      backgroundColor: Colors.grey[300],
      slideWidth: MediaQuery.of(context).size.width*(AwesomeDrawerBar.isRTL()? .45: 0.65),
    )
```

![Drawer Sliding](https://drive.google.com/uc?export=view&id=1axuT4Geh08s_QjmED9VTZiwZ9dC_C17C)

* Drawer Sliding with shadow

```dart
    AwesomeDrawerBar(
      controller: AwesomeDrawerBarController,
      menuScreen: MENU_SCREEN,
      mainScreen: MAIN_SCREEN,
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      backgroundColor: Colors.grey[300],
      slideWidth: MediaQuery.of(context).size.width*(AwesomeDrawerBar.isRTL()? .45: 0.65),
    )
```

![Drawer Sliding](https://drive.google.com/uc?export=view&id=1VNkUgtj_bhyYgWJ_Bs3yUpVNUJ30ToPL)

* Drawer Sliding with rotation

```dart
    AwesomeDrawerBar(
      controller: AwesomeDrawerBarController,
      menuScreen: MENU_SCREEN,
      mainScreen: MAIN_SCREEN,
      borderRadius: 24.0,
      showShadow: false,
      angle: -12.0,
      backgroundColor: Colors.grey[300],
      slideWidth: MediaQuery.of(context).size.width*(AwesomeDrawerBar.isRTL()? .45: 0.65),
    )
```

![Drawer Sliding with rotation](https://drive.google.com/uc?export=view&id=1xVYoZHnS9BFi5KicZtP3DY1vEiwZ4FyH)

* Drawer Sliding with rotation and shadows

```dart
    AwesomeDrawerBar(
      controller: AwesomeDrawerBarController,
      menuScreen: MENU_SCREEN,
      mainScreen: MAIN_SCREEN,
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      backgroundColor: Colors.grey[300],
      slideWidth: MediaQuery.of(context).size.width*(AwesomeDrawerBar.isRTL()? .45: 0.65),
    )
```

![Drawer Sliding with rotation and shadows](https://drive.google.com/uc?export=view&id=1b-U25tIY36ka75Ju2jQT9BIUVHv-oNe6)


## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/medyas/awesome_drawer_bar/issues) page.

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](CONTRIBUTING.md) and send us your [pull request](https://github.com/medyas/awesome_drawer_bar/pulls).

## Credits

Credits goes to [pedromassango](https://github.com/pedromassango/flutter_delivery) as most of this package comes from his implementation.
