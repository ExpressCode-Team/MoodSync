import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class CheckboxImageGenre extends StatefulWidget {
  final String imageURL; // Digunakan untuk genre, bukan URL gambar
  final String description;
  final bool initialCheck;
  final Function(bool) onChanged;

  const CheckboxImageGenre({
    super.key,
    required this.imageURL, // ImageURL tidak lagi digunakan untuk URL gambar
    required this.description,
    required this.initialCheck,
    required this.onChanged,
  });

  @override
  State<CheckboxImageGenre> createState() => _CheckboxImageGenreState();
}

class _CheckboxImageGenreState extends State<CheckboxImageGenre> {
  bool isChecked = false;
  late Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialCheck;
    _backgroundColor = _generateBackgroundColor(widget.description);
  }

  // Fungsi untuk menghasilkan warna latar belakang berdasarkan genre
  Color _generateBackgroundColor(String description) {
    int hash = description.hashCode;
    Random random = Random(hash); // Membuat random generator berdasarkan hash
    return Color.fromARGB(
      255,
      random.nextInt(200), // Red value (0-199)
      random.nextInt(200), // Green value (0-199)
      random.nextInt(200), // Blue value (0-199)
    );
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width * 0.2;
    String firstTwoLetters = widget.description.length > 1
        ? widget.description.substring(0, 2).toUpperCase()
        : widget.description.toUpperCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        widget.onChanged(isChecked);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize:
                MainAxisSize.min, // Prevent overflow by keeping size minimal
            children: [
              // Circular Avatar dengan dua huruf genre dan warna latar belakang yang konsisten
              CircleAvatar(
                radius: imageSize / 2,
                backgroundColor: _backgroundColor,
                child: Text(
                  firstTwoLetters,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              // Deskripsi genre dengan overflow handling
              Flexible(
                child: Text(
                  widget.description,
                  style: AppTextStyle.headline1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // Menghindari overflow
                  maxLines: 2, // Membatasi jumlah baris
                ),
              ),
            ],
          ),
          // Tanda centang ketika genre dipilih
          if (isChecked)
            const Positioned(
              top: 0,
              right: 12,
              child: Icon(
                shadows: <Shadow>[
                  Shadow(color: Colors.black, blurRadius: 15.0)
                ],
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}
