# 🚀 IDS Elder Rehab App: Digital Physical Rehabilitation

Aplikasi mobile rehabilitasi fisik digital berbasis **Flutter** dan **BLoC**, dirancang dengan arsitektur **Feature-First Clean Architecture**, antarmuka khusus lansia (High Accessibility), dan ekosistem **AI (Pose Detection) & AR (Augmented Reality)** yang berjalan sepenuhnya secara _offline_.

## ✨ Fitur Utama

- **🔐 Multi-Role Authentication:**
  - Login khusus untuk Lansia, Dokter, dan Caregiver.
  - Tampilan dan fungsionalitas aplikasi otomatis menyesuaikan dengan peran yang masuk.

- **🤖 AI Movement Tracker (Offline-First):**
  - Menggunakan Machine Learning _on-device_ untuk mendeteksi sendi lansia secara _real-time_ .
  - Menghitung repetisi gerakan (contoh: jongkok-berdiri) dan memberikan koreksi postur (suara) tanpa perlu koneksi internet. Privasi pasien 100% aman karena video tidak dikirim ke server.

- **🧊 AR 3D Instructor:**
  - Menampilkan model 3D instruktur di dunia nyata (menggunakan kamera HP) agar lansia bisa melihat contoh gerakan dari berbagai sudut.

- **🎮 Gamifikasi & Jadwal Adaptif:**
  - Sistem _Experience Points_ (XP), Leveling, dan _Badges_ untuk menjaga motivasi lansia.
  - Pengingat jadwal lokal yang beradaptasi dengan kebiasaan lansia menggunakan notifikasi pintar.

- **👥 Caregiver & Doctor Dashboard:**
  - Dokter dapat memberikan resep _micro-learning_ (video panduan).
  - Caregiver dapat memantau grafik kepatuhan lansia dan mengirimkan _voice note_ atau pesan penyemangat.

---

## 🛠️ Tech Stack & Packages

Project ini dibangun menggunakan teknologi _mobile_ terkini dengan mengutamakan performa dan aksesibilitas:

- **Framework:** Flutter (Dart)
- **State Management:** BLoC (`flutter_bloc`)
- **Routing:** GoRouter (URL-based declarative routing)
- **Architecture:** Feature-First Clean Architecture

### 📦 Key Packages

Berikut adalah _package_ utama yang menopang fitur unik aplikasi ini:

| Package                                 | Kegunaan                                                                                                                                         |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| **`google_mlkit_pose_detection`**       | **Engine AI Offline**. Mendeteksi 33 titik sendi tubuh langsung di HP pengguna untuk menghitung repetisi dan mengevaluasi postur tanpa internet. |
| **`model_viewer_plus`**                 | Memuat file `.glb` / `.gltf` dan otomatis membuka mode AR (ARCore/ARKit) agar lansia bisa melihat instruktur 3D di lantai rumah mereka.          |
| **`hive_flutter`**                      | Database NoSQL lokal super cepat untuk menyimpan progres gamifikasi dan jadwal secara _offline_, lalu di-sinkronisasi saat ada sinyal.           |
| **`freezed`** & **`json_serializable`** | Menjamin _state_ aplikasi bersifat _immutable_ dan menangani _parsing_ data dari API secara otomatis agar terhindar dari _bug_.                  |

---

## ⚙️ Instalasi

1. **Clone Repository**

```bash
git clone https://github.com/Muhammad-Sufyan-901/ids-elder-rehab-app.git
cd ids-elder-rehab-app

```

2. **Install Dependencies**

```bash
flutter pub get

```

3. **Generate Code (Freezed & JSON Serializable)**
   Langkah ini wajib untuk membuat model data dan file _routing_ otomatis.

```bash
flutter pub run build_runner build --delete-conflicting-outputs

```

4. **Setup Environment (.env)**
   Buat file `.env` di _root folder_ (jika menggunakan `flutter_dotenv`) untuk menyimpan URL API Backend.

```env
API_BASE_URL=https://api.elder-rehab-app.com/v1
ENVIRONMENT=development

```

5. **Jalankan Aplikasi**
   _Catatan: Sangat disarankan menjalankan aplikasi di **Real Device** (HP Asli) Android/iOS untuk menguji fitur Kamera AI dan ARCore/ARKit._

```bash
flutter run

```

---

## 🏛️ Arsitektur Aplikasi

Kami memisahkan logika aplikasi secara ketat menggunakan **Feature-First Clean Architecture** agar kode tetap bersih, mudah dites, dan _scalable_.

Setiap fitur (contoh: `ai_movement_tracker`, `auth`) dibagi menjadi 3 lapisan (Layers):

### 1. Presentation Layer (`presentation/`)

Berisi UI (Pages/Widgets) dan _State Management_ (BLoC). UI hanya bertugas menampilkan _State_ (Loading, Sukses, Error) dan mengirim _Event_ ke BLoC.

### 2. Domain Layer (`domain/`)

Jantung aplikasi. Berisi _Entities_ (objek murni Dart) dan _UseCases_.

- `CountRepetitionUseCase`: Logika trigonometri untuk menghitung sudut sendi lutut dari data ML Kit.

### 3. Data Layer (`data/`)

Berisi implementasi cara mengambil data.

- `RemoteDataSource`: Menembak API menggunakan `Dio`.
- `LocalDataSource`: Mengambil jadwal dari `Hive` saat HP tidak ada internet.

---

## 🗂️ Struktur Direktori

Struktur direktori aplikasi ini dirancang dengan arsitektur **Feature-First Clean Architecture** untuk memudahkan pengembangan, pemeliharaan, dan pemahaman kode. Berikut adalah struktur direktori utama:

```text
ids_elder_rehab_app/
├── assets/                             # Static physical files
│   ├── images/
│   ├── models/                         # AR 3D Models (.glb)
│   └── sounds/                         # Gamification SFX & Voice Guides
├── lib/
│   ├── core/                           # ⚙️ GLOBAL CORE (Shared everywhere)
│   │   ├── config/                     # api_client.dart (Dio config & interceptors)
│   │   ├── constants/                  # app_colors.dart, app_sizes.dart, api_endpoints.dart
│   │   ├── di/                         # injection_container.dart (GetIt setup)
│   │   ├── error/                      # failures.dart, exceptions.dart
│   │   ├── middlewares/                # auth_middleware.dart, role_guard.dart
│   │   ├── router/                     # app_router.dart (GoRouter Registry & Guards)
│   │   ├── themes/                     # app_theme.dart (High contrast, A11y focus)
│   │   ├── utils/                      # angle_calculator.dart, date_formatter.dart
│   │   └── widgets/                    # 🧱 Global Reusable UI (PrimaryButton, CustomDialog)
│   │
│   ├── features/                       # 📦 MAIN FEATURE MODULES (Clean Architecture)
│   │   │
│   │   ├── auth/                       # Authentication & Role Selection
│   │   │   └── data/                   # Datasources, Models, Repository Impl
|   |   |       ├── models/             # Models
│   │   |       ├── repositories/       # Repository Impl
│   │   |       └── usecases/           # UseCases
│   │   │   ├── domain/                 # Entities, Repository Interface, UseCases
|   |   |       ├── entities/           # Entities
│   │   |       ├── repositories/       # Repository Interface
│   │   |       └── usecases/           # UseCases
│   │   │   └── presentation/           # Screens, Widgets, BLoC
│   |   |       ├── screens/            # Screens
│   |   |       ├── widgets/            # Widgets
│   |   |       └── bloc/               # BLoC
│   │   │
│   │   ├── ar_treatment/               # AR 3D Instruction Module
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/           # ar_viewer_page.dart, ar_instruction_overlay.dart
│   │   │
│   │   ├── ai_movement_tracker/        # AI Camera & Pose Detection (Offline)
│   │   │   ├── domain/                 # detect_pose_usecase.dart, count_reps_usecase.dart
│   │   │   └── presentation/           # smart_camera_page.dart, pose_painter.dart
│   │   │
│   │   ├── rehab_learning/             # 2D Video Micro-learning
│   │   ├── gamification/               # XP, Badges, Leveling System
│   │   ├── schedule_reminder/          # Local adaptive scheduling & notifications
│   │   └── caregiver_feedback/         # Dashboard & monitoring module
│   │
│   └── main.dart                       # App Entry Point & Provider Init
│
├── pubspec.yaml                        # Dependencies (flutter_bloc, dio, hive, get_it, etc.)
├── build.yaml                          # Freezed/Code Generation config
└── gemini.md                           # 🤖 AI Agent Instructions
```

## 🌐 Panduan Sinkronisasi Data (Offline-First Workflow)

Aplikasi ini didesain untuk daerah susah sinyal. Berikut alurnya:

1. **Data Lokal:** Saat lansia selesai latihan AI, poin XP dan status selesai disimpan di `Hive` (Lokal).
2. **Listener Internet:** Aplikasi mendengarkan status koneksi via `internet_connection_checker`.
3. **Sinkronisasi:** Begitu HP mendapat sinyal (misal dari _tethering_ Caregiver), aplikasi otomatis menjalankan fungsi _Sync_ di _background_ untuk mengirim data ke server Dokter.

---

## 🧩 Dokumentasi Komponen (A11y/Lansia)

Komponen UI diletakkan di `lib/core/widgets/` dan dirancang khusus agar ramah lansia.

### 1. Tombol Utama (`PrimaryButton`)

Tombol berukuran besar (`minHeight: 56`) dengan warna kontras dan dukungan pembaca layar (_Semantics_).

```dart
PrimaryButton(
  text: 'Mulai Latihan',
  onPressed: () => context.push('/ar-treatment'),
  semanticLabel: 'Tombol untuk memulai sesi latihan fisik hari ini',
)

```

### 2. Input Teks Ramah Lansia (`CustomTextField`)

Input dengan _font_ besar dan jarak yang lega agar mudah dibaca.

```dart
CustomTextField(
  label: 'Nama Lengkap',
  hintText: 'Masukkan nama Anda...',
  textInputAction: TextInputAction.next,
)

```

---

## 🛡️ Aksesibilitas & Keamanan Data

- **Privasi Medis Terjamin:** Pemrosesan video menggunakan _Google ML Kit_ terjadi 100% di dalam perangkat pengguna. Tidak ada data video wajah/tubuh yang dikirim ke _cloud_.
- **High Contrast UI:** Skema warna di `app_colors.dart` dipastikan lulus standar kontras WCAG AAA.
- **Route Protection:** GoRouter mengatur ketat agar Lansia tidak bisa masuk ke _dashboard_ Dokter, begitupun sebaliknya.

---

## 📝 License

Project ini bersifat open-source di bawah lisensi [MIT license](https://opensource.org/licenses/MIT).
