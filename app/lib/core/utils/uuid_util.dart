/// Returns true if [s] is a canonical UUID (e.g. a real `food_portions.id`).
///
/// Synthesised portion ids like `<food-uuid>_default` are NOT valid UUIDs and
/// must never be sent to a Postgres `uuid` column — doing so throws
/// "invalid input syntax for type uuid" and silently fails sync.
final _uuidRegExp = RegExp(
  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
);

bool isUuid(String? s) => s != null && _uuidRegExp.hasMatch(s);
