import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class CanadianResumePdf {
  static Future<File> generate(
      String fullName,
      String address,
      String phoneNumber,
      String email,
      String profileSummary,
      List<Map<String, String>> workExperience,
      List<String> education,
      List<String> skills,
      ) async {
    // Load fonts and images
    final myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
      bold: Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")),
      italic: Font.ttf(await rootBundle.load("fonts/OpenSans-Italic.ttf")),
      boldItalic: Font.ttf(await rootBundle.load("fonts/OpenSans-BoldItalic.ttf")),
    );
    final MemoryImage image = MemoryImage(
      (await rootBundle.load('img/profile_picture.png')).buffer.asUint8List(),
    );

    // Create a new PDF document with the loaded theme
    final pdf = Document(theme: myTheme);

    // Add a page with the resume details
    pdf.addPage(
      Page(
        build: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(image, fullName),
            SizedBox(height: 20),
            buildSectionTitle('Contact Information'),
            SizedBox(height: 10),
            buildContactInfo(address, phoneNumber, email),
            SizedBox(height: 20),
            buildSectionTitle('Profile Summary'),
            SizedBox(height: 10),
            buildProfileSummary(profileSummary),
            SizedBox(height: 20),
            buildSectionTitle('Work Experience'),
            SizedBox(height: 10),
            ...workExperience.map((exp) => buildWorkExperience(exp)),
            SizedBox(height: 20),
            buildSectionTitle('Education'),
            SizedBox(height: 10),
            ...education.map((edu) => buildEducation(edu)),
            SizedBox(height: 20),
            buildSectionTitle('Skills'),
            SizedBox(height: 10),
            buildSkills(skills),
          ],
        ),
      ),
    );
try {
  final directory = Platform.isAndroid
       ? await getExternalStorageDirectory()
    : await getApplicationDocumentsDirectory();
  final path = directory!.path;
  final file = File('$path/$fullName.pdf');
  await file.writeAsBytes(await pdf.save());
  try {
    await file.writeAsBytes(await pdf.save());
    if (await file.exists()) {
      print('File saved successfully: $path');
    } else {
      print('File not saved at the expected location.');
    }
  } catch (e) {
    print('An error occurred while writing the file: $e');
    throw Exception('Failed to write the file');
  }
  return file;
} catch (e) {
  print('An error occurred while writing the file: $e');
  throw Exception('Failed to write the file');
  }
  }

  static Widget buildHeader(MemoryImage image, String fullName) => Row(
    children: [
      Image(image, height: 80, width: 80),
      SizedBox(width: 20),
      Text(
        fullName,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ],
  );

  static Widget buildSectionTitle(String title) => Text(
    title,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );

  static Widget buildContactInfo(String address, String phoneNumber, String email) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Address: $address'),
      SizedBox(height: 5),
      Text('Phone: $phoneNumber'),
      SizedBox(height: 5),
      Text('Email: $email'),
    ],
  );

  static Widget buildProfileSummary(String summary) => Text(
    summary,
    textAlign: TextAlign.justify,
  );

  static Widget buildWorkExperience(Map<String, String> experience) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        experience['position']!,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(experience['company']!),
      Text('${experience['startDate']} - ${experience['endDate'] ?? 'Present'}'),
      SizedBox(height: 5),
      Text(experience['description']!),
      SizedBox(height: 10),
    ],
  );

  static Widget buildEducation(String education) => Text(
    education,
    textAlign: TextAlign.justify,
  );

  static Widget buildSkills(List<String> skills) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: skills.map((skill) => Text('• $skill')).toList(),
  );

  static Future<void> openFile(File file) async {
    try {
      final url =file.path;

      if (!await file.exists()) {
        print('File does not exist');
        return;
      }

      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final result = await Permission.storage.request();
        if (result.isGranted) {
          await OpenFile.open(url);
        } else if (result.isPermanentlyDenied) {
          openAppSettings();  // Prompt user to manually enable the permission
        } else {
          print('Permission denied to access storage');
        }
      } else {
        await OpenFile.open(url);
      }
    } catch (e) {
      print('An error occurred while opening the file : $e');
      throw Exception('Failed to open the file');
    }
  }

}