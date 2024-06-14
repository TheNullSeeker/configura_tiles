import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConfiguraTileForge extends StatelessWidget {
  final ConfiguraAppBar? appBarConfig;
  final List<ConfiguraTile> tiles;
  final DebugMode? debugMode;
  final String? customErrorMessage;
  final ConfiguraFab? fabConfig;

  const ConfiguraTileForge({
    Key? key,
    this.appBarConfig,
    required this.tiles,
    this.debugMode,
    this.customErrorMessage,
    this.fabConfig,
  }) : super(key: key);

  void _showError(BuildContext context, String message) {
    if (debugMode == DebugMode.console) {
      if (kDebugMode) {
        print(message);
      }
    } else if (debugMode == DebugMode.userFriendly) {
      final errorMessage =
          customErrorMessage ?? 'An error occurred loading the page';
      if (message == 'snackbar') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage,
                style: TextStyle(
                    color: fabConfig?.snackbarTextColor ?? Colors.white)),
            backgroundColor: fabConfig?.snackbarColor ?? Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarConfig?.enabled == true
          ? AppBar(
              backgroundColor: appBarConfig?.backgroundColor ??
                  Theme.of(context).appBarTheme.backgroundColor,
              title: Text(
                appBarConfig?.title ?? 'Settings',
                style:
                    TextStyle(color: appBarConfig?.titleColor ?? Colors.white),
              ),
              leading: appBarConfig?.leadingIcon != null
                  ? IconButton(
                      icon: Icon(appBarConfig?.leadingIcon,
                          color: appBarConfig?.leadingColor ?? Colors.white),
                      onPressed: appBarConfig?.onLeadingTap,
                    )
                  : null,
              actions: appBarConfig?.trailingIconEnabled == true
                  ? [
                      IconButton(
                        icon: Icon(appBarConfig?.trailingIcon,
                            color: appBarConfig?.trailingIconColor ??
                                Colors.white),
                        onPressed: appBarConfig?.onTrailingTap,
                      ),
                    ]
                  : null,
            )
          : null,
      body: ListView.builder(
        itemCount: tiles.length,
        itemBuilder: (context, index) {
          final tile = tiles[index];
          final visibilityCondition = tile.visibilityCondition ?? () => true;
          return Visibility(
            visible: tile.visibilityEnabled ? visibilityCondition() : true,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 7.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment:
                    tile.headerPosition ?? CrossAxisAlignment.start,
                children: [
                  if (tile.headerText != null &&
                      tile.headerPositionOutside == true)
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: tile.headerSpacing ?? 10.0),
                      child: Text(
                        tile.headerText!,
                        style: TextStyle(
                            color: tile.headerTextColor ?? Colors.black),
                      ),
                    ),
                  BlurryContainer(
                    color: tile.tileColor ?? Colors.white,
                    blur: tile.blur ?? 8.0,
                    elevation: tile.elevation ?? 2.0,
                    padding: tile.padding ?? const EdgeInsets.all(10),
                    borderRadius: tile.borderRadius ??
                        const BorderRadius.all(Radius.circular(7)),
                    child: Column(
                      crossAxisAlignment:
                          tile.textAlignment ?? CrossAxisAlignment.start,
                      children: [
                        if (tile.headerText != null &&
                            tile.headerPositionOutside == false)
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: tile.headerSpacing ?? 10.0),
                            child: Text(
                              tile.headerText!,
                              style: TextStyle(
                                  color: tile.headerTextColor ?? Colors.black),
                            ),
                          ),
                        ListTile(
                          leading: Icon(tile.leading.icon,
                              color: tile.iconColor ??
                                  const Color.fromARGB(255, 21, 27, 32)),
                          title: Text(tile.title,
                              style: TextStyle(
                                  color: tile.titleColor ??
                                      const Color.fromARGB(255, 21, 27, 32))),
                          subtitle: tile.subtitle != null
                              ? Text(tile.subtitle!,
                                  style: TextStyle(
                                      color: tile.subtitleColor ??
                                          const Color.fromARGB(
                                              255, 21, 27, 32)))
                              : null,
                          trailing: tile.trailing != null
                              ? Icon(tile.trailing!.icon,
                                  color: tile.trailingColor ??
                                      const Color.fromARGB(255, 21, 27, 32))
                              : null,
                          onTap: () {
                            try {
                              tile.onTap();
                            } catch (e) {
                              if (debugMode != null) {
                                _showError(context, e.toString());
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: fabConfig?.visibility == true
          ? FloatingActionButton(
              onPressed: fabConfig?.onFabTap,
              backgroundColor: fabConfig?.color ?? Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(fabConfig?.roundness ?? 28.0),
              ),
              child: Icon(fabConfig?.icon ?? Icons.add,
                  color: fabConfig?.iconColor ?? Colors.white),
            )
          : null,
    );
  }
}

class ConfiguraAppBar {
  final bool enabled;
  final String? title;
  final Color? titleColor;
  final Color? backgroundColor;
  final IconData? leadingIcon;
  final Color? leadingColor;
  final VoidCallback? onLeadingTap;
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  final bool trailingIconEnabled;
  final VoidCallback? onTrailingTap;

  ConfiguraAppBar({
    this.enabled = true,
    this.title,
    this.titleColor,
    this.backgroundColor,
    this.leadingIcon,
    this.leadingColor,
    this.onLeadingTap,
    this.trailingIcon,
    this.trailingIconColor,
    this.trailingIconEnabled = false,
    this.onTrailingTap,
  });
}

class ConfiguraTile {
  final Color? tileColor;
  final Color? tileColorDark;
  final double? blur;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Icon leading;
  final String title;
  final String? subtitle; // Added subtitle
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? iconColorDark;
  final Color? titleColor;
  final Color? titleColorDark;
  final Color? subtitleColor; // Added subtitle color
  final Color? subtitleColorDark;
  final Icon? trailing;
  final Color? trailingColor;
  final Color? trailingColorDark;
  final String? headerText;
  final double? headerSpacing;
  final CrossAxisAlignment? textAlignment;
  final bool visibilityEnabled;
  final bool themeEnabled;
  final Function? visibilityCondition;
  final bool headerPositionOutside; // New property for header position
  final CrossAxisAlignment?
      headerPosition; // New property for header position alignment
  final Color? headerTextColor; // New property for header text color

  ConfiguraTile({
    this.tileColor,
    this.tileColorDark,
    this.blur,
    this.elevation,
    this.padding,
    this.borderRadius,
    required this.leading,
    required this.title,
    this.subtitle, // Updated constructor
    required this.onTap,
    this.iconColor,
    this.iconColorDark,
    this.titleColor,
    this.titleColorDark,
    this.subtitleColor, // Updated constructor
    this.subtitleColorDark,
    this.trailing,
    this.trailingColor,
    this.trailingColorDark,
    this.headerText,
    this.headerSpacing,
    this.textAlignment,
    this.visibilityEnabled = true,
    this.themeEnabled = false,
    this.visibilityCondition,
    this.headerPositionOutside = true, // Default value for header position
    this.headerPosition, // New property for header position alignment
    this.headerTextColor, // New property for header text color
  });
}

class ConfiguraFab {
  final bool visibility;
  final Color? color;
  final double? roundness;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onFabTap;
  final Color? snackbarColor;
  final Color? snackbarTextColor;

  ConfiguraFab({
    this.visibility = false,
    this.color,
    this.roundness,
    this.icon,
    this.iconColor,
    this.onFabTap,
    this.snackbarColor,
    this.snackbarTextColor,
  });
}

enum DebugMode {
  console,
  userFriendly,
}
