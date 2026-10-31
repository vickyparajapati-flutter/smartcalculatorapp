import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vault_item.dart';
import '../core/utils/haptic_service.dart';

enum VaultUnlockResult { success, decoy, failed }

class VaultProvider extends ChangeNotifier {
  static const String _keyMasterPin = 'vault_master_pin';
  static const String _keyDecoyPin = 'vault_decoy_pin';
  static const String _keyQuestion = 'vault_sec_question';
  static const String _keyAnswer = 'vault_sec_answer';

  static const String _keyPhotos = 'vault_photos_list';
  static const String _keyNotes = 'vault_notes_list';
  static const String _keyContacts = 'vault_contacts_list';

  String? _masterPin;
  String? _decoyPin;
  String _secQuestion = 'What was your first school or pet name?';
  String? _secAnswer;

  bool _isUnlocked = false;
  bool _isDecoyMode = false;

  final List<VaultPhoto> _photos = [];
  final List<VaultNote> _notes = [];
  final List<VaultContact> _contacts = [];

  bool get isConfigured => _masterPin != null && _masterPin!.isNotEmpty;
  bool get isUnlocked => _isUnlocked;
  bool get isDecoyMode => _isDecoyMode;
  String get securityQuestion => _secQuestion;
  String? get masterPin => _masterPin;

  List<VaultPhoto> get photos => _isDecoyMode ? [] : List.unmodifiable(_photos);
  List<VaultNote> get notes => _isDecoyMode ? [] : List.unmodifiable(_notes);
  List<VaultContact> get contacts => _isDecoyMode ? [] : List.unmodifiable(_contacts);

  VaultProvider() {
    _loadVaultData();
  }

  Future<void> _loadVaultData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final p = prefs.getString(_keyMasterPin);
      if (p != null) _masterPin = p;

      final d = prefs.getString(_keyDecoyPin);
      if (d != null) _decoyPin = d;

      final q = prefs.getString(_keyQuestion);
      if (q != null) _secQuestion = q;

      final a = prefs.getString(_keyAnswer);
      if (a != null) _secAnswer = a;

      final photosList = prefs.getStringList(_keyPhotos) ?? [];
      _photos.clear();
      for (var item in photosList) {
        _photos.add(VaultPhoto.fromJson(item));
      }

      final notesList = prefs.getStringList(_keyNotes) ?? [];
      _notes.clear();
      for (var item in notesList) {
        _notes.add(VaultNote.fromJson(item));
      }

      final contactsList = prefs.getStringList(_keyContacts) ?? [];
      _contacts.clear();
      for (var item in contactsList) {
        _contacts.add(VaultContact.fromJson(item));
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading vault data: $e');
    }
  }

  VaultUnlockResult unlock(String pin) {
    if (!isConfigured) return VaultUnlockResult.failed;

    if (pin == _masterPin) {
      HapticService.mediumClick();
      _isUnlocked = true;
      _isDecoyMode = false;
      notifyListeners();
      return VaultUnlockResult.success;
    }

    if (_decoyPin != null && _decoyPin!.isNotEmpty && pin == _decoyPin) {
      HapticService.mediumClick();
      _isUnlocked = true;
      _isDecoyMode = true;
      notifyListeners();
      return VaultUnlockResult.decoy;
    }

    HapticService.selectionClick();
    return VaultUnlockResult.failed;
  }

  void lock() {
    _isUnlocked = false;
    _isDecoyMode = false;
    notifyListeners();
  }

  Future<void> setupVault(String pin, String question, String answer) async {
    final prefs = await SharedPreferences.getInstance();
    final cleanPin = pin.trim();
    final cleanQuestion = question.trim();
    final cleanAnswer = answer.trim().toLowerCase();

    _masterPin = cleanPin;
    _secQuestion = cleanQuestion;
    _secAnswer = cleanAnswer;

    await prefs.setString(_keyMasterPin, cleanPin);
    await prefs.setString(_keyQuestion, cleanQuestion);
    await prefs.setString(_keyAnswer, cleanAnswer);

    _isUnlocked = true;
    _isDecoyMode = false;
    notifyListeners();
  }

  Future<void> setDecoyPin(String? decoyPin) async {
    final prefs = await SharedPreferences.getInstance();
    if (decoyPin == null || decoyPin.trim().isEmpty) {
      _decoyPin = null;
      await prefs.remove(_keyDecoyPin);
    } else {
      _decoyPin = decoyPin.trim();
      await prefs.setString(_keyDecoyPin, _decoyPin!);
    }
    notifyListeners();
  }

  Future<bool> changePin(String oldPin, String newPin) async {
    if (oldPin != _masterPin) return false;
    final prefs = await SharedPreferences.getInstance();
    _masterPin = newPin.trim();
    await prefs.setString(_keyMasterPin, _masterPin!);
    notifyListeners();
    return true;
  }

  bool verifySecurityAnswer(String answer) {
    if (_secAnswer == null) return false;
    return answer.trim().toLowerCase() == _secAnswer;
  }

  Future<bool> resetPinWithSecurity(String answer, String newPin) async {
    if (verifySecurityAnswer(answer)) {
      final prefs = await SharedPreferences.getInstance();
      _masterPin = newPin.trim();
      await prefs.setString(_keyMasterPin, _masterPin!);
      notifyListeners();
      return true;
    }
    return false;
  }

  // ==================== PHOTOS ====================
  Future<void> addPhoto(XFile pickedFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final vaultMediaDir = Directory('${appDir.path}/vault_media');
      if (!await vaultMediaDir.exists()) {
        await vaultMediaDir.create(recursive: true);
      }

      final fileName = 'vault_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(pickedFile.path).copy('${vaultMediaDir.path}/$fileName');

      final photo = VaultPhoto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        path: savedImage.path,
        dateAdded: DateTime.now(),
      );

      _photos.insert(0, photo);
      await _savePhotos();
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving vault photo: $e');
    }
  }

  Future<void> deletePhoto(String id) async {
    try {
      final index = _photos.indexWhere((p) => p.id == id);
      if (index != -1) {
        final photo = _photos[index];
        final file = File(photo.path);
        if (await file.exists()) {
          await file.delete();
        }
        _photos.removeAt(index);
        await _savePhotos();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error deleting photo: $e');
    }
  }

  Future<void> _savePhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _photos.map((p) => p.toJson()).toList();
    await prefs.setStringList(_keyPhotos, list);
  }

  // ==================== NOTES ====================
  Future<void> addNote(String title, String content) async {
    final note = VaultNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim().isEmpty ? 'Untitled Note' : title.trim(),
      content: content.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _notes.insert(0, note);
    await _saveNotes();
    notifyListeners();
  }

  Future<void> updateNote(String id, String title, String content) async {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes[index].title = title.trim().isEmpty ? 'Untitled Note' : title.trim();
      _notes[index].content = content.trim();
      _notes[index].updatedAt = DateTime.now();
      await _saveNotes();
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    await _saveNotes();
    notifyListeners();
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _notes.map((n) => n.toJson()).toList();
    await prefs.setStringList(_keyNotes, list);
  }

  // ==================== CONTACTS ====================
  Future<void> addContact(String name, String phone, String? note) async {
    final contact = VaultContact(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      phone: phone.trim(),
      note: note?.trim(),
    );
    _contacts.insert(0, contact);
    await _saveContacts();
    notifyListeners();
  }

  Future<void> updateContact(String id, String name, String phone, String? note) async {
    final index = _contacts.indexWhere((c) => c.id == id);
    if (index != -1) {
      _contacts[index].name = name.trim();
      _contacts[index].phone = phone.trim();
      _contacts[index].note = note?.trim();
      await _saveContacts();
      notifyListeners();
    }
  }

  Future<void> deleteContact(String id) async {
    _contacts.removeWhere((c) => c.id == id);
    await _saveContacts();
    notifyListeners();
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _contacts.map((c) => c.toJson()).toList();
    await prefs.setStringList(_keyContacts, list);
  }
}
