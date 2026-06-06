import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class InvoiceService {
  static Future<void> generateAndDownloadInvoice({
    required String bookingId,
    required String providerName,
    required String driverName,
    required String pickupAddress,
    required String destinationAddress,
    required String totalAmount,
    required String paymentMethod,
    required String date,
  }) async {
    final pdf = pw.Document();

    // Load logo if exists, else use placeholder
    pw.MemoryImage? logoImage;
    try {
      final logoData = await rootBundle.load('assets/images/ResQLink_Logo.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (e) {
      // Ignore if logo not found
    }

    final font = await PdfGoogleFonts.plusJakartaSansRegular();
    final fontBold = await PdfGoogleFonts.plusJakartaSansBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    if (logoImage != null)
                      pw.Image(logoImage, height: 40)
                    else
                      pw.Text('ResQLink', style: pw.TextStyle(font: fontBold, fontSize: 24, color: PdfColors.red900)),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('INVOICE', style: pw.TextStyle(font: fontBold, fontSize: 20)),
                        pw.Text(bookingId, style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey700)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),

                // Date and Payment Method
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Tanggal', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
                        pw.Text(date, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Metode Pembayaran', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
                        pw.Text(paymentMethod, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 32),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 32),

                // Provider Info
                pw.Text('INFORMASI LAYANAN', style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.orange800)),
                pw.SizedBox(height: 12),
                pw.Row(
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Provider', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
                        pw.Text(providerName, style: pw.TextStyle(font: fontBold, fontSize: 13)),
                      ],
                    ),
                    pw.SizedBox(width: 40),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Driver', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
                        pw.Text(driverName, style: pw.TextStyle(font: fontBold, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 32),

                // Journey Details
                pw.Text('DETAIL PERJALANAN', style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.orange800)),
                pw.SizedBox(height: 12),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Lokasi Jemput', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
                    pw.Text(pickupAddress, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                    pw.SizedBox(height: 16),
                    pw.Text('Lokasi Tujuan', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
                    pw.Text(destinationAddress, style: pw.TextStyle(font: fontBold, fontSize: 12)),
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 24),

                // Total
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Pembayaran', style: pw.TextStyle(font: fontBold, fontSize: 16)),
                    pw.Text(totalAmount, style: pw.TextStyle(font: fontBold, fontSize: 20, color: PdfColors.red900)),
                  ],
                ),
                
                pw.Spacer(),
                
                // Footer
                pw.Center(
                  child: pw.Text(
                    'Terima kasih telah menggunakan layanan ResQLink.',
                    style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600, fontStyle: pw.FontStyle.italic),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text(
                    'Ini adalah bukti pembayaran sah dari ResQLink.',
                    style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey500),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Share/Download the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Invoice-$bookingId.pdf',
    );
  }
}
