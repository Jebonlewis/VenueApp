import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class CertificateManager {
  static SecurityContext? _serverContext;

  static Future<void> loadCertificates() async {
    _serverContext = SecurityContext();

    // Get the path for storing temporary files
    Directory tempDir = await getTemporaryDirectory();
    String certPath = '${tempDir.path}/cert.pem';
    String keyPath = '${tempDir.path}/key.pem';

    try {
      // Load the certificate asset into a temporary file
      ByteData certData = await rootBundle.load('assets/certificates/cert.pem');
      List<int> certBytes = certData.buffer.asUint8List();
      File certFile = File(certPath);
      await certFile.writeAsBytes(certBytes);

      // Load the key asset into a temporary file
      ByteData keyData = await rootBundle.load('assets/certificates/key.pem');
      List<int> keyBytes = keyData.buffer.asUint8List();
      File keyFile = File(keyPath);
      await keyFile.writeAsBytes(keyBytes);

      // Use the certificate and key from the temporary files
      _serverContext!.useCertificateChain(certPath);
      _serverContext!.usePrivateKey(keyPath,password: 'venusecure');
      print('Certificates and key loaded successfully');
    } catch (e) {
      print('Error loading certificates and key: $e');
      // Handle the error accordingly
    }
  }

  static SecurityContext? getServerContext() {
    return _serverContext;
  }
}
