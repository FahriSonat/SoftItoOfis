enum PreferredChannel {
  call('Arama'),
  sms('SMS');

  final String label;
  const PreferredChannel(this.label);
}

class SupportContact {
  final String id;
  final String displayName;
  final String phoneNumber;
  final PreferredChannel preferredChannel;
  final String? messageTemplate;
  final List<String> linkedHabitIds;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  const SupportContact({
    required this.id,
    required this.displayName,
    required this.phoneNumber,
    this.preferredChannel = PreferredChannel.sms,
    this.messageTemplate,
    this.linkedHabitIds = const [],
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'phoneNumber': phoneNumber,
    'preferredChannel': preferredChannel.name,
    'messageTemplate': messageTemplate,
    'linkedHabitIds': linkedHabitIds,
    'createdAtUtc': createdAtUtc.toIso8601String(),
    'updatedAtUtc': updatedAtUtc.toIso8601String(),
  };

  factory SupportContact.fromJson(Map<String, dynamic> json) {
    return SupportContact(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      preferredChannel: json['preferredChannel'] != null
          ? PreferredChannel.values.byName(json['preferredChannel'] as String)
          : PreferredChannel.sms,
      messageTemplate: json['messageTemplate'] as String?,
      linkedHabitIds:
          (json['linkedHabitIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
    );
  }
}
