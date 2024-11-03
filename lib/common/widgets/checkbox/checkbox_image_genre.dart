import 'package:flutter/material.dart';
import 'package:mood_sync/core/config/theme/app_text_style.dart';

class CheckboxImageGenre extends StatefulWidget {
  final String imageURL;
  final String description;
  final bool initialCheck;
  final Function(bool) onChanged;
  const CheckboxImageGenre(
      {super.key,
      required this.imageURL,
      required this.description,
      required this.initialCheck,
      required this.onChanged});

  @override
  State<CheckboxImageGenre> createState() => _CheckboxImageGenreState();
}

class _CheckboxImageGenreState extends State<CheckboxImageGenre> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialCheck;
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width * 0.2;
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
            children: [
              ClipOval(
                child: Image.network(
                  widget.imageURL,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              Text(
                widget.description,
                style: AppTextStyle.headline1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          if (isChecked)
            const Positioned(
              top: 0,
              right: 12,
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
            )
        ],
      ),
    );
  }
}
