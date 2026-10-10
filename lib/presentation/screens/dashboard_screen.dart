import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/state_providers.dart';
import '../../application/providers/translation_pipeline.dart';
import '../theme/app_colors.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Initialize the translation pipeline
    ref.watch(translationPipelineProvider);
    
    final state = ref.watch(serviceStateProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      body: _currentIndex == 0
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeroStatus(ref, state),
                  const SizedBox(height: 16),
                  _buildEngineConfigCard(ref, state),
                  const SizedBox(height: 16),
                  _buildFeatureToggles(ref, state),
                  const SizedBox(height: 16),
                  _buildPermissionsCard(ref, state),
                  const SizedBox(height: 80),
                ],
              ),
            )
          : const Center(
              child: Text(
                "Feature under development",
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16),
              ),
            ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface.withOpacity(0.85),
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("ScreenTranslate AI", style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
          Text("DASHBOARD", style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10, letterSpacing: 1.2)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.memory, color: AppColors.onSurfaceVariant),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Memory diagnostics coming soon")));
          },
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 16,
            child: Icon(Icons.person, color: AppColors.onPrimary, size: 18),
          ),
        )
      ],
    );
  }

  Widget _buildHeroStatus(WidgetRef ref, ServiceState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: state.isDaemonRunning ? AppColors.tertiaryFixedDim : AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.isDaemonRunning ? "SERVICE ACTIVE • DAEMON RUNNING" : "SERVICE PAUSED",
                    style: TextStyle(
                      color: state.isDaemonRunning ? AppColors.tertiaryFixedDim : AppColors.error,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: state.isDaemonRunning ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                  foregroundColor: state.isDaemonRunning ? AppColors.onPrimaryFixed : AppColors.onSurface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  ref.read(serviceStateProvider.notifier).toggleDaemon();
                },
                icon: Icon(state.isDaemonRunning ? Icons.pause_circle : Icons.play_circle, size: 16),
                label: Text(state.isDaemonRunning ? "PAUSE SERVICE" : "RESUME SERVICE", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngineConfigCard(WidgetRef ref, ServiceState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.vpn_key, color: AppColors.primaryContainer),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Gemini API Engine Setup", style: TextStyle(color: AppColors.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Real-time multimodal neural translation core", style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          // Language Switcher
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Source", style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
                    _buildLanguageDropdown(state.sourceLanguage, AppColors.onSurface, (val) {
                      ref.read(serviceStateProvider.notifier).setSourceLanguage(val);
                    }),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.sync_alt, color: AppColors.primaryContainer),
                  onPressed: () {
                    ref.read(serviceStateProvider.notifier).swapLanguages();
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Target", style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
                    _buildLanguageDropdown(state.targetLanguage, AppColors.primaryContainer, (val) {
                      ref.read(serviceStateProvider.notifier).setTargetLanguage(val);
                    }),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static const Map<String, String> _languageNames = {
    'en': 'English',
    'ja': 'Japanese',
    'ko': 'Korean',
    'zh': 'Chinese',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'id': 'Indonesian',
    'th': 'Thai',
  };

  Widget _buildLanguageDropdown(String currentValue, Color color, Function(String) onChanged) {
    return DropdownButton<String>(
      value: currentValue,
      icon: Icon(Icons.arrow_drop_down, color: color, size: 16),
      elevation: 4,
      isDense: true,
      dropdownColor: AppColors.surfaceContainerHigh,
      underline: const SizedBox(),
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
      onChanged: (String? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      items: _languageNames.entries.map<DropdownMenuItem<String>>((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
    );
  }

  Widget _buildFeatureToggles(WidgetRef ref, ServiceState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text("ACTIVE CAPTURE PIPELINES", style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ),
        _buildToggleCard(
          title: "Screen Chat Reader",
          subtitle: "Floating bubble overlays real-time translations onto in-app chats.",
          icon: Icons.chat_bubble_outline,
          isActive: state.isAccessibilityActive,
          onToggle: (val) {
            ref.read(serviceStateProvider.notifier).toggleAccessibility();
          },
        ),
        const SizedBox(height: 12),
        _buildToggleCard(
          title: "Game OCR Screen Capture",
          subtitle: "HUD translation layer bounding boxes over in-game dialogs.",
          icon: Icons.sports_esports,
          isActive: state.isScreenCaptureActive,
          onToggle: (val) {
            ref.read(serviceStateProvider.notifier).toggleScreenCapture();
          },
        ),
      ],
    );
  }

  Widget _buildToggleCard({required String title, required String subtitle, required IconData icon, required bool isActive, required Function(bool) onToggle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryContainer.withOpacity(0.15) : AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isActive ? AppColors.primaryContainer : AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: isActive,
            onChanged: onToggle,
            activeColor: AppColors.onPrimaryFixed,
            activeTrackColor: AppColors.primaryContainer,
            inactiveThumbColor: AppColors.outline,
            inactiveTrackColor: AppColors.surfaceContainerHigh,
          )
        ],
      ),
    );
  }

  Widget _buildPermissionsCard(WidgetRef ref, ServiceState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.admin_panel_settings, color: AppColors.secondary),
              SizedBox(width: 8),
              Text("Android System Permissions", style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          _buildPermissionRow(Icons.picture_in_picture, "System Alert Window", "Draw Over Other Apps", true),
          const SizedBox(height: 8),
          _buildPermissionRow(Icons.accessibility_new, "Accessibility Service", "Text Node Hierarchy Reader", false),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(IconData icon, String title, String subtitle, bool isGranted) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: isGranted ? AppColors.tertiaryFixedDim : AppColors.primaryContainer, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.onSurface, fontSize: 12, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
              ],
            ),
          ),
          if (isGranted)
            const Text("GRANTED", style: TextStyle(color: AppColors.tertiaryFixedDim, fontSize: 10, fontWeight: FontWeight.bold))
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimaryFixed,
                minimumSize: const Size(60, 30),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Permission requests are not implemented in this demo")));
              },
              child: const Text("GRANT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            )
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return SafeArea(
      child: Container(
        color: AppColors.surfaceContainerLow,
        padding: const EdgeInsets.only(bottom: 8, top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.tune, "Dashboard", 0),
            _buildNavItem(Icons.picture_in_picture_alt, "Overlay", 1),
            _buildNavItem(Icons.record_voice_over, "Voice", 2),
            _buildNavItem(Icons.terminal, "API Logs", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? AppColors.primaryContainer : AppColors.onSurfaceVariant),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
