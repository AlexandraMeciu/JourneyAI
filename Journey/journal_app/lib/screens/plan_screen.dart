import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/database/plan_db.dart';
import 'package:journal_app/datetime/date_time.dart';
import 'package:journal_app/widgets/ultra_background.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  int _currentStep = 0;
  int index = 0;
  PlanDataBase planDB = PlanDataBase();
  var date = DateFormat.yMMMEd().format(nowTime);
  String dateSelected = convertDateTimeToString(nowTime);
  bool noEntry = false;

  final TextEditingController step1Controller = TextEditingController();
  final TextEditingController step2Controller = TextEditingController();
  final TextEditingController step3Controller = TextEditingController();
  final TextEditingController step4Controller = TextEditingController();
  final TextEditingController step5Controller = TextEditingController();
  final TextEditingController step6Controller = TextEditingController();

  @override
  void initState() {
    planDB.loadPlanData();
    setIndex();
    step1Controller.text = planDB.todaysPlanList[index][2];
    step2Controller.text = planDB.todaysPlanList[index][4];
    step3Controller.text = planDB.todaysPlanList[index][6];
    step4Controller.text = planDB.todaysPlanList[index][8];
    step5Controller.text = planDB.todaysPlanList[index][10];
    step6Controller.text = planDB.todaysPlanList[index][12];

    super.initState();
  }

  void setIndex() {
    if (dateSelected == todaysDateFormatted()) {
      if (planDB.todaysPlanList.last[0] != dateSelected) {
        planDB.createData();
      }
      index = planDB.todaysPlanList.length - 1;
    } else {
      index = selectionIndex;
    }
  }

  void saveStep1(int index) {
    setState(() {
      planDB.todaysPlanList[index][2] = step1Controller.text;
    });
    planDB.updatePlanDB();
  }

  void saveStep2(int index) {
    setState(() {
      planDB.todaysPlanList[index][4] = step2Controller.text;
    });
    planDB.updatePlanDB();
  }

  void saveStep3(int index) {
    setState(() {
      planDB.todaysPlanList[index][6] = step3Controller.text;
    });
    planDB.updatePlanDB();
  }

  void saveStep4(int index) {
    setState(() {
      planDB.todaysPlanList[index][8] = step4Controller.text;
    });
    planDB.updatePlanDB();
  }

  void saveStep5(int index) {
    setState(() {
      planDB.todaysPlanList[index][10] = step5Controller.text;
    });
    planDB.updatePlanDB();
  }

  void saveStep6(int index) {
    setState(() {
      planDB.todaysPlanList[index][12] = step6Controller.text;
    });
    planDB.updatePlanDB();
  }

  void _exportAsPDF() async {
    final pdf = pw.Document();
    final List<Map<String, String>> notes = [
      {
        'title': planDB.todaysPlanList[index][1],
        'content': planDB.todaysPlanList[index][2]
      },
      {
        'title': planDB.todaysPlanList[index][3],
        'content': planDB.todaysPlanList[index][4]
      },
      {
        'title': planDB.todaysPlanList[index][5],
        'content': planDB.todaysPlanList[index][6]
      },
      {
        'title': planDB.todaysPlanList[index][7],
        'content': planDB.todaysPlanList[index][8]
      },
      {
        'title': planDB.todaysPlanList[index][9],
        'content': planDB.todaysPlanList[index][10]
      },
      {
        'title': planDB.todaysPlanList[index][11],
        'content': planDB.todaysPlanList[index][12]
      },
    ];

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(children: [
          pw.Text(
            date,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 30),
          ...notes.map((step) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Text(step['title'] ?? '',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text(step['content'] ?? '',
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.normal)),
                pw.SizedBox(height: 20),
              ],
            );
          }),
        ]),
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: UltraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(date),
          ),
          extendBodyBehindAppBar: false,
          body: Stack(
            children: [
              Stepper(
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  noAction() {}
                  return Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: noAction(),
                        child: const Text(''),
                      ),
                      TextButton(
                        onPressed: noAction(),
                        child: const Text(''),
                      ),
                    ],
                  );
                },
                type: StepperType.vertical,
                currentStep: _currentStep,
                onStepTapped: (int index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                steps: [
                  Step(
                    stepStyle: StepStyle(
                      color: Colors.blueGrey.shade400.withAlpha(150),
                    ),
                    title: Text(
                      planDB.todaysPlanList[index][1],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    content: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: step1Controller,
                        autocorrect: true,
                        maxLines: null,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        onChanged: (value) => saveStep1(index),
                        decoration: const InputDecoration(
                          border: InputBorder.none, //OutlineInputBorder(),
                          hintText: 'Your story ...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Step(
                    stepStyle: StepStyle(
                      color: Colors.blueGrey.shade400.withAlpha(150),
                    ),
                    title: Text(
                      planDB.todaysPlanList[index][3],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    content: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: step2Controller,
                        autocorrect: true,
                        maxLines: null,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        onChanged: (value) => saveStep2(index),
                        decoration: const InputDecoration(
                          border: InputBorder.none, //OutlineInputBorder(),
                          hintText: 'Your story ...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Step(
                    stepStyle: StepStyle(
                      color: Colors.blueGrey.shade400.withAlpha(150),
                    ),
                    title: Text(
                      planDB.todaysPlanList[index][5],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    content: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: step3Controller,
                        autocorrect: true,
                        maxLines: null,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        onChanged: (value) => saveStep3(index),
                        decoration: const InputDecoration(
                          border: InputBorder.none, //OutlineInputBorder(),
                          hintText: 'Your story ...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Step(
                    stepStyle: StepStyle(
                      color: Colors.blueGrey.shade400.withAlpha(150),
                    ),
                    title: Text(
                      planDB.todaysPlanList[index][7],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    content: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: step4Controller,
                        autocorrect: true,
                        maxLines: null,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        onChanged: (value) => saveStep4(index),
                        decoration: const InputDecoration(
                          border: InputBorder.none, //OutlineInputBorder(),
                          hintText: 'Your story ...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Step(
                    stepStyle: StepStyle(
                      color: Colors.blueGrey.shade400.withAlpha(150),
                    ),
                    title: Text(
                      planDB.todaysPlanList[index][9],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    content: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: step5Controller,
                        autocorrect: true,
                        maxLines: null,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        onChanged: (value) => saveStep5(index),
                        decoration: const InputDecoration(
                          border: InputBorder.none, //OutlineInputBorder(),
                          hintText: 'Your story ...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Step(
                    stepStyle: StepStyle(
                      color: Colors.blueGrey.shade400.withAlpha(150),
                    ),
                    title: Text(
                      planDB.todaysPlanList[index][11],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    content: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: step6Controller,
                        autocorrect: true,
                        maxLines: null,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        onChanged: (value) => saveStep6(index),
                        decoration: const InputDecoration(
                          border: InputBorder.none, //OutlineInputBorder(),
                          hintText: 'Your story ...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              //_exportAsPDF();

              _exportAsPDF();
            },
            child: Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
