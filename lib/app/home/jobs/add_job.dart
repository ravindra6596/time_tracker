import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/exception_alert_dialog.dart';
import 'package:time_tracker/services/database.dart';

class AddJob extends StatefulWidget {
  const AddJob({Key key, @required this.database}) : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddJob(
          database: database,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddJobState createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final _formKey = GlobalKey<FormState>();
  String _jobName;
  int _ratePerHour;
  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submitJob() async {
    if (_validateAndSaveForm()) {
      try {
        final job = Job(name: _jobName, ratePerHour: _ratePerHour);
        await widget.database.createJob(job);
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation Failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('New Job'),
        actions: <Widget>[
          FlatButton(
              onPressed: _submitJob,
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ))
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  //Placeholder
  // this widget is useful stand-in your final widget
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildAddJobForm(),
          ),
        ),
      ),
    );
  }

//Use of Form =>
// - Use form with Global key
// - Add some text form field
// - Add validator to show error
// - Add onSaved to update variables
// - Add button with callback to validate and save
  Widget _buildAddJobForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildJobFormChildren(),
      ),
    );
  }

//In TextFormField
// the onSaved function update local variable
// Widget rebuild is not required => Is dont call setState
  List<Widget> _buildJobFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job Name'),
         validator: (value) =>
             value.isNotEmpty ? null : "Job Name can\`t be empty",
        onSaved: (value) => _jobName = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate Per Hour'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.parse(value) ?? 0,
      ),
    ];
  }
}
