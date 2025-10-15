import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/homework.dart';

class HomeworkRepository {
  static const _storageKey = 'homework_items_v1';
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Homework>> fetchAll() async {
    final str = _prefs?.getString(_storageKey);
    if (str == null || str.isEmpty) return [];
    final List<dynamic> list = json.decode(str);
    return list.map((e) => Homework.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> saveAll(List<Homework> items) async {
    final list = items.map((e) => e.toMap()).toList();
    await _prefs?.setString(_storageKey, json.encode(list));
  }
}