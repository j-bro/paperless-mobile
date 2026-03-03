import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

class MimeTypesPieChart extends StatefulWidget {
  final PaperlessServerStatisticsModel statistics;

  const MimeTypesPieChart({super.key, required this.statistics});

  @override
  State<MimeTypesPieChart> createState() => _MimeTypesPieChartState();
}

class _MimeTypesPieChartState extends State<MimeTypesPieChart> {
  static final _mimeTypeNames = {
    "application/pdf": "PDF",
    "image/png": "PNG",
    "image/jpeg": "JPEG",
    "image/tiff": "TIFF",
    "image/gif": "GIF",
    "image/webp": "WebP",
    "text/plain": "TXT",
    "application/msword": "DOC",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
        "DOCX",
    "application/vnd.ms-powerpoint": "PPT",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation":
        "PPTX",
    "application/vnd.ms-excel": "XLS",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": "XLSX",
    "application/vnd.oasis.opendocument.text": "ODT",
    "application/vnd.oasis.opendocument.presentation": "ODP",
    "application/vnd.oasis.opendocument.spreadsheet": "ODS",
  };

  int? _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final count = widget.statistics.documentFileTypeCounts.length;
    const startColor = Color(0xFF227D2D);
    const endColor = Color(0xFF1C2F1E);
    final colorShades = List.generate(count, (i) {
      if (count <= 1) return startColor;
      return Color.lerp(startColor, endColor, i / (count - 1))!;
    });

    final orderedMimeTypes = widget.statistics.documentFileTypeCounts
        .sortedBy((m) => m.mimeTypeCount)
        .reversed
        .toList();

    if (orderedMimeTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          width: 120 * 2 + 32,
          height: 120 * 2 + 32,
          child: PieChart(
            PieChartData(
              startDegreeOffset: 270,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      _touchedIndex = -1;
                      return;
                    }
                    _touchedIndex =
                        response.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 20,
              sections: _buildSections(colorShades, orderedMimeTypes).toList(),
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (int i = 0; i < orderedMimeTypes.length; i++)
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _touchedIndex = i;
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    _touchedIndex = -1;
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _touchedIndex = -1;
                  });
                },
                child: Row(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorShades[i % colorShades.length],
                      ),
                      width: 20,
                      height: 20,
                    ),
                    Text(
                      getMimeTypeName(orderedMimeTypes[i].mimeType),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  String getMimeTypeName(String mimeType) {
    return _mimeTypeNames[mimeType] ?? mimeType;
  }

  Iterable<PieChartSectionData> _buildSections(
    List<Color> colorShades,
    List<DocumentFileTypeCount> orderedMimeTypes,
  ) sync* {
    for (int i = 0; i < orderedMimeTypes.length; i++) {
      final type = orderedMimeTypes[i];
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 14.0 : 12.0;
      final radius = isTouched ? 120.0 : 100.0;
      final percentage =
          type.mimeTypeCount / widget.statistics.documentsTotal * 100;
      yield PieChartSectionData(
        color: colorShades[i % colorShades.length],
        value: type.mimeTypeCount.toDouble(),
        title: "${percentage.toStringAsFixed(1)}%",
        radius: radius,
        titleStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontSize: fontSize,
        ),
      );
    }
  }
}

extension AllShades on MaterialColor {
  List<Color> get values => [
    shade200,
    shade600,
    shade300,
    shade100,
    shade800,
    shade400,
    shade900,
    shade500,
    shade700,
  ];
}
