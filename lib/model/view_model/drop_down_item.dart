class DropDownItem {
  static DropDownItem objState;
  static DropDownItem objRole;
  static DropDownItem objMachineType;
  static DropDownItem objDialCode = DropDownItem(name: '+60', id: 1);
  String name;
  int id;

  DropDownItem({this.name, this.id});

  static List<DropDownItem> get listState => [
        DropDownItem(name: 'Johor', id: 1),
        DropDownItem(name: 'Kedah', id: 2),
        DropDownItem(name: 'Kelantan', id: 3),
        DropDownItem(name: 'Melaka', id: 4),
        DropDownItem(name: 'Negeri Sembilan', id: 5),
        DropDownItem(name: 'Pahang', id: 6),
        DropDownItem(name: 'Penang', id: 7),
        DropDownItem(name: 'Perak', id: 8),
        DropDownItem(name: 'Sabah', id: 9),
        DropDownItem(name: 'Sarawak', id: 10),
        DropDownItem(name: 'Selangor', id: 11),
        DropDownItem(name: 'Terengganu', id: 12),
      ];

  static List<DropDownItem> get listRole => [
        DropDownItem(name: 'Merchant', id: 1),
        DropDownItem(name: 'Admin', id: 2),
      ];

  static List<DropDownItem> get listMachineType => [
        DropDownItem(name: 'scissor_lift', id: 1),
        DropDownItem(name: 'aerial_lift', id: 2),
        DropDownItem(name: 'spider_lift', id: 3),
        DropDownItem(name: 'crawler_crane', id: 4),
        DropDownItem(name: 'boom_lift', id: 5),
        DropDownItem(name: 'fork_lift', id: 6),
        DropDownItem(name: 'sky_lift', id: 7),
        DropDownItem(name: 'beach_lift', id: 8),
      ];

  static List<DropDownItem> get listDialCode => [
        DropDownItem(name: '+60', id: 1),
        DropDownItem(name: '+03', id: 2),
        DropDownItem(name: '+07', id: 2),
      ];
}
