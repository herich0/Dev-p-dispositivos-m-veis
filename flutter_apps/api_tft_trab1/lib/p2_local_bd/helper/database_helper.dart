import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/composicao.dart'; // Importa o modelo que acabamos de criar

// Nome da tabela
const String composicaoTable = "composicaoTable";

class DatabaseHelper {
  // Padrão Singleton (só existe uma instância dessa classe)
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(
      databasePath,
      "tft_strategies.db",
    ); // Nome do arquivo do banco

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerVersion) async {
        await db.execute(
          "CREATE TABLE $composicaoTable("
          "$idColumn INTEGER PRIMARY KEY, "
          "$nomeColumn TEXT, "
          "$campeoesColumn TEXT, "
          "$itensColumn TEXT, "
          "$tierColumn TEXT, "
          "$dificuldadeColumn TEXT, "
          "$custoColumn TEXT, "
          "$obsColumn TEXT, "
          "$imageColumn TEXT)"
        );
      },
    );
  }

  // CRUD: Create (Salvar)
  Future<Composicao> saveComposicao(Composicao composicao) async {
    Database dbComposicao = await db;
    composicao.id = await dbComposicao.insert(
      composicaoTable,
      composicao.toMap(),
    );
    return composicao;
  }

  // CRUD: Read (Ler um)
  Future<Composicao?> getComposicao(int id) async {
    Database dbComposicao = await db;
    List<Map<String, dynamic>> maps = await dbComposicao.query(
      composicaoTable,
      columns: [
        idColumn,
        nomeColumn,
        campeoesColumn,
        itensColumn,
        tierColumn,
        dificuldadeColumn,
        custoColumn,
        obsColumn,
      ],
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Composicao.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // CRUD: Read All (Ler todos)
  Future<List<Composicao>> getAllComposicoes() async {
    Database dbComposicao = await db;
    List<Map<String, dynamic>> listMap = await dbComposicao.query(
      composicaoTable,
    );
    List<Composicao> listComposicao = [];
    for (Map<String, dynamic> m in listMap) {
      listComposicao.add(Composicao.fromMap(m));
    }
    return listComposicao;
  }

  // CRUD: Update (Atualizar)
  Future<int> updateComposicao(Composicao composicao) async {
    Database dbComposicao = await db;
    return await dbComposicao.update(
      composicaoTable,
      composicao.toMap(),
      where: "$idColumn = ?",
      whereArgs: [composicao.id],
    );
  }

  // CRUD: Delete (Apagar)
  Future<int> deleteComposicao(int id) async {
    Database dbComposicao = await db;
    return await dbComposicao.delete(
      composicaoTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }
}
