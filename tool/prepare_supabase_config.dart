import 'dart:convert';
import 'dart:io';

void main() {
  final File source = File('supabase.env');
  if (!source.existsSync()) {
    stderr.writeln(
      'supabase.env bulunamadı. Yerel Supabase URL ve publishable/anon '
      'anahtarını supabase.env içine ekleyin.',
    );
    exitCode = 64;
    return;
  }

  final Map<String, String> values = <String, String>{};
  for (final String rawLine in source.readAsLinesSync()) {
    final String line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) continue;

    final int separator = line.indexOf('=');
    if (separator <= 0) continue;

    final String key = line.substring(0, separator).trim();
    String value = line.substring(separator + 1).trim();
    if (value.length >= 2 &&
        ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'")))) {
      value = value.substring(1, value.length - 1);
    }
    values[key] = value;
  }

  final String? url = values['SUPABASE_URL'];
  final String? key =
      values['SUPABASE_PUBLISHABLE_KEY'] ?? values['SUPABASE_ANON_KEY'];
  if (url == null ||
      url.isEmpty ||
      key == null ||
      key.isEmpty ||
      key == 'sb_publishable_replace_me') {
    stderr.writeln(
      'supabase.env içinde geçerli SUPABASE_URL ve '
      'SUPABASE_PUBLISHABLE_KEY veya SUPABASE_ANON_KEY bulunamadı.',
    );
    exitCode = 64;
    return;
  }

  final File destination = File('tool/config/supabase.local.json');
  destination.parent.createSync(recursive: true);
  final String encoded = const JsonEncoder.withIndent('  ').convert(
    <String, String>{'SUPABASE_URL': url, 'SUPABASE_PUBLISHABLE_KEY': key},
  );
  destination.writeAsStringSync('$encoded\n');

  stdout.writeln(
    'Yerel Supabase config hazırlandı: ${destination.path} '
    '(anahtar yazdırılmadı).',
  );
}
