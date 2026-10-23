import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/support_contact.dart';

abstract class SupportContactsRepository {
  Future<List<SupportContact>> getContacts();
  Future<void> saveContact(SupportContact contact);
  Future<void> deleteContact(String id);
}

class LocalSupportContactsRepository implements SupportContactsRepository {
  final KeyValueStorage _storage;
  static const String _key = 'denge_support_contacts';

  LocalSupportContactsRepository(this._storage);

  @override
  Future<List<SupportContact>> getContacts() async {
    final raw = await _storage.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => SupportContact.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveContact(SupportContact contact) async {
    final all = await getContacts();
    final idx = all.indexWhere((c) => c.id == contact.id);
    if (idx >= 0) {
      all[idx] = contact;
    } else {
      all.add(contact);
    }
    await _storage.setString(
      _key,
      jsonEncode(all.map((c) => c.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteContact(String id) async {
    final all = await getContacts();
    all.removeWhere((c) => c.id == id);
    await _storage.setString(
      _key,
      jsonEncode(all.map((c) => c.toJson()).toList()),
    );
  }
}
