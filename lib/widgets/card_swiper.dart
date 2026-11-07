import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> pelis;

  const CardSwiper({Key? key, required this.pelis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mida = MediaQuery.of(context).size;

    if (pelis.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: mida.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: mida.height * 0.5,
      child: Swiper(
        itemCount: pelis.length,
        layout: SwiperLayout.STACK,
        itemWidth: mida.width * 0.6,
        itemHeight: mida.height * 0.4,
        itemBuilder: (BuildContext context, int index) {
          final peli = pelis[index];

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: peli),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(peli.fullPosterImg),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
