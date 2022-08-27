// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  OrderDao _orderDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Order` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `count` INTEGER, `total` REAL, `goods` TEXT, `createTime` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  OrderDao get orderDao {
    return _orderDaoInstance ??= _$OrderDao(database, changeListener);
  }
}

class _$OrderDao extends OrderDao {
  _$OrderDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _orderInsertionAdapter = InsertionAdapter(
            database,
            'Order',
            (Order item) => <String, dynamic>{
                  'id': item.id,
                  'count': item.count,
                  'total': item.total,
                  'goods': item.goods,
                  'createTime': item.createTime
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Order> _orderInsertionAdapter;

  @override
  Future<List<Order>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM Order',
        mapper: (Map<String, dynamic> row) => Order(
            row['id'] as int,
            row['count'] as int,
            row['total'] as double,
            row['goods'] as String,
            row['createTime'] as int));
  }

  @override
  Stream<Order> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Order WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'Order',
        isView: false,
        mapper: (Map<String, dynamic> row) => Order(
            row['id'] as int,
            row['count'] as int,
            row['total'] as double,
            row['goods'] as String,
            row['createTime'] as int));
  }

  @override
  Future<void> add(Order order) async {
    await _orderInsertionAdapter.insert(order, OnConflictStrategy.abort);
  }
}
