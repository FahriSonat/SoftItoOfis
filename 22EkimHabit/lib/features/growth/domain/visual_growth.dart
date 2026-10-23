enum GrowthStage {
  seed('Tohum', '🌱', 'Yolculuk yeni bir tohumla başladı.'),
  sprout('Filiz', '🌿', 'İlk adımlar kök salıyor.'),
  sapling('Fidan', '🪴', 'Düzen ve istikrar güçleniyor.'),
  youngTree('Genç Ağaç', '🌳', 'Dalların rüzgarlara karşı dayanıklı.'),
  bloomingTree('Çiçek Açan Ağaç', '🌸', 'Emeğinin güzelliği açığa çıkıyor.'),
  ancientTree('Ulu Çınar', '🌲', 'Sarsılmaz bir dengeye ulaştın.');

  final String title;
  final String icon;
  final String message;

  const GrowthStage(this.title, this.icon, this.message);

  static GrowthStage fromDays(int days) {
    if (days < 3) return GrowthStage.seed;
    if (days < 7) return GrowthStage.sprout;
    if (days < 14) return GrowthStage.sapling;
    if (days < 30) return GrowthStage.youngTree;
    if (days < 60) return GrowthStage.bloomingTree;
    return GrowthStage.ancientTree;
  }
}
