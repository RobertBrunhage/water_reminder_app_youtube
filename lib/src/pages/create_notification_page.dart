import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/src/global_blocs/notification_bloc.dart';
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
    final notificationBloc = Provider.of<NotificationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create Notification',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            'assets/create_notification.png',
                            width: 300,
                            height: 300,
                          ),
                        ),
                      ),
                    ),
                    CustomInputField(
                      controller: _titleController,
                      hintText: 'Title',
                      inputType: TextInputType.text,
                      autoFocus: true,
                    ),
                    SizedBox(height: 12),
                    CustomInputField(
                      controller: _descriptionController,
                      hintText: 'Description',
                      inputType: TextInputType.text,
                      autoFocus: true,
                    ),
                    SizedBox(height: 12),
                    OutlineButton(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      onPressed: selectTime,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.access_time),
                          SizedBox(width: 4),
                          Text(selectedTime.format(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomWideFlatButton(
            onPressed: () => createNotification(notificationBloc),
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
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void createNotification(NotificationBloc notificationBloc) {
    if (_formKey.currentState.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;

      final notificationData = NotificationData(title, description, selectedTime.hour, selectedTime.minute);
      notificationBloc.addNotification(notificationData);
      Navigator.of(context).pop();
    }
  }
}

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    Key key,
    @required this.controller,
    @required this.hintText,
    @required this.inputType,
    this.autoFocus,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autoFocus,
      keyboardType: inputType,
      validator: (value) {
        if (value.isEmpty) {
          return 'Field can not be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.grey.shade300,
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
