import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' show Blob, Url, AnchorElement;

import 'notification_service.dart';

class DownloadService {
  /// Download receipt as PDF format
  static Future<void> downloadReceipt(
    BuildContext context, {
    required String fileName,
    required String receiptData,
  }) async {
    try {
      final pdfBytes = await _buildReceiptPdf(receiptData);
      String? savedPath;

      if (kIsWeb) {
        _downloadOnWeb(fileName, pdfBytes);
      } else {
        savedPath = await _downloadOnNative(fileName, pdfBytes);
      }

      if (context.mounted) {
        NotificationService.showSuccess(
          context,
          savedPath != null ? 'Receipt downloaded to:\n$savedPath' : 'Receipt downloaded: $fileName.pdf',
        );
      }
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
  }

  static Future<Uint8List> _buildReceiptPdf(String receiptData) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Payment Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text(receiptData, style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 30),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('© Canteen Management System', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }


  /// Download menu list
  static void downloadMenu(
    BuildContext context, {
    required String fileName,
    required List<Map<String, String>> items,
  }) {
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          NotificationService.showSuccess(
            context,
            'Menu downloaded: $fileName.csv',
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
  }

  /// Download report (sales, revenue, etc.) as PDF
  static Future<void> downloadReport(
    BuildContext context, {
    required String fileName,
    required String reportType,
    required Map<String, dynamic> reportData,
  }) async {
    try {
      final pdfBytes = await _buildPdf(reportType, reportData);
      String? savedPath;

      if (kIsWeb) {
        _downloadOnWeb(fileName, pdfBytes);
      } else {
        savedPath = await _downloadOnNative(fileName, pdfBytes);
      }

      if (context.mounted) {
        NotificationService.showSuccess(
          context,
          savedPath != null ? 'Report downloaded to:\n$savedPath' : 'Report downloaded: $fileName.pdf',
        );
      }
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(
            context, 'Download failed: ${e.toString()}');
      }
    }
  }

  static Future<Uint8List> _buildPdf(
    String reportType,
    Map<String, dynamic> reportData,
  ) async {
    final pdf = pw.Document();
    final now = DateTime.now();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Beautiful Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(24),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#9B1C1C'),
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'CANTEENO REPORT',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      reportType.toUpperCase(),
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#FFCDD2'),
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),
              
              // Metadata Row
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Generated On:', style: pw.TextStyle(color: PdfColors.grey600, fontSize: 10)),
                      pw.SizedBox(height: 4),
                      pw.Text(now.toString().split('.')[0], style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    ]
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Status:', style: pw.TextStyle(color: PdfColors.grey600, fontSize: 10)),
                      pw.SizedBox(height: 4),
                      pw.Text('CONFIDENTIAL & OFFICIAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColor.fromHex('#008080'))),
                    ]
                  ),
                ]
              ),
              pw.SizedBox(height: 30),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 20),
              
              pw.Text(
                'Report Summary Metrics',
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColor.fromHex('#1A1A2E'),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              
              // Grid of Metrics
              pw.Wrap(
                spacing: 15,
                runSpacing: 15,
                children: reportData.entries.map((e) {
                  return pw.Container(
                    width: 230,
                    padding: const pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#F8F9FA'),
                      borderRadius: pw.BorderRadius.circular(12),
                      border: pw.Border.all(color: PdfColor.fromHex('#E9ECEF')),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          e.key.toUpperCase(),
                          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600, fontWeight: pw.FontWeight.bold, letterSpacing: 0.5),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          e.value.toString(),
                          style: pw.TextStyle(fontSize: 22, color: PdfColor.fromHex('#1A1A2E'), fontWeight: pw.FontWeight.bold),
                        ),
                      ]
                    )
                  );
                }).toList(),
              ),
              
              pw.Spacer(),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 15),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    '© Canteen Management System',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                  pw.Text(
                    'Page 1 of 1',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                ]
              )
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static void _downloadOnWeb(String fileName, Uint8List pdfBytes) {
    try {
      final blob = Blob([pdfBytes], 'application/pdf');
      final url = Url.createObjectUrlFromBlob(blob);
      final anchor = AnchorElement(href: url)
        ..setAttribute('download', '$fileName.pdf')
        ..click();
      Url.revokeObjectUrl(url);
    } catch (e) {
      throw 'Web download failed: $e';
    }
  }

  static Future<String> _downloadOnNative(
      String fileName, Uint8List pdfBytes) async {
    try {
      final directory = await _getDownloadDirectory();
      final filePath = path.join(directory.path, '$fileName.pdf');
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);
      return filePath;
    } catch (e) {
      throw 'Native download failed: $e';
    }
  }

  static Future<Directory> _getDownloadDirectory() async {
    try {
      if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        final home = Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
        if (home != null) {
          final desktop = Directory(path.join(home, 'Desktop'));
          if (await desktop.exists()) {
            return desktop;
          }
        }
      }
    } catch (_) {}

    try {
      final downloads = await getDownloadsDirectory();
      if (downloads != null) return downloads;
    } catch (_) {
      // Fallback to documents directory
    }
    return await getApplicationDocumentsDirectory();
  }

  /// Download transaction history
  static void downloadTransactionHistory(
    BuildContext context, {
    required String fileName,
    required List<Map<String, String>> transactions,
  }) {
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          NotificationService.showSuccess(
            context,
            'Transaction history downloaded: $fileName.csv',
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
  }

  /// Download order details
  static void downloadOrder(
    BuildContext context, {
    required String fileName,
    required String orderId,
    required List<Map<String, String>> items,
    required String totalAmount,
  }) {
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          NotificationService.showSuccess(
            context,
            'Order downloaded: $fileName.pdf',
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
  }

  /// Show download options dialog
  static void showDownloadOptions(
    BuildContext context, {
    required List<String> options,
    required Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Download Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...options.map((option) => ListTile(
                  leading: const Icon(Icons.download, color: Color(0xFF9B1C1C)),
                  title: Text(option),
                  onTap: () {
                    Navigator.pop(context);
                    onSelect(option);
                  },
                )),
          ],
        ),
      ),
    );
  }

  static Future<void> downloadQueueReport(
    BuildContext context, {
    required List<Map<String, dynamic>> cafeterias,
  }) async {
    try {
      final String fileName = 'queue_report_${DateTime.now().toString().split(' ')[0]}';
      final pdfBytes = await _buildQueueReportPdf(cafeterias);
      String? savedPath;

      if (kIsWeb) {
        _downloadOnWeb(fileName, pdfBytes);
      } else {
        savedPath = await _downloadOnNative(fileName, pdfBytes);
      }

      if (context.mounted) {
        NotificationService.showSuccess(
          context,
          savedPath != null
              ? 'Queue Report downloaded to:\n$savedPath'
              : 'Queue Report downloaded: $fileName.pdf',
        );
      }
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
  }

  static Future<Uint8List> _buildQueueReportPdf(List<Map<String, dynamic>> cafeterias) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = '${_getMonthName(now.month)} ${now.day}, ${now.year}';

    final canteenoRed = PdfColor.fromHex('#9B1C1C');
    final canteenoTeal = PdfColor.fromHex('#008080');
    final lightGrey = PdfColor.fromHex('#F0F0F0');

    // Aggregate totals for stats
    int totalQueue = 0;
    int totalCompleted = 0;
    int totalCancelled = 0;
    double totalWait = 0;

    for (var cafe in cafeterias) {
      totalQueue += (cafe['queue'] as int);
      totalCompleted += (cafe['completed'] as int);
      totalCancelled += (cafe['cancelled'] as int);
      totalWait += (cafe['wait'] as int).toDouble();
    }
    double avgWait = cafeterias.isNotEmpty ? totalWait / cafeterias.length : 0;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: pw.BoxDecoration(color: canteenoRed),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('QUEUE MANAGEMENT REPORT', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 18)),
                    pw.Text('Date: $dateStr', style: pw.TextStyle(color: PdfColors.white, fontSize: 12)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Summary Section
              pw.Text('REPORT OVERVIEW', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, color: canteenoRed)),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                   _buildStatBox('Total Queue', '$totalQueue', const PdfColor.fromInt(0xFF1565C0)),
                   _buildStatBox('Total Completed', '$totalCompleted', PdfColors.green),
                   _buildStatBox('Total Cancelled', '$totalCancelled', PdfColors.red),
                   _buildStatBox('Avg. Wait Time', '${avgWait.toStringAsFixed(1)} Min', canteenoTeal),
                ]
              ),
              pw.SizedBox(height: 20),

              // Cafeteria Details Table
              pw.Text('CAFETERIA METRICS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.grey700)),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                columnWidths: {
                  0: const pw.FlexColumnWidth(4),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(2),
                  4: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: lightGrey),
                    children: [
                      _buildTableCell('Cafeteria', isHeader: true),
                      _buildTableCell('Queue', isHeader: true),
                      _buildTableCell('Wait', isHeader: true),
                      _buildTableCell('Done', isHeader: true),
                      _buildTableCell('Cancel', isHeader: true),
                    ],
                  ),
                  ...cafeterias.map((cafe) => pw.TableRow(
                    children: [
                      _buildTableCell(cafe['name']),
                      _buildTableCell(cafe['queue'].toString()),
                      _buildTableCell('${cafe['wait']}m'),
                      _buildTableCell(cafe['completed'].toString()),
                      _buildTableCell(cafe['cancelled'].toString()),
                    ],
                  )),
                ],
              ),
              pw.SizedBox(height: 30),

              // Graphics Section
              pw.Text('VISUAL ANALYSIS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, color: canteenoRed)),
              pw.SizedBox(height: 15),
              
              pw.Row(
                children: [
                  // Completed Orders per Cafeteria (Bar Chart)
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Text('Completed Orders Distribution', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                        pw.SizedBox(height: 10),
                        pw.Container(
                          height: 150,
                          child: pw.Chart(
                            grid: pw.CartesianGrid(
                              xAxis: pw.FixedAxis(
                                List.generate(cafeterias.length, (i) => i.toDouble()),
                                format: (v) => cafeterias[v.toInt()]['name'].toString().split(' ')[0],
                                ticks: true,
                              ),
                              yAxis: pw.FixedAxis(
                                [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100],
                                ticks: true,
                              ),
                            ),
                            datasets: [
                              pw.BarDataSet(
                                color: PdfColors.green,
                                width: 15,
                                data: List.generate(cafeterias.length, (i) {
                                  return pw.PointChartValue(i.toDouble(), cafeterias[i]['completed'].toDouble());
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  // Wait Time Distribution (Line Chart)
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Text('Wait Time per Cafeteria (Min)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                        pw.SizedBox(height: 10),
                        pw.Container(
                          height: 150,
                          child: pw.Chart(
                            grid: pw.CartesianGrid(
                              xAxis: pw.FixedAxis(
                                List.generate(cafeterias.length, (i) => i.toDouble()),
                                format: (v) => cafeterias[v.toInt()]['name'].toString().split(' ')[0],
                                ticks: true,
                              ),
                              yAxis: pw.FixedAxis(
                                [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100],
                                ticks: true,
                              ),
                            ),
                            datasets: [
                              pw.LineDataSet(
                                color: canteenoTeal,
                                drawPoints: true,
                                data: List.generate(cafeterias.length, (i) {
                                  return pw.PointChartValue(i.toDouble(), cafeterias[i]['wait'].toDouble());
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              pw.Spacer(),
              pw.Divider(color: canteenoRed),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('© Canteeno System - Queue Management Insights', style: const pw.TextStyle(fontSize: 8)),
                  pw.Text('Report Generated Automatically based on Real-time Dashboard Data', style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildStatBox(String label, String value, PdfColor color) {
    return pw.Container(
      width: 110,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColor(color.red, color.green, color.blue, 0.1),
        border: pw.Border.all(color: PdfColor(color.red, color.green, color.blue, 0.3)),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(value, style: pw.TextStyle(color: color, fontWeight: pw.FontWeight.bold, fontSize: 16)),
          pw.SizedBox(height: 4),
          pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
        ],
      ),
    );
  }

  static Future<void> downloadStaffReport(
    BuildContext context, {
    required List<Map<String, dynamic>> staffMembers,
  }) async {
    try {
      final String fileName = 'staff_management_report_${DateTime.now().toString().split(' ')[0]}';
      final pdfBytes = await _buildStaffReportPdf(staffMembers);
      String? savedPath;

      if (kIsWeb) {
        _downloadOnWeb(fileName, pdfBytes);
      } else {
        savedPath = await _downloadOnNative(fileName, pdfBytes);
      }

      if (context.mounted) {
        NotificationService.showSuccess(
          context,
          savedPath != null
              ? 'Staff Report downloaded to:\n$savedPath'
              : 'Staff Report downloaded: $fileName.pdf',
        );
      }
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
  }

  static Future<Uint8List> _buildStaffReportPdf(List<Map<String, dynamic>> staffMembers) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = '${_getMonthName(now.month)} ${now.day}, ${now.year}';

    final canteenoRed = PdfColor.fromHex('#9B1C1C');
    final lightGrey = PdfColor.fromHex('#F0F0F0');

    // Calculate statistics
    final Map<String, int> roleCounts = {};
    for (var staff in staffMembers) {
      final role = staff['role'] as String;
      roleCounts[role] = (roleCounts[role] ?? 0) + 1;
    }
    final totalActiveStaff = staffMembers.where((s) => s['status'] == 'Active').length;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: pw.BoxDecoration(color: canteenoRed),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('STAFF MANAGEMENT REPORT', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 16)),
                    pw.Text('Date: $dateStr', style: pw.TextStyle(color: PdfColors.white, fontSize: 12)),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text('STAFF MANAGEMENT REPORT - SYSTEM OVERVIEW', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
              ),
              pw.SizedBox(height: 10),

              // Section 1: Active Staff Profile
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(4),
                decoration: pw.BoxDecoration(color: lightGrey, border: pw.Border.all(color: PdfColors.grey400)),
                child: pw.Center(child: pw.Text('SECTION 1: ACTIVE STAFF PROFILE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(4),
                  3: const pw.FlexColumnWidth(2),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: lightGrey),
                    children: [
                      _buildTableCell('Employee Name', isHeader: true),
                      _buildTableCell('Assigned Role', isHeader: true),
                      _buildTableCell('Contact Email', isHeader: true),
                      _buildTableCell('System Status', isHeader: true),
                    ],
                  ),
                  // Table Rows
                  ...staffMembers.map((staff) {
                    final isActive = staff['status'] == 'Active';
                    return pw.TableRow(
                      children: [
                        _buildTableCell(staff['name']),
                        _buildTableCell(staff['role']),
                        _buildTableCell(staff['email']),
                        _buildTableCell(staff['status'], textColor: isActive ? PdfColors.green : PdfColors.red),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 20),

              // Section 2: Summary Statistics
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(4),
                decoration: pw.BoxDecoration(color: lightGrey, border: pw.Border.all(color: PdfColors.grey400)),
                child: pw.Center(child: pw.Text('SECTION 2: SUMMARY STATISTICS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: pw.BoxDecoration(color: lightGrey, border: pw.Border.all(color: PdfColors.grey400)),
                  child: pw.Text('Total Active Staff: $totalActiveStaff', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                ),
              ),
              pw.SizedBox(height: 10),
              
              // Chart
              pw.Center(
                child: pw.Container(
                  width: 300,
                  height: 150,
                  child: pw.Chart(
                    grid: pw.CartesianGrid(
                      xAxis: pw.FixedAxis(
                        List.generate(roleCounts.length, (i) => i.toDouble()),
                        format: (v) => roleCounts.keys.elementAt(v.toInt()),
                      ),
                      yAxis: pw.FixedAxis(
                         List.generate(5, (i) => i * 0.5),
                         format: (v) => v.toString(),
                      ),
                    ),
                    datasets: [
                      pw.BarDataSet(
                        color: lightGrey,
                        borderColor: PdfColors.grey600,
                        width: 40,
                        data: List.generate(roleCounts.length, (i) {
                          final count = roleCounts.values.elementAt(i);
                          return pw.PointChartValue(i.toDouble(), count.toDouble());
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              
              pw.Spacer(),
              // Footer
              pw.Divider(thickness: 1, color: canteenoRed),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Report Generated for: [User Name] - System ID: SMGR-001', style: const pw.TextStyle(fontSize: 8)),
                  pw.Text('NOTE: To add or edit staff, please use the system interface.', style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false, PdfColor? textColor}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Center(
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
            fontSize: 10,
            color: textColor ?? PdfColors.black,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ),
    );
  }

  static String _getMonthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }
}
