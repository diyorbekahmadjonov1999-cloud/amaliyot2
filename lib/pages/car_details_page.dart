import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backgrounds/create_account_background.dart';
import '../widgets/create_account_bottom.dart';
import '../widgets/custom_drop_down.dart';
import '../models/car_brand.dart';
import '../models/car_model.dart';
import '../services/car_service.dart';
import 'car_mileage_page.dart';

class CarDetailsPage extends StatefulWidget {
  final String fullName;
  final String phoneNumber;

  const CarDetailsPage({
    super.key,
    required this.fullName,
    required this.phoneNumber,
  });

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  static const String _addNewOption = '+ Boshqa (qo\'lda kiritish)';

  // API'dan kelgan brend va model ro'yxatlari
  List<CarBrand> _brands = [];
  List<CarModel> _models = [];

  bool _isLoadingBrands = true;
  bool _isLoadingModels = false;
  String? _loadError;

  // Yil: 2027 dan 2000 gacha (eng yangisi tepada), keyin qo'lda qo'shilganlar bilan kengayadi
  List<String> _years =
  List.generate(2027 - 2000 + 1, (i) => '${2027 - i}');

  CarBrand? _selectedBrand;
  CarModel? _selectedModel;
  String? _selectedYear;

  String? _brandError;
  String? _modelError;
  String? _yearError;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    setState(() {
      _isLoadingBrands = true;
      _loadError = null;
    });

    try {
      final brands = await CarService.getBrands();
      setState(() {
        _brands = brands;
        _isLoadingBrands = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingBrands = false;
        _loadError = 'Brendlarni yuklab bo\'lmadi. Internetni tekshiring.';
      });
    }
  }

  Future<void> _loadModels(int brandId) async {
    setState(() {
      _isLoadingModels = true;
      _models = [];
      _selectedModel = null;
    });

    try {
      final models = await CarService.getModels(brandId);
      setState(() {
        _models = models;
        _isLoadingModels = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingModels = false;
        _loadError = 'Modellarni yuklab bo\'lmadi. Internetni tekshiring.';
      });
    }
  }

  // "+ Boshqa" tanlanganda ism kiritish uchun umumiy dialog (hozircha faqat ko'rinish uchun)
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

  void _handleBrandChanged(String? brandName) {
    if (brandName == _addNewOption) {
      _showAddDialog(
        title: 'Yangi brend qo\'shish',
        onAdd: (value) {
          // DIQQAT: bu yerda backend'dan haqiqiy id kelmaydi,
          // shuning uchun hozircha faqat ko'rinish uchun ishlaydi.
          setState(() {
            _brandError = 'Ro\'yxatda yo\'q brend hali qo\'llab-quvvatlanmaydi.';
          });
        },
      );
      return;
    }

    final brand = _brands.firstWhere((b) => b.name == brandName);

    setState(() {
      _selectedBrand = brand;
      _brandError = null;
    });

    _loadModels(brand.id);
  }

  void _handleModelChanged(String? modelName) {
    if (modelName == _addNewOption) {
      _showAddDialog(
        title: 'Yangi model qo\'shish',
        onAdd: (value) {
          setState(() {
            _modelError = 'Ro\'yxatda yo\'q model hali qo\'llab-quvvatlanmaydi.';
          });
        },
      );
      return;
    }

    final model = _models.firstWhere((m) => m.name == modelName);

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarMileagePage(
            fullName: widget.fullName,
            phoneNumber: widget.phoneNumber,
            brandId: _selectedBrand!.id,
            carModelId: _selectedModel!.id,
            carYear: int.parse(_selectedYear!),
          ),
        ),
      );
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

                  SizedBox(height: 24),

                  if (_isLoadingBrands)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(
                        color: Color(0xFF009577),
                      ),
                    ),

                  if (_loadError != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _loadError!,
                        style: TextStyle(color: Colors.red, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  SizedBox(height: 26),

                  // Brand va Model yonma-yon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          label: 'Brand',
                          hintText: 'Select brand',
                          items: [
                            ..._brands.map((b) => b.name),
                            _addNewOption,
                          ],
                          value: _selectedBrand?.name,
                          errorText: _brandError,
                          onChanged: _isLoadingBrands ? null : _handleBrandChanged,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomDropdown(
                          label: 'Model',
                          hintText: _isLoadingModels ? 'Yuklanmoqda...' : 'Select model',
                          items: _selectedBrand == null
                              ? const []
                              : [
                            ..._models.map((m) => m.name),
                            _addNewOption,
                          ],
                          value: _selectedModel?.name,
                          errorText: _modelError,
                          onChanged: (_selectedBrand == null || _isLoadingModels)
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