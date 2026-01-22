enum ImplementEnum {
  bakingDish('baking dish', 'fırın kabı'),
  bakingSheet('baking sheet', 'fırın tepsisi'),
  baster('baster', 'sos şırıngası'),
  blender('blender', 'blender'),
  casseroleDish('casserole dish', 'güveç kabı'),
  colander('colander', 'süzgeç'),
  cuttingBoard('cutting board', 'kesme tahtası'),
  dutchOven('dutch oven', 'döküm tencere'),
  foodProcessor('food processor', 'mutfak robotu'),
  fryingPan('frying pan', 'kızartma tavası'),
  grater('grater', 'rende'),
  griddle('griddle', 'ızgara tava'),
  grill('grill', 'ızgara'),
  juicer('juicer', 'meyve sıkacağı'),
  knife('knife', 'bıçak'),
  ladle('ladle', 'kepçe'),
  mallet('mallet', 'et döveceği'),
  mandoline('mandoline', 'mandolin dilimleyici'),
  measuringCup('measuring cup', 'ölçü kabı'),
  measuringSpoon('measuring spoon', 'ölçü kaşığı'),
  microwave('microwave', 'mikrodalga'),
  mixer('mixer', 'mikser'),
  mortar('mortar', 'havan'),
  oven('oven', 'fırın'),
  pan('pan', 'tava'),
  paringKnife('paring knife', 'soyma bıçağı'),
  pipingBag('piping bag', 'krema torbası'),
  pizzaCutter('pizza cutter', 'pizza kesici'),
  pot('pot', 'tencere'),
  pressureCooker('pressure cooker', 'düdüklü tencere'),
  roastingPan('roasting pan', 'rosto tavası'),
  rollingPin('rolling pin', 'merdane'),
  saladSpinner('salad spinner', 'salata kurutucu'),
  saucepan('saucepan', 'sos tenceresi'),
  skillet('skillet', 'döküm tava'),
  slowCooker('slow cooker', 'yavaş pişirici'),
  spatula('spatula', 'spatula'),
  steamer('steamer', 'buharlı pişirici'),
  stockpot('stockpot', 'derin tencere'),
  strainer('strainer', 'ince süzgeç'),
  tenderizer('tenderizer', 'et yumuşatıcı'),
  thermometer('thermometer', 'termometre'),
  tongs('tongs', 'maşa'),
  waffleIron('waffle iron', 'waffle makinesi'),
  whisk('whisk', 'çırpıcı'),
  wok('wok', 'wok tava'),
  zester('zester', 'kabuk rendesi');

  final String label;
  final String trLabel;
  const ImplementEnum(this.label, this.trLabel);

  static ImplementEnum? fromLabel(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value.trim().toLowerCase();
    for (final implement in ImplementEnum.values) {
      if (implement.label.toLowerCase() == normalized) {
        return implement;
      }
    }
    return null;
  }
}
