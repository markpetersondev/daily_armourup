import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/user_profile.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/section_header.dart';
import '../../onboarding/data/onboarding_options.dart';
import 'profile_screen.dart' show goalLabel;

/// Edit name, focus areas, spiritual goals, and reminder times.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late Set<String> _focusAreas;
  late Map<String, GoalFrequency> _goals;
  late ReminderPreferences _reminders;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _nameController = TextEditingController(text: profile.name);
    _focusAreas = profile.focusAreas.toSet();
    _goals = {
      for (final g in profile.spiritualGoals) g.id: g.frequency,
    };
    _reminders = profile.reminderPreferences;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final profile = ref.read(userProfileProvider);
    await ref.read(userProfileProvider.notifier).update(profile.copyWith(
          name: _nameController.text.trim(),
          focusAreas: _focusAreas.toList(),
          spiritualGoals: _goals.entries
              .map((e) => SpiritualGoal(id: e.key, frequency: e.value))
              .toList(),
          reminderPreferences: _reminders,
        ));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated.')));
      context.pop();
    }
  }

  Future<void> _pickTime(
      int currentMinutes, ValueChanged<int> onPicked) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: currentMinutes ~/ 60, minute: currentMinutes % 60),
    );
    if (picked != null) {
      setState(() => onPicked(picked.hour * 60 + picked.minute));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                const SectionHeader(title: 'Your name'),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration:
                      const InputDecoration(hintText: 'What should we call you?'),
                ),
                const SizedBox(height: 28),
                const SectionHeader(
                  title: 'Focus areas',
                  subtitle: 'Where you want extra strength right now.',
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final option in focusAreaOptions)
                      FilterChip(
                        selected: _focusAreas.contains(option.label),
                        avatar: _focusAreas.contains(option.label)
                            ? null
                            : Icon(option.icon, size: 16),
                        label: Text(option.label),
                        onSelected: (selected) => setState(() {
                          selected
                              ? _focusAreas.add(option.label)
                              : _focusAreas.remove(option.label);
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                const SectionHeader(
                  title: 'Spiritual goals',
                  subtitle: 'Tap to include a goal; choose how often.',
                ),
                for (final option in goalOptions) ...[
                  Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: _goals.containsKey(option.id),
                          onChanged: (v) => setState(() {
                            v
                                ? _goals[option.id] = GoalFrequency.daily
                                : _goals.remove(option.id);
                          }),
                          secondary: Icon(option.icon,
                              color: theme.colorScheme.primary),
                          title: Text(goalLabel(option.id)),
                        ),
                        if (_goals.containsKey(option.id))
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 14),
                            child: SegmentedButton<GoalFrequency>(
                              segments: [
                                for (final f in GoalFrequency.values)
                                  ButtonSegment(
                                    value: f,
                                    label: Text(switch (f) {
                                      GoalFrequency.daily => 'Daily',
                                      GoalFrequency.threeTimesAWeek =>
                                        '3× a week',
                                      GoalFrequency.weekly => 'Weekly',
                                    }),
                                  ),
                              ],
                              selected: {_goals[option.id]!},
                              onSelectionChanged: (s) => setState(
                                  () => _goals[option.id] = s.first),
                              style: SegmentedButton.styleFrom(
                                minimumSize: const Size(44, 40),
                                selectedBackgroundColor:
                                    theme.colorScheme.primaryContainer,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                const SectionHeader(
                  title: 'Reminders',
                  subtitle: 'Gentle nudges at the moments you choose.',
                ),
                _reminderTile(
                  'Morning start',
                  _reminders.morningEnabled,
                  _reminders.morningMinutes,
                  (v) => _reminders = _reminders.copyWith(morningEnabled: v),
                  (m) => _reminders = _reminders.copyWith(morningMinutes: m),
                ),
                _reminderTile(
                  'Midday prayer',
                  _reminders.middayEnabled,
                  _reminders.middayMinutes,
                  (v) => _reminders = _reminders.copyWith(middayEnabled: v),
                  (m) => _reminders = _reminders.copyWith(middayMinutes: m),
                ),
                _reminderTile(
                  'Evening reflection',
                  _reminders.eveningEnabled,
                  _reminders.eveningMinutes,
                  (v) => _reminders = _reminders.copyWith(eveningEnabled: v),
                  (m) => _reminders = _reminders.copyWith(eveningMinutes: m),
                ),
                _reminderTile(
                  'Strength check-in',
                  _reminders.highRiskEnabled,
                  _reminders.highRiskMinutes,
                  (v) => _reminders = _reminders.copyWith(highRiskEnabled: v),
                  (m) => _reminders = _reminders.copyWith(highRiskMinutes: m),
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: 'Save Changes',
                  icon: Icons.check_rounded,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _reminderTile(
    String label,
    bool enabled,
    int minutes,
    ValueChanged<bool> onToggle,
    ValueChanged<int> onTime,
  ) {
    final time = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: SwitchListTile(
        value: enabled,
        onChanged: (v) => setState(() => onToggle(v)),
        title: Text(label),
        subtitle: enabled
            ? InkWell(
                onTap: () => _pickTime(minutes, onTime),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'At ${time.format(context)} — tap to change',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              )
            : const Text('Off'),
      ),
    );
  }
}
