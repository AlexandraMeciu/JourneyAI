import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthAPI {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> localAuthAvailable() async {
    final hasAuth = await hasBiometrics();
    return hasAuth;
  }

  static Future<bool> authenticateLocal() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
        localizedReason: 'Scan for Authentication',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }
}
