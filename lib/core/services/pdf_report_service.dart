import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:work_time/view_models/reports_view_model.dart';

class PdfReportService {
  /// Generate and open interactive print / share / preview sheet for monthly report
  static Future<void> generateAndPreviewReport(MonthlyReportSummary report) async {
    final doc = pw.Document();

    // Load Cairo Arabic Font
    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final boldFontData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(boldFontData);

    const primaryColor = PdfColor.fromInt(0xFFEA580C);   // Amber brand
    const secondaryColor = PdfColor.fromInt(0xFF0F172A);  // Deep Slate
    const lightBgColor = PdfColor.fromInt(0xFFFFF7ED);
    const borderColor = PdfColor.fromInt(0xFFE4E8F0);
    const textDark = PdfColor.fromInt(0xFF0F172A);
    const textMuted = PdfColor.fromInt(0xFF718096);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        textDirection: pw.TextDirection.rtl,
        margin: const pw.EdgeInsets.all(24),
        header: (context) => _buildPdfHeader(report, primaryColor, secondaryColor, textDark, textMuted),
        footer: (context) => _buildPdfFooter(context, textMuted),
        build: (context) => [
          pw.SizedBox(height: 12),
          _buildKpiSummary(report, primaryColor, lightBgColor, borderColor, textDark, textMuted),
          pw.SizedBox(height: 16),
          _buildDataTable(report, primaryColor, borderColor, textDark, textMuted),
          pw.SizedBox(height: 24),
          _buildSignaturesSection(textDark),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'تقرير_الرواتب_والحضور_${report.year}_${report.month}.pdf',
    );
  }

  static pw.Widget _buildPdfHeader(
    MonthlyReportSummary report,
    PdfColor primaryColor,
    PdfColor secondaryColor,
    PdfColor textDark,
    PdfColor textMuted,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColor.fromInt(0xFFE4E8F0), width: 1.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'تقرير الحضور والرواتب الشهري',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: primaryColor),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'عُمَّالي • رفيق صاحب العمل لإدارة العمال',
                style: pw.TextStyle(fontSize: 11, color: textMuted),
              ),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFEEF0FF),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Text(
              'الفترة: شهر ${report.month} / ${report.year}',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildKpiSummary(
    MonthlyReportSummary report,
    PdfColor primaryColor,
    PdfColor lightBgColor,
    PdfColor borderColor,
    PdfColor textDark,
    PdfColor textMuted,
  ) {
    return pw.Row(
      children: [
        _kpiCard('إجمالي العمال', '${report.totalWorkers} عامل', primaryColor, lightBgColor, borderColor, textDark),
        pw.SizedBox(width: 10),
        _kpiCard('أيام الحضور', '${report.totalDaysPresent} يوم', primaryColor, lightBgColor, borderColor, textDark),
        pw.SizedBox(width: 10),
        _kpiCard('إجمالي المستحق', '${report.totalSalaryEarned.toStringAsFixed(1)} ريال', primaryColor, lightBgColor, borderColor, textDark),
        pw.SizedBox(width: 10),
        _kpiCard('المسحوب / المدفوع', '${report.totalSalaryReceived.toStringAsFixed(1)} ريال', const PdfColor.fromInt(0xFFEF476F), lightBgColor, borderColor, textDark),
        pw.SizedBox(width: 10),
        _kpiCard('صافي المتبقي', '${report.totalRemaining.toStringAsFixed(1)} ريال', const PdfColor.fromInt(0xFF10B981), lightBgColor, borderColor, textDark),
      ],
    );
  }

  static pw.Widget _kpiCard(
    String title,
    String value,
    PdfColor accentColor,
    PdfColor bgColor,
    PdfColor borderColor,
    PdfColor textDark,
  ) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: bgColor,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          border: pw.Border.all(color: borderColor, width: 1),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: const pw.TextStyle(fontSize: 10, color: PdfColor.fromInt(0xFF718096))),
            pw.SizedBox(height: 4),
            pw.Text(value, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: accentColor)),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildDataTable(
    MonthlyReportSummary report,
    PdfColor primaryColor,
    PdfColor borderColor,
    PdfColor textDark,
    PdfColor textMuted,
  ) {
    final headers = [
      'م',
      'اسم العامل',
      'الوظيفة',
      'اليومية',
      'حاضر',
      'غائب',
      'سهرات',
      'إجمالي المستحق',
      'المسحوب',
      'المتبقي',
    ];

    final List<List<String>> rows = [];
    for (int i = 0; i < report.workerReports.length; i++) {
      final w = report.workerReports[i];
      rows.add([
        '${i + 1}',
        w.userName,
        w.userJob.isNotEmpty ? w.userJob : '—',
        '${w.dailyRate}',
        '${w.daysPresent}',
        '${w.daysAbsent}',
        '${w.overtimeDays}',
        '${w.totalEarned}',
        '${w.totalReceived}',
        '${w.remaining}',
      ]);
    }

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      border: pw.TableBorder.all(color: borderColor, width: 0.8),
      headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: pw.BoxDecoration(color: primaryColor),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.center,
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      rowDecoration: const pw.BoxDecoration(
        color: PdfColors.white,
      ),
      oddRowDecoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFF9FAFB),
      ),
    );
  }

  static pw.Widget _buildSignaturesSection(PdfColor textDark) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('توقيع المحاسب:', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: textDark)),
            pw.SizedBox(height: 20),
            pw.Text('................................................', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('توقيع الإدارة / صاحب العمل:', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: textDark)),
            pw.SizedBox(height: 20),
            pw.Text('................................................', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildPdfFooter(pw.Context context, PdfColor textMuted) {
    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('تم الاستخراج عبر تطبيق عُمَّالي', style: pw.TextStyle(fontSize: 8, color: textMuted)),
          pw.Text('صفحة ${context.pageNumber} من ${context.pagesCount}', style: pw.TextStyle(fontSize: 8, color: textMuted)),
        ],
      ),
    );
  }
}
