// Mock implementation of [CareGuidesRepository].
//
// Returns hardcoded data synchronously — no network or Supabase dependency.
// Replace with a real Supabase-backed implementation once the backend table
// is provisioned (see `system_architecture.md` Appendix A).

import 'package:opto/features/prosthetic_hub/domain/entities/care_guide.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/care_guides_repository.dart';

/// Hardcoded care guide data for UI development and testing.
class CareGuidesRepositoryMock implements CareGuidesRepository {
  const CareGuidesRepositoryMock();

  @override
  Future<List<CareGuide>> getCareGuides() async {
    return const [
      // 1 — Inserting
      CareGuide(
        id: 'guide-insert',
        title: 'Inserting Your Prosthesis',
        category: CareGuideCategory.insert,
        hasAudio: true,
        durationLabel: '~3 min',
        sortOrder: 1,
        transcript: '''
Step 1: Wash your hands thoroughly with soap and warm water for at least 20 seconds. Dry with a clean lint-free towel.

Step 2: Place a clean towel or soft cloth over a flat surface in case the prosthesis slips from your fingers.

Step 3: Apply 1–2 drops of approved lubricating solution to the prosthesis. Do not use tap water or saliva.

Step 4: Hold the prosthesis between your thumb and forefinger with the flat side facing you and the notched end (if present) pointing toward the nose.

Step 5: With your free hand, gently pull down the lower eyelid using your middle finger.

Step 6: Tilt your head slightly forward and look down. Slide the upper edge of the prosthesis under the upper eyelid first.

Step 7: Gently push the lower edge of the prosthesis down and behind the lower eyelid until it sits comfortably in the socket.

Step 8: Blink a few times naturally to center the prosthesis. Use a clean fingertip to adjust position if necessary.

Step 9: Check that the pupil (iris detail) is oriented correctly — typically centered and slightly upward.

If you experience pain, resistance, or the prosthesis does not seat easily, do not force it. Consult your ocularist.
''',
        steps: [
          CareGuideStep(
            title: 'Wash your hands',
            body:
                'Wash thoroughly with soap and warm water for at least 20 seconds. Dry with a clean lint-free towel.',
          ),
          CareGuideStep(
            title: 'Prepare a soft surface',
            body:
                'Place a clean towel or soft cloth over a flat surface in case the prosthesis slips from your fingers.',
          ),
          CareGuideStep(
            title: 'Apply lubricating solution',
            body: 'Apply 1–2 drops of approved lubricating solution to the prosthesis.',
            tip: 'Never use tap water or saliva — they introduce bacteria and can damage the surface.',
          ),
          CareGuideStep(
            title: 'Hold correctly',
            body:
                'Hold the prosthesis between your thumb and forefinger with the flat side facing you and the notched end (if present) pointing toward the nose.',
          ),
          CareGuideStep(
            title: 'Open the eyelid',
            body:
                'With your free hand, gently pull down the lower eyelid using your middle finger.',
          ),
          CareGuideStep(
            title: 'Slide in the upper edge',
            body:
                'Tilt your head slightly forward and look down. Slide the upper edge of the prosthesis under the upper eyelid first.',
          ),
          CareGuideStep(
            title: 'Seat the lower edge',
            body:
                'Gently push the lower edge of the prosthesis down and behind the lower eyelid until it sits comfortably in the socket.',
          ),
          CareGuideStep(
            title: 'Center and check',
            body:
                'Blink a few times naturally to center the prosthesis. Check that the pupil (iris detail) is oriented correctly — typically centered and slightly upward.',
          ),
        ],
      ),

      // 2 — Removing
      CareGuide(
        id: 'guide-remove',
        title: 'Removing Your Prosthesis',
        category: CareGuideCategory.remove,
        hasAudio: true,
        durationLabel: '~2 min',
        sortOrder: 2,
        transcript: '''
Step 1: Wash your hands thoroughly with soap and warm water. Dry completely.

Step 2: Place a soft cloth or folded towel over your lap or a flat surface to catch the prosthesis.

Step 3: Look upward. With one hand, gently pull down the lower eyelid using your index or middle finger.

Step 4: Using the small rubber suction cup (if available), moisten the tip slightly and apply it to the center of the prosthesis iris.

Step 5: If using your finger instead of a suction cup: hook the tip of your index finger under the lower edge of the prosthesis.

Step 6: Apply gentle downward pressure while looking up. The prosthesis will slide out from under the lower eyelid.

Step 7: Catch the prosthesis in your cupped free hand or let it fall onto the cloth.

Step 8: Immediately rinse the prosthesis under clean running water and place it in its storage case filled with saline solution or approved lens storage solution.

Step 9: Inspect the socket in a mirror. Clean the socket gently with a clean damp cotton pad if needed.

Contact your ocularist if removal causes pain or if the prosthesis appears scratched or damaged.
''',
        steps: [
          CareGuideStep(
            title: 'Wash your hands',
            body: 'Wash thoroughly with soap and warm water. Dry completely before touching your prosthesis.',
          ),
          CareGuideStep(
            title: 'Prepare a catch surface',
            body:
                'Place a soft cloth or folded towel over your lap or a flat surface to catch the prosthesis safely.',
          ),
          CareGuideStep(
            title: 'Open the eyelid',
            body:
                'Look upward. With one hand, gently pull down the lower eyelid using your index or middle finger.',
          ),
          CareGuideStep(
            title: 'Use removal tool or finger',
            body:
                'Moisten a rubber suction cup and apply it to the prosthesis iris, or hook your fingertip under the lower edge of the prosthesis.',
          ),
          CareGuideStep(
            title: 'Ease it out',
            body:
                'Apply gentle downward pressure while looking up. The prosthesis will slide out from under the lower eyelid into your cupped hand.',
            tip: 'If removal causes pain or resistance, stop immediately and contact your ocularist.',
          ),
          CareGuideStep(
            title: 'Store immediately',
            body:
                'Rinse the prosthesis under clean running water and place it in its storage case filled with fresh saline or approved storage solution.',
          ),
        ],
      ),

      // 3 — Cleaning
      CareGuide(
        id: 'guide-clean',
        title: 'Daily Cleaning Routine',
        category: CareGuideCategory.clean,
        hasAudio: true,
        durationLabel: '~4 min',
        sortOrder: 3,
        transcript: '''
Step 1: Remove the prosthesis following the Removal guide steps. Wash your hands before handling.

Step 2: Fill a small clean bowl with warm (not hot) sterile saline solution or your ocularist-recommended cleaning solution.

Step 3: Place the prosthesis in the bowl and let it soak for 2–3 minutes to loosen debris.

Step 4: Hold the prosthesis between your thumb and forefinger. Using a soft cotton pad or a clean lint-free cloth, gently wipe the entire surface using circular motions.

Step 5: Pay special attention to any mucous build-up on the edges or back of the prosthesis.

Step 6: Do NOT use toothpaste, household cleaners, alcohol, or hydrogen peroxide — these can etch the acrylic surface.

Step 7: Rinse the prosthesis under clean lukewarm running water for at least 30 seconds.

Step 8: Inspect under good lighting. The surface should appear clear and scratch-free. If cloudy, repeat the soak and gentle wipe.

Step 9: Apply 1–2 drops of approved lubricant before re-inserting, or store in solution if not wearing.

Step 10: Clean your storage case with warm water and allow it to air-dry completely before refilling with fresh solution.

Aim to perform a full cleaning at least once a week or whenever discharge or discomfort increases.
''',
        steps: [
          CareGuideStep(
            title: 'Remove and wash hands',
            body:
                'Remove the prosthesis following the Removal guide. Wash your hands thoroughly before handling it.',
          ),
          CareGuideStep(
            title: 'Soak in saline',
            body:
                'Fill a clean bowl with warm sterile saline solution and let the prosthesis soak for 2–3 minutes to loosen debris.',
          ),
          CareGuideStep(
            title: 'Gently wipe the surface',
            body:
                'Using a soft cotton pad or lint-free cloth, wipe the entire surface in circular motions. Pay attention to mucous build-up on the edges and back.',
            tip: 'Never use toothpaste, alcohol, or household cleaners — they permanently etch the acrylic surface.',
          ),
          CareGuideStep(
            title: 'Rinse thoroughly',
            body:
                'Rinse under clean lukewarm running water for at least 30 seconds. The surface should appear clear and scratch-free.',
          ),
          CareGuideStep(
            title: 'Lubricate before reinserting',
            body:
                'Apply 1–2 drops of approved lubricant before re-inserting. If storing overnight, place in fresh solution instead.',
          ),
          CareGuideStep(
            title: 'Clean the storage case',
            body:
                'Rinse the case with warm water and allow it to air-dry completely before refilling with fresh solution.',
          ),
        ],
      ),

      // 4 — Lubrication
      CareGuide(
        id: 'guide-lubricate',
        title: 'Lubrication Guide',
        category: CareGuideCategory.lubricate,
        hasAudio: false,
        durationLabel: '~2 min',
        sortOrder: 4,
        transcript: '''
Why lubrication matters: The prosthesis does not produce natural tears. Regular lubrication reduces friction, prevents socket irritation, and extends the surface life of the prosthesis.

When to lubricate:
- Before inserting the prosthesis each morning.
- Every 3–4 hours during the day if you notice increased friction, redness, or a gritty sensation.
- Immediately after swimming, exposure to wind, or prolonged air-conditioned environments.

How to lubricate:
Step 1: Wash your hands thoroughly and dry them.

Step 2: Tilt your head back slightly and look upward.

Step 3: Pull down the lower eyelid gently with one finger.

Step 4: Apply 1–2 drops of your ocularist-recommended lubricating drops directly onto the visible surface of the prosthesis or into the lower eyelid pocket.

Step 5: Blink naturally 3–4 times to distribute the lubricant evenly.

Recommended products: Use only preservative-free artificial tear drops or the specific product recommended by your ocularist. Common options include sodium hyaluronate 0.1% or carbomer-based drops.

What to avoid: Do not use contact lens rewetting drops, medicated eye drops, or oil-based preparations unless specifically prescribed. Thick gels are generally not suitable for daily use over a prosthesis.

If dryness persists despite regular lubrication, consult your ocularist — the prosthesis may need polishing or refitting.
''',
        steps: [
          CareGuideStep(
            title: 'Wash your hands',
            body: 'Wash and dry your hands thoroughly before touching your prosthesis.',
          ),
          CareGuideStep(
            title: 'Tilt and look up',
            body: 'Tilt your head back slightly and look upward.',
          ),
          CareGuideStep(
            title: 'Open the lower lid',
            body: 'Gently pull down the lower eyelid with one finger.',
          ),
          CareGuideStep(
            title: 'Apply drops',
            body:
                'Apply 1–2 drops of your ocularist-recommended lubricating drops onto the visible prosthesis surface or into the lower eyelid pocket.',
            tip: 'Use only preservative-free artificial tears. Avoid contact lens rewetting drops, medicated drops, or oil-based preparations.',
          ),
          CareGuideStep(
            title: 'Blink to distribute',
            body: 'Blink naturally 3–4 times to spread the lubricant evenly across the surface.',
          ),
        ],
      ),

      // 5 — Case use
      CareGuide(
        id: 'guide-case',
        title: 'Using Your Storage Case',
        category: CareGuideCategory.caseUse,
        hasAudio: false,
        durationLabel: '~1 min',
        sortOrder: 5,
        transcript: '''
Your storage case keeps the prosthesis safe, moist, and clean during the hours you are not wearing it — typically during sleep.

Step 1: Before storing, clean the prosthesis following the Cleaning guide.

Step 2: Fill the case completely with fresh sterile saline solution or your ocularist-recommended storage solution. Do not use tap water.

Step 3: Place the prosthesis in the case with the convex (curved front) surface facing upward if your case has a curved holder, or lying flat otherwise.

Step 4: Close the lid securely. Label the case if you have more than one prosthesis.

Step 5: Store the closed case at room temperature, away from direct sunlight and extreme heat. Bathroom cabinets with good ventilation are suitable.

Step 6: Replace the solution daily — do not top up old solution. Bacteria can grow in stagnant solution.

Step 7: Wash the storage case itself with warm water and mild soap weekly. Rinse thoroughly and air-dry before refilling.

Step 8: Inspect the case for cracks, stains, or odor regularly. Replace it every 3 months or sooner if damaged.

Reminder: Never leave the prosthesis dry in the case overnight. A dry prosthesis can develop micro-cracks over time.
''',
        steps: [
          CareGuideStep(
            title: 'Clean first',
            body: 'Before storing, clean the prosthesis following the Cleaning guide.',
          ),
          CareGuideStep(
            title: 'Fill with fresh solution',
            body:
                'Fill the case completely with fresh sterile saline or your ocularist-recommended storage solution.',
            tip: 'Never use tap water — it contains bacteria that can damage the surface and irritate the socket.',
          ),
          CareGuideStep(
            title: 'Place the prosthesis',
            body:
                'Place the prosthesis with the convex (curved front) surface facing upward, or lying flat if your case has no curved holder.',
          ),
          CareGuideStep(
            title: 'Close and store',
            body:
                'Close the lid securely and store at room temperature, away from direct sunlight and extreme heat.',
          ),
          CareGuideStep(
            title: 'Replace solution daily',
            body:
                'Replace the solution every day — never top up old solution, as bacteria can grow in stagnant liquid.',
          ),
          CareGuideStep(
            title: 'Weekly case cleaning',
            body:
                'Wash the case with warm water and mild soap weekly. Rinse thoroughly and air-dry before refilling. Replace the case every 3 months.',
          ),
        ],
      ),
    ];
  }
}
