class LyricLine {
  final Duration start;
  final Duration end;
  final String text;

  LyricLine(this.start, this.end, this.text);

  LyricLine.simple(this.start, this.text) : end = Duration.zero;

  Duration get duration => end - start;

  @override
  String toString() => '$start -> $end: $text';
}

List<LyricLine> parseVtt(String vttContent) {
  final List<String> lines = vttContent.split('\n');
  final List<LyricLine> result = [];

  // Regex hỗ trợ định dạng HH:MM:SS,mmm hoặc HH:MM:SS.mmm
  final timeRegex = RegExp(
      r'^\s*((?:\d+:)?\d+:\d+)[.,](\d+)\s*-->\s*((?:\d+:)?\d+:\d+)[.,](\d+)'
  );

  bool foundHeader = false;
  int i = 0;

  // Tìm header WEBVTT (bỏ qua BOM nếu có)
  while (i < lines.length) {
    final line = lines[i].trim().replaceAll('\uFEFF', '');
    if (line.startsWith('WEBVTT')) {
      foundHeader = true;
      i++;
      break;
    }
    i++;
  }


  if (!foundHeader) {
    i = 0;
  }


  while (i < lines.length && !timeRegex.hasMatch(lines[i])) {
    i++;
  }

  while (i < lines.length) {
    // Bỏ qua cue identifier nếu là số (ví dụ: 1, 2, 3)
    if (RegExp(r'^\d+$').hasMatch(lines[i].trim())) {
      i++;
      continue;
    }

    final match = timeRegex.firstMatch(lines[i]);

    if (match != null) {
      final startTime = _parseTimeString(match.group(1)!, match.group(2)!);
      final endTime = _parseTimeString(match.group(3)!, match.group(4)!);

      i++;
      String text = "";

      while (i < lines.length &&
          lines[i].trim().isNotEmpty &&
          !timeRegex.hasMatch(lines[i]) &&
          !RegExp(r'^\d+$').hasMatch(lines[i].trim())) {
        if (text.isNotEmpty) {
          text += " ";
        }
        text += lines[i].trim();
        i++;
      }

      if (text.trim().isEmpty) continue;
      if (endTime <= startTime) continue;

      result.add(LyricLine(startTime, endTime, text));
    } else {
      i++;
    }
  }

  result.sort((a, b) => a.start.compareTo(b.start));
  return result;
}

Duration _parseTimeString(String time, String millisStr) {
  final parts = time.split(':');
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  if (parts.length == 3) {
    hours = int.parse(parts[0]);
    minutes = int.parse(parts[1]);
    seconds = int.parse(parts[2]);
  } else if (parts.length == 2) {
    minutes = int.parse(parts[0]);
    seconds = int.parse(parts[1]);
  }

  // Chuẩn hóa milliseconds từ 1-3 chữ số
  int milliseconds = int.parse(millisStr.padRight(3, '0'));

  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    milliseconds: milliseconds,
  );
}
