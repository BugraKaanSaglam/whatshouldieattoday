enum CookingMethodEnum {
  bake('bake', 'fırınlamak'),
  blanch('blanch', 'blanşe etmek'),
  boil('boil', 'kaynatmak'),
  braise('braise', 'kısık ateşte pişirmek'),
  broil('broil', 'üstten ızgara'),
  char('char', 'közlemek'),
  cure('cure', 'kürlemek'),
  fry('fry', 'kızartmak'),
  grill('grill', 'ızgara'),
  microwave('microwave', 'mikrodalga'),
  poach('poach', 'poşe etmek'),
  pressureCook('pressure cook', 'düdüklüde pişirmek'),
  reduce('reduce', 'yoğunlaştırmak'),
  roast('roast', 'fırında kavurmak'),
  saute('sauté', 'sotelemek'),
  sear('sear', 'mühürlemek'),
  simmer('simmer', 'hafif kaynatmak'),
  slowCook('slow cook', 'yavaş pişirmek'),
  smoke('smoke', 'tütsülemek'),
  steam('steam', 'buharda pişirmek'),
  stirFry('stir-fry', 'wokta sote'),
  toast('toast', 'tost');

  final String label;
  final String trLabel;
  const CookingMethodEnum(this.label, this.trLabel);

  static CookingMethodEnum? fromLabel(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value.trim().toLowerCase();
    for (final method in CookingMethodEnum.values) {
      if (method.label.toLowerCase() == normalized) {
        return method;
      }
    }
    return null;
  }
}
