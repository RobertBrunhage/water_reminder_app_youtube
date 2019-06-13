import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_reminder_app/src/view_models/notification_data.dart';
import 'package:water_reminder_app/src/widgets/buttons/custom_wide_flat_button.dart';

class CreateNotificationPage extends StatefulWidget {
  @override
  _CreateNotificationPageState createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomInputField(
                      controller: _titleController,
                      hintText: 'Title',
                      autoFocus: true,
                    ),
                    SizedBox(height: 12),
                    CustomInputField(
                      controller: _descriptionController,
                      hintText: 'Description',
                      autoFocus: true,
                    ),
                    SizedBox(height: 12),
                    FlatButton(
                      onPressed: selectTime,
                      color: Colors.blue,
                      child: Text(selectedTime.format(context)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomWideFlatButton(
            onPressed: createNotification,
            backgroundColor: Colors.blue.shade300,
            foregroundColor: Colors.blue.shade900,
            isRoundedAtBottom: false,
          ),
        ],
      ),
    );
  }

  Future<void> selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    setState(() {
      selectedTime = time;
    });
  }

  void createNotification() {
    if (_formKey.currentState.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final time = Time(selectedTime.hour, selectedTime.minute);

      final notificationData = NotificationData(title, description, time);
      Navigator.of(context).pop(notificationData);
    }
  }
}

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    Key key,
    @required this.controller,
    @required this.hintText,
    this.autoFocus,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autoFocus,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return 'Field can not be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.grey.shade300,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(
            const Radius.circular(5),
          ),
        ),
      ),
    );
  }
}
