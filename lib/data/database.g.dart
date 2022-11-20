// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
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

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

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
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
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
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  OrderDao? _orderDaoInstance;

  CategoryDao? _categoryDaoInstance;

  ItemDao? _itemDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
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
            'CREATE TABLE IF NOT EXISTS `Order` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `count` INTEGER NOT NULL, `total` REAL NOT NULL, `goods` TEXT NOT NULL, `createTime` INTEGER NOT NULL, `content` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Category` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `createTime` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Item` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `catId` INTEGER NOT NULL, `price` REAL NOT NULL, `count` INTEGER NOT NULL, `createTime` INTEGER NOT NULL, `widget` TEXT NOT NULL, `content` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  OrderDao get orderDao {
    return _orderDaoInstance ??= _$OrderDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  ItemDao get itemDao {
    return _itemDaoInstance ??= _$ItemDao(database, changeListener);
  }
}

class _$OrderDao extends OrderDao {
  _$OrderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _orderInsertionAdapter = InsertionAdapter(
            database,
            'Order',
            (Order item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'count': item.count,
                  'total': item.total,
                  'goods': item.goods,
                  'createTime': item.createTime,
                  'content': item.content
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Order> _orderInsertionAdapter;

  @override
  Future<List<Order>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM Order',
        mapper: (Map<String, Object?> row) => Order(row['title'] as String,
            row['count'] as int, row['total'] as double, row['goods'] as String,
            content: row['content'] as String,
            createTime: row['createTime'] as int));
  }

  @override
  Stream<Order?> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Order WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Order(row['title'] as String,
            row['count'] as int, row['total'] as double, row['goods'] as String,
            content: row['content'] as String,
            createTime: row['createTime'] as int),
        arguments: [id],
        queryableName: 'Order',
        isView: false);
  }

  @override
  Future<int> add(Order order) {
    return _orderInsertionAdapter.insertAndReturnId(
        order, OnConflictStrategy.abort);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _categoryInsertionAdapter = InsertionAdapter(
            database,
            'Category',
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'createTime': item.createTime
                },
            changeListener),
        _categoryUpdateAdapter = UpdateAdapter(
            database,
            'Category',
            ['id'],
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'createTime': item.createTime
                },
            changeListener),
        _categoryDeletionAdapter = DeletionAdapter(
            database,
            'Category',
            ['id'],
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'createTime': item.createTime
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Category> _categoryInsertionAdapter;

  final UpdateAdapter<Category> _categoryUpdateAdapter;

  final DeletionAdapter<Category> _categoryDeletionAdapter;

  @override
  Future<List<Category>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM Category',
        mapper: (Map<String, Object?> row) => Category(row['name'] as String,
            id: row['id'] as int?, createTime: row['createTime'] as int));
  }

  @override
  Stream<Category?> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Category WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Category(row['name'] as String,
            id: row['id'] as int?, createTime: row['createTime'] as int),
        arguments: [id],
        queryableName: 'Category',
        isView: false);
  }

  @override
  Future<int> add(Category cat) {
    return _categoryInsertionAdapter.insertAndReturnId(
        cat, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> adds(List<Category> cats) {
    return _categoryInsertionAdapter.insertListAndReturnIds(
        cats, OnConflictStrategy.abort);
  }

  @override
  Future<int> save(Category cat) {
    return _categoryUpdateAdapter.updateAndReturnChangedRows(
        cat, OnConflictStrategy.abort);
  }

  @override
  Future<int> saves(List<Category> cats) {
    return _categoryUpdateAdapter.updateListAndReturnChangedRows(
        cats, OnConflictStrategy.abort);
  }

  @override
  Future<int> remove(Category cat) {
    return _categoryDeletionAdapter.deleteAndReturnChangedRows(cat);
  }
}

class _$ItemDao extends ItemDao {
  _$ItemDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _itemInsertionAdapter = InsertionAdapter(
            database,
            'Item',
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'catId': item.catId,
                  'price': item.price,
                  'count': item.count,
                  'createTime': item.createTime,
                  'widget': item.widget,
                  'content': item.content
                },
            changeListener),
        _itemUpdateAdapter = UpdateAdapter(
            database,
            'Item',
            ['id'],
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'catId': item.catId,
                  'price': item.price,
                  'count': item.count,
                  'createTime': item.createTime,
                  'widget': item.widget,
                  'content': item.content
                },
            changeListener),
        _itemDeletionAdapter = DeletionAdapter(
            database,
            'Item',
            ['id'],
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'catId': item.catId,
                  'price': item.price,
                  'count': item.count,
                  'createTime': item.createTime,
                  'widget': item.widget,
                  'content': item.content
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Item> _itemInsertionAdapter;

  final UpdateAdapter<Item> _itemUpdateAdapter;

  final DeletionAdapter<Item> _itemDeletionAdapter;

  @override
  Future<List<Item>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM Item',
        mapper: (Map<String, Object?> row) => Item(
            row['title'] as String, row['catId'] as int, row['price'] as double,
            count: row['count'] as int,
            id: row['id'] as int?,
            widget: row['widget'] as String,
            content: row['content'] as String,
            createTime: row['createTime'] as int));
  }

  @override
  Stream<Item?> findById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Item WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Item(
            row['title'] as String, row['catId'] as int, row['price'] as double,
            count: row['count'] as int,
            id: row['id'] as int?,
            widget: row['widget'] as String,
            content: row['content'] as String,
            createTime: row['createTime'] as int),
        arguments: [id],
        queryableName: 'Item',
        isView: false);
  }

  @override
  Future<int> add(Item item) {
    return _itemInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> adds(List<Item> items) {
    return _itemInsertionAdapter.insertListAndReturnIds(
        items, OnConflictStrategy.abort);
  }

  @override
  Future<int> save(Item item) {
    return _itemUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> saves(List<Item> items) {
    return _itemUpdateAdapter.updateListAndReturnChangedRows(
        items, OnConflictStrategy.abort);
  }

  @override
  Future<int> remove(Item item) {
    return _itemDeletionAdapter.deleteAndReturnChangedRows(item);
  }
}
