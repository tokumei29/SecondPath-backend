FactoryBot.define do
  factory :cognitive_distortion_assessment do
    user { nil }
    all_or_nothing { 1 }
    overgeneralization { 1 }
    mental_filter { 1 }
    disqualifying_the_positive { 1 }
    jumping_to_conclusions { 1 }
    magnification_minimization { 1 }
    emotional_reasoning { 1 }
    should_statements { 1 }
    labeling { 1 }
    personalization { 1 }
  end
end
