import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';
import 'dart:io';

class DisplayImages extends StatefulWidget {
  final String email;

  DisplayImages({required this.email});

  @override
  _DisplayImagesState createState() => _DisplayImagesState();
}

class _DisplayImagesState extends State<DisplayImages> {
  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      final ioClient = IOClient(
        HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true,
      );
      final response = await ioClient.get(
        Uri.parse('https://192.168.0.102:443/vendor/images?email=${widget.email}'),
      );
       // Close the IOClient when done
      if (response.statusCode == 200) {
        setState(() {
          images = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Error fetching images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(images[index]['filename']),
          leading: Image.network(
            'https://192.168.0.102:443/${images[index]['filename']}',
          ),
          // Add more UI elements as needed to display image details
        );
      },
    );
  }
}