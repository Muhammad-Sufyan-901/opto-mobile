# 👁️ Opto — *"Your world, made clear."*

Opto adalah **super app aksesibilitas pertama di Indonesia** yang dirancang khusus untuk pengguna **tunanetra, low-vision, dan pemakai prostesis okular**. Setiap fitur dirancang agar dapat diselesaikan **sepenuhnya tanpa melihat layar** — melalui suara, sentuhan, dan haptic.

Dibangun dengan **Flutter** dan arsitektur **Feature-First Clean Architecture**, didukung oleh **Supabase** sebagai backend, dan dipersenjatai dengan **AI on-device** serta **Aura Voice** yang berjalan di setiap layar.

---

## 🧭 Prinsip Produk — "Invisible & Inclusive"

| # | Prinsip | Penjelasan |
|---|---------|-----------|
| 1 | **Fungsi sebelum estetika** | Setiap elemen harus bermakna saat dibacakan oleh screen reader. |
| 2 | **Tiga indera, satu informasi** | Status penting disampaikan secara **visual + audio + haptic** secara redundan. |
| 3 | **Voice-first, vision-optional** | Semua tugas inti dapat diselesaikan tanpa melihat layar. |
| 4 | **Privasi medis by default** | Data okular, foto mata, dan riwayat konsultasi dilindungi di lapisan database (Row Level Security). |
| 5 | **Sederhana > lengkap** | Navigasi dangkal; hindari sub-menu yang dalam. |

---

## 🌐 Delapan Modul Ekosistem

| # | Modul | Peran |
|---|-------|-------|
| 1 | **Prosthetic Hub (Okular)** | Katalog terverifikasi prostesis mata & case self-cleaning; pemesanan custom anthropometrik; tutorial perawatan (video + teks + audio). |
| 2 | **Health & Consultation** | Telemedicine dengan dokter mata/okularist; konsultasi non-verbal berbasis kamera; booking jadwal & peta klinik. |
| 3 | **Vision AI — "Aura"** | Mata digital real-time: deskripsi adegan, baca teks (OCR), identifikasi objek/warna, panduan navigasi ringan. |
| 4 | **Connect (Komunitas)** | Ruang berbagi pengalaman, motivasi, dan tanya jawab antar sesama pengguna. |
| 5 | **Emergency SOS** | Pemicu darurat berbasis lokasi + notifikasi ke caregiver dan komunitas terdekat. |
| 6 | **Accessibility Map** | Peta kolaboratif fasilitas ramah disabilitas (ramp, lift, jalur taktil, akses kursi roda). |
| 7 | **Aura Voice** | Lapisan navigasi suara di setiap layar ("Pesan prostesis", "Cari dokter", "Panggil darurat"). |
| 8 | **Profile & Accessibility Settings** | Kendali penuh atas tema, tipografi, haptic, suara, tautan caregiver, dan ekspor/hapus data medis. |

---

## 🛠️ Tech Stack

| Kategori | Teknologi |
|----------|-----------|
| **Framework** | Flutter (Dart) — Android & iOS |
| **State Management** | BLoC (`flutter_bloc`) + GetIt (service locator) |
| **Routing** | `go_router` (deklaratif, URL-based, deep link `opto://`) |
| **Backend** | Supabase — Postgres + Row Level Security, Auth (OTP), Storage, Realtime, Edge Functions (Deno) |
| **AI On-Device** | Google ML Kit — Text Recognition (OCR), Object Detection, Color CV |
| **AI Cloud** | Cloud Multimodal LLM via Edge Function `scene-describe` (< 3 s) |
| **Telemedicine** | WebRTC (peer-to-peer, signaling via Supabase Realtime) |
| **Push Notification** | Firebase Cloud Messaging (FCM) via Edge Function `send-notification` |
| **Data Modeling** | `freezed` + `json_serializable` (immutable, auto-generated) |
| **Penyimpanan Lokal** | `hive_flutter` (offline-first cache), `flutter_secure_storage` (sesi biometrik) |
| **Font** | Atkinson Hyperlegible (dirancang untuk low-vision) |

---

## 🏛️ Arsitektur

Opto menggunakan **Feature-First Clean Architecture**. Setiap modul produk di `lib/features/[nama]/` dibagi menjadi tiga lapisan yang ketat:

- **`data/`** → Data sources (Supabase / cache Hive), DTOs, implementasi repository
- **`domain/`** → Entitas Dart murni, kontrak repository (interface), use cases (satu metode `call()`)
- **`presentation/`** → BLoC (event/state via `freezed`), screens, widget spesifik fitur

### Aturan emas

- `lib/core/` **tidak boleh** mengimpor dari `lib/features/`.
- Fitur **tidak boleh** saling mengimpor — kebutuhan lintas fitur melewati `shared/` atau kontrak `domain` yang diekspor.
- Widget **tidak pernah** memanggil `SupabaseClient` secara langsung — selalu lewat **repository** yang mengembalikan domain entity.
- **RLS adalah sumber otorisasi**, bukan klien Flutter. Aplikasi hanya memegang *anon key*; operasi yang membutuhkan hak lebih tinggi dijalankan melalui **Edge Function**.
- Tabel medis sensitif (🔒) bersifat owner-only dan **tidak pernah** muncul di query komunitas, peta, atau katalog.

### Struktur direktori (target)

```
lib/
├── core/
│   ├── accessibility/      # Semantics helpers, katalog haptic, announce()
│   ├── config/             # Konfigurasi app & environment
│   ├── constants/          # Route, warna, tipografi, endpoint
│   ├── di/                 # GetIt — dependencies_injection_container.dart
│   ├── error/              # Failures & exceptions (typed)
│   ├── middlewares/        # Auth guard & role guard (go_router)
│   ├── router/             # app_router.dart — satu-satunya sumber rute
│   ├── supabase/           # SupabaseClient provider & error mapping
│   ├── themes/             # ColorScheme tokens (Light/Dark/High-Contrast)
│   ├── voice/              # STT + NLU intent mapping (Aura Voice engine)
│   ├── widgets/            # Primitif UI aksesibel global (OptoButton, dll.)
│   └── utils/              # Formatter, helper, result types
│
├── features/
│   ├── onboarding/         # Splash, carousel, sign-in hub, setup (4 langkah)
│   ├── auth/               # Login, register, OTP, lupa password
│   ├── profile/            # Settings, caregiver linking, ekspor data medis
│   ├── vision_ai/          # Aura: OCR, object detect, warna, deskripsi adegan
│   ├── prosthetic_hub/     # Katalog, custom order, tutorial, pengingat
│   ├── consultation/       # Pencarian dokter, booking, WebRTC, riwayat
│   ├── connect/            # Feed komunitas, komposer, moderasi
│   ├── sos/                # Pemicu darurat, layar SOS aktif, dispatch
│   └── map/                # Accessibility Map, detail POI, kontribusi
│
└── shared/                 # Value objects & model lintas fitur (gunakan seperlunya)
```

---

## ♿ Aksesibilitas — Inti Aplikasi

Setiap layar **wajib** memenuhi standar berikut (lihat `design_system.md` §9 & §15.4):

- `Semantics` / `MergeSemantics` di semua elemen interaktif; dekorasi dikecualikan dengan `ExcludeSemantics`.
- Status dinamis (hasil Vision AI, error form, "SOS terkirim") diumumkan via **live region** (`SemanticsService.announce`).
- Target sentuhan ≥ **48 × 48 dp**; teks bisa di-scale s/d **300%** dengan reflow (tidak ada overflow/clipping).
- Kontras ≥ **4.5:1** untuk teks, ≥ **3:1** untuk batas komponen. **Tidak ada makna yang hanya dikodekan lewat warna** — selalu dipasangkan dengan teks + ikon + audio + haptic.
- Haptic dijalankan dari **katalog bersama** (`design_system.md` §6); pola *danger/SOS* (pulsa panjang) adalah reserved dan tidak pernah digunakan untuk kejadian lain.
- Setiap layar menyediakan jalur **Aura Voice** untuk tugas utamanya.
- **Tidak ada visual CAPTCHA** di mana pun.
- Tema default **Light** (biru-putih); **Dark** dan **High-Contrast** tersedia sebagai opsi.
- Font utama: **Atkinson Hyperlegible**.

**Target sertifikasi:** WCAG 2.2 AA, kompatibilitas penuh TalkBack (Android) & VoiceOver (iOS).

---

## ⚙️ Instalasi & Menjalankan

### 1. Clone & install dependensi

```bash
git clone <url-repo>
cd opto
flutter pub get
```

### 2. Generate kode (Freezed & JSON Serializable)

Langkah ini **wajib** dijalankan setelah membuat atau mengubah model data.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Konfigurasi environment

Buat file `.env` di root folder:

```env
SUPABASE_URL=https://<project-ref>.supabase.co
SUPABASE_ANON_KEY=<your-anon-key>
ENVIRONMENT=development
```

> ⚠️ **Jangan** commit file `.env` ke repository.

### 4. Jalankan aplikasi

```bash
flutter run
```

> 📱 **Sangat disarankan menggunakan perangkat fisik** (bukan emulator) untuk menguji fitur kamera Vision AI, ARCore/ARKit, dan haptic feedback.

---

## 🗺️ Roadmap

| Fase | Fokus | Modul |
|------|-------|-------|
| **MVP (P0)** | Kemandirian & keamanan inti | Onboarding, Vision AI (adegan + OCR), Prosthetic Hub (katalog + order + tutorial), Health & Consultation (booking + konsultasi), Emergency SOS, Profile/Settings |
| **V1 (P1)** | Komunitas & retensi | Connect, Accessibility Map, pengingat perawatan, latihan mata, Vision AI objek/warna |
| **V2 (P2)** | Lanjutan | Navigasi rintangan, follow topik, kontribusi peta, evaluasi integrasi asuransi |

---

## 🛡️ Privasi & Keamanan

- **Privasi medis terjamin:** pemrosesan kamera (OCR, deteksi objek, identifikasi warna iris) terjadi 100% di dalam perangkat menggunakan Google ML Kit. Tidak ada video atau foto tubuh/wajah yang dikirim ke cloud tanpa izin eksplisit.
- **RLS di setiap tabel:** tidak ada tabel yang dikirim tanpa Row Level Security. Kebijakan RLS diuji untuk happy path (pemilik bisa baca) dan sad path (orang lain ditolak, caregiver yang dicabut aksesnya ditolak).
- **Bucket Storage privat:** `eye-photos` dan `consultation-attachments` bersifat private dengan signed URL saja; kebijakan bucket mencerminkan RLS tabel.
- **Edge Functions:** satu-satunya jalur untuk operasi service-role (SOS dispatch, LLM proxy, payment, push). Kunci service-role **tidak pernah** ada di dalam aplikasi Flutter.
- **Kepatuhan data:** ekspor dan penghapusan data medis tersedia sesuai ketentuan UU PDP.

---

## 📝 Lisensi

Project ini bersifat open-source di bawah lisensi [MIT](https://opensource.org/licenses/MIT).
