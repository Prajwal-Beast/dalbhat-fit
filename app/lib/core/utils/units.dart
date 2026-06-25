/// Weight unit conversion + formatting helpers.
///
/// Weight is always stored in kilograms (Supabase + local DB). These helpers
/// only affect what the user sees / types when the "lbs" preference is on.
const double kgPerLb = 0.45359237;
const double lbPerKg = 2.20462262;

/// Convert a stored kg value into the user's chosen display unit.
double kgToDisplay(double kg, bool useLbs) => useLbs ? kg * lbPerKg : kg;

/// Convert a value the user typed (in their chosen unit) back to kg for storage.
double displayToKg(double value, bool useLbs) =>
    useLbs ? value * kgPerLb : value;

/// The short unit label, e.g. for a `suffixText`.
String weightUnit(bool useLbs) => useLbs ? 'lb' : 'kg';

/// Format a stored kg value for display, e.g. "72.4 kg" or "159.6 lb".
String formatWeight(double kg, bool useLbs, {int decimals = 1}) =>
    '${kgToDisplay(kg, useLbs).toStringAsFixed(decimals)} ${weightUnit(useLbs)}';
