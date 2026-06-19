import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/movies/widgets/circle_icon_button.dart';

class CustomAppBar extends SliverAppBar {
  final BuildContext context;
  final String bannerUrl;

  CustomAppBar({super.key, required this.context, required this.bannerUrl})
    : super(
        expandedHeight: 400,
        pinned: true,
        backgroundColor: ColorTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,

        // Back button
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ),

        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Stack(
            fit: StackFit.expand,
            children: [
              // Poster image
              CachedNetworkImage(
                imageUrl: bannerUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    Container(color: ColorTheme.surfaceVariant),
                errorWidget: (_, _, _) => Container(
                  color: ColorTheme.surfaceVariant,
                  child: const Icon(
                    Icons.movie_outlined,
                    color: ColorTheme.textSecondary,
                    size: 48,
                  ),
                ),
              ),

              // Gradient overlay — bottom fade into page bg
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.35),
                      Color.fromRGBO(0, 0, 0, 0.55),
                      Colors.black,
                      Color.fromRGBO(247, 245, 240, 0.85),
                      ColorTheme.background,
                    ],
                    stops: const [0.0, 0.25, 0.55, 0.88, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
