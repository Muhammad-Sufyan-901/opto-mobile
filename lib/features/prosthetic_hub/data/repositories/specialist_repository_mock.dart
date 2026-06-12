// Mock implementation of [SpecialistRepository].
//
// Returns hardcoded Indonesian ocular-prosthetic specialist data — no network
// or Supabase dependency. Replace with a real Supabase-backed implementation
// once the backend table is provisioned (see `system_architecture.md` Appendix A).

import 'package:opto/features/prosthetic_hub/domain/entities/specialist.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/specialist_repository.dart';

/// Hardcoded specialist directory for UI development and testing.
class SpecialistRepositoryMock implements SpecialistRepository {
  const SpecialistRepositoryMock();

  // ---------------------------------------------------------------------------
  // Hardcoded dataset — 5 realistic Indonesian ocular-prosthetics specialists.
  // Verified specialists appear first (s1, s2, s3).
  // ---------------------------------------------------------------------------

  static const List<Specialist> _all = [
    Specialist(
      id: 's1',
      fullName: 'Dr. Anwar Santoso',
      specialty: 'Ocularist & Prosthetic Specialist',
      isVerified: true,
      repliesLabel: 'usually replies same day',
      clinicName: 'Klinik Mata Anwar, Jakarta',
    ),
    Specialist(
      id: 's2',
      fullName: 'Dr. Siti Rahayu',
      specialty: 'Ophthalmologist',
      isVerified: true,
      repliesLabel: 'replies within 2 days',
      clinicName: 'RSUD Cipto Mangunkusumo, Jakarta',
    ),
    Specialist(
      id: 's3',
      fullName: 'Dr. Budi Hartono',
      specialty: 'Ocular Prosthetic Technician',
      isVerified: true,
      repliesLabel: 'usually replies same day',
      clinicName: 'Pusat Prostesis Okular Bandung',
    ),
    Specialist(
      id: 's4',
      fullName: 'Dr. Rina Kusuma',
      specialty: 'Ophthalmologist',
      isVerified: false,
      repliesLabel: 'replies within 3 days',
      clinicName: 'Klinik Mata Sehat, Surabaya',
    ),
    Specialist(
      id: 's5',
      fullName: 'Ahmad Faisal, S.Prot',
      specialty: 'Certified Ocularist',
      isVerified: false,
      repliesLabel: 'replies within 2 days',
      clinicName: 'Studio Prostesis Mata, Yogyakarta',
    ),
  ];

  // ---------------------------------------------------------------------------
  // SpecialistRepository implementation
  // ---------------------------------------------------------------------------

  /// Returns all specialists with verified ones first.
  @override
  Future<List<Specialist>> getAllSpecialists() async {
    // _all is already ordered: verified (s1–s3) then unverified (s4–s5).
    return List<Specialist>.from(_all);
  }

  /// Returns only verified specialists (recommended list).
  @override
  Future<List<Specialist>> getRecommendedSpecialists() async {
    return _all.where((s) => s.isVerified).toList();
  }

  /// Returns the specialist matching [id] or throws [StateError].
  @override
  Future<Specialist> getSpecialistById(String id) async {
    return _all.firstWhere(
      (s) => s.id == id,
      orElse: () => throw StateError('Specialist not found: $id'),
    );
  }
}
