class LyricLine {
  final Duration start;
  final Duration end;
  final String text;

  LyricLine(this.start, this.end, this.text);

  // Constructor với chỉ start và text
  LyricLine.simple(this.start, this.text) : end = Duration.zero;

  // Độ dài của dòng lời bài hát
  Duration get duration => end - start;

  @override
  String toString() => '$start -> $end: $text';
}

List<LyricLine> parseVtt(String vttContent) {
  final List<String> lines = vttContent.split('\n');
  final List<LyricLine> result = [];

  // Regex chính xác hơn cho định dạng VTT
  // Hỗ trợ cả định dạng HH:MM:SS.mmm và MM:SS.mmm
  final timeRegex = RegExp(
      r'((?:\d+:)??\d+:\d+)\.(\d+)\s*-->\s*((?:\d+:)??\d+:\d+)\.(\d+)'
  );

  // Bỏ qua dòng WEBVTT và metadata
  bool foundHeader = false;
  int i = 0;

  // Tìm header WEBVTT
  while (i < lines.length) {
    if (lines[i].trim().startsWith('WEBVTT')) {
      foundHeader = true;
      i++;
      break;
    }
    i++;
  }

  // Nếu không tìm thấy header, quay lại và coi như đây là file VTT đơn giản
  if (!foundHeader) {
    i = 0;
  }

  // Bỏ qua metadata (các dòng trống và không chứa timestamps)
  while (i < lines.length && !timeRegex.hasMatch(lines[i])) {
    i++;
  }

  // Bây giờ bắt đầu xử lý các cue
  while (i < lines.length) {
    final match = timeRegex.firstMatch(lines[i]);

    if (match != null) {
      // Parse thời gian bắt đầu
      final startTime = _parseTimeString(match.group(1)!, match.group(2)!);

      // Parse thời gian kết thúc
      final endTime = _parseTimeString(match.group(3)!, match.group(4)!);

      // Tìm nội dung lời
      i++;
      String text = "";

      // Thu thập tất cả dòng cho đến khi gặp dòng trống hoặc dòng thời gian tiếp theo
      while (i < lines.length &&
          lines[i].trim().isNotEmpty &&
          !timeRegex.hasMatch(lines[i])) {
        if (text.isNotEmpty) {
          text += " ";
        }
        text += lines[i].trim();
        i++;
      }

      if (text.isNotEmpty) {
        result.add(LyricLine(startTime, endTime, text));
      }
    } else {
      i++;
    }
  }

  // Sắp xếp theo thời gian bắt đầu để đảm bảo thứ tự chính xác
  result.sort((a, b) => a.start.compareTo(b.start));

  return result;
}

// Hàm tiện ích để chuyển đổi chuỗi thời gian thành Duration
Duration _parseTimeString(String time, String millisStr) {
  final parts = time.split(':');

  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  // Xử lý HH:MM:SS hoặc MM:SS
  if (parts.length == 3) {
    hours = int.parse(parts[0]);
    minutes = int.parse(parts[1]);
    seconds = int.parse(parts[2]);
  } else if (parts.length == 2) {
    minutes = int.parse(parts[0]);
    seconds = int.parse(parts[1]);
  }

  // Xử lý milliseconds - chuẩn hóa về milliseconds
  int milliseconds = 0;
  if (millisStr.length == 3) {
    milliseconds = int.parse(millisStr);
  } else if (millisStr.length == 2) {
    milliseconds = int.parse(millisStr) * 10;
  } else if (millisStr.length == 1) {
    milliseconds = int.parse(millisStr) * 100;
  }

  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    milliseconds: milliseconds,
  );
}