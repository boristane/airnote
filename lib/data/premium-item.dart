final premiumItems = [
  PremiumItem(title: "Lesley Experience", isAvailableBasic: true, isAvailablePremium: true, description: "The basic Lesley experience"),
  PremiumItem(title: "Guided Audio Journal", isAvailablePremium: true, isAvailableBasic: true, description: "Clinically based guided journaling"),
  PremiumItem(title: "Personalised Guidance", isAvailableBasic: false, isAvailablePremium: true, description: "Personalised daily prompts"),
  PremiumItem(title: "Exclusive Quests", isAvailableBasic: false, isAvailablePremium: true, description: "Hand curated programmes spanning multiple days of guided journaling"),
  PremiumItem(title: "Entries Transcription", isAvailablePremium: true, isAvailableBasic: false, description: "Transcripts of your audio entries"),
];

class PremiumItem {
  final String title;
  final bool isAvailableBasic;
  final bool isAvailablePremium;
  final String description;

  PremiumItem({this.title, this.description, this.isAvailableBasic, this.isAvailablePremium});
}
