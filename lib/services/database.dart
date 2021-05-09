import 'package:meta/meta.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  // Writeing data with firestore
  // Single set Method(declare below line) for  CREATE and UPDATE
  // Its same conversion in our Firestore database  class
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();
}
//DateTime.now().toIso8601String() =>
//document id carries implicit information about when it was created

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FireStoreService.instance;
  @override
  Future<void> setJob(Job job) => _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );
  @override
  Future<void> deleteJob(Job job) =>
      _service.deleteData(path: APIPath.job(uid, job.id));
// _setData defines single entry point for all writes to Firestore
// (its useful for logging/debugging)
  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(
          data,
          documentId,
        ),
      );
}
