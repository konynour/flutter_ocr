import 'package:flutter/material.dart';

class EntityModel {
  final String name;
  final String value;
  final IconData iconData;

  EntityModel(this.name, this.value) : iconData = _getIcon(name);

  static IconData _getIcon(String name) {
    final nameLower = name.toLowerCase();
    
    if (nameLower.contains('phone')) {
      return Icons.phone;
    } else if (nameLower.contains('address')) {
      return Icons.location_on;
    } else if (nameLower.contains('email')) {
      return Icons.mail;
    } else if (nameLower.contains('url') || nameLower.contains('website')) {
      return Icons.web;
    } else if (nameLower.contains('person') || nameLower.contains('name')) {
      return Icons.person;
    } else if (nameLower.contains('date')) {
      return Icons.calendar_today;
    } else if (nameLower.contains('money') || nameLower.contains('price')) {
      return Icons.attach_money;
    } else if (nameLower.contains('number')) {
      return Icons.numbers;
    } else {
      return Icons.badge;
    }
  }

  /// Get formatted display name
  String get displayName {
    return name
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Check if this entity is a contact information
  bool get isContactInfo {
    final nameLower = name.toLowerCase();
    return nameLower.contains('phone') ||
        nameLower.contains('email') ||
        nameLower.contains('address');
  }

  @override
  String toString() => 'EntityModel(name: $name, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EntityModel &&
        other.name == name &&
        other.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
