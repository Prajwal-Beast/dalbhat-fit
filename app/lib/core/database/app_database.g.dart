// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalFoodLogsTable extends LocalFoodLogs
    with TableInfo<$LocalFoodLogsTable, LocalFoodLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalFoodLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _portionIdMeta = const VerificationMeta(
    'portionId',
  );
  @override
  late final GeneratedColumn<String> portionId = GeneratedColumn<String>(
    'portion_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _caloriesConfirmedMeta = const VerificationMeta(
    'caloriesConfirmed',
  );
  @override
  late final GeneratedColumn<double> caloriesConfirmed =
      GeneratedColumn<double>(
        'calories_confirmed',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
    'fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<String> loggedAt = GeneratedColumn<String>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedViaMeta = const VerificationMeta(
    'loggedVia',
  );
  @override
  late final GeneratedColumn<String> loggedVia = GeneratedColumn<String>(
    'logged_via',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodNameMeta = const VerificationMeta(
    'foodName',
  );
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
    'food_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foodNameNeMeta = const VerificationMeta(
    'foodNameNe',
  );
  @override
  late final GeneratedColumn<String> foodNameNe = GeneratedColumn<String>(
    'food_name_ne',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _portionLabelMeta = const VerificationMeta(
    'portionLabel',
  );
  @override
  late final GeneratedColumn<String> portionLabel = GeneratedColumn<String>(
    'portion_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    foodId,
    portionId,
    quantity,
    caloriesConfirmed,
    proteinG,
    carbsG,
    fatG,
    mealType,
    loggedAt,
    loggedVia,
    foodName,
    foodNameNe,
    portionLabel,
    synced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_food_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalFoodLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    }
    if (data.containsKey('portion_id')) {
      context.handle(
        _portionIdMeta,
        portionId.isAcceptableOrUnknown(data['portion_id']!, _portionIdMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('calories_confirmed')) {
      context.handle(
        _caloriesConfirmedMeta,
        caloriesConfirmed.isAcceptableOrUnknown(
          data['calories_confirmed']!,
          _caloriesConfirmedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesConfirmedMeta);
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinGMeta);
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsGMeta);
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    } else if (isInserting) {
      context.missing(_fatGMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('logged_via')) {
      context.handle(
        _loggedViaMeta,
        loggedVia.isAcceptableOrUnknown(data['logged_via']!, _loggedViaMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedViaMeta);
    }
    if (data.containsKey('food_name')) {
      context.handle(
        _foodNameMeta,
        foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta),
      );
    }
    if (data.containsKey('food_name_ne')) {
      context.handle(
        _foodNameNeMeta,
        foodNameNe.isAcceptableOrUnknown(
          data['food_name_ne']!,
          _foodNameNeMeta,
        ),
      );
    }
    if (data.containsKey('portion_label')) {
      context.handle(
        _portionLabelMeta,
        portionLabel.isAcceptableOrUnknown(
          data['portion_label']!,
          _portionLabelMeta,
        ),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalFoodLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalFoodLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      ),
      portionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}portion_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      caloriesConfirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_confirmed'],
      )!,
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      )!,
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_g'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logged_at'],
      )!,
      loggedVia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logged_via'],
      )!,
      foodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name'],
      ),
      foodNameNe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name_ne'],
      ),
      portionLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}portion_label'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalFoodLogsTable createAlias(String alias) {
    return $LocalFoodLogsTable(attachedDatabase, alias);
  }
}

class LocalFoodLog extends DataClass implements Insertable<LocalFoodLog> {
  final String id;
  final String userId;
  final String? foodId;
  final String? portionId;
  final double quantity;
  final double caloriesConfirmed;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final String mealType;
  final String loggedAt;
  final String loggedVia;
  final String? foodName;
  final String? foodNameNe;
  final String? portionLabel;

  /// false = not yet pushed to Supabase; true = synced.
  final bool synced;
  final DateTime createdAt;
  const LocalFoodLog({
    required this.id,
    required this.userId,
    this.foodId,
    this.portionId,
    required this.quantity,
    required this.caloriesConfirmed,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.mealType,
    required this.loggedAt,
    required this.loggedVia,
    this.foodName,
    this.foodNameNe,
    this.portionLabel,
    required this.synced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || foodId != null) {
      map['food_id'] = Variable<String>(foodId);
    }
    if (!nullToAbsent || portionId != null) {
      map['portion_id'] = Variable<String>(portionId);
    }
    map['quantity'] = Variable<double>(quantity);
    map['calories_confirmed'] = Variable<double>(caloriesConfirmed);
    map['protein_g'] = Variable<double>(proteinG);
    map['carbs_g'] = Variable<double>(carbsG);
    map['fat_g'] = Variable<double>(fatG);
    map['meal_type'] = Variable<String>(mealType);
    map['logged_at'] = Variable<String>(loggedAt);
    map['logged_via'] = Variable<String>(loggedVia);
    if (!nullToAbsent || foodName != null) {
      map['food_name'] = Variable<String>(foodName);
    }
    if (!nullToAbsent || foodNameNe != null) {
      map['food_name_ne'] = Variable<String>(foodNameNe);
    }
    if (!nullToAbsent || portionLabel != null) {
      map['portion_label'] = Variable<String>(portionLabel);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalFoodLogsCompanion toCompanion(bool nullToAbsent) {
    return LocalFoodLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      foodId: foodId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodId),
      portionId: portionId == null && nullToAbsent
          ? const Value.absent()
          : Value(portionId),
      quantity: Value(quantity),
      caloriesConfirmed: Value(caloriesConfirmed),
      proteinG: Value(proteinG),
      carbsG: Value(carbsG),
      fatG: Value(fatG),
      mealType: Value(mealType),
      loggedAt: Value(loggedAt),
      loggedVia: Value(loggedVia),
      foodName: foodName == null && nullToAbsent
          ? const Value.absent()
          : Value(foodName),
      foodNameNe: foodNameNe == null && nullToAbsent
          ? const Value.absent()
          : Value(foodNameNe),
      portionLabel: portionLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(portionLabel),
      synced: Value(synced),
      createdAt: Value(createdAt),
    );
  }

  factory LocalFoodLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalFoodLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      foodId: serializer.fromJson<String?>(json['foodId']),
      portionId: serializer.fromJson<String?>(json['portionId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      caloriesConfirmed: serializer.fromJson<double>(json['caloriesConfirmed']),
      proteinG: serializer.fromJson<double>(json['proteinG']),
      carbsG: serializer.fromJson<double>(json['carbsG']),
      fatG: serializer.fromJson<double>(json['fatG']),
      mealType: serializer.fromJson<String>(json['mealType']),
      loggedAt: serializer.fromJson<String>(json['loggedAt']),
      loggedVia: serializer.fromJson<String>(json['loggedVia']),
      foodName: serializer.fromJson<String?>(json['foodName']),
      foodNameNe: serializer.fromJson<String?>(json['foodNameNe']),
      portionLabel: serializer.fromJson<String?>(json['portionLabel']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'foodId': serializer.toJson<String?>(foodId),
      'portionId': serializer.toJson<String?>(portionId),
      'quantity': serializer.toJson<double>(quantity),
      'caloriesConfirmed': serializer.toJson<double>(caloriesConfirmed),
      'proteinG': serializer.toJson<double>(proteinG),
      'carbsG': serializer.toJson<double>(carbsG),
      'fatG': serializer.toJson<double>(fatG),
      'mealType': serializer.toJson<String>(mealType),
      'loggedAt': serializer.toJson<String>(loggedAt),
      'loggedVia': serializer.toJson<String>(loggedVia),
      'foodName': serializer.toJson<String?>(foodName),
      'foodNameNe': serializer.toJson<String?>(foodNameNe),
      'portionLabel': serializer.toJson<String?>(portionLabel),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalFoodLog copyWith({
    String? id,
    String? userId,
    Value<String?> foodId = const Value.absent(),
    Value<String?> portionId = const Value.absent(),
    double? quantity,
    double? caloriesConfirmed,
    double? proteinG,
    double? carbsG,
    double? fatG,
    String? mealType,
    String? loggedAt,
    String? loggedVia,
    Value<String?> foodName = const Value.absent(),
    Value<String?> foodNameNe = const Value.absent(),
    Value<String?> portionLabel = const Value.absent(),
    bool? synced,
    DateTime? createdAt,
  }) => LocalFoodLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    foodId: foodId.present ? foodId.value : this.foodId,
    portionId: portionId.present ? portionId.value : this.portionId,
    quantity: quantity ?? this.quantity,
    caloriesConfirmed: caloriesConfirmed ?? this.caloriesConfirmed,
    proteinG: proteinG ?? this.proteinG,
    carbsG: carbsG ?? this.carbsG,
    fatG: fatG ?? this.fatG,
    mealType: mealType ?? this.mealType,
    loggedAt: loggedAt ?? this.loggedAt,
    loggedVia: loggedVia ?? this.loggedVia,
    foodName: foodName.present ? foodName.value : this.foodName,
    foodNameNe: foodNameNe.present ? foodNameNe.value : this.foodNameNe,
    portionLabel: portionLabel.present ? portionLabel.value : this.portionLabel,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalFoodLog copyWithCompanion(LocalFoodLogsCompanion data) {
    return LocalFoodLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      portionId: data.portionId.present ? data.portionId.value : this.portionId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      caloriesConfirmed: data.caloriesConfirmed.present
          ? data.caloriesConfirmed.value
          : this.caloriesConfirmed,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      loggedVia: data.loggedVia.present ? data.loggedVia.value : this.loggedVia,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      foodNameNe: data.foodNameNe.present
          ? data.foodNameNe.value
          : this.foodNameNe,
      portionLabel: data.portionLabel.present
          ? data.portionLabel.value
          : this.portionLabel,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalFoodLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('foodId: $foodId, ')
          ..write('portionId: $portionId, ')
          ..write('quantity: $quantity, ')
          ..write('caloriesConfirmed: $caloriesConfirmed, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('mealType: $mealType, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('loggedVia: $loggedVia, ')
          ..write('foodName: $foodName, ')
          ..write('foodNameNe: $foodNameNe, ')
          ..write('portionLabel: $portionLabel, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    foodId,
    portionId,
    quantity,
    caloriesConfirmed,
    proteinG,
    carbsG,
    fatG,
    mealType,
    loggedAt,
    loggedVia,
    foodName,
    foodNameNe,
    portionLabel,
    synced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalFoodLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.foodId == this.foodId &&
          other.portionId == this.portionId &&
          other.quantity == this.quantity &&
          other.caloriesConfirmed == this.caloriesConfirmed &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.mealType == this.mealType &&
          other.loggedAt == this.loggedAt &&
          other.loggedVia == this.loggedVia &&
          other.foodName == this.foodName &&
          other.foodNameNe == this.foodNameNe &&
          other.portionLabel == this.portionLabel &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt);
}

class LocalFoodLogsCompanion extends UpdateCompanion<LocalFoodLog> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> foodId;
  final Value<String?> portionId;
  final Value<double> quantity;
  final Value<double> caloriesConfirmed;
  final Value<double> proteinG;
  final Value<double> carbsG;
  final Value<double> fatG;
  final Value<String> mealType;
  final Value<String> loggedAt;
  final Value<String> loggedVia;
  final Value<String?> foodName;
  final Value<String?> foodNameNe;
  final Value<String?> portionLabel;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalFoodLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.foodId = const Value.absent(),
    this.portionId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.caloriesConfirmed = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.mealType = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.loggedVia = const Value.absent(),
    this.foodName = const Value.absent(),
    this.foodNameNe = const Value.absent(),
    this.portionLabel = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalFoodLogsCompanion.insert({
    required String id,
    required String userId,
    this.foodId = const Value.absent(),
    this.portionId = const Value.absent(),
    this.quantity = const Value.absent(),
    required double caloriesConfirmed,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required String mealType,
    required String loggedAt,
    required String loggedVia,
    this.foodName = const Value.absent(),
    this.foodNameNe = const Value.absent(),
    this.portionLabel = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       caloriesConfirmed = Value(caloriesConfirmed),
       proteinG = Value(proteinG),
       carbsG = Value(carbsG),
       fatG = Value(fatG),
       mealType = Value(mealType),
       loggedAt = Value(loggedAt),
       loggedVia = Value(loggedVia);
  static Insertable<LocalFoodLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? foodId,
    Expression<String>? portionId,
    Expression<double>? quantity,
    Expression<double>? caloriesConfirmed,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatG,
    Expression<String>? mealType,
    Expression<String>? loggedAt,
    Expression<String>? loggedVia,
    Expression<String>? foodName,
    Expression<String>? foodNameNe,
    Expression<String>? portionLabel,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (foodId != null) 'food_id': foodId,
      if (portionId != null) 'portion_id': portionId,
      if (quantity != null) 'quantity': quantity,
      if (caloriesConfirmed != null) 'calories_confirmed': caloriesConfirmed,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (mealType != null) 'meal_type': mealType,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (loggedVia != null) 'logged_via': loggedVia,
      if (foodName != null) 'food_name': foodName,
      if (foodNameNe != null) 'food_name_ne': foodNameNe,
      if (portionLabel != null) 'portion_label': portionLabel,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalFoodLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? foodId,
    Value<String?>? portionId,
    Value<double>? quantity,
    Value<double>? caloriesConfirmed,
    Value<double>? proteinG,
    Value<double>? carbsG,
    Value<double>? fatG,
    Value<String>? mealType,
    Value<String>? loggedAt,
    Value<String>? loggedVia,
    Value<String?>? foodName,
    Value<String?>? foodNameNe,
    Value<String?>? portionLabel,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalFoodLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      foodId: foodId ?? this.foodId,
      portionId: portionId ?? this.portionId,
      quantity: quantity ?? this.quantity,
      caloriesConfirmed: caloriesConfirmed ?? this.caloriesConfirmed,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      mealType: mealType ?? this.mealType,
      loggedAt: loggedAt ?? this.loggedAt,
      loggedVia: loggedVia ?? this.loggedVia,
      foodName: foodName ?? this.foodName,
      foodNameNe: foodNameNe ?? this.foodNameNe,
      portionLabel: portionLabel ?? this.portionLabel,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (portionId.present) {
      map['portion_id'] = Variable<String>(portionId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (caloriesConfirmed.present) {
      map['calories_confirmed'] = Variable<double>(caloriesConfirmed.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<String>(loggedAt.value);
    }
    if (loggedVia.present) {
      map['logged_via'] = Variable<String>(loggedVia.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (foodNameNe.present) {
      map['food_name_ne'] = Variable<String>(foodNameNe.value);
    }
    if (portionLabel.present) {
      map['portion_label'] = Variable<String>(portionLabel.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalFoodLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('foodId: $foodId, ')
          ..write('portionId: $portionId, ')
          ..write('quantity: $quantity, ')
          ..write('caloriesConfirmed: $caloriesConfirmed, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('mealType: $mealType, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('loggedVia: $loggedVia, ')
          ..write('foodName: $foodName, ')
          ..write('foodNameNe: $foodNameNe, ')
          ..write('portionLabel: $portionLabel, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalWeightLogsTable extends LocalWeightLogs
    with TableInfo<$LocalWeightLogsTable, LocalWeightLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalWeightLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<String> loggedAt = GeneratedColumn<String>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    weightKg,
    loggedAt,
    notes,
    synced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_weight_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalWeightLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalWeightLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalWeightLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logged_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalWeightLogsTable createAlias(String alias) {
    return $LocalWeightLogsTable(attachedDatabase, alias);
  }
}

class LocalWeightLog extends DataClass implements Insertable<LocalWeightLog> {
  final String id;
  final String userId;
  final double weightKg;
  final String loggedAt;
  final String? notes;
  final bool synced;
  final DateTime createdAt;
  const LocalWeightLog({
    required this.id,
    required this.userId,
    required this.weightKg,
    required this.loggedAt,
    this.notes,
    required this.synced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['weight_kg'] = Variable<double>(weightKg);
    map['logged_at'] = Variable<String>(loggedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalWeightLogsCompanion toCompanion(bool nullToAbsent) {
    return LocalWeightLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      weightKg: Value(weightKg),
      loggedAt: Value(loggedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      synced: Value(synced),
      createdAt: Value(createdAt),
    );
  }

  factory LocalWeightLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWeightLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      loggedAt: serializer.fromJson<String>(json['loggedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'weightKg': serializer.toJson<double>(weightKg),
      'loggedAt': serializer.toJson<String>(loggedAt),
      'notes': serializer.toJson<String?>(notes),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalWeightLog copyWith({
    String? id,
    String? userId,
    double? weightKg,
    String? loggedAt,
    Value<String?> notes = const Value.absent(),
    bool? synced,
    DateTime? createdAt,
  }) => LocalWeightLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    weightKg: weightKg ?? this.weightKg,
    loggedAt: loggedAt ?? this.loggedAt,
    notes: notes.present ? notes.value : this.notes,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalWeightLog copyWithCompanion(LocalWeightLogsCompanion data) {
    return LocalWeightLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWeightLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('weightKg: $weightKg, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('notes: $notes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, weightKg, loggedAt, notes, synced, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalWeightLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.weightKg == this.weightKg &&
          other.loggedAt == this.loggedAt &&
          other.notes == this.notes &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt);
}

class LocalWeightLogsCompanion extends UpdateCompanion<LocalWeightLog> {
  final Value<String> id;
  final Value<String> userId;
  final Value<double> weightKg;
  final Value<String> loggedAt;
  final Value<String?> notes;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalWeightLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWeightLogsCompanion.insert({
    required String id,
    required String userId,
    required double weightKg,
    required String loggedAt,
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       weightKg = Value(weightKg),
       loggedAt = Value(loggedAt);
  static Insertable<LocalWeightLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<double>? weightKg,
    Expression<String>? loggedAt,
    Expression<String>? notes,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (weightKg != null) 'weight_kg': weightKg,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (notes != null) 'notes': notes,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWeightLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<double>? weightKg,
    Value<String>? loggedAt,
    Value<String?>? notes,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalWeightLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weightKg: weightKg ?? this.weightKg,
      loggedAt: loggedAt ?? this.loggedAt,
      notes: notes ?? this.notes,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<String>(loggedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalWeightLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('weightKg: $weightKg, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('notes: $notes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueEntriesTable extends SyncQueueEntries
    with TableInfo<$SyncQueueEntriesTable, SyncQueueEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retriesMeta = const VerificationMeta(
    'retries',
  );
  @override
  late final GeneratedColumn<int> retries = GeneratedColumn<int>(
    'retries',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetTable,
    operation,
    localId,
    retries,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('retries')) {
      context.handle(
        _retriesMeta,
        retries.isAcceptableOrUnknown(data['retries']!, _retriesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      retries: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retries'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncQueueEntriesTable createAlias(String alias) {
    return $SyncQueueEntriesTable(attachedDatabase, alias);
  }
}

class SyncQueueEntry extends DataClass implements Insertable<SyncQueueEntry> {
  final int id;

  /// 'food_logs' | 'weight_logs'
  final String targetTable;

  /// 'insert' | 'delete'
  final String operation;

  /// Matches the local UUID in LocalFoodLogs or LocalWeightLogs.
  final String localId;
  final int retries;
  final DateTime createdAt;
  const SyncQueueEntry({
    required this.id,
    required this.targetTable,
    required this.operation,
    required this.localId,
    required this.retries,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_table'] = Variable<String>(targetTable);
    map['operation'] = Variable<String>(operation);
    map['local_id'] = Variable<String>(localId);
    map['retries'] = Variable<int>(retries);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueEntriesCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueEntriesCompanion(
      id: Value(id),
      targetTable: Value(targetTable),
      operation: Value(operation),
      localId: Value(localId),
      retries: Value(retries),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueEntry(
      id: serializer.fromJson<int>(json['id']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      operation: serializer.fromJson<String>(json['operation']),
      localId: serializer.fromJson<String>(json['localId']),
      retries: serializer.fromJson<int>(json['retries']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetTable': serializer.toJson<String>(targetTable),
      'operation': serializer.toJson<String>(operation),
      'localId': serializer.toJson<String>(localId),
      'retries': serializer.toJson<int>(retries),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueEntry copyWith({
    int? id,
    String? targetTable,
    String? operation,
    String? localId,
    int? retries,
    DateTime? createdAt,
  }) => SyncQueueEntry(
    id: id ?? this.id,
    targetTable: targetTable ?? this.targetTable,
    operation: operation ?? this.operation,
    localId: localId ?? this.localId,
    retries: retries ?? this.retries,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncQueueEntry copyWithCompanion(SyncQueueEntriesCompanion data) {
    return SyncQueueEntry(
      id: data.id.present ? data.id.value : this.id,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      operation: data.operation.present ? data.operation.value : this.operation,
      localId: data.localId.present ? data.localId.value : this.localId,
      retries: data.retries.present ? data.retries.value : this.retries,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueEntry(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('operation: $operation, ')
          ..write('localId: $localId, ')
          ..write('retries: $retries, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, targetTable, operation, localId, retries, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueEntry &&
          other.id == this.id &&
          other.targetTable == this.targetTable &&
          other.operation == this.operation &&
          other.localId == this.localId &&
          other.retries == this.retries &&
          other.createdAt == this.createdAt);
}

class SyncQueueEntriesCompanion extends UpdateCompanion<SyncQueueEntry> {
  final Value<int> id;
  final Value<String> targetTable;
  final Value<String> operation;
  final Value<String> localId;
  final Value<int> retries;
  final Value<DateTime> createdAt;
  const SyncQueueEntriesCompanion({
    this.id = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.operation = const Value.absent(),
    this.localId = const Value.absent(),
    this.retries = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String targetTable,
    required String operation,
    required String localId,
    this.retries = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : targetTable = Value(targetTable),
       operation = Value(operation),
       localId = Value(localId);
  static Insertable<SyncQueueEntry> custom({
    Expression<int>? id,
    Expression<String>? targetTable,
    Expression<String>? operation,
    Expression<String>? localId,
    Expression<int>? retries,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetTable != null) 'target_table': targetTable,
      if (operation != null) 'operation': operation,
      if (localId != null) 'local_id': localId,
      if (retries != null) 'retries': retries,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? targetTable,
    Value<String>? operation,
    Value<String>? localId,
    Value<int>? retries,
    Value<DateTime>? createdAt,
  }) {
    return SyncQueueEntriesCompanion(
      id: id ?? this.id,
      targetTable: targetTable ?? this.targetTable,
      operation: operation ?? this.operation,
      localId: localId ?? this.localId,
      retries: retries ?? this.retries,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (retries.present) {
      map['retries'] = Variable<int>(retries.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueEntriesCompanion(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('operation: $operation, ')
          ..write('localId: $localId, ')
          ..write('retries: $retries, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalFoodLogsTable localFoodLogs = $LocalFoodLogsTable(this);
  late final $LocalWeightLogsTable localWeightLogs = $LocalWeightLogsTable(
    this,
  );
  late final $SyncQueueEntriesTable syncQueueEntries = $SyncQueueEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localFoodLogs,
    localWeightLogs,
    syncQueueEntries,
  ];
}

typedef $$LocalFoodLogsTableCreateCompanionBuilder =
    LocalFoodLogsCompanion Function({
      required String id,
      required String userId,
      Value<String?> foodId,
      Value<String?> portionId,
      Value<double> quantity,
      required double caloriesConfirmed,
      required double proteinG,
      required double carbsG,
      required double fatG,
      required String mealType,
      required String loggedAt,
      required String loggedVia,
      Value<String?> foodName,
      Value<String?> foodNameNe,
      Value<String?> portionLabel,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$LocalFoodLogsTableUpdateCompanionBuilder =
    LocalFoodLogsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String?> foodId,
      Value<String?> portionId,
      Value<double> quantity,
      Value<double> caloriesConfirmed,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatG,
      Value<String> mealType,
      Value<String> loggedAt,
      Value<String> loggedVia,
      Value<String?> foodName,
      Value<String?> foodNameNe,
      Value<String?> portionLabel,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalFoodLogsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalFoodLogsTable> {
  $$LocalFoodLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portionId => $composableBuilder(
    column: $table.portionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesConfirmed => $composableBuilder(
    column: $table.caloriesConfirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggedVia => $composableBuilder(
    column: $table.loggedVia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodNameNe => $composableBuilder(
    column: $table.foodNameNe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portionLabel => $composableBuilder(
    column: $table.portionLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalFoodLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalFoodLogsTable> {
  $$LocalFoodLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portionId => $composableBuilder(
    column: $table.portionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesConfirmed => $composableBuilder(
    column: $table.caloriesConfirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggedVia => $composableBuilder(
    column: $table.loggedVia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodNameNe => $composableBuilder(
    column: $table.foodNameNe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portionLabel => $composableBuilder(
    column: $table.portionLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalFoodLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalFoodLogsTable> {
  $$LocalFoodLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get portionId =>
      $composableBuilder(column: $table.portionId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get caloriesConfirmed => $composableBuilder(
    column: $table.caloriesConfirmed,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<String> get loggedVia =>
      $composableBuilder(column: $table.loggedVia, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<String> get foodNameNe => $composableBuilder(
    column: $table.foodNameNe,
    builder: (column) => column,
  );

  GeneratedColumn<String> get portionLabel => $composableBuilder(
    column: $table.portionLabel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalFoodLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalFoodLogsTable,
          LocalFoodLog,
          $$LocalFoodLogsTableFilterComposer,
          $$LocalFoodLogsTableOrderingComposer,
          $$LocalFoodLogsTableAnnotationComposer,
          $$LocalFoodLogsTableCreateCompanionBuilder,
          $$LocalFoodLogsTableUpdateCompanionBuilder,
          (
            LocalFoodLog,
            BaseReferences<_$AppDatabase, $LocalFoodLogsTable, LocalFoodLog>,
          ),
          LocalFoodLog,
          PrefetchHooks Function()
        > {
  $$LocalFoodLogsTableTableManager(_$AppDatabase db, $LocalFoodLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalFoodLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalFoodLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalFoodLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> foodId = const Value.absent(),
                Value<String?> portionId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> caloriesConfirmed = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatG = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<String> loggedAt = const Value.absent(),
                Value<String> loggedVia = const Value.absent(),
                Value<String?> foodName = const Value.absent(),
                Value<String?> foodNameNe = const Value.absent(),
                Value<String?> portionLabel = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFoodLogsCompanion(
                id: id,
                userId: userId,
                foodId: foodId,
                portionId: portionId,
                quantity: quantity,
                caloriesConfirmed: caloriesConfirmed,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                mealType: mealType,
                loggedAt: loggedAt,
                loggedVia: loggedVia,
                foodName: foodName,
                foodNameNe: foodNameNe,
                portionLabel: portionLabel,
                synced: synced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String?> foodId = const Value.absent(),
                Value<String?> portionId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                required double caloriesConfirmed,
                required double proteinG,
                required double carbsG,
                required double fatG,
                required String mealType,
                required String loggedAt,
                required String loggedVia,
                Value<String?> foodName = const Value.absent(),
                Value<String?> foodNameNe = const Value.absent(),
                Value<String?> portionLabel = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFoodLogsCompanion.insert(
                id: id,
                userId: userId,
                foodId: foodId,
                portionId: portionId,
                quantity: quantity,
                caloriesConfirmed: caloriesConfirmed,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                mealType: mealType,
                loggedAt: loggedAt,
                loggedVia: loggedVia,
                foodName: foodName,
                foodNameNe: foodNameNe,
                portionLabel: portionLabel,
                synced: synced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalFoodLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalFoodLogsTable,
      LocalFoodLog,
      $$LocalFoodLogsTableFilterComposer,
      $$LocalFoodLogsTableOrderingComposer,
      $$LocalFoodLogsTableAnnotationComposer,
      $$LocalFoodLogsTableCreateCompanionBuilder,
      $$LocalFoodLogsTableUpdateCompanionBuilder,
      (
        LocalFoodLog,
        BaseReferences<_$AppDatabase, $LocalFoodLogsTable, LocalFoodLog>,
      ),
      LocalFoodLog,
      PrefetchHooks Function()
    >;
typedef $$LocalWeightLogsTableCreateCompanionBuilder =
    LocalWeightLogsCompanion Function({
      required String id,
      required String userId,
      required double weightKg,
      required String loggedAt,
      Value<String?> notes,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$LocalWeightLogsTableUpdateCompanionBuilder =
    LocalWeightLogsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<double> weightKg,
      Value<String> loggedAt,
      Value<String?> notes,
      Value<bool> synced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalWeightLogsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalWeightLogsTable> {
  $$LocalWeightLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalWeightLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalWeightLogsTable> {
  $$LocalWeightLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalWeightLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalWeightLogsTable> {
  $$LocalWeightLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalWeightLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalWeightLogsTable,
          LocalWeightLog,
          $$LocalWeightLogsTableFilterComposer,
          $$LocalWeightLogsTableOrderingComposer,
          $$LocalWeightLogsTableAnnotationComposer,
          $$LocalWeightLogsTableCreateCompanionBuilder,
          $$LocalWeightLogsTableUpdateCompanionBuilder,
          (
            LocalWeightLog,
            BaseReferences<
              _$AppDatabase,
              $LocalWeightLogsTable,
              LocalWeightLog
            >,
          ),
          LocalWeightLog,
          PrefetchHooks Function()
        > {
  $$LocalWeightLogsTableTableManager(
    _$AppDatabase db,
    $LocalWeightLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalWeightLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalWeightLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalWeightLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<String> loggedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWeightLogsCompanion(
                id: id,
                userId: userId,
                weightKg: weightKg,
                loggedAt: loggedAt,
                notes: notes,
                synced: synced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required double weightKg,
                required String loggedAt,
                Value<String?> notes = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWeightLogsCompanion.insert(
                id: id,
                userId: userId,
                weightKg: weightKg,
                loggedAt: loggedAt,
                notes: notes,
                synced: synced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalWeightLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalWeightLogsTable,
      LocalWeightLog,
      $$LocalWeightLogsTableFilterComposer,
      $$LocalWeightLogsTableOrderingComposer,
      $$LocalWeightLogsTableAnnotationComposer,
      $$LocalWeightLogsTableCreateCompanionBuilder,
      $$LocalWeightLogsTableUpdateCompanionBuilder,
      (
        LocalWeightLog,
        BaseReferences<_$AppDatabase, $LocalWeightLogsTable, LocalWeightLog>,
      ),
      LocalWeightLog,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueEntriesTableCreateCompanionBuilder =
    SyncQueueEntriesCompanion Function({
      Value<int> id,
      required String targetTable,
      required String operation,
      required String localId,
      Value<int> retries,
      Value<DateTime> createdAt,
    });
typedef $$SyncQueueEntriesTableUpdateCompanionBuilder =
    SyncQueueEntriesCompanion Function({
      Value<int> id,
      Value<String> targetTable,
      Value<String> operation,
      Value<String> localId,
      Value<int> retries,
      Value<DateTime> createdAt,
    });

class $$SyncQueueEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueEntriesTable> {
  $$SyncQueueEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retries => $composableBuilder(
    column: $table.retries,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueEntriesTable> {
  $$SyncQueueEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retries => $composableBuilder(
    column: $table.retries,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueEntriesTable> {
  $$SyncQueueEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<int> get retries =>
      $composableBuilder(column: $table.retries, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueEntriesTable,
          SyncQueueEntry,
          $$SyncQueueEntriesTableFilterComposer,
          $$SyncQueueEntriesTableOrderingComposer,
          $$SyncQueueEntriesTableAnnotationComposer,
          $$SyncQueueEntriesTableCreateCompanionBuilder,
          $$SyncQueueEntriesTableUpdateCompanionBuilder,
          (
            SyncQueueEntry,
            BaseReferences<
              _$AppDatabase,
              $SyncQueueEntriesTable,
              SyncQueueEntry
            >,
          ),
          SyncQueueEntry,
          PrefetchHooks Function()
        > {
  $$SyncQueueEntriesTableTableManager(
    _$AppDatabase db,
    $SyncQueueEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<int> retries = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncQueueEntriesCompanion(
                id: id,
                targetTable: targetTable,
                operation: operation,
                localId: localId,
                retries: retries,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String targetTable,
                required String operation,
                required String localId,
                Value<int> retries = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncQueueEntriesCompanion.insert(
                id: id,
                targetTable: targetTable,
                operation: operation,
                localId: localId,
                retries: retries,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueEntriesTable,
      SyncQueueEntry,
      $$SyncQueueEntriesTableFilterComposer,
      $$SyncQueueEntriesTableOrderingComposer,
      $$SyncQueueEntriesTableAnnotationComposer,
      $$SyncQueueEntriesTableCreateCompanionBuilder,
      $$SyncQueueEntriesTableUpdateCompanionBuilder,
      (
        SyncQueueEntry,
        BaseReferences<_$AppDatabase, $SyncQueueEntriesTable, SyncQueueEntry>,
      ),
      SyncQueueEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalFoodLogsTableTableManager get localFoodLogs =>
      $$LocalFoodLogsTableTableManager(_db, _db.localFoodLogs);
  $$LocalWeightLogsTableTableManager get localWeightLogs =>
      $$LocalWeightLogsTableTableManager(_db, _db.localWeightLogs);
  $$SyncQueueEntriesTableTableManager get syncQueueEntries =>
      $$SyncQueueEntriesTableTableManager(_db, _db.syncQueueEntries);
}
