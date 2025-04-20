import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/models/article.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(article.url);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'URL açılamadı: $url';
      }
    } catch (e) {
      debugPrint('URL açma hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tarih formatını ayarla
    final DateTime publishDate = DateTime.parse(article.publishedAt);
    final DateFormat formatter = DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR');
    final String formattedDate = formatter.format(publishDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Haber Detayı',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Haber başlığı
            Text(
              article.title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Kaynak ve tarih
            Row(
              children: [
                if (article.source != null)
                  Chip(
                    label: Text(article.source!),
                    backgroundColor: Colors.blue.shade100,
                  ),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Haber görseli
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                ),
              ),
            const SizedBox(height: 16),

            // Yazar
            if (article.author != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Yazar: ${article.author}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),

            // Açıklama
            if (article.description != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  article.description!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            // İçerik
            if (article.content != null)
              Text(article.content!, style: GoogleFonts.poppins(fontSize: 16)),

            const SizedBox(height: 24),

            // Kaynak linki
            ElevatedButton(
              onPressed: _launchUrl,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.link),
                  const SizedBox(width: 8),
                  Text(
                    'Kaynağa Git',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
