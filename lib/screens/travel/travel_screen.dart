import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';
import 'package:here2there_kids/screens/travel/widgets/arrival_celebration.dart';
import 'package:here2there_kids/sprites/bush_1.dart';
import 'package:here2there_kids/sprites/bush_2.dart';
import 'package:here2there_kids/sprites/bush_3.dart';
import 'package:here2there_kids/sprites/bush_4.dart';
import 'package:here2there_kids/sprites/bush_5.dart';
import 'package:here2there_kids/sprites/bush_6.dart';
import 'package:here2there_kids/sprites/bush_7.dart';
import 'package:here2there_kids/sprites/bush_8.dart';
import 'package:here2there_kids/sprites/bush_9.dart';
import 'package:here2there_kids/sprites/castle.dart';

import 'package:here2there_kids/sprites/cloud_1.dart';
import 'package:here2there_kids/sprites/cloud_2.dart';
import 'package:here2there_kids/sprites/cloud_3.dart';
import 'package:here2there_kids/sprites/cloud_4.dart';
import 'package:here2there_kids/sprites/grass.dart';
import 'package:here2there_kids/sprites/house.dart';
import 'package:here2there_kids/sprites/road.dart';
import 'package:here2there_kids/sprites/sky.dart';
import 'package:here2there_kids/sprites/star_1.dart';
import 'package:here2there_kids/sprites/star_2.dart';
import 'package:here2there_kids/sprites/star_3.dart';
import 'package:here2there_kids/sprites/star_4.dart';
import 'package:here2there_kids/sprites/star_5.dart';
import 'package:here2there_kids/sprites/star_6.dart';
import 'package:here2there_kids/sprites/sun.dart';
import 'package:here2there_kids/sprites/tree_1.dart';
import 'package:here2there_kids/sprites/tree_2.dart';
import 'package:here2there_kids/sprites/tree_3.dart';
import 'package:here2there_kids/services/location_progress_service.dart';
import 'package:provider/provider.dart';

class TravelScene extends StatefulWidget {
  const TravelScene({super.key});

  @override
  State<TravelScene> createState() => _TravelSceneState();
}

class _TravelSceneState extends State<TravelScene>
    with SingleTickerProviderStateMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var imagePath in [
      'assets/bush_1.png',
      'assets/bush_2.png',
      'assets/bush_3.png',
      'assets/bush_4.png',
      'assets/bush_5.png',
      'assets/bush_6.png',
      'assets/bush_7.png',
      'assets/bush_8.png',
      'assets/bush_9.png',
      'assets/castle.png',
      'assets/cloud_1.png',
      'assets/cloud_2.png',
      'assets/cloud_3.png',
      'assets/cloud_4.png',
      'assets/grass.png',
      'assets/house.png',
      'assets/landscape.png',
      'assets/road.png',
      'assets/road_2.png',
      'assets/sky.png',
      'assets/star_1.png',
      'assets/star_2.png',
      'assets/star_3.png',
      'assets/star_4.png',
      'assets/star_5.png',
      'assets/star_6.png',
      'assets/sun.png',
      'assets/tree_1.png',
      'assets/tree_2.png',
      'assets/tree_3.png',
      'assets/vehicle.png',
    ]) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final locationService = context.watch<LocationProgressService>();
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          // Tamaño vehículo relativo al ancho (ejemplo 10%)
          final vehicleWidth = width * 0.12;
          final vehicleHeight = vehicleWidth; // para mantener cuadrado

          // Posición horizontal en píxeles según porcentaje
          final vehicleLeft = locationService.progress * (width - vehicleWidth);
          // final vehicleLeft = (width - vehicleWidth) * 0.85;

          // Posición vertical relativa desde abajo (ejemplo 8% del alto)
          final vehicleBottom = height * 0.14;

          return Stack(
            children: [
              Sky(height: height),
              Grass(height: height),
              Sun(height: height, width: width),
              Cloud1(height: height),
              Cloud2(height: height),
              Cloud3(height: height, width: width),
              Cloud4(height: height, width: width),
              Star1(height: height, width: width),
              Star2(height: height, width: width),
              Star3(height: height, width: width),
              Star4(height: height, width: width),
              Star5(height: height, width: width),
              Star6(height: height, width: width),
              Tree1(height: height, width: width),
              Tree2(height: height, width: width),
              Tree3(height: height, width: width),
              Bush1(height: height, width: width),
              Bush2(height: height, width: width),
              Bush3(height: height, width: width),
              Bush4(height: height, width: width),
              Bush5(height: height, width: width),
              Road(height: height),
              Bush6(height: height, width: width),
              Bush7(height: height, width: width),
              Bush8(height: height, width: width),
              Bush9(height: height, width: width),
              House(height: height, width: width),
              Castle(width: width, height: height),
              Positioned(
                top: height * 0.005,
                left: width * 0.005,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_circle_left,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                    color: Colors.yellow,
                    size: 50,
                  ),
                ),
              ),
              Sprite(
                spriteRoute: 'assets/vehicle.png',
                bottom: vehicleBottom,
                left: vehicleLeft,
                width: vehicleWidth,
                height: vehicleHeight,
              ),
              if (locationService.progress >= 0.85)
                ArrivalCelebration(
                  height: height,
                  width: width,
                  onClose: () {
                    Navigator.pop(context);
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
