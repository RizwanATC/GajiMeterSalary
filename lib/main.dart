import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  runApp(const GajiMeterApp());
}

class AppThemeModel {
  final String name;
  final Color swatch;
  final ThemeData data;
  const AppThemeModel({required this.name, required this.swatch, required this.data});
}

class AppThemes {
  static final List<AppThemeModel> all = [
    AppThemeModel(
      name: 'Dark Blue', swatch: const Color(0xFF3B82F6),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E40AF), brightness: Brightness.dark, primary: const Color(0xFF3B82F6), secondary: const Color(0xFF60A5FA), surface: const Color(0xFF0F172A), onSurface: const Color(0xFFF1F5F9))),
    ),
    AppThemeModel(
      name: 'Purple', swatch: const Color(0xFF8B5CF6),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B21B6), brightness: Brightness.dark, primary: const Color(0xFF8B5CF6), secondary: const Color(0xFFA78BFA), surface: const Color(0xFF1A0F2E), onSurface: const Color(0xFFF5F3FF))),
    ),
    AppThemeModel(
      name: 'Pearl', swatch: const Color(0xFF64748B),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF64748B), brightness: Brightness.light, primary: const Color(0xFF475569), secondary: const Color(0xFF94A3B8), surface: Colors.white, onSurface: const Color(0xFF1E293B))),
    ),
    AppThemeModel(
      name: 'Emerald Green', swatch: const Color(0xFF10B981),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF064E3B), brightness: Brightness.dark, primary: const Color(0xFF10B981), secondary: const Color(0xFF34D399), surface: const Color(0xFF0A1F18), onSurface: const Color(0xFFF0FDF9))),
    ),
    AppThemeModel(
      name: 'Soft Pink', swatch: const Color(0xFFEC4899),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFBE185D), brightness: Brightness.light, primary: const Color(0xFFEC4899), secondary: const Color(0xFFF472B6), surface: Colors.white, onSurface: const Color(0xFF1F2937))),
    ),
    AppThemeModel(
      name: 'Midnight Black', swatch: const Color(0xFF334155),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E293B), brightness: Brightness.dark, primary: const Color(0xFFCBD5E1), secondary: const Color(0xFF94A3B8), surface: const Color(0xFF0A0A0A), onSurface: const Color(0xFFF8FAFC))),
    ),
    AppThemeModel(
      name: 'Cream Beige', swatch: const Color(0xFFD97706),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB45309), brightness: Brightness.light, primary: const Color(0xFFD97706), secondary: const Color(0xFFF59E0B), surface: const Color(0xFFFFFDF7), onSurface: const Color(0xFF1C1917))),
    ),
    AppThemeModel(
      name: 'Sky Blue', swatch: const Color(0xFF0EA5E9),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0284C7), brightness: Brightness.light, primary: const Color(0xFF0EA5E9), secondary: const Color(0xFF38BDF8), surface: Colors.white, onSurface: const Color(0xFF0C4A6E))),
    ),
    AppThemeModel(
      name: 'Lavender', swatch: const Color(0xFF7C3AED),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4C1D95), brightness: Brightness.light, primary: const Color(0xFF7C3AED), secondary: const Color(0xFF8B5CF6), surface: Colors.white, onSurface: const Color(0xFF1E1B4B))),
    ),
    AppThemeModel(
      name: 'Rose Gold', swatch: const Color(0xFFB5607A),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9D174D), brightness: Brightness.light, primary: const Color(0xFFB5607A), secondary: const Color(0xFFD4846E), surface: Colors.white, onSurface: const Color(0xFF1A0A0E))),
    ),
  ];
}

class AppStrings {
  static String get(String langKey, String key) {
    final map = _all[langKey] ?? _all['ms']!;
    return map[key] ?? (_all['ms']![key] ?? key);
  }

  static const _all = {
    'en': {
      'nav_tracker': 'Tracker', 'nav_expenses': 'Expenses', 'nav_history': 'History', 'nav_settings': 'Settings',
      'app_title': 'GajiMeter', 'app_subtitle': 'Real-time value tracker',
      'status_working': 'Working now', 'status_paused': 'Paused', 'status_ready': 'Ready',
      'label_earned_session': 'EARNED THIS SESSION', 'label_per_sec': '/ sec',
      'label_daily_target': '% of daily target',
      'stat_hourly': 'Hourly', 'stat_minute': 'Minute',
      'label_monthly_outlook': 'MONTHLY OUTLOOK', 'label_expenses_bar': 'EXPENSES', 'label_full_gaji': 'FULL SALARY',
      'label_earnings': 'Earnings', 'label_expenses': 'Expenses',
      'msg_breakeven': 'BREAK-EVEN ACHIEVED!',
      'label_config': 'CONFIGURATION',
      'btn_start': 'START WORKING', 'btn_pause': 'PAUSE SESSION', 'btn_reset': 'RESET',
      'expenses_title': 'Expenses', 'expenses_subtitle': 'Track your commitments',
      'label_monthly_total': 'MONTHLY TOTAL EXPENSES',
      'empty_expenses': 'No monthly expenses pinned',
      'see_more': 'See More', 'see_less': 'See Less',
      'add_expense': 'Add Expense',
      'my_expenses': 'My Expenses', 'total_monthly': 'TOTAL MONTHLY',
      'empty_no_expenses': 'No expenses yet', 'empty_hint': 'Tap Add Expense below to get started',
      'form_title_add': 'Add Expense', 'form_title_edit': 'Edit Expense',
      'label_category': 'Category', 'label_type': 'Type', 'label_detail': 'Detail',
      'field_description': 'Description', 'field_amount': 'Amount (RM)', 'field_months': 'Duration (Months)',
      'btn_save': 'Save',
      'card_budget_title': 'Monthly Budget Formula',
      'btn_change': 'Change', 'sheet_pick_formula': 'Select Formula',
      'net_salary_prefix': 'Net salary after KWSP 11%:',
      'enter_salary_hint': 'Enter salary to see breakdown',
      'bucket_komitmen': 'Commitment', 'bucket_makan': 'Food', 'bucket_spend': 'Spend', 'bucket_saving': 'Saving',
      'formula_balanced': 'Balanced', 'formula_balanced_desc': 'Most balanced & realistic',
      'formula_saving': 'Saving Mode', 'formula_saving_desc': 'Save money fast',
      'formula_commitment': 'Commitment Heavy', 'formula_commitment_desc': 'Many bills/loans',
      'formula_lifestyle': 'Lifestyle Friendly', 'formula_lifestyle_desc': 'Enjoy but still save',
      'formula_strict': 'Strict Budget', 'formula_strict_desc': 'Control spending tightly',
      'history_title': 'Work History', 'history_subtitle': 'Your completed sessions',
      'empty_history': 'No history yet',
      'settings_title': 'Settings',
      'section_theme': 'Theme', 'section_language': 'Language',
      'lang_standard': 'Standard', 'lang_dialect': 'Local Dialect Mode',
      'section_data': 'Data Management', 'section_about': 'About',
      'clear_history': 'Clear History', 'clear_history_sub': 'Remove all session records',
      'clear_expenses': 'Clear Expenses', 'clear_expenses_sub': 'Remove all pinned expenses',
      'reset_all': 'Reset All Data', 'reset_all_sub': 'Clear everything and start fresh',
      'app_version': 'App Version', 'rate_app': 'Rate GajiMeter', 'rate_app_sub': 'Love the app? Leave a review',
      'privacy': 'Privacy Policy', 'privacy_sub': 'How we handle your data',
      'about_app': 'About GajiMeter', 'about_sub': 'Built for Malaysian workers',
      'btn_cancel': 'Cancel', 'btn_delete': 'Delete',
    },
    'ms': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanja', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Penjejak nilai masa nyata',
      'status_working': 'Sedang bekerja', 'status_paused': 'Dijeda', 'status_ready': 'Bersedia',
      'label_earned_session': 'DIPEROLEH SESI INI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripada sasaran harian',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANAN', 'label_expenses_bar': 'BELANJA', 'label_full_gaji': 'PENUH GAJI',
      'label_earnings': 'Pendapatan', 'label_expenses': 'Belanja',
      'msg_breakeven': 'TITIK PULANG MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULA BEKERJA', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULA',
      'expenses_title': 'Perbelanjaan', 'expenses_subtitle': 'Jejak komitmen anda',
      'label_monthly_total': 'JUMLAH PERBELANJAAN BULANAN',
      'empty_expenses': 'Tiada perbelanjaan bulanan disematkan',
      'see_more': 'Lihat Lagi', 'see_less': 'Lihat Kurang',
      'add_expense': 'Tambah Belanja',
      'my_expenses': 'Belanja Saya', 'total_monthly': 'JUMLAH BULANAN',
      'empty_no_expenses': 'Tiada belanja lagi', 'empty_hint': 'Tekan Tambah Belanja untuk mulakan',
      'form_title_add': 'Tambah Belanja', 'form_title_edit': 'Edit Belanja',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butiran',
      'field_description': 'Penerangan', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpan',
      'card_budget_title': 'Formula Budget Bulanan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih selepas KWSP 11%:',
      'enter_salary_hint': 'Masukkan gaji untuk lihat pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makan', 'bucket_spend': 'Boleh Spend', 'bucket_saving': 'Saving',
      'formula_balanced': 'Balanced', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Saving Mode', 'formula_saving_desc': 'Nak cepat kumpul duit',
      'formula_commitment': 'Commitment Heavy', 'formula_commitment_desc': 'Kalau banyak bil/loan',
      'formula_lifestyle': 'Lifestyle Friendly', 'formula_lifestyle_desc': 'Nak enjoy tapi masih saving',
      'formula_strict': 'Strict Budget', 'formula_strict_desc': 'Nak control spending ketat',
      'history_title': 'Sejarah Kerja', 'history_subtitle': 'Sesi yang telah selesai',
      'empty_history': 'Tiada sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahasa',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek Tempatan',
      'section_data': 'Pengurusan Data', 'section_about': 'Tentang',
      'clear_history': 'Padam Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Padam Belanja', 'clear_expenses_sub': 'Buang semua belanja disematkan',
      'reset_all': 'Set Semula Semua Data', 'reset_all_sub': 'Padam semua dan mulakan semula',
      'app_version': 'Versi Aplikasi', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suka aplikasi ini? Bagi ulasan',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Cara kami uruskan data anda',
      'about_app': 'Tentang GajiMeter', 'about_sub': 'Dibina untuk pekerja Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padam',
    },
    'kelantan': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanje', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapang',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit demo masa nyata',
      'status_working': 'Tengah kijo', 'status_paused': 'Berhenti jap', 'status_ready': 'Sedia',
      'label_earned_session': 'DUIT DAPAT SESI NI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripada sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANG', 'label_expenses_bar': 'BELANJE', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapate', 'label_expenses': 'Belanje',
      'msg_breakeven': 'DAH BALIK MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULO KIJO', 'btn_pause': 'REHAT JE', 'btn_reset': 'TETAPKE SEMULO',
      'expenses_title': 'Belanje', 'expenses_subtitle': 'Jejak komitmen demo',
      'label_monthly_total': 'JUMLAH BELANJE BULANG',
      'empty_expenses': 'Takdok belanje bulan ni',
      'see_more': 'Tengok Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tamboh Belanje',
      'my_expenses': 'Belanje Demo', 'total_monthly': 'JUMLAH BULANG',
      'empty_no_expenses': 'Takdok belanje lagi', 'empty_hint': 'Tekan Tamboh Belanje untuk mulo',
      'form_title_add': 'Tamboh Belanje', 'form_title_edit': 'Edit Belanje',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butire',
      'field_description': 'Huraie', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpang',
      'card_budget_title': 'Formula Budget Bulang',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji demo tengok pecahang',
      'bucket_komitmen': 'Komitmeng', 'bucket_makan': 'Makae', 'bucket_spend': 'Boleh Belanje', 'bucket_saving': 'Simpang',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpang', 'formula_saving_desc': 'Nok cepak kumpul duit',
      'formula_commitment': 'Banyok Komitmeng', 'formula_commitment_desc': 'Kalu banyok bil/loan',
      'formula_lifestyle': 'Suko Enjoy', 'formula_lifestyle_desc': 'Nok enjoy tapi still simpang',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nok kontrol belanje ketat',
      'history_title': 'Sejarah Kijo', 'history_subtitle': 'Sesi demo yang dah habih',
      'empty_history': 'Takdok sejarah lagi',
      'settings_title': 'Tetapang',
      'section_theme': 'Tema', 'section_language': 'Bahaso',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Buang Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Buang Belanje', 'clear_expenses_sub': 'Buang semua belanje',
      'reset_all': 'Set Semulo Semua', 'reset_all_sub': 'Padam habih mulo balik',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suko dak? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mano kito jago data demo',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pekerjo Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Buang',
    },
    'terengganu': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanje', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit awok masa nyata',
      'status_working': 'Tengah kerje', 'status_paused': 'Berehat jap', 'status_ready': 'Sedia',
      'label_earned_session': 'DUIT DAPAT SESI NI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripade sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANE', 'label_expenses_bar': 'BELANJE', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapate', 'label_expenses': 'Belanje',
      'msg_breakeven': 'DAH BALIK MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULO KERJE', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULE',
      'expenses_title': 'Belanje', 'expenses_subtitle': 'Jejak komitmen awok',
      'label_monthly_total': 'JUMLAH BELANJE BULAN NI',
      'empty_expenses': 'Takde belanje bulan ni',
      'see_more': 'Tengok Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tamboh Belanje',
      'my_expenses': 'Belanje Sayo', 'total_monthly': 'JUMLAH BULANE',
      'empty_no_expenses': 'Takde belanje lagi', 'empty_hint': 'Tekan Tamboh Belanje untuk mulo',
      'form_title_add': 'Tamboh Belanje', 'form_title_edit': 'Edit Belanje',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butire',
      'field_description': 'Huraie', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpa',
      'card_budget_title': 'Formula Budget Bulan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji untuk tengok pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makae', 'bucket_spend': 'Boleh Belanje', 'bucket_saving': 'Simpan',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpan', 'formula_saving_desc': 'Nok cepat kumpul duit',
      'formula_commitment': 'Banyok Komitmen', 'formula_commitment_desc': 'Kalu banyok bil/loan',
      'formula_lifestyle': 'Suke Enjoy', 'formula_lifestyle_desc': 'Nok enjoy tapi still simpan',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nok kontrol belanje ketat',
      'history_title': 'Sejarah Kerje', 'history_subtitle': 'Sesi awok yang dah selesai',
      'empty_history': 'Takde sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahase',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Padam Sejarah', 'clear_history_sub': 'Buang semue rekod sesi',
      'clear_expenses': 'Padam Belanje', 'clear_expenses_sub': 'Buang semue belanje',
      'reset_all': 'Set Semule Semue', 'reset_all_sub': 'Padam habis mule balik',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suke dak? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mane kite jage data awok',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pekerje Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padam',
    },
    'ns': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanja', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit den masa nyata',
      'status_working': 'Tengah kojo', 'status_paused': 'Berehat jap', 'status_ready': 'Sedia',
      'label_earned_session': 'DUIT DAPAT SESI NI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripado sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANO', 'label_expenses_bar': 'BELANJA', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapatan', 'label_expenses': 'Belanja',
      'msg_breakeven': 'DAH BALIK MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULO KOJO', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULO',
      'expenses_title': 'Belanja', 'expenses_subtitle': 'Jejak komitmen den',
      'label_monthly_total': 'JUMLAH BELANJA BULAN NI',
      'empty_expenses': 'Tak ado belanja bulan ni',
      'see_more': 'Tengok Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tambah Belanja',
      'my_expenses': 'Belanja Den', 'total_monthly': 'JUMLAH BULANO',
      'empty_no_expenses': 'Tak ado belanja lagi', 'empty_hint': 'Tekan Tambah Belanja untuk mulo',
      'form_title_add': 'Tambah Belanja', 'form_title_edit': 'Edit Belanja',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butiran',
      'field_description': 'Huraian', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpan',
      'card_budget_title': 'Formula Budget Bulan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji untuk tengok pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makan', 'bucket_spend': 'Boleh Belanja', 'bucket_saving': 'Simpan',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpan', 'formula_saving_desc': 'Nak cepat kumpul duit',
      'formula_commitment': 'Banyak Komitmen', 'formula_commitment_desc': 'Kalu banyak bil/loan',
      'formula_lifestyle': 'Suko Enjoy', 'formula_lifestyle_desc': 'Nak enjoy tapi masih simpan',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nak kontrol belanja ketat',
      'history_title': 'Sejarah Kojo', 'history_subtitle': 'Sesi den yang dah selesai',
      'empty_history': 'Tak ado sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahasa',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Padam Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Padam Belanja', 'clear_expenses_sub': 'Buang semua belanja',
      'reset_all': 'Set Semulo Semua', 'reset_all_sub': 'Padam habis mulo balik',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suko tak? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mano kito jago data den',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pokerjo Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padam',
    },
    'utara': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanja', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit hang masa nyata',
      'status_working': 'Tengah kerja', 'status_paused': 'Berehat jap', 'status_ready': 'Sedia',
      'label_earned_session': 'DUIT DAPAT SESI NI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripada sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANAN', 'label_expenses_bar': 'BELANJA', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapatan', 'label_expenses': 'Belanja',
      'msg_breakeven': 'DAH BALIK MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULA KERJA', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULA',
      'expenses_title': 'Belanja', 'expenses_subtitle': 'Jejak komitmen hang',
      'label_monthly_total': 'JUMLAH BELANJA BULAN NI',
      'empty_expenses': 'Dok ada belanja bulan ni',
      'see_more': 'Tengok Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tambah Belanja',
      'my_expenses': 'Belanja Hang', 'total_monthly': 'JUMLAH BULANAN',
      'empty_no_expenses': 'Dok ada belanja lagi', 'empty_hint': 'Tekan Tambah Belanja untuk mula',
      'form_title_add': 'Tambah Belanja', 'form_title_edit': 'Edit Belanja',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butiran',
      'field_description': 'Huraian', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpan',
      'card_budget_title': 'Formula Budget Bulan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji untuk tengok pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makan', 'bucket_spend': 'Boleh Belanja', 'bucket_saving': 'Simpan',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpan', 'formula_saving_desc': 'Nak cepat kumpul duit',
      'formula_commitment': 'Banyak Komitmen', 'formula_commitment_desc': 'Kalu banyak bil/loan',
      'formula_lifestyle': 'Suka Enjoy', 'formula_lifestyle_desc': 'Nak enjoy tapi still simpan',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nak kontrol belanja ketat',
      'history_title': 'Sejarah Kerja', 'history_subtitle': 'Sesi hang yang dah selesai',
      'empty_history': 'Dok ada sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahasa',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Padam Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Padam Belanja', 'clear_expenses_sub': 'Buang semua belanja',
      'reset_all': 'Set Semula Semua', 'reset_all_sub': 'Padam habis mula balik',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suka dok? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mana kita jaga data hang',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pekerja Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padam',
    },
    'sarawak': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanja', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit kitak masa nyata',
      'status_working': 'Tengah kerja', 'status_paused': 'Berehat jap', 'status_ready': 'Sedia',
      'label_earned_session': 'DUIT DAPAT SESI TOK', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripada sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULAN TOK', 'label_expenses_bar': 'BELANJA', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapatan', 'label_expenses': 'Belanja',
      'msg_breakeven': 'DAH BALIK MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULA KERJA', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULA',
      'expenses_title': 'Belanja', 'expenses_subtitle': 'Jejak komitmen kitak',
      'label_monthly_total': 'JUMLAH BELANJA BULAN TOK',
      'empty_expenses': 'Sik ada belanja bulan tok',
      'see_more': 'Nangga Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tambah Belanja',
      'my_expenses': 'Belanja Kitak', 'total_monthly': 'JUMLAH BULAN TOK',
      'empty_no_expenses': 'Sik ada belanja lagi', 'empty_hint': 'Tekan Tambah Belanja untuk mula',
      'form_title_add': 'Tambah Belanja', 'form_title_edit': 'Edit Belanja',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butiran',
      'field_description': 'Huraian', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpan',
      'card_budget_title': 'Formula Budget Bulan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji untuk nangga pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makan', 'bucket_spend': 'Boleh Belanja', 'bucket_saving': 'Simpan',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpan', 'formula_saving_desc': 'Nak cepat kumpul duit',
      'formula_commitment': 'Banyak Komitmen', 'formula_commitment_desc': 'Kalu banyak bil/loan',
      'formula_lifestyle': 'Suka Enjoy', 'formula_lifestyle_desc': 'Nak enjoy tapi still simpan',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nak kontrol belanja ketat',
      'history_title': 'Sejarah Kerja', 'history_subtitle': 'Sesi kitak yang dah selesai',
      'empty_history': 'Sik ada sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahasa',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Padamka Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Padamka Belanja', 'clear_expenses_sub': 'Buang semua belanja',
      'reset_all': 'Set Semula Semua', 'reset_all_sub': 'Padam habis mula balit',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suka sik? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mana kitai jaga data kitak',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pekerja Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padamka',
    },
    'sabah': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanja', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit ko masa nyata',
      'status_working': 'Tengah kerja bah', 'status_paused': 'Berehat jap', 'status_ready': 'Sedia bah',
      'label_earned_session': 'DUIT DAPAT SESI NI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripada sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANAN', 'label_expenses_bar': 'BELANJA', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapatan', 'label_expenses': 'Belanja',
      'msg_breakeven': 'DAH BALIK MODAL BAH!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULA KERJA BAH', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULA',
      'expenses_title': 'Belanja', 'expenses_subtitle': 'Jejak komitmen ko',
      'label_monthly_total': 'JUMLAH BELANJA BULAN NI',
      'empty_expenses': 'Nda ada belanja bulan ni',
      'see_more': 'Tengok Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tambah Belanja',
      'my_expenses': 'Belanja Ko', 'total_monthly': 'JUMLAH BULANAN',
      'empty_no_expenses': 'Nda ada belanja lagi', 'empty_hint': 'Tekan Tambah Belanja untuk mula bah',
      'form_title_add': 'Tambah Belanja', 'form_title_edit': 'Edit Belanja',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butiran',
      'field_description': 'Huraian', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpan',
      'card_budget_title': 'Formula Budget Bulan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji untuk tengok pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makan', 'bucket_spend': 'Boleh Belanja', 'bucket_saving': 'Simpan',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpan', 'formula_saving_desc': 'Nak cepat kumpul duit',
      'formula_commitment': 'Banyak Komitmen', 'formula_commitment_desc': 'Kalu banyak bil/loan',
      'formula_lifestyle': 'Suka Enjoy', 'formula_lifestyle_desc': 'Nak enjoy tapi still simpan',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nak kontrol belanja ketat',
      'history_title': 'Sejarah Kerja', 'history_subtitle': 'Sesi ko yang dah selesai',
      'empty_history': 'Nda ada sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahasa',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Padam Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Padam Belanja', 'clear_expenses_sub': 'Buang semua belanja',
      'reset_all': 'Set Semula Semua', 'reset_all_sub': 'Padam habis mula balik',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suka bah? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mana kami jaga data ko',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pekerja Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padam',
    },
  };
}

class AppLang extends InheritedWidget {
  final String langKey;
  final Function(String) onChanged;

  const AppLang({super.key, required this.langKey, required this.onChanged, required super.child});

  static AppLang of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppLang>()!;

  String t(String key) => AppStrings.get(langKey, key);

  @override
  bool updateShouldNotify(AppLang old) => langKey != old.langKey;
}

class GajiMeterApp extends StatefulWidget {
  const GajiMeterApp({super.key});

  @override
  State<GajiMeterApp> createState() => _GajiMeterAppState();
}

class _GajiMeterAppState extends State<GajiMeterApp> {
  int _themeIndex = 3; // default: Emerald Green
  String _langKey = 'ms';

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadLang();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt('themeIndex') ?? 3;
    setState(() => _themeIndex = saved.clamp(0, AppThemes.all.length - 1));
  }

  void _setTheme(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeIndex', index);
    setState(() => _themeIndex = index);
  }

  Future<void> _loadLang() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('langKey') ?? 'ms';
    setState(() => _langKey = saved);
  }

  void _setLang(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('langKey', key);
    setState(() => _langKey = key);
  }

  @override
  Widget build(BuildContext context) {
    return AppLang(
      langKey: _langKey,
      onChanged: _setLang,
      child: MaterialApp(
        title: 'GajiMeter',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: AppThemes.all[_themeIndex].data,
        home: MainScaffold(onThemeChanged: _setTheme, themeIndex: _themeIndex),
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  final Function(int) onThemeChanged;
  final int themeIndex;

  const MainScaffold({super.key, required this.onThemeChanged, required this.themeIndex});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  bool _isInitialized = false;
  bool _isSetupComplete = false;
  bool _adFlowComplete = false;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  final TextEditingController _salaryController = TextEditingController(text: "");
  final TextEditingController _daysController = TextEditingController(text: "20");
  final TextEditingController _hoursController = TextEditingController(text: "8");
  
  int _savedElapsedMillis = 0;
  int _sessionStartMillis = 0;
  bool _isTracking = false;
  List<WorkSession> _history = [];
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedInterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-5978067529669035/5766780268'
          : 'ca-app-pub-3940256099942544/5354046379',
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdMob: Rewarded Interstitial Ad loaded.');
          _rewardedInterstitialAd = ad;
          
          _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              setState(() => _adFlowComplete = true);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              setState(() => _adFlowComplete = true);
            },
          );
          
          _showRewardedAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('AdMob: Rewarded Interstitial failed to load: $error');
          setState(() => _adFlowComplete = true);
        },
      ),
    );

    // Safety timeout: proceed after 8s if ad isn't ready
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && !_adFlowComplete) {
        setState(() => _adFlowComplete = true);
      }
    });
  }

  void _showRewardedAd() {
    if (_rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          debugPrint('AdMob: User earned reward: ${reward.amount} ${reward.type}');
        },
      );
    }
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSalary = prefs.getString('salary');
    final savedDays = prefs.getString('days');
    final savedHours = prefs.getString('hours');
    final savedEarnings = prefs.getInt('savedElapsedMillis');
    final savedSessionStart = prefs.getInt('sessionStartMillis');
    final savedIsTracking = prefs.getBool('isTracking') ?? false;
    final savedHistoryJson = prefs.getString('history');
    final savedExpensesJson = prefs.getString('expenses');
    final savedSetupComplete = prefs.getBool('isSetupComplete') ?? false;

    if (mounted) {
      setState(() {
        if (savedSalary != null) _salaryController.text = savedSalary;
        if (savedDays != null) _daysController.text = savedDays;
        if (savedHours != null) _hoursController.text = savedHours;
        if (savedEarnings != null) _savedElapsedMillis = savedEarnings;
        if (savedSessionStart != null) _sessionStartMillis = savedSessionStart;
        _isTracking = savedIsTracking;
        _isSetupComplete = savedSetupComplete;
        
        if (savedHistoryJson != null) {
          try {
            final List<dynamic> decoded = jsonDecode(savedHistoryJson);
            _history = decoded.map((item) => WorkSession.fromJson(item)).toList();
          } catch (_) {}
        }

        if (savedExpensesJson != null) {
          try {
            final List<dynamic> decoded = jsonDecode(savedExpensesJson);
            _expenses = decoded.map((item) => Expense.fromJson(item)).toList();
          } catch (_) {}
        }
        
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _rewardedInterstitialAd?.dispose();
    super.dispose();
  }

  Future<void> _saveGlobalData({
    int? currentElapsed,
    bool? isTracking,
    int? sessionStart,
    List<WorkSession>? history,
    List<Expense>? expenses,
    bool? isSetupComplete,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('salary', _salaryController.text);
    await prefs.setString('days', _daysController.text);
    await prefs.setString('hours', _hoursController.text);
    
    if (currentElapsed != null) await prefs.setInt('savedElapsedMillis', currentElapsed);
    if (sessionStart != null) await prefs.setInt('sessionStartMillis', sessionStart);
    if (isTracking != null) await prefs.setBool('isTracking', isTracking);
    if (isSetupComplete != null) await prefs.setBool('isSetupComplete', isSetupComplete);
    
    if (history != null) {
      await prefs.setString('history', jsonEncode(history.map((e) => e.toJson()).toList()));
      setState(() => _history = history);
    }

    if (expenses != null) {
      await prefs.setString('expenses', jsonEncode(expenses.map((e) => e.toJson()).toList()));
      setState(() => _expenses = expenses);
    }

    setState(() {
      if (currentElapsed != null) _savedElapsedMillis = currentElapsed;
      if (isTracking != null) _isTracking = isTracking;
      if (sessionStart != null) _sessionStartMillis = sessionStart;
      if (isSetupComplete != null) _isSetupComplete = isSetupComplete;
    });
  }

  void _addToHistory(double amount, int durationMillis) {
    if (amount <= 0) return;
    final newSession = WorkSession(
      date: DateTime.now(),
      amount: amount,
      durationMillis: durationMillis,
    );
    final updatedHistory = [newSession, ..._history];
    _saveGlobalData(history: updatedHistory);
  }

  void _onAddOrUpdateExpense(Expense expense) {
    setState(() {
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
      } else {
        _expenses.insert(0, expense);
      }
      _saveGlobalData(expenses: _expenses);
    });
  }

  void _onAddMultipleExpenses(List<Expense> newExpenses) {
    setState(() {
      _expenses.addAll(newExpenses);
      _saveGlobalData(expenses: _expenses);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // SHOW SPLASH SCREEN AS A LOADING GUARD
    if (!_isInitialized || !_adFlowComplete) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.analytics_rounded, size: 64, color: Color(0xFF10B981)),
              ),
              const SizedBox(height: 24),
              const Text(
                "GajiMeter",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Color(0xFF10B981),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Loading your workspace...",
                style: TextStyle(
                  color: Colors.grey.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isSetupComplete) {
      return SetupWizard(
        salaryController: _salaryController,
        expenses: _expenses,
        onAddExpense: _onAddOrUpdateExpense,
        onDeleteExpense: (index) {
          final updatedExpenses = List<Expense>.from(_expenses)..removeAt(index);
          _saveGlobalData(expenses: updatedExpenses);
        },
        onComplete: () => _saveGlobalData(isSetupComplete: true),
      );
    }

    final List<Widget> screens = [
      SalaryTrackerScreen(
        salaryController: _salaryController,
        daysController: _daysController,
        hoursController: _hoursController,
        initialSavedMillis: _savedElapsedMillis,
        initialSessionStart: _sessionStartMillis,
        initialIsTracking: _isTracking,
        totalExpenses: _expenses.fold(0.0, (sum, item) => sum + item.amount),
        onSave: (elapsed, isTracking, start) => _saveGlobalData(
          currentElapsed: elapsed,
          isTracking: isTracking,
          sessionStart: start,
        ),
        onSessionEnd: _addToHistory,
      ),
      ExpenseScreen(
        expenses: _expenses,
        salary: double.tryParse(_salaryController.text) ?? 0,
        onAdd: _onAddOrUpdateExpense,
        onDelete: (index) {
          final updatedExpenses = List<Expense>.from(_expenses)..removeAt(index);
          _saveGlobalData(expenses: updatedExpenses);
        },
        onClear: () => _saveGlobalData(expenses: []),
      ),
      HistoryScreen(history: _history, onClear: () => _saveGlobalData(history: [])),
      SettingsScreen(
        themeIndex: widget.themeIndex,
        onThemeChanged: widget.onThemeChanged,
        onClearHistory: () => _saveGlobalData(history: []),
        onClearExpenses: () => _saveGlobalData(expenses: []),
        onClearAll: () {
          _saveGlobalData(history: [], expenses: []);
          setState(() {
            _salaryController.text = '';
            _daysController.text = '20';
            _hoursController.text = '8';
          });
        },
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: GlassBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class GlassBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const GlassBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      height: 72,
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.08 : 0.05),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Builder(
                builder: (context) {
                  final lang = AppLang.of(context);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavBarItem(
                        icon: Icons.analytics_rounded,
                        label: lang.t('nav_tracker'),
                        isSelected: selectedIndex == 0,
                        onTap: () => onItemSelected(0),
                      ),
                      _NavBarItem(
                        icon: Icons.receipt_long_rounded,
                        label: lang.t('nav_expenses'),
                        isSelected: selectedIndex == 1,
                        onTap: () => onItemSelected(1),
                      ),
                      _NavBarItem(
                        icon: Icons.history_rounded,
                        label: lang.t('nav_history'),
                        isSelected: selectedIndex == 2,
                        onTap: () => onItemSelected(2),
                      ),
                      _NavBarItem(
                        icon: Icons.settings_rounded,
                        label: lang.t('nav_settings'),
                        isSelected: selectedIndex == 3,
                        onTap: () => onItemSelected(3),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SetupWizard extends StatefulWidget {
  final TextEditingController salaryController;
  final List<Expense> expenses;
  final Function(Expense) onAddExpense;
  final Function(int) onDeleteExpense;
  final VoidCallback onComplete;

  const SetupWizard({
    super.key,
    required this.salaryController,
    required this.expenses,
    required this.onAddExpense,
    required this.onDeleteExpense,
    required this.onComplete,
  });

  @override
  State<SetupWizard> createState() => _SetupWizardState();
}

class _SetupWizardState extends State<SetupWizard> {
  int _step = 0; // 0: Salary, 1: Expenses

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                _step == 0 ? "Berapa gaji bersih anda?" : "Pin Monthly Expenses",
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.5),
              ),
              const SizedBox(height: 8),
              Text(
                _step == 0 
                  ? "Sila masukkan jumlah gaji selepas potongan (EPF, SOCSO, Tax)." 
                  : "Sila masukkan semua komitmen bulanan tetap anda.",
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 48),
              
              if (_step == 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3), width: 2),
                  ),
                  child: TextField(
                    controller: widget.salaryController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                    decoration: const InputDecoration(
                      labelText: "Gaji Bersih (RM)",
                      border: InputBorder.none,
                      prefixText: "RM ",
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      if (double.tryParse(widget.salaryController.text) != null) {
                        setState(() => _step = 1);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("NEXT: FILL EXPENSES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                ),
              ] else ...[
                // Unified Pinned Card in Setup
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.push_pin_rounded, color: Colors.white, size: 32),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "MONTHLY TOTAL EXPENSES",
                                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: 1.2),
                                ),
                                Text(
                                  currencyFormat.format(widget.expenses.fold(0.0, (sum, item) => sum + item.amount)),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(color: Colors.white24, height: 1),
                        ),
                        Expanded(
                          child: widget.expenses.isEmpty
                              ? const Center(
                                  child: Text("No items pinned yet", style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w500)),
                                )
                              : ListView.builder(
                                  itemCount: widget.expenses.length,
                                  itemBuilder: (context, index) {
                                    final exp = widget.expenses[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                                    children: [
                                                      TextSpan(text: exp.description, style: const TextStyle(fontWeight: FontWeight.w800)),
                                                      TextSpan(
                                                        text: " ( ${exp.category}${exp.subCategory != null ? ' | ${exp.subCategory}' : ''}${exp.months != null ? ' | ${exp.months} Month' : ''} )",
                                                        style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  currencyFormat.format(exp.amount),
                                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white70),
                                                onPressed: () => _showAddExpenseDialog(context, widget.onAddExpense, expense: exp),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                              const SizedBox(width: 12),
                                              IconButton(
                                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.white70),
                                                onPressed: () => widget.onDeleteExpense(index),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => _showAddDialog(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text("ADD MONTHLY EXPENSE", style: TextStyle(fontWeight: FontWeight.w800)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: widget.expenses.isNotEmpty ? widget.onComplete : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      disabledBackgroundColor: Colors.grey.withValues(alpha: 0.2),
                    ),
                    child: const Text("FINISH & PIN ALL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    _showAddExpenseDialog(context, widget.onAddExpense);
  }

  void _showAddExpenseDialog(BuildContext context, Function(Expense) onAdd, {Expense? expense}) {
    final descController = TextEditingController(text: expense?.description);
    final amountController = TextEditingController(text: expense?.amount.toString());
    final monthsController = TextEditingController(text: expense?.months?.toString());
    
    String selectedCategory = expense?.category ?? "Food";
    String? selectedSubCategory = expense?.subCategory;

    final categories = ["Food", "Groceries", "Bills", "Transport", "Rent", "Utilities", "Health", "Leisure", "Shopping", "Other"];
    
    final Map<String, List<String>> subCategories = {
      "Bills": ["Telephone", "Wifi", "Electric", "Water"],
      "Transport": ["Motor", "Car", "Public"],
      "Other": ["Shopping (Monthly)", "Custom"],
    };

    final Map<String, List<String>> transportOptions = {
      "Motor": ["Minyak"],
      "Car": ["Tol", "Minyak"],
      "Public": ["Daily", "Monthly"],
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense == null ? "Pin New Expense" : "Edit Pinned Expense",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 24),
                
                // Category Selection
                const Text("Category", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((cat) => ChoiceChip(
                    label: Text(cat),
                    selected: selectedCategory == cat,
                    onSelected: (selected) {
                      if (selected) {
                        setModalState(() {
                          selectedCategory = cat;
                          selectedSubCategory = null;
                        });
                      }
                    },
                  )).toList(),
                ),
                
                // SubCategory Selection
                if (subCategories.containsKey(selectedCategory)) ...[
                  const SizedBox(height: 16),
                  Text("Type of $selectedCategory", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: subCategories[selectedCategory]!.map((sub) => ChoiceChip(
                      label: Text(sub),
                      selected: selectedSubCategory == sub || (selectedCategory == "Transport" && transportOptions.containsKey(selectedSubCategory) && sub == selectedSubCategory),
                      onSelected: (selected) {
                        if (selected) setModalState(() => selectedSubCategory = sub);
                      },
                    )).toList(),
                  ),
                ],

                // Transport Specific Options (Nested)
                if (selectedCategory == "Transport" && transportOptions.containsKey(selectedSubCategory)) ...[
                  const SizedBox(height: 16),
                  Text("Details for $selectedSubCategory", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: transportOptions[selectedSubCategory]!.map((opt) => ChoiceChip(
                      label: Text(opt),
                      selected: descController.text == opt,
                      onSelected: (selected) {
                        if (selected) setModalState(() => descController.text = opt);
                      },
                    )).toList(),
                  ),
                ],

                const SizedBox(height: 24),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    filled: true,
                    fillColor: Colors.grey.withValues(alpha: 0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount (RM)",
                    filled: true,
                    fillColor: Colors.grey.withValues(alpha: 0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                
                if (selectedCategory == "Other" || selectedCategory == "Bills" || selectedCategory == "Rent") ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: monthsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Duration (Months)",
                      hintText: "Enter number of months",
                      filled: true,
                      fillColor: Colors.grey.withValues(alpha: 0.1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final desc = descController.text;
                      final amount = double.tryParse(amountController.text) ?? 0.0;
                      final months = int.tryParse(monthsController.text);
                      
                      if (desc.isNotEmpty && amount > 0) {
                        onAdd(Expense(
                          id: expense?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                          date: expense?.date ?? DateTime.now(),
                          category: selectedCategory,
                          subCategory: selectedSubCategory,
                          description: desc,
                          amount: amount,
                          months: months,
                        ));
                        Navigator.pop(context);
                        setState(() {}); // Refresh setup list
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      expense == null ? "PIN IT" : "UPDATE PIN",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SetupAddProxy extends StatelessWidget {
  final Function(Expense) onAdd;
  const _SetupAddProxy({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    // Just a shell to access the _showAddExpenseDialog logic which is currently in ExpenseScreen
    // Since I can't easily move it without refactoring everything, I'll duplicate the logic for setup
    return Container(); 
  }
}

class ExpenseScreen extends StatefulWidget {
  final List<Expense> expenses;
  final Function(Expense) onAdd;
  final Function(int) onDelete;
  final VoidCallback onClear;
  final double salary;

  const ExpenseScreen({super.key, required this.expenses, required this.onAdd, required this.onDelete, required this.onClear, required this.salary});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  bool _setupWizardShown = false;
  bool _showAllExpenses = false;
  static const int _visibleCount = 3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.expenses.isEmpty && !_setupWizardShown) {
      _setupWizardShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSetupWizard(context);
      });
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Food": return Icons.restaurant_rounded;
      case "Groceries": return Icons.shopping_cart_rounded;
      case "Transport": return Icons.directions_car_rounded;
      case "Bills": return Icons.receipt_rounded;
      case "Rent": return Icons.home_rounded;
      case "Utilities": return Icons.lightbulb_rounded;
      case "Health": return Icons.medical_services_rounded;
      case "Leisure": return Icons.theater_comedy_rounded;
      case "Shopping": return Icons.shopping_bag_rounded;
      default: return Icons.more_horiz_rounded;
    }
  }

  void _showSetupWizard(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Pin Expenses Setup", style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text("Welcome! Let's pin your fixed expenses first (Sewa, Bill, Wifi, etc.) to get an accurate tracking."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("LATER"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showAddExpenseDialog(context, widget.onAdd);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("START SETUP"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);

    double totalExpenses = widget.expenses.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: RepaintBoundary(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.08 : 0.05),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lang.t('expenses_title'), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
                          Text(lang.t('expenses_subtitle'), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline_rounded, size: 28, color: colorScheme.primary),
                        onPressed: () => _showAddExpenseDialog(context, widget.onAdd),
                        tooltip: lang.t('add_expense'),
                      ),
                    ],
                  ),
                ),
                
                // Unified Pinned Card in Expenses Tab
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Column(
                      children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.75)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.push_pin_rounded, color: Colors.white, size: 32),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.t('label_monthly_total'),
                                      style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: 1.2),
                                    ),
                                    Text(
                                      currencyFormat.format(totalExpenses),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(color: Colors.white24, height: 1),
                          ),
                          if (widget.expenses.isEmpty)
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.push_pin_rounded, size: 48, color: Colors.white30),
                                    const SizedBox(height: 16),
                                    Text(lang.t('empty_expenses'), style: const TextStyle(color: Colors.white60)),
                                  ],
                                ),
                              )
                            else
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(bottom: 8),
                                    itemCount: _showAllExpenses
                                        ? widget.expenses.length
                                        : widget.expenses.length.clamp(0, _visibleCount),
                                    itemBuilder: (context, index) {
                                      final expense = widget.expenses[index];
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                                  children: [
                                                    TextSpan(text: expense.description, style: const TextStyle(fontWeight: FontWeight.w800)),
                                                    TextSpan(
                                                      text: " ( ${expense.category}${expense.subCategory != null ? ' | ${expense.subCategory}' : ''}${expense.months != null ? ' | ${expense.months} Month' : ''} )",
                                                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              currencyFormat.format(expense.amount),
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  if (widget.expenses.length > _visibleCount)
                                    GestureDetector(
                                      onTap: () => setState(() => _showAllExpenses = !_showAllExpenses),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _showAllExpenses
                                                  ? lang.t('see_less')
                                                  : "${lang.t('see_more')} (${widget.expenses.length - _visibleCount} more)",
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              _showAllExpenses ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                        ],
                      ),
                    ),
                    _BudgetFormulaCard(salary: widget.salary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, Function(Expense) onAdd, {Expense? expense}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(
          onAdd: onAdd,
          onDelete: widget.onDelete,
          expenses: widget.expenses,
          expense: expense,
        ),
      ),
    );
  }
}

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) onAdd;
  final Function(int) onDelete;
  final List<Expense> expenses;
  final Expense? expense;

  const AddExpenseScreen({
    super.key,
    required this.onAdd,
    required this.onDelete,
    required this.expenses,
    this.expense,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late List<Expense> _expenses;

  final _categories = ["Food", "Groceries", "Bills", "Transport", "Rent", "Utilities", "Health", "Leisure", "Shopping", "Other"];
  final _subCategories = {
    "Bills": ["Telephone", "Wifi", "Electric", "Water"],
    "Transport": ["Motor", "Car", "Public"],
    "Other": ["Shopping (Monthly)", "Custom"],
  };
  final _transportOptions = {
    "Motor": ["Minyak"],
    "Car": ["Tol", "Minyak"],
    "Public": ["Daily", "Monthly"],
  };

  static const _categoryColors = {
    "Food": Color(0xFFF59E0B),
    "Groceries": Color(0xFF10B981),
    "Bills": Color(0xFFEF4444),
    "Transport": Color(0xFF3B82F6),
    "Rent": Color(0xFF8B5CF6),
    "Utilities": Color(0xFF06B6D4),
    "Health": Color(0xFFEC4899),
    "Leisure": Color(0xFFF97316),
    "Shopping": Color(0xFF6366F1),
    "Other": Color(0xFF64748B),
  };

  static const _categoryIcons = {
    "Food": Icons.restaurant_rounded,
    "Groceries": Icons.shopping_basket_rounded,
    "Bills": Icons.receipt_rounded,
    "Transport": Icons.directions_car_rounded,
    "Rent": Icons.home_rounded,
    "Utilities": Icons.bolt_rounded,
    "Health": Icons.favorite_rounded,
    "Leisure": Icons.sports_esports_rounded,
    "Shopping": Icons.shopping_bag_rounded,
    "Other": Icons.more_horiz_rounded,
  };

  @override
  void initState() {
    super.initState();
    _expenses = List.from(widget.expenses);
  }

  void _openForm({Expense? editing, int? editIndex}) {
    final descCtrl = TextEditingController(text: editing?.description);
    final amountCtrl = TextEditingController(text: editing?.amount.toString());
    final monthsCtrl = TextEditingController(text: editing?.months?.toString());
    String selCat = editing?.category ?? "Food";
    String? selSub = editing?.subCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final colorScheme = Theme.of(ctx).colorScheme;
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          final sheetBg = isDark ? const Color(0xFF0F172A) : Colors.white;
          final fieldFill = colorScheme.onSurface.withValues(alpha: 0.06);
          final lang = AppLang.of(ctx);

          return Container(
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              left: 24, right: 24, top: 8,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    editing == null ? lang.t('form_title_add') : lang.t('form_title_edit'),
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 20),
                  Text(lang.t('label_category'), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5), letterSpacing: 0.8)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _categories.map((cat) {
                      final selected = selCat == cat;
                      final color = _categoryColors[cat] ?? colorScheme.primary;
                      return GestureDetector(
                        onTap: () => setSheet(() { selCat = cat; selSub = null; }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: selected ? color.withValues(alpha: 0.15) : colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selected ? color : Colors.transparent, width: 1.5),
                          ),
                          child: Text(cat, style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? color : colorScheme.onSurface.withValues(alpha: 0.6))),
                        ),
                      );
                    }).toList(),
                  ),

                  if (_subCategories.containsKey(selCat)) ...[
                    const SizedBox(height: 16),
                    Text(lang.t('label_type'), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5), letterSpacing: 0.8)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _subCategories[selCat]!.map((sub) => GestureDetector(
                        onTap: () => setSheet(() => selSub = sub),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: selSub == sub ? colorScheme.primary.withValues(alpha: 0.15) : colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selSub == sub ? colorScheme.primary : Colors.transparent, width: 1.5),
                          ),
                          child: Text(sub, style: TextStyle(fontSize: 12, fontWeight: selSub == sub ? FontWeight.w700 : FontWeight.w500, color: selSub == sub ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6))),
                        ),
                      )).toList(),
                    ),
                  ],

                  if (selCat == "Transport" && _transportOptions.containsKey(selSub)) ...[
                    const SizedBox(height: 16),
                    Text(lang.t('label_detail'), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5), letterSpacing: 0.8)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _transportOptions[selSub]!.map((opt) => GestureDetector(
                        onTap: () => setSheet(() => descCtrl.text = opt),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: descCtrl.text == opt ? colorScheme.primary.withValues(alpha: 0.15) : colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: descCtrl.text == opt ? colorScheme.primary : Colors.transparent, width: 1.5),
                          ),
                          child: Text(opt, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colorScheme.onSurface.withValues(alpha: 0.6))),
                        ),
                      )).toList(),
                    ),
                  ],

                  const SizedBox(height: 20),
                  TextField(
                    controller: descCtrl,
                    decoration: InputDecoration(
                      labelText: lang.t('field_description'),
                      filled: true, fillColor: fieldFill,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: lang.t('field_amount'),
                      filled: true, fillColor: fieldFill,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  if (selCat == "Other" || selCat == "Bills" || selCat == "Rent") ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: monthsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: lang.t('field_months'),
                        filled: true, fillColor: fieldFill,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity, height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        final desc = descCtrl.text.trim();
                        final amount = double.tryParse(amountCtrl.text) ?? 0.0;
                        final months = int.tryParse(monthsCtrl.text);
                        if (desc.isNotEmpty && amount > 0) {
                          final e = Expense(
                            id: editing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                            date: editing?.date ?? DateTime.now(),
                            category: selCat,
                            subCategory: selSub,
                            description: desc,
                            amount: amount,
                            months: months,
                          );
                          widget.onAdd(e);
                          setState(() {
                            if (editIndex != null) {
                              _expenses[editIndex] = e;
                            } else {
                              _expenses.add(e);
                            }
                          });
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(lang.t('btn_save'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final bg = isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = colorScheme.onSurface.withValues(alpha: 0.07);
    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);
    final total = _expenses.fold(0.0, (s, e) => s + e.amount);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(lang.t('my_expenses'), style: TextStyle(fontWeight: FontWeight.w900, color: colorScheme.onSurface)),
      ),
      body: Column(
        children: [
          // ── Total banner ──
          Container(
            margin: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.push_pin_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lang.t('total_monthly'), style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                    Text(currencyFormat.format(total), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                  ],
                ),
                const Spacer(),
                Text("${_expenses.length} item${_expenses.length == 1 ? '' : 's'}",
                  style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // ── List ──
          Expanded(
            child: _expenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.push_pin_outlined, size: 52, color: colorScheme.onSurface.withValues(alpha: 0.15)),
                      const SizedBox(height: 12),
                      Text(lang.t('empty_no_expenses'), style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.35), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(lang.t('empty_hint'), style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.25))),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  itemCount: _expenses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final exp = _expenses[index];
                    final color = _categoryColors[exp.category] ?? colorScheme.primary;
                    final icon = _categoryIcons[exp.category] ?? Icons.label_rounded;
                    return Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        leading: Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                          child: Icon(icon, size: 20, color: color),
                        ),
                        title: Text(exp.description, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: colorScheme.onSurface)),
                        subtitle: Text(
                          "${exp.category}${exp.subCategory != null ? ' · ${exp.subCategory}' : ''}",
                          style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.4)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(currencyFormat.format(exp.amount),
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: color)),
                                if (exp.months != null)
                                  Text("${exp.months}mo", style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withValues(alpha: 0.35))),
                              ],
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: Icon(Icons.edit_rounded, size: 16, color: colorScheme.onSurface.withValues(alpha: 0.35)),
                              onPressed: () => _openForm(editing: exp, editIndex: index),
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red.withValues(alpha: 0.5)),
                              onPressed: () {
                                widget.onDelete(index);
                                setState(() => _expenses.removeAt(index));
                              },
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),

      // ── Add button ──
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            label: Text(lang.t('add_expense'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 4,
              shadowColor: colorScheme.primary.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }
}

class _BudgetFormula {
  final String name;
  final String suitableFor;
  final int komitmen;
  final int makan;
  final int bolehSpend;
  final int saving;
  const _BudgetFormula({
    required this.name,
    required this.suitableFor,
    required this.komitmen,
    required this.makan,
    required this.bolehSpend,
    required this.saving,
  });
}

class _BudgetFormulaCard extends StatefulWidget {
  final double salary;
  const _BudgetFormulaCard({required this.salary});

  @override
  State<_BudgetFormulaCard> createState() => _BudgetFormulaCardState();
}

class _BudgetFormulaCardState extends State<_BudgetFormulaCard> {
  int _formulaIndex = 0;

  List<_BudgetFormula> _getFormulas(String langKey) => [
    _BudgetFormula(name: AppStrings.get(langKey, 'formula_balanced'), suitableFor: AppStrings.get(langKey, 'formula_balanced_desc'), komitmen: 40, makan: 15, bolehSpend: 25, saving: 20),
    _BudgetFormula(name: AppStrings.get(langKey, 'formula_saving'), suitableFor: AppStrings.get(langKey, 'formula_saving_desc'), komitmen: 35, makan: 15, bolehSpend: 20, saving: 30),
    _BudgetFormula(name: AppStrings.get(langKey, 'formula_commitment'), suitableFor: AppStrings.get(langKey, 'formula_commitment_desc'), komitmen: 50, makan: 15, bolehSpend: 15, saving: 20),
    _BudgetFormula(name: AppStrings.get(langKey, 'formula_lifestyle'), suitableFor: AppStrings.get(langKey, 'formula_lifestyle_desc'), komitmen: 35, makan: 15, bolehSpend: 30, saving: 20),
    _BudgetFormula(name: AppStrings.get(langKey, 'formula_strict'), suitableFor: AppStrings.get(langKey, 'formula_strict_desc'), komitmen: 45, makan: 15, bolehSpend: 10, saving: 30),
  ];

  void _showFormulaPicker(BuildContext context, ColorScheme colorScheme, bool isDark, AppLang lang) {
    final formulas = _getFormulas(lang.langKey);
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.55,
          child: Column(
            children: [
              // fixed header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(width: 36, height: 4, decoration: BoxDecoration(color: colorScheme.onSurface.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
                    ),
                    const SizedBox(height: 16),
                    Text(lang.t('sheet_pick_formula'), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: colorScheme.onSurface)),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              // scrollable list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: formulas.length,
                  itemBuilder: (_, i) {
                    final f = formulas[i];
                    final selected = i == _formulaIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _formulaIndex = i);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: selected ? colorScheme.primary.withValues(alpha: 0.12) : colorScheme.onSurface.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: selected ? colorScheme.primary : Colors.transparent, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${i + 1}. ${f.name}", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: selected ? colorScheme.primary : colorScheme.onSurface)),
                                  const SizedBox(height: 2),
                                  Text(f.suitableFor, style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.5))),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      _formulaChip("K ${f.komitmen}%", const Color(0xFFEF4444)),
                                      const SizedBox(width: 4),
                                      _formulaChip("M ${f.makan}%", const Color(0xFFF59E0B)),
                                      const SizedBox(width: 4),
                                      _formulaChip("S ${f.bolehSpend}%", colorScheme.primary),
                                      const SizedBox(width: 4),
                                      _formulaChip("💰 ${f.saving}%", const Color(0xFF10B981)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (selected) Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formulaChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = colorScheme.onSurface.withValues(alpha: 0.07);
    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 0);

    final formulas = _getFormulas(lang.langKey);
    final netSalary = widget.salary * 0.89;
    final f = formulas[_formulaIndex];
    final buckets = [
      _BudgetBucket(label: lang.t('bucket_komitmen'), percent: f.komitmen, amount: netSalary * f.komitmen / 100, color: const Color(0xFFEF4444), icon: Icons.home_rounded),
      _BudgetBucket(label: lang.t('bucket_makan'), percent: f.makan, amount: netSalary * f.makan / 100, color: const Color(0xFFF59E0B), icon: Icons.restaurant_rounded),
      _BudgetBucket(label: lang.t('bucket_spend'), percent: f.bolehSpend, amount: netSalary * f.bolehSpend / 100, color: colorScheme.primary, icon: Icons.shopping_bag_rounded),
      _BudgetBucket(label: lang.t('bucket_saving'), percent: f.saving, amount: netSalary * f.saving / 100, color: const Color(0xFF10B981), icon: Icons.savings_rounded),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart_rounded, color: colorScheme.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(lang.t('card_budget_title'), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: colorScheme.onSurface)),
              ),
              GestureDetector(
                onTap: () => _showFormulaPicker(context, colorScheme, isDark, lang),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.tune_rounded, size: 13, color: colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(lang.t('btn_change'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colorScheme.primary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text("${_formulaIndex + 1}. ${f.name}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorScheme.primary)),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(f.suitableFor, style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withValues(alpha: 0.45), fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            widget.salary > 0
                ? "${lang.t('net_salary_prefix')} ${currencyFormat.format(netSalary)}"
                : lang.t('enter_salary_hint'),
            style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          ...buckets.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(color: b.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(b.icon, size: 16, color: b.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${b.percent}% ${b.label}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: colorScheme.onSurface)),
                          Text(
                            widget.salary > 0 ? currencyFormat.format(b.amount) : "--",
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: b.color),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: b.percent / 100,
                          minHeight: 4,
                          backgroundColor: b.color.withValues(alpha: 0.12),
                          valueColor: AlwaysStoppedAnimation<Color>(b.color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _BudgetBucket {
  final String label;
  final int percent;
  final double amount;
  final Color color;
  final IconData icon;
  const _BudgetBucket({required this.label, required this.percent, required this.amount, required this.color, required this.icon});
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary.withValues(alpha: 0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4),
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4),
              letterSpacing: 0.5,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

class SalaryTrackerScreen extends StatefulWidget {
  final TextEditingController salaryController;
  final TextEditingController daysController;
  final TextEditingController hoursController;
  final int initialSavedMillis;
  final int initialSessionStart;
  final bool initialIsTracking;
  final double totalExpenses;
  final Function(int, bool, int) onSave;
  final Function(double, int) onSessionEnd;

  const SalaryTrackerScreen({
    super.key,
    required this.salaryController,
    required this.daysController,
    required this.hoursController,
    required this.initialSavedMillis,
    required this.initialSessionStart,
    required this.initialIsTracking,
    required this.totalExpenses,
    required this.onSave,
    required this.onSessionEnd,
  });

  @override
  State<SalaryTrackerScreen> createState() => _SalaryTrackerScreenState();
}

class _SalaryTrackerScreenState extends State<SalaryTrackerScreen> with SingleTickerProviderStateMixin {
  late bool _isTracking;
  late int _sessionStartMillis;
  late int _savedElapsedMillis;
  
  final ValueNotifier<int> _currentMillisNotifier = ValueNotifier(DateTime.now().millisecondsSinceEpoch);
  Timer? _timer;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _savedElapsedMillis = widget.initialSavedMillis;
    _sessionStartMillis = widget.initialSessionStart;
    _isTracking = widget.initialIsTracking;
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    if (_isTracking) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _currentMillisNotifier.dispose();
    super.dispose();
  }

  int get _currentElapsed {
    if (_isTracking) {
      return _savedElapsedMillis + (_currentMillisNotifier.value - _sessionStartMillis).clamp(0, double.infinity).toInt();
    } else {
      return _savedElapsedMillis;
    }
  }

  void _triggerSave() {
    widget.onSave(_isTracking ? _savedElapsedMillis : _currentElapsed, _isTracking, _sessionStartMillis);
  }

  void _toggleTracking() {
    setState(() {
      if (_isTracking) {
        _savedElapsedMillis = _currentElapsed;
        _isTracking = false;
        _timer?.cancel();
      } else {
        _currentMillisNotifier.value = DateTime.now().millisecondsSinceEpoch;
        _sessionStartMillis = _currentMillisNotifier.value;
        _isTracking = true;
        _startTimer();
      }
    });
    _triggerSave();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _currentMillisNotifier.value = DateTime.now().millisecondsSinceEpoch;
      
      if (timer.tick % 50 == 0) {
        _triggerSave();
      }
    });
  }

  void _reset() {
    final currentAmount = _calculateEarnedAmount(_currentElapsed);
    if (currentAmount > 0) {
      widget.onSessionEnd(currentAmount, _currentElapsed);
    }
    setState(() {
      _savedElapsedMillis = 0;
      _sessionStartMillis = 0;
      _currentMillisNotifier.value = DateTime.now().millisecondsSinceEpoch;
      _isTracking = false;
      _timer?.cancel();
    });
    _triggerSave();
  }

  double _calculateEarnedAmount(int elapsed) {
    final salary = double.tryParse(widget.salaryController.text) ?? 0.0;
    final days = int.tryParse(widget.daysController.text) ?? 0;
    final hours = int.tryParse(widget.hoursController.text) ?? 0;
    
    final totalSecondsWorkedPerMonth = days * hours * 3600;
    if (totalSecondsWorkedPerMonth > 0) {
      final earningsPerSecond = salary / totalSecondsWorkedPerMonth;
      return (elapsed / 1000.0) * earningsPerSecond;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final lang = AppLang.of(context);

    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);
    final secondFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 5);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: Stack(
                children: [
                  Positioned(
                    top: -100,
                    right: -50,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.05),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RepaintBoundary(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.t('app_title'),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.5,
                              ),
                            ),
                            Text(
                              lang.t('app_subtitle'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isTracking 
                                ? colorScheme.primary.withValues(alpha: 0.1 + (_pulseController.value * 0.1))
                                : colorScheme.onSurface.withValues(alpha: 0.05),
                            ),
                            child: Icon(
                              _isTracking ? Icons.timer : Icons.timer_off_outlined,
                              color: _isTracking ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.3),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28.0),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: colorScheme.onSurface.withValues(alpha: isDark ? 0.05 : 0.03),
                      ),
                    ),
                    child: Column(
                      children: [
                        StatusPill(
                          text: _isTracking ? lang.t('status_working') : (_currentElapsed > 0 ? lang.t('status_paused') : lang.t('status_ready')),
                          color: _isTracking ? const Color(0xFF10B981) : const Color(0xFF64748B),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          lang.t('label_earned_session'),
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        ValueListenableBuilder<int>(
                          valueListenable: _currentMillisNotifier,
                          builder: (context, now, _) {
                            final elapsed = _isTracking 
                              ? _savedElapsedMillis + (now - _sessionStartMillis).clamp(0, double.infinity).toInt()
                              : _savedElapsedMillis;
                            final amount = _calculateEarnedAmount(elapsed);
                            
                            return Column(
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [colorScheme.primary, colorScheme.primary.withBlue(200)],
                                  ).createShader(bounds),
                                  child: Text(
                                    currencyFormat.format(amount),
                                    style: theme.textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "+ ${secondFormat.format(_calculateEarnedAmount(1000))} ${lang.t('label_per_sec')}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final salary = double.tryParse(widget.salaryController.text) ?? 0.0;
                                    final days = int.tryParse(widget.daysController.text) ?? 0;
                                    final dailyTarget = days > 0 ? salary / days : 0.0;
                                    final progress = dailyTarget > 0 ? (amount / dailyTarget).clamp(0.0, 1.0) : 0.0;

                                    return Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 12,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: colorScheme.primary.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                            ),
                                            Container(
                                              height: 12,
                                              width: constraints.maxWidth * progress,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [colorScheme.primary, colorScheme.primary.withBlue(200)],
                                                ),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          "${(progress * 100).toStringAsFixed(1)}${lang.t('label_daily_target')}",
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: CompactStatCard(
                          label: lang.t('stat_hourly'),
                          value: currencyFormat.format(_calculateHourlyRate()),
                          icon: Icons.hourglass_bottom_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CompactStatCard(
                          label: lang.t('stat_minute'),
                          value: currencyFormat.format(_calculateHourlyRate() / 60),
                          icon: Icons.shutter_speed_rounded,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // NEW: Monthly Salary Progress Card with Expenses
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang.t('label_monthly_outlook'),
                              style: theme.textTheme.labelSmall?.copyWith(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w800,
                                color: colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                            Icon(Icons.insights_rounded, size: 16, color: colorScheme.primary.withValues(alpha: 0.5)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ValueListenableBuilder<int>(
                          valueListenable: _currentMillisNotifier,
                          builder: (context, now, _) {
                            final elapsed = _isTracking 
                              ? _savedElapsedMillis + (now - _sessionStartMillis).clamp(0, double.infinity).toInt()
                              : _savedElapsedMillis;
                            final amountEarned = _calculateEarnedAmount(elapsed);
                            final totalSalary = double.tryParse(widget.salaryController.text) ?? 1.0;
                            final totalExpenses = widget.totalExpenses;

                            final expRatio = (totalExpenses / totalSalary).clamp(0.0, 1.0);
                            final earnRatio = (amountEarned / totalSalary).clamp(0.0, 1.0);

                            return Column(
                              children: [
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Column(
                                      children: [
                                        // Labels Row
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Stack(
                                            children: [
                                              const SizedBox(height: 14, width: double.infinity),
                                              if (expRatio > 0.1 && expRatio < 0.9)
                                                Positioned(
                                                  left: constraints.maxWidth * expRatio - 30,
                                                  child: Text(
                                                    lang.t('label_expenses_bar'),
                                                    style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFFEF4444), letterSpacing: 0.5),
                                                  ),
                                                ),
                                              Positioned(
                                                right: 0,
                                                child: Text(
                                                  lang.t('label_full_gaji'),
                                                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 0.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            // Background Track
                                            Container(
                                              height: 24,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: colorScheme.onSurface.withValues(alpha: 0.05),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            // Expense Zone (Red Shading)
                                            Container(
                                              height: 24,
                                              width: constraints.maxWidth * expRatio,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.horizontal(
                                                  left: const Radius.circular(12),
                                                  right: expRatio >= 1.0 ? const Radius.circular(12) : Radius.zero,
                                                ),
                                              ),
                                            ),
                                            // Earnings Progress (Green)
                                            Container(
                                              height: 24,
                                              width: constraints.maxWidth * earnRatio,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [colorScheme.primary, colorScheme.primary.withBlue(200)],
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  if (earnRatio > 0)
                                                    BoxShadow(
                                                      color: colorScheme.primary.withValues(alpha: 0.3),
                                                      blurRadius: 10,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            // Expense Break-even Marker
                                            if (expRatio > 0 && expRatio < 1.0)
                                              Positioned(
                                                left: constraints.maxWidth * expRatio - 1,
                                                child: Container(
                                                  width: 2,
                                                  height: 24,
                                                  color: const Color(0xFFEF4444),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lang.t('label_earnings'),
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorScheme.primary),
                                        ),
                                        Text(
                                          currencyFormat.format(amountEarned),
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          lang.t('label_expenses'),
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFEF4444)),
                                        ),
                                        Text(
                                          currencyFormat.format(totalExpenses),
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (amountEarned >= totalExpenses && totalExpenses > 0)
                                  Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.celebration_rounded, size: 14, color: colorScheme.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          lang.t('msg_breakeven'),
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                            color: colorScheme.primary,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  RepaintBoundary(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.t('label_config'),
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SlickInputSection(
                          salaryController: widget.salaryController,
                          daysController: widget.daysController,
                          hoursController: widget.hoursController,
                          enabled: !_isTracking,
                          onChanged: (val) {
                            setState(() {});
                            _triggerSave();
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: _toggleTracking,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              gradient: _isTracking 
                                ? const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)])
                                : LinearGradient(colors: [colorScheme.primary, colorScheme.primary.withBlue(200)]),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isTracking ? Colors.red : colorScheme.primary).withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _isTracking ? lang.t('btn_pause') : lang.t('btn_start'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!_isTracking && _savedElapsedMillis > 0) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: _reset,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: colorScheme.onSurface.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
                              ),
                              child: Center(
                                child: Text(
                                  lang.t('btn_reset'),
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  const AdMobBanner(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateHourlyRate() {
    final salary = double.tryParse(widget.salaryController.text) ?? 0.0;
    final days = int.tryParse(widget.daysController.text) ?? 0;
    final hours = int.tryParse(widget.hoursController.text) ?? 0;
    return (days > 0 && hours > 0) ? salary / days / hours : 0.0;
  }
}

class AdMobBanner extends StatefulWidget {
  const AdMobBanner({super.key});

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  AdSize? _adSize;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-5978067529669035/6245822645'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_adSize == null) {
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    final AdSize? size = 
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            (MediaQuery.of(context).size.width - 48).toInt());

    if (size == null) return;

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('AdMob: Ad loaded successfully.');
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
              _isLoaded = true;
              _adSize = size;
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('AdMob: Ad failed to load: ${err.message}');
          debugPrint('AdMob: Error code: ${err.code}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null || _adSize == null) {
      return const SlickAdBanner();
    }

    return Container(
      alignment: Alignment.center,
      width: _adSize!.width.toDouble(),
      height: _adSize!.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

class SlickAdBanner extends StatelessWidget {
  const SlickAdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ads_click_rounded, size: 20, color: Colors.grey),
            SizedBox(height: 4),
            Text(
              "ADVERTISEMENT",
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final String text;
  final Color color;

  const StatusPill({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Text(
            text.toUpperCase(),
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class CompactStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const CompactStatCard({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class SlickInputSection extends StatelessWidget {
  final TextEditingController salaryController;
  final TextEditingController daysController;
  final TextEditingController hoursController;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const SlickInputSection({
    super.key,
    required this.salaryController,
    required this.daysController,
    required this.hoursController,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        _buildField(
          controller: salaryController,
          label: "Monthly Salary",
          prefix: "RM",
          enabled: enabled,
          onChanged: onChanged,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildField(
                controller: daysController,
                label: "Working Days",
                enabled: enabled,
                onChanged: onChanged,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildField(
                controller: hoursController,
                label: "Daily Hours",
                enabled: enabled,
                onChanged: onChanged,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    required bool enabled,
    required ValueChanged<String> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefix != null ? "$prefix " : null,
          labelStyle: TextStyle(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final int themeIndex;
  final Function(int) onThemeChanged;
  final VoidCallback onClearHistory;
  final VoidCallback onClearExpenses;
  final VoidCallback onClearAll;

  const SettingsScreen({
    super.key,
    required this.themeIndex,
    required this.onThemeChanged,
    required this.onClearHistory,
    required this.onClearExpenses,
    required this.onClearAll,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _standardLangs = [
    {'key': 'en', 'label': 'English', 'flag': '🇬🇧'},
    {'key': 'ms', 'label': 'Bahasa Melayu', 'flag': '🇲🇾'},
  ];

  static const _dialectLangs = [
    {'key': 'kelantan', 'label': 'Kelantan', 'abbr': 'KTN'},
    {'key': 'terengganu', 'label': 'Terengganu', 'abbr': 'TRG'},
    {'key': 'ns', 'label': 'N. Sembilan', 'abbr': 'N9'},
    {'key': 'utara', 'label': 'Utara', 'abbr': 'UTR'},
    {'key': 'sarawak', 'label': 'Sarawak', 'abbr': 'SWK'},
    {'key': 'sabah', 'label': 'Sabah', 'abbr': 'SBH'},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final bg = isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC);
    final surface = isDark ? const Color(0xFF0F172A) : Colors.white;
    final List<BoxShadow> shadow = isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 3))];
    final muted = colorScheme.onSurface.withValues(alpha: 0.3);
    final activeTheme = AppThemes.all[widget.themeIndex];
    final activeLang = [..._standardLangs, ..._dialectLangs].firstWhere(
      (l) => l['key'] == lang.langKey, orElse: () => _standardLangs[1]);
    const langColor = Color(0xFF8B5CF6);
    const dangerColor = Color(0xFFEF4444);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ──────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("GAJIMETER", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: colorScheme.primary, letterSpacing: 2.5)),
                        const SizedBox(height: 3),
                        Text(lang.t('settings_title'), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: colorScheme.onSurface, letterSpacing: -1.2, height: 1.05)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                    ),
                    child: Text("v 1.0.0", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colorScheme.primary, letterSpacing: 0.5)),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ── 01 — Colour ────────────────────────────────────
              _SettingsSection(number: "01", label: lang.t('section_theme'), color: colorScheme.primary),
              const SizedBox(height: 18),

              // Active theme card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: activeTheme.swatch.withValues(alpha: 0.35), width: 1.5),
                  boxShadow: [BoxShadow(color: activeTheme.swatch.withValues(alpha: isDark ? 0.15 : 0.12), blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(color: activeTheme.swatch, borderRadius: BorderRadius.circular(13)),
                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(activeTheme.name, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: colorScheme.onSurface)),
                          Text("Active Theme", style: TextStyle(fontSize: 11, color: muted)),
                        ],
                      ),
                    ),
                    // mini preview dots
                    Row(
                      children: [
                        for (int k = 0; k < AppThemes.all.length && k < 5; k++)
                          Container(
                            width: 8, height: 8,
                            margin: const EdgeInsets.only(left: 4),
                            decoration: BoxDecoration(
                              color: AppThemes.all[k].swatch.withValues(alpha: widget.themeIndex == k ? 1.0 : 0.25),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Scrollable dot row
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppThemes.all.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final t = AppThemes.all[i];
                    final sel = widget.themeIndex == i;
                    return GestureDetector(
                      onTap: () => widget.onThemeChanged(i),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: sel ? 48 : 32,
                          height: sel ? 48 : 32,
                          decoration: BoxDecoration(
                            color: t.swatch,
                            shape: BoxShape.circle,
                            border: Border.all(color: sel ? Colors.white : Colors.transparent, width: 2.5),
                            boxShadow: sel ? [BoxShadow(color: t.swatch.withValues(alpha: 0.55), blurRadius: 12, spreadRadius: 0)] : [],
                          ),
                          child: sel ? const Icon(Icons.check_rounded, color: Colors.white, size: 16) : null,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              // ── 02 — Language ──────────────────────────────────
              _SettingsSection(number: "02", label: lang.t('section_language'), color: langColor),
              const SizedBox(height: 18),

              // Active language banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: langColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: langColor.withValues(alpha: 0.25), width: 1.5),
                  boxShadow: [BoxShadow(color: langColor.withValues(alpha: isDark ? 0.08 : 0.06), blurRadius: 12, offset: const Offset(0, 3))],
                ),
                child: Row(
                  children: [
                    Text(activeLang['flag'] ?? '🗣️', style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(activeLang['label']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: langColor)),
                          Text("Active Language", style: TextStyle(fontSize: 11, color: langColor.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: langColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.check_rounded, size: 14, color: langColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Standard
              Text(lang.t('lang_standard').toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4, color: muted)),
              const SizedBox(height: 10),
              Row(
                children: _standardLangs.map((e) {
                  final sel = lang.langKey == e['key'];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => lang.onChanged(e['key']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(right: e == _standardLangs.last ? 0 : 10),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: sel ? langColor.withValues(alpha: 0.08) : surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: sel ? langColor : colorScheme.onSurface.withValues(alpha: 0.07), width: sel ? 1.5 : 1),
                          boxShadow: sel ? <BoxShadow>[] : shadow,
                        ),
                        child: Column(
                          children: [
                            Text(e['flag']!, style: TextStyle(fontSize: sel ? 24 : 20)),
                            const SizedBox(height: 6),
                            Text(e['label']!, style: TextStyle(fontSize: 11, fontWeight: sel ? FontWeight.w800 : FontWeight.w500, color: sel ? langColor : colorScheme.onSurface.withValues(alpha: 0.7)), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Dialect
              Text(lang.t('lang_dialect').toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4, color: muted)),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.7,
                children: _dialectLangs.map((e) {
                  final sel = lang.langKey == e['key'];
                  return GestureDetector(
                    onTap: () => lang.onChanged(e['key']!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: sel ? langColor.withValues(alpha: 0.08) : surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: sel ? langColor : colorScheme.onSurface.withValues(alpha: 0.07), width: sel ? 1.5 : 1),
                        boxShadow: sel ? <BoxShadow>[BoxShadow(color: langColor.withValues(alpha: 0.12), blurRadius: 8)] : shadow,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(e['abbr']!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: sel ? langColor : colorScheme.onSurface.withValues(alpha: 0.5), letterSpacing: 0.5)),
                          const SizedBox(height: 2),
                          Text(e['label']!, style: TextStyle(fontSize: 9, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, color: sel ? langColor : colorScheme.onSurface.withValues(alpha: 0.45)), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              // ── 03 — Data ──────────────────────────────────────
              _SettingsSection(number: "03", label: lang.t('section_data'), color: dangerColor),
              const SizedBox(height: 18),

              _DataActionRow(label: lang.t('clear_history'), sub: lang.t('clear_history_sub'), accentColor: Colors.orange, surface: surface, onTap: () => _confirmClear(context, lang.t('clear_history'), "This will permanently delete all work session history.", widget.onClearHistory)),
              const SizedBox(height: 10),
              _DataActionRow(label: lang.t('clear_expenses'), sub: lang.t('clear_expenses_sub'), accentColor: Colors.orange, surface: surface, onTap: () => _confirmClear(context, lang.t('clear_expenses'), "This will permanently delete all pinned monthly expenses.", widget.onClearExpenses)),
              const SizedBox(height: 10),
              _DataActionRow(label: lang.t('reset_all'), sub: lang.t('reset_all_sub'), accentColor: dangerColor, surface: surface, isDestructive: true, onTap: () => _confirmClear(context, lang.t('reset_all'), "This will permanently delete all your data including salary, history, and expenses.", widget.onClearAll)),

              const SizedBox(height: 40),

              // ── 04 — About ─────────────────────────────────────
              _SettingsSection(number: "04", label: lang.t('section_about'), color: colorScheme.primary),
              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(child: _AboutPill(icon: Icons.star_rounded, label: lang.t('rate_app'), sub: lang.t('rate_app_sub'), color: const Color(0xFFF59E0B), surface: surface, shadow: shadow)),
                  const SizedBox(width: 10),
                  Expanded(child: _AboutPill(icon: Icons.lock_outline_rounded, label: lang.t('privacy'), sub: lang.t('privacy_sub'), color: langColor, surface: surface, shadow: shadow)),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.25), shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text("GajiMeter  ·  Made for Malaysia", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.2), letterSpacing: 0.3)),
                        const SizedBox(width: 8),
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.25), shape: BoxShape.circle)),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context, String title, String content, VoidCallback onConfirm) {
    final lang = AppLang.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(lang.t('btn_cancel'))),
          TextButton(
            onPressed: () { Navigator.pop(ctx); onConfirm(); },
            child: Text(lang.t('btn_delete'), style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      label.toUpperCase(),
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: colorScheme.onSurface.withValues(alpha: 0.4)),
    );
  }
}

class _SettingsGroupHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SettingsGroupHeader({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 8),
        Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.1, color: color)),
      ],
    );
  }
}

class _SettingsSubLabel extends StatelessWidget {
  final String label;
  const _SettingsSubLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.4)));
  }
}

class _SettingsSection extends StatelessWidget {
  final String number;
  final String label;
  final Color color;
  const _SettingsSection({required this.number, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Text(number, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color.withValues(alpha: 0.5), letterSpacing: 1)),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 1, color: color.withValues(alpha: 0.15))),
        const SizedBox(width: 8),
        Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: onSurface.withValues(alpha: 0.5), letterSpacing: 1.2)),
      ],
    );
  }
}

class _DataActionRow extends StatelessWidget {
  final String label;
  final String sub;
  final Color accentColor;
  final Color surface;
  final VoidCallback onTap;
  final bool isDestructive;
  const _DataActionRow({required this.label, required this.sub, required this.accentColor, required this.surface, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDestructive ? accentColor.withValues(alpha: 0.06) : surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accentColor.withValues(alpha: isDestructive ? 0.25 : 0.12)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 56,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isDestructive ? accentColor : Theme.of(context).colorScheme.onSurface)),
                  Text(sub, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: accentColor.withValues(alpha: 0.5)),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class _AboutPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final Color surface;
  final List<BoxShadow> shadow;
  const _AboutPill({required this.icon, required this.label, required this.sub, required this.color, required this.surface, required this.shadow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 10),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)), maxLines: 2),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconColor;
  final VoidCallback? onTap;

  const _SettingsTile({required this.icon, required this.label, required this.subtitle, required this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.45))),
                ],
              ),
            ),
            if (onTap != null) Icon(Icons.chevron_right_rounded, size: 18, color: colorScheme.onSurface.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}

class _LangTile extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _LangTile({required this.flag, required this.label, required this.selected, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected ? color.withValues(alpha: 0.12) : colorScheme.onSurface.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(flag, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? color : colorScheme.onSurface)),
            ),
            if (selected) Icon(Icons.check_circle_rounded, size: 20, color: color),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  final List<WorkSession> history;
  final VoidCallback onClear;

  const HistoryScreen({super.key, required this.history, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: RepaintBoundary(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.05),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lang.t('history_title'), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
                          Text(lang.t('history_subtitle'), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      if (history.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.delete_sweep_rounded),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Clear History?"),
                                content: const Text("This will permanently delete all session records."),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: Text(lang.t('btn_cancel'))),
                                  TextButton(
                                    onPressed: () {
                                      onClear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Clear", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: history.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.history_rounded, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(lang.t('empty_history'), style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final session = history[index];
                            final duration = Duration(milliseconds: session.durationMillis);
                            final h = duration.inHours;
                            final m = duration.inMinutes.remainder(60);
                            final s = duration.inSeconds.remainder(60);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check_circle_outline_rounded, color: colorScheme.primary),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('MMM dd, yyyy • hh:mm a').format(session.date),
                                          style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 4),
                                        Text("${h > 0 ? '${h}h ' : ''}${m}m ${s}s worked", style: const TextStyle(fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    currencyFormat.format(session.amount),
                                    style: TextStyle(fontWeight: FontWeight.w900, color: colorScheme.primary),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkSession {
  final DateTime date;
  final double amount;
  final int durationMillis;

  WorkSession({required this.date, required this.amount, required this.durationMillis});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'amount': amount,
        'durationMillis': durationMillis,
      };

  factory WorkSession.fromJson(Map<String, dynamic> json) => WorkSession(
        date: DateTime.parse(json['date']),
        amount: json['amount'],
        durationMillis: json['durationMillis'],
      );
}

class Expense {
  final String id;
  final DateTime date;
  final String category;
  final String? subCategory;
  final String description;
  final double amount;
  final int? months;

  Expense({
    required this.id,
    required this.date,
    required this.category,
    this.subCategory,
    required this.description,
    required this.amount,
    this.months,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'category': category,
        'subCategory': subCategory,
        'description': description,
        'amount': amount,
        'months': months,
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.parse(json['date']),
        category: json['category'],
        subCategory: json['subCategory'],
        description: json['description'],
        amount: json['amount'],
        months: json['months'],
      );
}
