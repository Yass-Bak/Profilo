import 'dart:io';
import 'dart:math';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import '../PdfGenerator/GenerateCv.dart'; // Ensure the path matches your project structure
import 'package:wc_form_validators/wc_form_validators.dart';
class CanadianResumeForm extends StatefulWidget {
  final Function(bool) toggleTheme;

  CanadianResumeForm({required this.toggleTheme});

  @override
  _CanadianResumeFormState createState() => _CanadianResumeFormState();
}

class _CanadianResumeFormState extends State<CanadianResumeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String fullName = '';
  String address = '';
  String phoneNumber = '';
  String email = '';
  String profileSummary = '';
  List<Map<String, String>> workExperience = [];
  List<String> education = [];
  List<String> skills = [];

  TextEditingController positionController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController skillController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final File pdfFile = await CanadianResumePdf.generate(
          fullName,
          address,
          phoneNumber,
          email,
          profileSummary,
          workExperience,
          education,
          skills,
        );

       CanadianResumePdf.openFile(pdfFile);
        print('-----all done ---');
      } catch (e) {
        print('Failed to generate PDF: $e');
      }
    }
  }


  void _addWorkExperience() {
    setState(() {
      workExperience.add({
        'position': positionController.text,
        'company': companyController.text,
        'startDate': startDateController.text,
        'endDate': endDateController.text,
        'description': descriptionController.text,
      });

      positionController.clear();
      companyController.clear();
      startDateController.clear();
      endDateController.clear();
      descriptionController.clear();
    });
  }

  void _addEducation() {
    setState(() {
      education.add(educationController.text);
      educationController.clear();
    });
  }

  void _addSkill() {
    setState(() {
      skills.add(skillController.text);
      skillController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profilo'),
        actions: [


        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: Text('Theme'),
                secondary: Icon(
                  Theme.of(context).brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.yellow : Colors.grey,
                ),
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: widget.toggleTheme,
                activeColor: Colors.yellow,
                activeTrackColor: Colors.yellowAccent,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade400,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) {
                  fullName = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) {
                  address = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                maxLength: 8,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  phoneNumber = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: Validators.compose([
                  Validators.email('Please enter valid email'),
                  Validators.required('Please enter your email')
                ]),
                autocorrect: false,

                onSaved: (value) {
                  email = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Profile Summary'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a profile summary';
                  }
                  return null;
                },
                onSaved: (value) {
                  profileSummary = value ?? '';
                },
              ),
              // Other input fields for work experience, education, and skills...
              SizedBox(height: 20),
              Text('Work Experience', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: positionController,
                decoration: InputDecoration(labelText: 'Position'),
              ),
              TextFormField(
                controller: companyController,
                decoration: InputDecoration(labelText: 'Company'),
              ),
              Row(
                children: [
                  Expanded(
                    child: DateTimeField(
                      format: DateFormat("yyyy-MM-dd"),
                    /*  validator: (selectedDateTime) {
                        if (selectedDateTime == null) {
                          return ('Please select a start date.');
                        } else {
                          final now = DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day);
                          final dateSelected = DateTime(selectedDateTime.year,
                              selectedDateTime.month, selectedDateTime.day);
                          // If the DateTime difference is negative,
                          // this indicates that the selected DateTime is in the past
                          if (dateSelected.compareTo(now) == 0) {
                            AlertDialog(
                              title: Text("Error"),
                              backgroundColor: Colors.red,
                              titleTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            );
                            return ('Please select a valid start date.');
                          } else if (!selectedDateTime
                              .difference(DateTime.now())
                              .isNegative) {
                            return ('Date selected in the future.');
                          }
                        }
                      },*/
                      controller: startDateController,
                      decoration: InputDecoration(labelText: 'Start Date'),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        return date;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DateTimeField(
                      format: DateFormat("yyyy-MM-dd"),
                      controller: endDateController,
                      decoration: InputDecoration(labelText: 'End Date'),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        return date;
                      },
                    ),
                  ),
                ],
              )
,
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: null,
              ),
              ElevatedButton(
                onPressed: _addWorkExperience,
                child: Text('Press to add Work Experience'),
              ),

              // Education section
              SizedBox(height: 20),
              Text('Education', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: educationController,
                decoration: InputDecoration(labelText: 'Education'),
              ),
              ElevatedButton(
                onPressed: _addEducation,
                child: Text('Press to add Education'),
              ),

              // Skills section
              SizedBox(height: 20),
              Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: skillController,
                decoration: InputDecoration(labelText: 'Skill'),
              ),
              ElevatedButton(
                onPressed: _addSkill,
                child: Text('Press to add skills'),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Generate Resume'),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
