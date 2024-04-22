// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class DisplayImages extends StatefulWidget {
//   final String email;

//   DisplayImages({required this.email});
//   @override
//   _DisplayImagesState createState() => _DisplayImagesState();
// }

// class _DisplayImagesState extends State<DisplayImages> {
//   List<ImageData> images = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchImages();
//   }

//   Future<void> fetchImages() async {
//     try {
//       final response = await http.get(Uri.parse('http://192.168.43.160:443/vendor/images?email=${widget.email}'));
//       if (response.statusCode == 200) {
//         final List<dynamic> responseData = json.decode(response.body);
//         setState(() {
//           images = responseData.map((data) => ImageData.fromMap(data)).toList();
//         });
//       } else {
//         throw Exception('Failed to load images');
//       }
//     } catch (error) {
//       print('Error fetching images: $error');
//       // Handle error appropriately, e.g., show error message to the user
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Display Images'),
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 4.0,
//           mainAxisSpacing: 4.0,
//         ),
//         itemCount: images.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Image.memory(images[index].imageBytes);
//         },
//       ),
//     );
//   }
// }

// class ImageData {
//   final String filename;
//   final Uint8List imageBytes;

//   ImageData({required this.filename, required this.imageBytes});

//   factory ImageData.fromMap(Map<String, dynamic> map) {
//     return ImageData(
//       filename: map['filename'],
//       imageBytes: base64Decode(map['image']),
//     );
//   }
// }


import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisplayImages extends StatefulWidget {
  final String email;

  DisplayImages({required this.email});
  @override
  _DisplayImagesState createState() => _DisplayImagesState();
}

class _DisplayImagesState extends State<DisplayImages> {
  List<ItemData> itemDataList = [];

  @override
  void initState() {
    super.initState();
    fetchItemData();
  }

  Future<void> fetchItemData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.43.160:443/vendor/images?email=${widget.email}'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          itemDataList = responseData.map((data) => ItemData.fromMap(data)).toList();
        });
      } else {
        throw Exception('Failed to load item data');
      }
    } catch (error) {
      print('Error fetching item data: $error');
      // Handle error appropriately, e.g., show error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Items'),
      ),
      body: ListView.builder(
        itemCount: itemDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(itemDataList[index].itemDetails.itemName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(itemDataList[index].itemDetails.aboutItem),
                Text(itemDataList[index].itemDetails.price),
              ],
            ),
            leading: Image.memory(itemDataList[index].imageData.imageBytes),
          );
        },
      ),
    );
  }
}

class ItemData {
  final ItemDetails itemDetails;
  final ImageData imageData;

  ItemData({required this.itemDetails, required this.imageData});

  factory ItemData.fromMap(Map<String, dynamic> map) {
    return ItemData(
      itemDetails: ItemDetails.fromMap(map['itemDetails']),
      imageData: ImageData.fromMap(map['imageData']),
    );
  }
}

class ItemDetails {
  final String itemName;
  final String aboutItem;
  final String price;

  ItemDetails({required this.itemName, required this.aboutItem, required this.price});

  factory ItemDetails.fromMap(Map<String, dynamic> map) {
    return ItemDetails(
      itemName: map['itemName'],
      aboutItem: map['aboutItem'],
      price: map['price'].toString(),
    );
  }
}

class ImageData {
  final String filename;
  final Uint8List imageBytes;

  ImageData({required this.filename, required this.imageBytes});

  factory ImageData.fromMap(Map<String, dynamic> map) {
    return ImageData(
      filename: map['filename'],
      imageBytes: base64Decode(map['image']),
    );
  }
}
