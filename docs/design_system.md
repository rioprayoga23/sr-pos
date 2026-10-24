# SR-POS Design System Extraction

Dokumen ini menjadi sumber kerja untuk menerapkan design system SR-POS dari
referensi Figma. Nilai yang diberi label **Figma exact** berasal dari data
referensi yang sudah diekstrak. Nama semantik dan aturan implementasi di bagian
lain adalah kontrak internal SR-POS; nama tersebut bukan klaim bahwa Figma
menggunakan penamaan yang sama.

## Sumber

- Figma file: [`kE0ttvjNMBfzLofbm2Bklc`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-)
- Components: [node `6:757`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-?node-id=6-757)
- Styles: [node `6:464`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-?node-id=6-464)
- Color: [node `261:8659`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-?node-id=261-8659)
- Badge: [node `261:6762`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-?node-id=261-6762)
- Validation screen: [node `283:6138`](https://www.figma.com/design/kE0ttvjNMBfzLofbm2Bklc/Mobile-Apps-%E2%80%93-Prototyping-Kit--Community---Copy-?node-id=283-6138)

## Status ekstraksi

Seluruh keluarga dan komponen pada katalog sudah diinventarisasi melalui panel
Layers dan tersedia sebagai widget Flutter reusable di
`lib/core/design_system/components`. Primitive, semantic theme, tipografi,
spacing, radius, sizing, border, dan motion dipusatkan di
`lib/core/design_system`. Screen validasi memakai komponen publik melalui satu
barrel import, bukan style ad hoc.

Seluruh family preview memiliki golden visual pada viewport `390` logical
pixel. Golden tersebut memeriksa komposisi default, font Poppins, token
warna, constraint, dan overflow. Screen validasi memiliki golden terpisah pada
viewport `375 × 812`.

Informasi berikut belum boleh dianggap sebagai nilai Figma exact sampai
diekstrak langsung dari node terkait:

- line height dan letter spacing tipografi;
- spacing, grid, radius, border width, elevation, serta shadow;
- ukuran icon dan target sentuh;
- state dan varian setiap komponen;
- durasi serta easing motion.

Nilai sementara untuk hal-hal tersebut, bila dibutuhkan selama implementasi,
harus diberi komentar `assumption`, ditempatkan di satu token terpusat, dan
diganti setelah validasi. Jangan menyebarkan nilai sementara sebagai literal di
screen atau komponen.

## Warna — Figma exact

Urutan swatch dipertahankan sesuai data ekstraksi. Label `01`, `02`, dan
seterusnya hanya penanda urutan dalam dokumen ini, bukan nama ataupun skala
resmi dari Figma.

| Keluarga | 01 | 02 | 03 | 04 | 05 |
| --- | --- | --- | --- | --- | --- |
| Highlight | `#006FFD` | `#2897FF` | `#6FBAFF` | `#B4DBFF` | `#EAF2FF` |
| Neutral light | `#C5C6CC` | `#D4D6DD` | `#E8E9F1` | `#F8F9FE` | `#FFFFFF` |
| Neutral dark | `#1F2024` | `#2F3036` | `#494A50` | `#71727A` | `#8F9098` |
| Success | `#298267` | `#3AC0A0` | `#E7F4E8` | — | — |
| Warning | `#E86339` | `#FFB37C` | `#FFF4E4` | — | — |
| Error | `#ED3241` | `#FF616D` | `#FFE2E5` | — | — |

### Aturan semantik warna

1. Simpan nilai di atas sebagai primitive yang immutable, misalnya
   `SrColorPrimitives.highlight01`. Nama ini adalah konvensi implementasi
   SR-POS, bukan nama Figma.
2. Komponen hanya memakai semantic alias seperti `brandPrimary`,
   `textPrimary`, `textSecondary`, `surfaceBase`, `borderDefault`,
   `statusSuccess`, `statusWarning`, atau `statusError`.
3. Relasi semantic alias ke primitive harus ditentukan dari konteks node dan
   hasil uji kontras. Jangan menyimpulkan peran hanya dari posisi swatch.
4. Jangan menulis hex literal di screen atau komponen. Semua warna harus masuk
   melalui theme atau token.
5. Nama token menjelaskan peran, bukan lokasi pemakaian. Hindari nama seperti
   `loginBlue`, `homeGrey`, atau `cardColor`.

## Tipografi

Font family default produk: **Poppins**. Scale ukuran dan weight di bawah tetap
mengikuti ekstraksi Figma.

| Kategori | Style | Weight | Size |
| --- | --- | --- | ---: |
| Heading | H1 | ExtraBold | 24 |
| Heading | H2 | ExtraBold | 18 |
| Heading | H3 | ExtraBold | 16 |
| Heading | H4 | Bold | 14 |
| Heading | H5 | Bold | 12 |
| Body | XL | Regular | 18 |
| Body | L | Regular | 16 |
| Body | M | Regular | 14 |
| Body | S | Regular | 12 |
| Body | XS | Medium | 10 |
| Action | L | SemiBold | 14 |
| Action | M | SemiBold | 12 |
| Action | S | SemiBold | 10 |
| Caption | M | SemiBold | 10 |

Angka size mengikuti data ekstraksi; satuan implementasi Flutter adalah logical
pixel. Line height dan letter spacing masih perlu diekstrak dan tidak boleh
ditebak sebagai Figma exact.

Konvensi mapping Flutter berikut adalah keputusan implementasi, bukan data
tambahan dari Figma: Regular → `FontWeight.w400`, Medium → `w500`, SemiBold →
`w600`, Bold → `w700`, dan ExtraBold → `w800`.

Gunakan nama role yang stabil seperti `headingH1`, `bodyM`, `actionL`, dan
`captionM`. Screen tidak boleh membuat `TextStyle` ad hoc apabila role yang
sesuai sudah tersedia.

## Katalog komponen

| Keluarga | Komponen yang telah diinventarisasi |
| --- | --- |
| Assets | Icon, Image, Video, Avatar |
| Informative | Banner, Toast, Dialog, Tooltip, Badge |
| Control | Button, Content Switcher, Action Sheet, Filter, Tabs |
| Input | Checkbox, Radio Button, Toggle, Star Rating, Slider, Number Input, Text Field, Text Area, Dropdown, Search Bar |
| Navigation | Tab Bar, Nav Bar |
| Content | Tag, List Item, List Title, Divider, Calendar, Accordion, Card |
| Progress | Progress Bar, Pagination Dots, Loader, Stepper |
| Chat | Message Bubble, Message Input |
| Map | Map, Location Pin |
| E-commerce | Shopping Cart Item |
| Device | Overlay, Device Components |

### Varian terkonfirmasi dari Figma

Daftar berikut hanya menyatakan nama, state, atau komposisi yang tampak pada
Layers/node terkait. Daftar ini tidak menetapkan ukuran, spacing, radius, atau
nilai visual lain yang belum diekstrak.

- **Button**: 
  Primary, Secondary, dan Tertiary. Figma menulis varian ketiga sebagai
  `Terciary`; implementasi memakai ejaan `Tertiary` dan menyimpan catatan typo
  ini untuk traceability.
- **Dialog**: varian 2-button dan 3-button.
- **Badge**: dot memakai lingkaran `8 × 8`; count satu digit memakai
  `CircleBorder` pada constraint persegi `24 × 24`; count lebih panjang dan
  label memakai bentuk pill dengan tinggi minimum `24`.
- **Content Switcher**: layer section/item serta container; komposisi 2 sampai 4
  segment terlihat pada referensi.
- **Action Sheet**: `.Action` dan `Action Sheet`.
- **Tabs**: `.Tab Item` dan `Tabs`.
- **Search Bar**:
  state empty dengan placeholder, focused dengan text/cursor, dan filled dengan
  text. Property yang terkonfirmasi adalah `Placeholder` dan `Text`. Placeholder
  dan value memakai token tipografi yang sama, `Body M / 14 px`; perbedaannya
  hanya warna semantik.
- **Card**:
  komposisi vertical dengan media/icon/avatar, title, subtitle, description,
  optional tag, dan optional button; komposisi horizontal dengan
  media/avatar/icon serta trailing button/chevron/none.

Setiap komponen menyediakan API berbasis intent dan mengambil nilai visual dari
theme/token. Pengembangan varian baru tetap harus mencatat:

- anatomy dan hierarchy;
- ukuran serta density;
- state (`enabled`, `pressed`, `focused`, `disabled`, `loading`, dan state lain
  yang benar-benar tampak pada referensi);
- property/variant Figma dan nilai default;
- token warna, tipografi, radius, spacing, border, dan icon yang digunakan;
- perilaku interaksi dan semantics.

## Naming dan penggunaan di kode

Konvensi berikut adalah aturan internal SR-POS:

- prefix public component dan token dengan `Sr`, misalnya `SrButton`,
  `SrTextField`, `SrTypography`, dan `SrSemanticColors`;
- gunakan lower camel case untuk token Dart (`headingH1`, `spaceM`) dan Upper
  Camel Case untuk type/widget (`SrButton`);
- pisahkan primitive dari semantic token; widget hanya bergantung pada semantic
  token;
- satu komponen memiliki API berbasis intent/variant, bukan boolean yang saling
  bertabrakan;
- komponen lintas screen berada di design system, sedangkan komponen yang hanya
  menyusun satu feature tetap berada di feature tersebut;
- semua state visual mengambil nilai dari theme agar konsisten dan mudah
  dipelihara;
- penambahan token baru harus menyertakan sumber node atau diberi label
  `assumption` sampai tervalidasi.

## Accessibility baseline

Ketentuan berikut adalah persyaratan implementasi, bukan ukuran Figma exact:

- pertahankan kontras minimum WCAG 2.1 AA: `4.5:1` untuk teks normal dan `3:1`
  untuk teks besar serta elemen UI penting;
- jangan memakai warna sebagai satu-satunya penanda success, warning, error,
  selected, atau disabled; sertakan icon, label, atau perubahan bentuk;
- sediakan label `Semantics`, urutan fokus, dan dukungan keyboard yang jelas
  pada kontrol interaktif;
- target sentuh minimal `44 × 44` logical pixel; gunakan `48 × 48` bila mengikuti
  default Material;
- dukung text scaling tanpa clipping dan jangan mengunci tinggi komponen teks
  sebelum diuji pada skala yang lebih besar;
- hubungkan helper/error text dengan input terkait dan umumkan perubahan status
  penting kepada screen reader;
- hormati preferensi reduced motion untuk animasi non-esensial.

## Checklist sebelum komponen dinyatakan siap pakai

- Variant dan state yang dibutuhkan screen sudah cocok dengan node Figma.
- Tidak ada warna atau style teks literal di luar token/theme.
- Asumsi tercatat dan terpisah dari nilai Figma exact.
- Semantics, focus, text scaling, dan contrast sudah diperiksa.
- Widget test mencakup state utama; golden test menggunakan viewport screen
  referensi bila fidelity visual perlu dijaga.
