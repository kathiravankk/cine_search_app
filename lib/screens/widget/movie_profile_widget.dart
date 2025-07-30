import 'package:cine_search_app/utils/app_theme_manager.dart';
import 'package:flutter/material.dart';

class MovieProfileWidget extends StatelessWidget {
  final String imageUrl;
  final String movieTitle;
  final String year;
  final VoidCallback? viewFunction;

  const MovieProfileWidget({super.key, required this.imageUrl, required this.movieTitle, required this.year, this.viewFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: viewFunction!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppThemeManager.hintColor
                ),
                height: 180,
                width: double.infinity,
              ),
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            movieTitle,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: AppThemeManager.customTextStyleWithSize(
              size: 12,
              color: Colors.white,
            ),
          ),
          Text(
            year,
            style: AppThemeManager.customTextStyleWithSize(size: 12,color: Colors.white70,),
          ),
        ],
      ),
    );
  }
}
