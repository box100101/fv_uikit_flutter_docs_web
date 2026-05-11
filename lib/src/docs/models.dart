import 'package:flutter/material.dart';

enum DocsLanguage { en, vi }

class LocalizedText {
  final String en;
  final String vi;

  const LocalizedText({required this.en, required this.vi});

  String resolve(DocsLanguage language) {
    return switch (language) {
      DocsLanguage.en => en,
      DocsLanguage.vi => vi,
    };
  }
}

class PropDocEntry {
  final String name;
  final String type;
  final bool required;
  final String defaultValue;
  final LocalizedText description;

  const PropDocEntry({
    required this.name,
    required this.type,
    required this.required,
    required this.defaultValue,
    required this.description,
  });
}

class ExampleDocEntry {
  final LocalizedText title;
  final LocalizedText description;
  final String code;
  final WidgetBuilder builder;

  const ExampleDocEntry({
    required this.title,
    required this.description,
    required this.code,
    required this.builder,
  });
}

class WidgetDocEntry {
  final String slug;
  final String widgetName;
  final LocalizedText title;
  final LocalizedText summary;
  final LocalizedText quickStart;
  final List<PropDocEntry> props;
  final List<ExampleDocEntry> examples;

  const WidgetDocEntry({
    required this.slug,
    required this.widgetName,
    required this.title,
    required this.summary,
    required this.quickStart,
    required this.props,
    required this.examples,
  });
}

class NavItem {
  final String route;
  final IconData icon;
  final LocalizedText title;
  final LocalizedText description;

  const NavItem({
    required this.route,
    required this.icon,
    required this.title,
    required this.description,
  });
}

class NavGroup {
  final LocalizedText title;
  final LocalizedText description;
  final List<NavItem> items;

  const NavGroup({
    required this.title,
    required this.description,
    required this.items,
  });
}

class TokenCategory {
  final LocalizedText title;
  final LocalizedText description;
  final String quickUse;
  final List<TokenValueEntry> items;

  const TokenCategory({
    required this.title,
    required this.description,
    required this.quickUse,
    required this.items,
  });
}

class TokenValueEntry {
  final String name;
  final String value;

  const TokenValueEntry({required this.name, required this.value});
}

class ColorTokenEntry {
  final String name;
  final Color color;

  const ColorTokenEntry({required this.name, required this.color});
}
