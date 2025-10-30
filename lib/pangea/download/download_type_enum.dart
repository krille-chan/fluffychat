enum DownloadType {
  txt,
  csv,
  xlsx;

  String get mimetype {
    switch (this) {
      case DownloadType.txt:
        return 'text/plain';
      case DownloadType.csv:
        return 'text/csv';
      case DownloadType.xlsx:
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    }
  }

  String get extension {
    switch (this) {
      case DownloadType.txt:
        return 'txt';
      case DownloadType.csv:
        return 'csv';
      case DownloadType.xlsx:
        return 'xlsx';
    }
  }
}
