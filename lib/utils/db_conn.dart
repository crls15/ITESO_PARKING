import 'dart:ffi';
import 'package:iteso_parking/utils/User.dart';
import 'package:mysql1/mysql1.dart';
import 'secrets.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  MySqlConnection? _connection;

  factory DatabaseProvider() {
    return _instance;
  }

  DatabaseProvider._internal();

  Future<MySqlConnection?> get connection async {
    if (_connection == null) {
      _connection = await _getDbConnection();
    }
    return _connection;
  }

  Future<MySqlConnection> _getDbConnection() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: DB_HOST,
      port: DB_PORT,
      password: DB_PSW,
      user: DB_USER,
      db: DB_NAME,
    ));
    return conn;
  }

  Future<Null> closeDbConnection(MySqlConnection conn) async {
    return await conn.close();
  }

// Querys

  Future<String> printDbUsers(MySqlConnection conn) async {
    final results = await conn.query('SELECT * FROM users');

    List<User> users = [];

    for (var row in results) {
      users.add(User.fromJson(row.fields));
    }

// Ahora tienes una lista de objetos User que puedes utilizar
    for (var user in users) {
      print(
          'ID: ${user.id_users}, Name: ${user.userName}, Email: ${user.email}');
    }
    return "";
  }

  Future<bool?> isUserParked(String firebase_id) async {
    String query = '''SELECT parking_logs.id_parking_logs
                    FROM users
                    INNER JOIN parking_logs
                    ON parking_logs.id_users = users.id_users
                    WHERE parking_logs.isActive = 1
                    AND users.firebase_id = "${firebase_id}"
                  ''';

    final server_results = await this._connection?.query(query);

    return server_results?.isNotEmpty;
  }
}
