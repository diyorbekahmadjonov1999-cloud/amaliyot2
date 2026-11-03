import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/page_decor.dart';

const Color _teal = Color(0xFF009577);
const Color _ink = Color(0xFF1B2B28);
const Color _muted = Color(0xFF8A9A97);
const Color _errorRed = Color(0xFFE53935);

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _kmCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();

  String? _brand;
  String? _model;
  int? _year;

  String? _nameError;
  String? _phoneError;
  String? _brandError;
  String? _modelError;
  String? _yearError;
  String? _kmError;
  String? _plateError;

  // TODO: keyinchalik API'dan (GET /api/cars/brands va /api/cars/models/{id}) keladi
  static const Map<String, List<String>> _brandModels = {
    'Chevrolet': ['Onix', 'Cobalt', 'Nexia 3', 'Gentra', 'Tracker', 'Malibu'],
    'Kia': ['K5', 'Sportage', 'Seltos', 'Sorento'],
    'BYD': ['Song Plus', 'Han', 'Chazor'],
    'Toyota': ['Camry', 'Corolla', 'RAV4'],
    'Hyundai': ['Elantra', 'Tucson', 'Sonata'],
  };

  // 2027 dan 2000 gacha
  final List<int> _years = List.generate(28, (i) => 2027 - i);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _kmCtrl.dispose();
    _plateCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final km = _kmCtrl.text.trim();
    final plate = _plateCtrl.text.trim();

    setState(() {
      _nameError = (name.length < 7 || name.split(RegExp(r'\s+')).length < 2)
          ? 'Enter your full name (first and last name).'
          : null;
      _phoneError = phone.length != 9 ? 'Enter a valid phone number.' : null;
      _brandError = _brand == null ? 'Please select a brand.' : null;
      _modelError = _model == null ? 'Please select a model.' : null;
      _yearError = _year == null ? 'Please select a year.' : null;
      _kmError = km.isEmpty ? 'Please enter the mileage.' : null;
      _plateError = plate.length < 8
          ? 'Enter the full car number (e.g. 01A123BC).'
          : null;
    });

    final hasError = [
      _nameError,
      _phoneError,
      _brandError,
      _modelError,
      _yearError,
      _kmError,
      _plateError,
    ].any((e) => e != null);

    if (hasError) return;

    // TODO: ma'lumotlarni serverga yuborish (hozircha update endpoint yo'q)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final models = _brand == null ? <String>[] : _brandModels[_brand] ?? [];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: PageBackgroundPainter()),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(title: 'ACCOUNT'),
                    const SizedBox(height: 10),
                    Text(
                      'Keep your contact details and car information up to date.',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 1-karta: shaxsiy ma'lumotlar
                    _FormCard(
                      children: [
                        _Field(
                          label: 'Full name',
                          controller: _nameCtrl,
                          hint: 'Alisherov Alisher',
                          errorText: _nameError,
                          onChanged: (_) {
                            if (_nameError != null) {
                              setState(() => _nameError = null);
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        _Field(
                          label: 'Phone number',
                          controller: _phoneCtrl,
                          hint: '(99) 928-48-14',
                          prefixText: '+998 ',
                          keyboardType: TextInputType.phone,
                          errorText: _phoneError,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          onChanged: (_) {
                            if (_phoneError != null) {
                              setState(() => _phoneError = null);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 2-karta: mashina ma'lumotlari
                    _FormCard(
                      children: [
                        _Dropdown<String>(
                          label: 'Brand',
                          hint: 'Select brand',
                          value: _brand,
                          items: _brandModels.keys.toList(),
                          itemLabel: (b) => b,
                          errorText: _brandError,
                          onChanged: (v) {
                            setState(() {
                              _brand = v;
                              _model = null; // brend o'zgarsa, model qayta tanlanadi
                              _brandError = null;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        _Dropdown<String>(
                          label: 'Model',
                          hint: 'Select model',
                          value: _model,
                          items: models,
                          itemLabel: (m) => m,
                          errorText: _modelError,
                          onChanged: (v) {
                            setState(() {
                              _model = v;
                              _modelError = null;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        _Dropdown<int>(
                          label: 'Car Year',
                          hint: 'Select year',
                          value: _year,
                          items: _years,
                          itemLabel: (y) => y.toString(),
                          errorText: _yearError,
                          onChanged: (v) {
                            setState(() {
                              _year = v;
                              _yearError = null;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        _Field(
                          label: 'Car reacher (km)',
                          controller: _kmCtrl,
                          hint: '12000',
                          keyboardType: TextInputType.number,
                          errorText: _kmError,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (_) {
                            if (_kmError != null) {
                              setState(() => _kmError = null);
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        _Field(
                          label: 'Car number',
                          controller: _plateCtrl,
                          hint: '01A123CD',
                          errorText: _plateError,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]')),
                            LengthLimitingTextInputFormatter(8),
                            TextInputFormatter.withFunction(
                                  (oldValue, newValue) => newValue.copyWith(
                                text: newValue.text.toUpperCase(),
                              ),
                            ),
                          ],
                          onChanged: (_) {
                            if (_plateError != null) {
                              setState(() => _plateError = null);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // X + Save tugmalari
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.5),
                              ),
                            ),
                            child: const Icon(Icons.close_rounded,
                                size: 20, color: _muted),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _teal,
                                foregroundColor: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(23),
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Oq karta
// ---------------------------------------------------------------------------
class _FormCard extends StatelessWidget {
  final List<Widget> children;

  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Umumiy input dekoratsiyasi
// ---------------------------------------------------------------------------
InputDecoration _decoration({
  String? hint,
  String? prefixText,
  String? errorText,
}) {
  OutlineInputBorder border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );

  return InputDecoration(
    isDense: true,
    hintText: hint,
    hintStyle: GoogleFonts.montserrat(fontSize: 11, color: _muted),
    prefixText: prefixText,
    prefixStyle: GoogleFonts.montserrat(fontSize: 12, color: _ink),
    errorText: errorText,
    errorMaxLines: 2,
    errorStyle: GoogleFonts.montserrat(fontSize: 10, color: _errorRed),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    enabledBorder: border(Colors.grey.withValues(alpha: 0.45)),
    focusedBorder: border(_teal),
    errorBorder: border(_errorRed),
    focusedErrorBorder: border(_errorRed),
  );
}

Widget _label(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 6),
  child: Text(
    text,
    style: GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: _ink,
    ),
  ),
);

// ---------------------------------------------------------------------------
// Matn kiritish maydoni
// ---------------------------------------------------------------------------
class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? prefixText;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const _Field({
    required this.label,
    required this.controller,
    required this.hint,
    this.prefixText,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          cursorColor: _teal,
          style: GoogleFonts.montserrat(fontSize: 12, color: _ink),
          decoration: _decoration(
            hint: hint,
            prefixText: prefixText,
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tanlash (dropdown) maydoni
// ---------------------------------------------------------------------------
class _Dropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final String? errorText;
  final ValueChanged<T?> onChanged;

  const _Dropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        InputDecorator(
          decoration: _decoration(errorText: errorText).copyWith(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              isDense: false,
              borderRadius: BorderRadius.circular(12),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: _ink),
              hint: Text(
                hint,
                style: GoogleFonts.montserrat(fontSize: 11, color: _ink),
              ),
              style: GoogleFonts.montserrat(fontSize: 12, color: _ink),
              items: items
                  .map(
                    (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(itemLabel(e)),
                ),
              )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}