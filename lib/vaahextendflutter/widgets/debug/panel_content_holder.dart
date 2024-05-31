import 'package:json_annotation/json_annotation.dart';

import '../../services/dynamic_links.dart';
import 'section_data.dart';

part 'panel_content_holder.g.dart';

abstract class PanelContentHolder {
  const PanelContentHolder();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PanelDataContentHolder extends PanelContentHolder {
  final Map<String, SectionData> content;

  const PanelDataContentHolder({
    required this.content,
  });

  factory PanelDataContentHolder.fromJson(Map<String, dynamic> json) =>
      _$PanelDataContentHolderFromJson(json);

  Map<String, dynamic> toJson() => _$PanelDataContentHolderToJson(this);
}

class PanelLinkContentHolder extends PanelContentHolder {
  final DeepLink content;

  const PanelLinkContentHolder({
    required this.content,
  });
}
