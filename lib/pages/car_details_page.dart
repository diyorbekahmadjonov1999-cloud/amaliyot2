import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backgrounds/create_account_background.dart';
import '../widgets/create_account_bottom.dart';
import '../widgets/custom_drop_down.dart';

class CarDetailsPage extends StatefulWidget {
  const CarDetailsPage({super.key});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  static const String _addNewOption = '+ Boshqa (qo\'lda kiritish)';

  // TODO: haqiqiy ma'lumotlar manbasi (API) bilan almashtiring
  List<String> _brands = ['Chevrolet', 'Kia', 'Hyundai', 'Toyota', 'BMW'];
  List<String> _models = [];

  // Yil: 2050 dan 1990 gacha (eng yangisi tepada), keyin qo'lda qo'shilganlar bilan kengayadi
  List<String> _years =
  List.generate(2050 - 1990 + 1, (i) => '${2050 - i}');

  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedYear;

  String? _brandError;
  String? _modelError;
  String? _yearError;

  // Har bir brand uchun namunaviy modellar (haqiqiy loyihada API'dan olinadi)
  final Map<String, List<String>> _brandModels = {
    'Chevrolet': ['Cobalt', 'Nexia', 'Malibu', 'Tracker'],
    'Kia': ['Rio', 'Sportage', 'Cerato'],
    'Hyundai': ['Elantra', 'Tucson', 'Sonata'],
    'Toyota': ['Camry', 'Corolla', 'Land Cruiser'],
    'BMW': ['320i', 'X5', 'X6'],
  };

  // "+ Boshqa" tanlanganda ism kiritish uchun umumiy dialog (brend/model uchun)
  Future<void> _showAddDialog({
    required String title,
    required void Function(String value) onAdd,
  }) async {
    final TextEditingController controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Nomini kiriting',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Bekor qilish'),
            ),
            TextButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  onAdd(value);
                }
                Navigator.pop(context);
              },
              child: const Text('Qo\'shish'),
            ),
          ],
        );
      },
    );
  }

  // Yil uchun alohida dialog — faqat raqam qabul qiladi va oralig'ini tekshiradi
  Future<void> _showAddYearDialog() async {
    final TextEditingController controller = TextEditingController();
    String? dialogError;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Yilni qo\'lda kiritish'),
              content: TextField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masalan: 2019',
                  errorText: dialogError,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Bekor qilish'),
                ),
                TextButton(
                  onPressed: () {
                    final text = controller.text.trim();
                    final year = int.tryParse(text);

                    if (year == null) {
                      setDialogState(
                            () => dialogError = 'Faqat raqam kiriting.',
                      );
                      return;
                    }
                    if (year < 1900 || year > 2100) {
                      setDialogState(
                            () => dialogError = '1900–2100 oralig\'ida kiriting.',
                      );
                      return;
                    }

                    setState(() {
                      final yearStr = year.toString();
                      if (!_years.contains(yearStr)) {
                        _years.add(yearStr);
                        _years.sort(
                              (a, b) => int.parse(b).compareTo(int.parse(a)),
                        );
                      }
                      _selectedYear = yearStr;
                      _yearError = null;
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('Qo\'shish'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleBrandChanged(String? brand) {
    if (brand == _addNewOption) {
      _showAddDialog(
        title: 'Yangi brend qo\'shish',
        onAdd: (value) {
          setState(() {
            if (!_brands.contains(value)) {
              _brands = [..._brands, value];
            }
            _brandModels.putIfAbsent(value, () => []);
            _selectedBrand = value;
            _selectedModel = null;
            _models = _brandModels[value] ?? [];
            _brandError = null;
          });
        },
      );
      return;
    }

    setState(() {
      _selectedBrand = brand;
      _selectedModel = null;
      _models = brand != null ? (_brandModels[brand] ?? []) : [];
      _brandError = null;
    });
  }

  void _handleModelChanged(String? model) {
    if (model == _addNewOption) {
      _showAddDialog(
        title: 'Yangi model qo\'shish',
        onAdd: (value) {
          setState(() {
            if (!_models.contains(value)) {
              _models = [..._models, value];
            }
            if (_selectedBrand != null) {
              _brandModels[_selectedBrand!] = _models;
            }
            _selectedModel = value;
            _modelError = null;
          });
        },
      );
      return;
    }

    setState(() {
      _selectedModel = model;
      _modelError = null;
    });
  }

  void _handleContinue() {
    setState(() {
      _brandError = _selectedBrand == null ? 'Please select a brand.' : null;
      _modelError = _selectedModel == null ? 'Please select a model.' : null;
      _yearError = _selectedYear == null ? 'Please select a year.' : null;
    });

    if (_brandError == null && _modelError == null && _yearError == null) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          children: [

            // 1-QAVAT:
            Positioned.fill(
              child: CreateAccountBackground(),
            ),

            Positioned(
              left: 0,
              bottom: 0,
              child: CreateAccountBottom(),
            ),

            // 2-QAVAT:
            SafeArea(child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFF00897B),
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Row(
                            children: [
                              Text("UZ", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              SizedBox(width: 8),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Color(0xFF00897B),
                                child: Text("ENG", style: TextStyle(fontSize: 10, color: Colors.white)),
                              ),
                              SizedBox(width: 8),
                              Text("RU", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 80),

                  Text(
                    'Create Account',
                    style: GoogleFonts.brunoAce(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1D1D1D),
                    ),
                  ),

                  Text(
                    'House engine',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Color(0xFF909090),
                    ),
                  ),

                  SizedBox(height: 50),

                  // Brand va Model yonma-yon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          label: 'Brand',
                          hintText: 'Select brand',
                          items: [..._brands, _addNewOption],
                          value: _selectedBrand,
                          errorText: _brandError,
                          onChanged: _handleBrandChanged,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomDropdown(
                          label: 'Model',
                          hintText: 'Select model',
                          items: _selectedBrand == null
                              ? const []
                              : [..._models, _addNewOption],
                          value: _selectedModel,
                          errorText: _modelError,
                          onChanged: _selectedBrand == null
                              ? null
                              : _handleModelChanged,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  CustomDropdown(
                    label: 'Car Year',
                    hintText: 'Select year',
                    items: [..._years, _addNewOption],
                    value: _selectedYear,
                    errorText: _yearError,
                    onChanged: (year) {
                      if (year == _addNewOption) {
                        _showAddYearDialog();
                        return;
                      }
                      setState(() {
                        _selectedYear = year;
                        _yearError = null;
                      });
                    },
                  ),

                  SizedBox(height: 32),

                  // To'liq kenglikdagi Continue tugmasi (eraser tugmasi yo'q)
                  GestureDetector(
                    onTap: _handleContinue,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Color(0xFF009577),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x40000000),
                            offset: Offset(0, 4),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              letterSpacing: 0,
                              color: Color(0xFFF0EBE5),
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFF0EBE5),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}