import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/share_preference/share_preference.dart';
import 'package:cam_id/main/ui/language/language_bloc.dart';
import 'package:cam_id/main/ui/language/language_event.dart';
import 'package:cam_id/main/utils/logger.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});
  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String currentLang = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang =
    await SharePreferenceUtil.getString(ShareKey.KEY_CHANGE_LANGUAGE, defaultValue: 'vi');
    if (!mounted) return;
    AppLogger().logInfo("Language: $lang");
    setState(() {
      currentLang = lang;
    });
  }

  void _changeLanguage(String langCode) {
    context.read<LanguageBloc>().add(ChangeLanguageEvent(Locale(langCode)));

    setState(() {
      currentLang = langCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.colorMain,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: kToolbarHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.language,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                LanguageItemButton(
                  title: AppLocalizations.of(context)!.english,
                  assetFlag: 'assets/icons/ic_en.png',
                  isSelected: currentLang == 'en',
                  onTap: () => _changeLanguage('en'),
                ),
                const SizedBox(height: 12),
                LanguageItemButton(
                  title: AppLocalizations.of(context)!.vietnamese,
                  assetFlag: 'assets/icons/ic_vn.png',
                  isSelected: currentLang == 'vi',
                  onTap: () => _changeLanguage('vi'),
                ),
                const SizedBox(height: 12),
                LanguageItemButton(
                  title: AppLocalizations.of(context)!.khmer,
                  assetFlag: 'assets/icons/ic_km.png',
                  isSelected: currentLang == 'km',
                  onTap: () => _changeLanguage('km'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageItemButton extends StatelessWidget {
  final String title;
  final String assetFlag;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageItemButton({
    super.key,
    required this.title,
    required this.assetFlag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(assetFlag, width: 32, height: 22, fit: BoxFit.cover),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check, color: Colors.green[800]),
          ],
        ),
      ),
    );
  }
}
