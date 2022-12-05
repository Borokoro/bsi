
import 'package:bsi/Functions/Functions.dart';
import 'package:test/test.dart';
void main() {
  Functions f=Functions();
  group('Check if password is encrypted and decrypted correctly', () {
    final params = {
      '12323': '12323',
      'qwrawsfr': 'qwrawsfr',
      'ęąćźżłó': 'ęąćźżłó',
      'asd a dasd': 'asd a dasd',
    };

    params.forEach((element, expected) {
      test('$element => $expected', () {
        final String salt = f.salt_generate();
        final encrypted = f.encrypt(element, salt);
        expect(element, f.decrypt(salt, encrypted));
      });
    });
  });

  group('Check if sha512 length is 128', () {
    final params = [
      '12323',
      'qwrawsfr',
      'ęąćźżłó',
      'asd a dasd',
    ];

    // ignore: cascade_invocations
    params.forEach((element) {
      test('$element => length = 128', () {
        final String salt = f.salt_generate();
        expect(f.hashSha512(salt,element).length, 128);
      });
    });
  });

  group('True if hmac length is 128', () {
    final params = [
      '12323',
      'qwrawsfr',
      'ęąćźżłó',
      'asd a dasd',
    ];

    // ignore: cascade_invocations
    params.forEach((element) {
      test('$element => hashed length = 128', () {
        final String salt = f.salt_generate();
        expect(f.hashHMAC(salt, element).length, 128);
      });
    });
  });
}