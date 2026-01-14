import 'dart:convert';
import 'package:cam_id/main/data/model/chatbot/ws_response_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// Import file model của bạn ở đây

class ChatDatabaseHelper {
  static final ChatDatabaseHelper instance = ChatDatabaseHelper._init();
  static Database? _database;

  ChatDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chatbot_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chat_messages (
        local_id INTEGER PRIMARY KEY AUTOINCREMENT,
        json_data TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // --- HÀM LƯU TIN NHẮN ---
  Future<void> saveMessage(WsResponseData message) async {
    final db = await instance.database;
    await db.insert('chat_messages', {
      'json_data': jsonEncode(message.toJson()), // Convert sang chuỗi JSON
      'timestamp': (message.datetime ?? DateTime.now()).toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // --- HÀM LẤY TOÀN BỘ LỊCH SỬ ---
  Future<List<WsResponseData>> loadMessages() async {
    final db = await instance.database;
    final result = await db.query('chat_messages', orderBy: 'timestamp ASC');

    return result.map((row) {
      final String jsonStr = row['json_data'] as String;
      return WsResponseData.fromJson(jsonDecode(jsonStr));
    }).toList();
  }

  // --- HÀM XÓA LỊCH SỬ (Nếu cần) ---
  Future<void> clearHistory() async {
    final db = await instance.database;
    await db.delete('chat_messages');
  }
}
