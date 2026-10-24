# SR-POS Repository Instructions

Aturan ini berlaku untuk seluruh repository dan wajib diikuti pada setiap
implementasi, refactor, review, dan perbaikan bug. Jangan melemahkan atau
menyimpang dari aturan ini tanpa instruksi eksplisit dari user.

## Sumber kebenaran

- Untuk struktur dan dependency, ikuti `docs/architecture.md`.
- Untuk pekerjaan UI, ikuti `docs/design_system.md` dan
  `docs/component_catalog.md`.
- API design system yang benar adalah public barrel
  `lib/core/design_system/design_system.dart` dan implementasi aktualnya.
- Baca dokumen yang relevan sebelum mengubah area tersebut. Jika dokumentasi
  dan kode aktual bertentangan, jangan menebak atau membuat kontrak baru;
  laporkan perbedaannya dan minta keputusan user.

## Aturan UI dan core yang tidak boleh dilanggar

1. Kode di `lib/app/**` dan `lib/features/**` harus mengimpor design system
   hanya melalui:

   ```dart
   import 'package:sr_pos/core/design_system/design_system.dart';
   ```

   Jangan melakukan deep import ke file komponen, category barrel, helper
   internal, atau folder `components/shared`. Deep import hanya diperbolehkan
   di dalam implementasi core serta test/preview yang memang menguji internal.

2. Sebelum menulis UI, periksa `docs/component_catalog.md` dan public barrel.
   Jika komponen atau variant `Sr*` yang sesuai sudah ada, pemakaiannya wajib.
   Contoh: gunakan `SrButton`, `SrTextField`, `SrSearchBar`, `SrCard`, `SrIcon`,
   `SrLoader`, dan komponen `Sr*` lain; jangan menggantinya dengan widget
   Material/Cupertino mentah atau tampilan rakitan sendiri.

3. Primitive Flutter untuk struktur/layout tetap boleh digunakan jika tidak
   ada ekuivalen di core, misalnya `Scaffold`, `SafeArea`, `Row`, `Column`,
   `Flex`, `Expanded`, `Padding`, `SizedBox`, `Align`, `Stack`, `Sliver*`, dan
   builder. Primitive tersebut hanya boleh menyusun screen dan komponen `Sr*`;
   jangan dipakai untuk menciptakan ulang visual atau perilaku komponen yang
   sudah tersedia di core. `Text` boleh dipakai karena belum ada `SrText`,
   tetapi harus mewarisi theme atau memakai role dari `SrTypography`.

4. Semua keputusan visual harus berasal dari core: semantic `ColorScheme`/
   extension theme, `SrTypography`, `SrSpacing`, `SrSizing`, `SrRadii`,
   `SrBorders`, dan `SrMotion`. Di luar core, jangan menambahkan hex/color
   literal, `Colors.*`, `TextStyle` ad hoc, spacing, radius, border, ukuran icon,
   atau motion literal untuk styling. Constraint layout yang benar-benar
   spesifik terhadap screen boleh menjadi private named constant bila tidak ada
   token yang sesuai.

5. Jangan memakai primitive color `SrColors` langsung di screen/feature.
   Gunakan semantic theme. Nilai desain sementara harus terpusat, diberi
   komentar `assumption`, dan tidak boleh disebarkan sebagai literal.

## Gerbang persetujuan komponen kustom

- Secara default, **dilarang membuat** komponen UI reusable baru, komponen
  visual feature baru, komponen `Sr*` baru, variant baru, token baru, atau
  wrapper yang membentuk kontrak visual baru.
- Kebutuhan screen/page tidak otomatis menjadi izin membuat komponen kustom.
  Izin hanya sah bila user secara eksplisit meminta atau menyetujui komponen
  tersebut pada task yang sedang dikerjakan.
- Jika kebutuhan tidak dapat dipenuhi oleh katalog core, hentikan bagian UI
  tersebut dan laporkan: komponen/variant yang kurang, kebutuhan perilakunya,
  dan komponen `Sr*` terdekat. Tunggu instruksi user; jangan diam-diam memakai
  widget mentah sebagai substitusi.
- Private widget hanya boleh memecah struktur screen dan mengomposisikan
  primitive layout dengan komponen `Sr*`. Private widget tidak boleh
  memperkenalkan visual, interaction pattern, atau reusable API baru.
- Komponen kustom yang sudah ada boleh dipakai, tetapi isi visual/interaktifnya
  tetap harus tersusun dari API core.
- Setelah user memberi izin, tempatkan komponen lintas-screen di
  `core/design_system` dengan prefix `Sr`; tempatkan komposisi yang benar-benar
  khusus satu feature di `features/<feature>/presentation/widgets`. Tetap
  gunakan token core, accessibility baseline, public barrel, dokumentasi,
  preview, dan test yang sesuai.

## Arsitektur wajib

- Pertahankan feature-first MVVM:

  ```text
  lib/
  ├── app/                         # composition root dan navigation
  ├── core/design_system/          # shared UI, theme, dan token
  └── features/<feature>/
      ├── data/                    # repository implementation dan data source
      ├── domain/                  # immutable model dan repository contract
      └── presentation/            # screen, view model, state, dan widget
  ```

- `presentation` boleh bergantung pada `domain` dan public design system,
  tetapi tidak boleh mengimpor concrete repository atau data source.
- `data` mengimplementasikan contract dari `domain` dan tidak boleh bergantung
  pada `presentation`.
- `domain` harus bebas dari Flutter UI dan detail infrastructure.
- `app` adalah composition root: buat concrete dependency di sana dan inject
  melalui constructor. Jangan memakai global service locator.
- View hanya merender state dan meneruskan event. Loading, error, filtering,
  sorting, transformasi data, dan interaction/data logic berada di view model.
- Pertahankan aliran satu arah repository -> view model -> immutable UI state
  -> view. Collection yang diekspos lintas layer harus immutable/unmodifiable.
- Pertahankan pola `ChangeNotifier` yang sekarang. Jangan menambah state
  management, DI, routing, atau framework arsitektur baru tanpa instruksi
  eksplisit user.
- Buat service hanya untuk I/O nyata seperti API, database, file, atau platform
  integration. Jangan membuat layer kosong atau abstraksi spekulatif.
- Jangan mengubah struktur folder atau arah dependency yang sudah ditentukan
  tanpa persetujuan eksplisit user.

## Konvensi kode

- Gunakan package imports, bukan relative imports lintas file library.
- File/directory: `snake_case`; class/enum/typedef: `UpperCamelCase`; variable,
  parameter, dan method: `lowerCamelCase`.
- Pertahankan nama peran arsitektur yang eksplisit, misalnya `Repository`,
  `ViewModel`, `UiState`, dan `Screen`.
- Ikuti seluruh strict analyzer dan lint di `analysis_options.yaml`.
- Jangan menambah dependency baru kecuali benar-benar diminta atau disetujui
  user.

## Testing dan definition of done

- Repository dan view model: unit test dengan fake yang terisolasi.
- Komponen core: widget test untuk variant, state, interaction, semantics, dan
  accessibility yang relevan.
- Screen: widget test dengan dependency/fake yang di-inject.
- Golden test hanya untuk kontrak visual yang stabil dan deterministik. Ubah
  baseline hanya bila perubahan visual memang disengaja dan sudah diperiksa.
- Format file yang berubah, lalu jalankan minimal:

  ```bash
  flutter analyze --no-pub
  flutter test --no-pub
  ```

- Sebelum menyatakan task selesai, pastikan tidak ada pengganti mentah untuk
  komponen `Sr*`, custom component tanpa izin, deep import design system, atau
  dependency yang melanggar arah layer. Jika salah satu verifikasi tidak dapat
  dijalankan, jelaskan alasannya dengan jujur.

## Aturan review

Anggap pelanggaran penggunaan core, pembuatan komponen kustom tanpa izin, dan
pelanggaran dependency layer sebagai finding blocking. Jangan menyetujui atau
menyatakan implementasi selesai sampai pelanggaran tersebut diperbaiki atau
user memberikan pengecualian eksplisit.
