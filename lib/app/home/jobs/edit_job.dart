import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/alert_dialog.dart';
import 'package:time_tracker/common_widgets/exception_alert_dialog.dart';
import 'package:time_tracker/services/database.dart';

class EditJob extends StatefulWidget {
  const EditJob({Key key, @required this.database, this.job}) : super(key: key);
  final Database database;
  final Job job;
  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJob(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobState createState() => _EditJobState();
}

class _EditJobState extends State<EditJob> {
  final _formKey = GlobalKey<FormState>();
  String _jobName;
  int _ratePerHour;
  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _jobName = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

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
        // following line display the current list of jobs from firestore
        // get the 1st (most-up-to-date)value on stream
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_jobName)) {
          showAlertDialog(context,
              title: 'Job Name Already Used',
              content: 'Please Choose a different Job name',
              defaultActionText: 'Ok');
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(
            id: id,
            name: _jobName,
            ratePerHour: _ratePerHour,
          );
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
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
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
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
        initialValue: _jobName,
        textCapitalization: TextCapitalization.sentences,
        validator: (value) =>
            value.isNotEmpty ? null : "Job Name can\`t be empty",
        onSaved: (value) => _jobName = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate Per Hour'),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
