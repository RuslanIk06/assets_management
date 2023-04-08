import 'dart:convert';
import 'dart:typed_data';

import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:assets_management/config/app_constant.dart';

class CreateAssetPage extends StatefulWidget {
  const CreateAssetPage({super.key});

  @override
  State<CreateAssetPage> createState() => _CreateAssetPageState();
}

class _CreateAssetPageState extends State<CreateAssetPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  List<String> types = [
    'Vehicle',
    'Electronic',
    'Inventory',
    'Other',
  ];

  String type = 'Electronic';

  String? imageName;
  Uint8List? imageByte;

  void pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);

    if (picked != null) {
      // if there data
      imageName = picked.name;
      imageByte = await picked.readAsBytes();

      setState(() {});
    }
  }

  void onSave() async {
    bool isValidInput = formKey.currentState!.validate();

    if (!isValidInput) return;

    if (imageName == null) {
      DInfo.toastError("Image don't empty");
      return;
    }

    Uri url = Uri.parse(
      '${AppConstant.baseUrl}/asset/create.php',
    );
    try {
      final response = await http.post(
        url,
        body: {
          'name': nameController.text,
          'type': type,
          'image': imageName,
          'base64code': base64Encode(imageByte! as List<int>),
        },
      );
      DMethod.printResponse(response);

      Map resBody = jsonDecode(response.body);

      bool isSucess = resBody['success'] ?? false;

      if (isSucess) {
        DInfo.toastSuccess('Success Create New Assets');
        Navigator.pop(context);
      } else {
        DInfo.toastError('Failed Create New Assets');
      }
    } catch (e) {
      DMethod.printTitle('catch', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Assets"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DInput(
              controller: nameController,
              fillColor: Colors.white,
              title: 'Nama',
              hint: 'Masukan Nama Asset',
              validator: (input) => input == '' ? "Don't Empty" : null,
              radius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 16),
            const Text(
              "Type",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField(
              icon: const Icon(Icons.keyboard_arrow_down),
              value: type,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              items: types.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  type = value;
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "Image",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: imageByte == null
                    ? const Text("Empty")
                    : Image.memory(imageByte!),
              ),
            ),
            ButtonBar(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    pickImage(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera_enhance),
                  label: const Text("Camera"),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Gallery"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                onSave();
              },
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              label: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
