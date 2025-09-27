import 'package:flutter/material.dart';
import '../models/education_models.dart';

class EducationMockData {
  static final List<EducationModule> modules = [
    EducationModule(
      id: 'nutrition',
      title: 'Nutrition Guide',
      icon: Icons.restaurant,
      color: Colors.green,
      totalLessons: 12,
      completedLessons: 8,
      duration: '45 min',
      difficulty: 'Medium',
      overview:
          'Proper nutrition fuels peak performance. Learn how to plan meals, hydrate, and recover effectively.',
      objectives: const [
        'Understand macronutrients and micronutrients',
        'Plan pre- and post-workout meals',
        'Create a personalized nutrition plan',
      ],
      lessons: [
        const Lesson(
          id: 'l1',
          title: 'Basics of Sports Nutrition',
          content:
              'Proper nutrition is the foundation of athletic performance. Athletes need 1.2-2.0g protein per kg body weight daily... ',
          duration: '5 min',
          isCompleted: true,
          isLocked: false,
          keyPoints: [
            'Protein supports muscle repair',
            'Carbs are the main energy source',
            'Fats support hormones and recovery',
          ],
        ),
        const Lesson(
          id: 'l2',
          title: 'Pre-Workout Nutrition',
          content:
              'Eat 2-3 hours before training. Focus on carbohydrates for energy. Avoid high-fat foods that slow digestion...',
          duration: '4 min',
          isCompleted: true,
          isLocked: false,
          keyPoints: ['Carbs timing', 'Hydration', 'Avoid heavy fats'],
        ),
        const Lesson(
          id: 'l3',
          title: 'Hydration Strategies',
          content:
              'Drink 500ml water 2 hours before exercise. During exercise, consume 150-250ml every 15-20 minutes...',
          duration: '4 min',
          isCompleted: false,
          isLocked: false,
          keyPoints: ['Pre-hydration', 'During exercise', 'Electrolytes'],
        ),
        // ... fill remaining lessons as simple placeholders
        const Lesson(
          id: 'l4',
          title: 'Post-Workout Recovery Foods',
          content: 'Protein + carbs within 45 minutes improves recovery.',
          duration: '4 min',
          isCompleted: false,
          isLocked: false,
          keyPoints: ['Protein', 'Carbs', 'Timing'],
        ),
        const Lesson(
          id: 'l5',
          title: 'Micronutrients for Athletes',
          content: 'Vitamins and minerals support performance and recovery.',
          duration: '3 min',
          isCompleted: false,
          isLocked: true,
          keyPoints: ['Iron', 'Vitamin D', 'Magnesium'],
        ),
        const Lesson(
          id: 'l6',
          title: 'Meal Planning for Training',
          content: 'Structure meals around training load and recovery windows.',
          duration: '4 min',
          isCompleted: false,
          isLocked: true,
          keyPoints: ['Periodization', 'Portions', 'Prep'],
        ),
        const Lesson(
          id: 'l7',
          title: 'Supplements: Facts vs Fiction',
          content: 'Evidence-based supplements vs marketing claims.',
          duration: '3 min',
          isCompleted: false,
          isLocked: true,
          keyPoints: ['Creatine', 'Caffeine', 'Whey'],
        ),
        const Lesson(
          id: 'l8',
          title: 'Competition Day Nutrition',
          content: 'Simple, familiar foods that sit well. Hydrate early.',
          duration: '4 min',
          isCompleted: false,
          isLocked: true,
          keyPoints: ['Familiarity', 'Timing', 'Hydration'],
        ),
        const Lesson(
          id: 'l9',
          title: 'Weight Management for Athletes',
          content: 'Sustainable approaches to weight changes.',
          duration: '4 min',
          isCompleted: false,
          isLocked: true,
          keyPoints: ['Rate of change', 'Recovery', 'Support'],
        ),
        const Lesson(
          id: 'l10',
          title: 'Vegetarian Sports Nutrition',
          content: 'Meeting protein and micronutrient needs.',
          duration: '4 min',
          isCompleted: false,
          isLocked: true,
          keyPoints: ['Protein sources', 'B12', 'Iron'],
        ),
        const Lesson(
          id: 'l11',
          title: 'Reading Nutrition Labels',
          content: 'Identify serving sizes and key nutrients.',
          duration: '3 min',
          isCompleted: false,
          isLocked: true,
          keyPoints: ['Serving size', 'Macros', 'Ingredients'],
        ),
        const Lesson(
          id: 'l12',
          title: 'Creating Your Nutrition Plan',
          content: 'Put it all together with a weekly template.',
          duration: '5 min',
          isCompleted: false,
          isLocked: true,
          keyPoints: ['Schedule', 'Shopping list', 'Adjustments'],
        ),
      ],
    ),
    EducationModule(
      id: 'anti_doping',
      title: 'Anti-Doping Education',
      icon: Icons.security,
      color: Colors.red,
      totalLessons: 8,
      completedLessons: 8,
      duration: '30 min',
      difficulty: 'Easy',
      overview:
          'Understand anti-doping rules to compete fairly and safely.',
      objectives: const [
        'Know the WADA list basics',
        'Understand TUEs and supplement risk',
        'Learn testing procedures',
      ],
      lessons: const [
        Lesson(
          id: 'l1',
          title: 'What is Doping?',
          content:
              'Doping is the use of banned performance-enhancing drugs or methods...',
          duration: '4 min',
          isCompleted: true,
          isLocked: false,
          keyPoints: ['Fair play', 'Health risks', 'Integrity'],
        ),
        Lesson(
          id: 'l2',
          title: 'WADA Prohibited List',
          content: 'Updated annually; categories include stimulants, steroids...',
          duration: '4 min',
          isCompleted: true,
          isLocked: false,
          keyPoints: ['Categories', 'Updates', 'Resources'],
        ),
        Lesson(id: 'l3', title: 'Therapeutic Use Exemptions', content: 'TUE basics.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Eligibility', 'Process']),
        Lesson(id: 'l4', title: 'Supplement Safety', content: 'Third-party tested products.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Contamination', 'Certification']),
        Lesson(id: 'l5', title: 'Testing Procedures', content: 'What to expect during testing.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Sample collection', 'Rights']),
        Lesson(id: 'l6', title: 'Consequences of Doping', content: 'Bans and health effects.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Sanctions', 'Reputation']),
        Lesson(id: 'l7', title: 'Clean Sport Values', content: 'Why clean sport matters.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Respect', 'Responsibility']),
        Lesson(id: 'l8', title: 'Reporting Violations', content: 'How to report safely.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Confidential', 'Channels']),
      ],
    ),
    EducationModule(
      id: 'exercise',
      title: 'Exercise Techniques',
      icon: Icons.fitness_center,
      color: Colors.blue,
      totalLessons: 15,
      completedLessons: 9,
      duration: '60 min',
      difficulty: 'Medium',
      overview:
          'Master technique to train safely and effectively across strength and conditioning.',
      objectives: const [
        'Warm-up and cool-down correctly',
        'Strength and power fundamentals',
        'Plan training across the week',
      ],
      lessons: const [
        Lesson(
          id: 'l1',
          title: 'Proper Warm-up Protocols',
          content:
              'Start with 5-10 minutes light cardio, dynamic stretching, and activation...',
          duration: '4 min',
          isCompleted: true,
          isLocked: false,
          keyPoints: ['Raise', 'Activate', 'Mobilize'],
        ),
        Lesson(id: 'l2', title: 'Strength Training Fundamentals', content: 'Movement patterns, reps, load.', duration: '4 min', isCompleted: true, isLocked: false, keyPoints: ['Squat', 'Hinge', 'Push/Pull']),
        Lesson(id: 'l3', title: 'Cardiovascular Training Methods', content: 'Intervals vs steady state.', duration: '4 min', isCompleted: true, isLocked: false, keyPoints: ['HIIT', 'Z2']),
        Lesson(id: 'l4', title: 'Flexibility and Mobility', content: 'Static vs dynamic stretching.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Timing', 'Safety']),
        Lesson(id: 'l5', title: 'Plyometric Training', content: 'Jump training basics.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Landing', 'Volume']),
        Lesson(id: 'l6', title: 'Core Strengthening', content: 'Anti-rotation and stability.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Bracing', 'Progressions']),
        Lesson(id: 'l7', title: 'Balance and Coordination', content: 'Proprioception work.', duration: '3 min', isCompleted: false, isLocked: false, keyPoints: ['Unstable', 'Single-leg']),
        Lesson(id: 'l8', title: 'Speed Development', content: 'Technique + sprint drills.', duration: '3 min', isCompleted: false, isLocked: false, keyPoints: ['Accel', 'Max velocity']),
        Lesson(id: 'l9', title: 'Agility Training', content: 'COD and reactive drills.', duration: '3 min', isCompleted: false, isLocked: false, keyPoints: ['Footwork', 'Reaction']),
        Lesson(id: 'l10', title: 'Power Development', content: 'Force-velocity curve.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Olympic lifts', 'Jumps']),
        Lesson(id: 'l11', title: 'Endurance Building', content: 'Volume, intensity, frequency.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Long runs', 'Recovery']),
        Lesson(id: 'l12', title: 'Sport-Specific Drills', content: 'Transfer to play.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Specificity', 'Skill']),
        Lesson(id: 'l13', title: 'Cool-down Techniques', content: 'Lower HR, light mobility.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Breathing', 'Stretch']),
        Lesson(id: 'l14', title: 'Training Periodization', content: 'Macro/meso/micro cycles.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Blocks', 'Peaking']),
        Lesson(id: 'l15', title: 'Monitoring Training Load', content: 'RPE and metrics.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['RPE', 'HRV']),
      ],
    ),
    EducationModule(
      id: 'psychology',
      title: 'Sports Psychology',
      icon: Icons.psychology,
      color: Colors.purple,
      totalLessons: 10,
      completedLessons: 4,
      duration: '35 min',
      difficulty: 'Easy',
      overview:
          'Train your mind like your body. Build confidence, focus, and resilience.',
      objectives: const [
        'Set meaningful goals',
        'Manage anxiety',
        'Use visualization',
      ],
      lessons: const [
        Lesson(
          id: 'l1',
          title: 'Mental Training Basics',
          content:
              'Mental skills are like physical skills - they can be developed with practice...',
          duration: '4 min',
          isCompleted: true,
          isLocked: false,
          keyPoints: ['Confidence', 'Focus', 'Resilience'],
        ),
        Lesson(id: 'l2', title: 'Goal Setting Strategies', content: 'SMART goals framework.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Specific', 'Measurable']),
        Lesson(id: 'l3', title: 'Visualization Techniques', content: 'Rehearse success mentally.', duration: '3 min', isCompleted: false, isLocked: false, keyPoints: ['Imagery', 'Senses']),
        Lesson(id: 'l4', title: 'Managing Competition Anxiety', content: 'Breathing and routines.', duration: '3 min', isCompleted: false, isLocked: false, keyPoints: ['Breath', 'Cues']),
        Lesson(id: 'l5', title: 'Building Confidence', content: 'Self-talk and evidence.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Affirmations', 'Wins']),
        Lesson(id: 'l6', title: 'Focus and Concentration', content: 'Attentional control.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['External', 'Internal']),
        Lesson(id: 'l7', title: 'Dealing with Setbacks', content: 'Growth mindset.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Learning', 'Bounce back']),
        Lesson(id: 'l8', title: 'Team Communication', content: 'Roles and feedback.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Active listening', 'Clarity']),
        Lesson(id: 'l9', title: 'Pre-Competition Routines', content: 'Consistent prep.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Checklist', 'Timing']),
        Lesson(id: 'l10', title: 'Staying Motivated', content: 'Intrinsic vs extrinsic.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Purpose', 'Habits']),
      ],
    ),
    EducationModule(
      id: 'recovery',
      title: 'Recovery Methods',
      icon: Icons.healing,
      color: Colors.orange,
      totalLessons: 6,
      completedLessons: 5,
      duration: '25 min',
      difficulty: 'Easy',
      overview:
          'Recovery drives adaptation. Sleep, active recovery, and smart modalities matter.',
      objectives: const [
        'Sleep optimization',
        'Active recovery planning',
        'Modalities pros/cons',
      ],
      lessons: const [
        Lesson(
          id: 'l1',
          title: 'Importance of Recovery',
          content:
              'Recovery is when your body adapts and gets stronger. Without proper recovery...',
          duration: '4 min',
          isCompleted: true,
          isLocked: false,
          keyPoints: ['Adaptation', 'Injury risk', 'Planning'],
        ),
        Lesson(id: 'l2', title: 'Sleep for Athletes', content: 'Duration and quality.', duration: '4 min', isCompleted: true, isLocked: false, keyPoints: ['7-9 hours', 'Routine']),
        Lesson(id: 'l3', title: 'Active Recovery Techniques', content: 'Light movement days.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Zone 1', 'Mobility']),
        Lesson(id: 'l4', title: 'Massage and Self-Massage', content: 'When and how.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['Foam roll', 'Timing']),
        Lesson(id: 'l5', title: 'Ice Baths and Heat Therapy', content: 'Use sparingly around strength.', duration: '3 min', isCompleted: false, isLocked: false, keyPoints: ['Cold', 'Heat']),
        Lesson(id: 'l6', title: 'Stress Management', content: 'Breathing and mindfulness.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Breathwork', 'Meditation']),
      ],
    ),
    EducationModule(
      id: 'injury_prevention',
      title: 'Injury Prevention',
      icon: Icons.health_and_safety,
      color: Colors.teal,
      totalLessons: 9,
      completedLessons: 2,
      duration: '40 min',
      difficulty: 'Medium',
      overview:
          'Reduce risk through smart load, technique, and early warning recognition.',
      objectives: const [
        'Identify risk factors',
        'Improve movement quality',
        'Respond to early signs',
      ],
      lessons: const [
        Lesson(
          id: 'l1',
          title: 'Common Sports Injuries',
          content:
              'Understanding injury patterns helps prevention. Most injuries occur due to overuse...',
          duration: '4 min',
          isCompleted: true,
          isLocked: false,
          keyPoints: ['Overuse', 'Technique', 'Preparation'],
        ),
        Lesson(id: 'l2', title: 'Risk Factor Assessment', content: 'History and screening.', duration: '3 min', isCompleted: true, isLocked: false, keyPoints: ['History', 'Asymmetries']),
        Lesson(id: 'l3', title: 'Proper Equipment Use', content: 'Fit and maintenance.', duration: '3 min', isCompleted: false, isLocked: false, keyPoints: ['Shoes', 'Protective gear']),
        Lesson(id: 'l4', title: 'Movement Quality', content: 'Technique and control.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Form', 'Coaching']),
        Lesson(id: 'l5', title: 'Load Management', content: 'Progression and rest.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['10% rule', 'Deloads']),
        Lesson(id: 'l6', title: 'Environmental Considerations', content: 'Heat, cold, surfaces.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Acclimatization', 'Surfaces']),
        Lesson(id: 'l7', title: 'Warning Signs', content: 'Red flags and niggles.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Swelling', 'Pain scale']),
        Lesson(id: 'l8', title: 'First Aid Basics', content: 'RICE and beyond.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Rest', 'Ice', 'Compression', 'Elevation']),
        Lesson(id: 'l9', title: 'Return to Sport Guidelines', content: 'Graded return.', duration: '3 min', isCompleted: false, isLocked: true, keyPoints: ['Criteria', 'Testing']),
      ],
    ),
  ];

  static EducationModule? getModuleById(String id) {
    try {
      return modules.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  static Lesson? getLesson(String moduleId, String lessonId) {
    final module = getModuleById(moduleId);
    if (module == null) return null;
    try {
      return module.lessons.firstWhere((l) => l.id == lessonId);
    } catch (_) {
      return null;
    }
  }
}


