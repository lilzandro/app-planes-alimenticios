import 'package:app_planes/services/database_service.dart';
import 'package:app_planes/widgets/orientacion_responsive.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';
import 'package:intl/intl.dart';
import 'package:app_planes/screens/VentanaPlanAlimentacion/plan_dia.dart';
import 'package:app_planes/models/planAlimenticioModel.dart';

class VentanaPlanAlimentacion extends StatefulWidget {
  final PlanAlimenticioModel? planAlimenticio;

  const VentanaPlanAlimentacion({super.key, required this.planAlimenticio});

  @override
  _VentanaPlanAlimentacionState createState() =>
      _VentanaPlanAlimentacionState();
}

class _VentanaPlanAlimentacionState extends State<VentanaPlanAlimentacion> {
  Future<PlanAlimenticioModel?>? _futurePlanAlimenticio;

  @override
  void initState() {
    super.initState();
    _futurePlanAlimenticio = _loadPlanAlimenticio();
  }

  Future<PlanAlimenticioModel?> _loadPlanAlimenticio() async {
    return await PlanAlimenticioService.loadPlanAlimenticio();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlanAlimenticioModel?>(
      future: _futurePlanAlimenticio,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar el plan alimenticio'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Plan alimenticio no disponible'));
        } else {
          PlanAlimenticioModel planAlimenticio = snapshot.data!;
          int cantidadComidas = planAlimenticio.desayuno.length;
          return ResponsiveContainer(
            buildBlocks: (context) =>
                _buildBlocks(context, cantidadComidas, planAlimenticio),
            backgroundColor: Color(0xFFEAF8E7),
          );
        }
      },
    );
  }

  List<Widget> _buildBlocks(BuildContext context, int cantidadComidas,
      PlanAlimenticioModel planAlimenticio) {
    return [
      SizedBox(
        height: DimensionesDePantalla.pantallaSize * 0.17,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Plan Semanal\n de Alimentación',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023336),
                ),
              ),
            ),
          ],
        ),
      ),
      Divider(color: const Color(0xFF4DA674).withOpacity(0.5), thickness: 0.8),
      _buildCalendarWidget(cantidadComidas, planAlimenticio),
      Divider(color: const Color(0xFF4DA674).withOpacity(0.5), thickness: 0.8),
      SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
      _buildManualMenuSection(),
      SizedBox(height: DimensionesDePantalla.anchoPantalla * 0.05),
      _buildCreatePlanButton(),
      SizedBox(height: DimensionesDePantalla.anchoPantalla * 0.07),
      _buildCarousel(),
    ];
  }

  Widget _buildManualMenuSection() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'Menú manual',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Comfortaa',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF023336),
            ),
          ),
          Text(
            'Realiza tus propias recetas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Comfortaa',
              fontSize: 15,
              color: Color(0xFF023336),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatePlanButton() {
    return Container(
      height: DimensionesDePantalla.anchoPantalla * .12,
      width: DimensionesDePantalla.anchoPantalla * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(45, 0, 0, 0),
            blurRadius: 4.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF023336),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: Text(
          "Crear plan nuevo",
          style: TextStyle(
            fontFamily: 'Comfortaa',
            color: Color(0xFFEAF8E7),
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: DimensionesDePantalla.pantallaSize * 0.18,
        autoPlay: true,
        viewportFraction: 0.5,
      ),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: Color(0xFFC1E6BA)),
              child: Text(
                'text $i',
                style: TextStyle(fontSize: 16.0),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCalendarWidget(
      int cantidadComidas, PlanAlimenticioModel planAlimenticio) {
    DateTime startOfWeek = planAlimenticio.desayuno.isNotEmpty
        ? planAlimenticio.desayuno.first.fecha
        : DateTime.now();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(DimensionesDePantalla.pantallaSize * 0.02),
          margin: EdgeInsets.symmetric(
              horizontal: DimensionesDePantalla.pantallaSize * 0.01),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8E7).withOpacity(0.35),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.025),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: DimensionesDePantalla.pantallaSize * 0.01,
                  mainAxisSpacing: DimensionesDePantalla.pantallaSize * 0.02,
                  childAspectRatio: 1,
                ),
                itemCount: cantidadComidas,
                itemBuilder: (context, index) {
                  DateTime dayDate = startOfWeek.add(Duration(days: index));
                  String dayString = DateFormat('d').format(dayDate);
                  String dayOfWeekString =
                      DateFormat('EEEE', 'es_ES').format(dayDate);

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DayDetailScreen.planDia(
                                dayString: dayString,
                                daysOfWeek: dayOfWeekString,
                                planAlimenticio: planAlimenticio,
                                selectedDate: dayDate,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFeaf8e7),
                            borderRadius: BorderRadius.circular(
                                DimensionesDePantalla.pantallaSize * 0.012),
                            border: Border.all(
                                color: const Color(0xFF023336), width: 2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(4.0),
                                height:
                                    DimensionesDePantalla.pantallaSize * 0.03,
                                width: DimensionesDePantalla.pantallaSize * 0.1,
                                decoration: BoxDecoration(
                                  border: const Border(
                                    bottom: BorderSide(
                                        color: Color(0xFF023336), width: 2.0),
                                  ),
                                  color: const Color(0xFF4da674),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(9.0),
                                    topRight: Radius.circular(9.0),
                                  ),
                                ),
                                child: Text(
                                  dayOfWeekString,
                                  style: const TextStyle(
                                    fontFamily: 'Comfortaa',
                                    color: Color(0xFFeaf8e7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    dayString,
                                    style: TextStyle(
                                      color: const Color(0xFF023336),
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          DimensionesDePantalla.pantallaSize *
                                              0.02,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _positionGancho(0.008, 0.015, 0.075),
                      _positionGancho(0.008, 0.075, 0.015),
                    ],
                  );
                },
              ),
              SizedBox(height: DimensionesDePantalla.pantallaSize * 0.02),
            ],
          ),
        ),
      ],
    );
  }

  Widget _positionGancho(double top, double left, double right) {
    return Positioned(
      top: -DimensionesDePantalla.pantallaSize * 0.008,
      left: DimensionesDePantalla.pantallaSize * left,
      right: DimensionesDePantalla.pantallaSize * right,
      child: Container(
        height: DimensionesDePantalla.pantallaSize * 0.015,
        width: DimensionesDePantalla.pantallaSize * 0.01,
        decoration: BoxDecoration(
          color: const Color(0xFF023336),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
