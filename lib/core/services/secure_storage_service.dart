import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_store/core/models/user_session.dart';

class SecureStorageService {
  SecureStorageService._();

  static SecureStorageService? instance;

  factory SecureStorageService() {
    instance ??= SecureStorageService._();
    return instance!;
  }

  final _storage = const FlutterSecureStorage();

  static const _keyId = 'id';
  static const _keyToken = 'token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUsername = 'username';
  static const _keyEmail = 'email';
  static const _keyFirstName = 'first_name';
  static const _keyLastName = 'last_name';
  static const _keyImage = 'image';

  // A corrupted keystore entry (e.g. after an Android backup restore) throws on
  // read; dropping the key lets the user sign in again instead of crashing.
  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      try {
        await _storage.delete(key: key);
      } catch (_) {}
      return null;
    }
  }

  Future<void> saveUserSession(UserSession session) async {
    await Future.wait([
      _storage.write(key: _keyId, value: session.id.toString()),
      _storage.write(key: _keyToken, value: session.token),
      _storage.write(key: _keyRefreshToken, value: session.refreshToken),
      _storage.write(key: _keyUsername, value: session.username),
      _storage.write(key: _keyEmail, value: session.email),
      _storage.write(key: _keyFirstName, value: session.firstName),
      _storage.write(key: _keyLastName, value: session.lastName),
      _storage.write(key: _keyImage, value: session.image),
    ]);
  }

  Future<UserSession?> readUserSession() async {
    final token = await _safeRead(_keyToken);
    if (token == null || token.isEmpty) return null;
    return UserSession(
      id: int.tryParse(await _safeRead(_keyId) ?? '') ?? 0,
      token: token,
      refreshToken: await _safeRead(_keyRefreshToken) ?? '',
      username: await _safeRead(_keyUsername) ?? '',
      email: await _safeRead(_keyEmail) ?? '',
      firstName: await _safeRead(_keyFirstName) ?? '',
      lastName: await _safeRead(_keyLastName) ?? '',
      image: await _safeRead(_keyImage) ?? '',
    );
  }

  Future<String?> get token => _safeRead(_keyToken);

  Future<void> clearUserSession() => _storage.deleteAll();
}
