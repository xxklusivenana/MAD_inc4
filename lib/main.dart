import 'package:flutter/material.dart';
// Activity 04
// Team JBF
// Janiya Green 002831712
// Brandon Walker 002727997
// Femi Ijimayowa 002802809


// ============================================================================
// 1. MAIN ENTRY POINT
// ============================================================================
// Summary: Every Flutter app starts here. runApp() takes your root widget and
// attaches it to the screen, kicking off the framework's build-and-render pipeline.
// Reference: https://api.flutter.dev/flutter/widgets/runApp.html
void main() {
  runApp(const MagicSpellConsoleApp());
}

// ============================================================================
// 2. ROOT APPLICATION WIDGET (Manages Global Theme State)
// ============================================================================
// Summary: A StatefulWidget that owns the single source of truth for light/dark
// mode. MaterialApp reads isDarkMode to pick a theme, and onToggleTheme lets the
// child screen flip it via a callback — no need to pass data back up manually.
// Reference: https://docs.flutter.dev/cookbook/design/themes
class MagicSpellConsoleApp extends StatefulWidget {
  const MagicSpellConsoleApp({super.key});

  @override
  State<MagicSpellConsoleApp> createState() => _MagicSpellConsoleAppState();
}

class _MagicSpellConsoleAppState extends State<MagicSpellConsoleApp> {
  // Global theme toggle variable
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcane Spell Console',
      debugShowCheckedModeBanner: false,
      // Apply Material 3 Dark or Light theme based on state
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: SpellConsoleScreen(
        isDark: isDarkMode,
        // Callback function to toggle theme mode from child widget
        onToggleTheme: () => setState(() => isDarkMode = !isDarkMode),
      ),
    );
  }
}

// ============================================================================
// 3. MAIN DASHBOARD SCREEN (Stateful Controller)
// ============================================================================
// Summary: The screen users actually see. Its State object holds mana,
// spellsCast, arcanePower, and lastSpell, and rebuilds the metrics card,
// status banner, spell buttons, and slider every time setState() runs.
// Reference: https://api.flutter.dev/flutter/material/Scaffold-class.html
class SpellConsoleScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const SpellConsoleScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<SpellConsoleScreen> createState() => _SpellConsoleScreenState();
}

class _SpellConsoleScreenState extends State<SpellConsoleScreen> {
  // --- Mutable State Variables ---
  int mana = 100;                // Depletes as spells are cast, refilled by Heal
  int spellsCast = 0;            // Increments on every successful cast
  double arcanePower = 50;       // Controlled by the interactive slider
  String lastSpell = "NONE";     // Displays latest cast spell / combo

  // Tracks the two most recent successfully-cast spells, used to detect combos
  final List<String> _recentSpells = [];

  // Feedback message shown when a spell can't be cast (insufficient mana)
  String? _feedbackMessage;

  // Whether Arcane Overload has been triggered (arcanePower maxed out)
  bool get arcaneOverload => arcanePower >= 100;

  // Helper method to attempt casting a spell, deducting mana and checking combos
  void _castSpell(String spellName, int manaCost) {
    if (mana < manaCost) {
      // Not enough mana — surface clear feedback, no state mutation of gameplay values
      setState(() {
        _feedbackMessage = "Not enough mana for $spellName (needs $manaCost, have $mana)";
      });
      return;
    }

    setState(() {
      mana -= manaCost;
      spellsCast++;
      lastSpell = "$spellName CAST";
      _feedbackMessage = null;

      // Track recent spells for combo detection (keep only last 2)
      _recentSpells.add(spellName);
      if (_recentSpells.length > 2) {
        _recentSpells.removeAt(0);
      }

      // Combo rule: Shield + Fireball unlocks Flame Armor
      if (_recentSpells.length == 2 &&
          _recentSpells[0] == "Shield" &&
          _recentSpells[1] == "Fireball") {
        lastSpell = "FLAME ARMOR UNLOCKED";
        arcanePower = (arcanePower + 15).clamp(0, 100);
      }
      // Combo rule: Teleport + Shield unlocks Phase Barrier
      else if (_recentSpells.length == 2 &&
          _recentSpells[0] == "Teleport" &&
          _recentSpells[1] == "Shield") {
        lastSpell = "PHASE BARRIER UNLOCKED";
        arcanePower = (arcanePower + 15).clamp(0, 100);
      } else {
        // Regular cast nudges arcane power up slightly
        arcanePower = (arcanePower + 5).clamp(0, 100);
      }

      // Heal restores mana directly
      if (spellName == "Heal") {
        mana = (mana + 40).clamp(0, 100);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic background color adapting to current theme
    final screenBg = widget.isDark ? const Color(0xFF1A1030) : const Color(0xFFEDE6F7);
    final cardBg = widget.isDark ? const Color(0xFF2A1E4A) : Colors.white;

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        title: const Text(
          "ARCANE SPELL CONSOLE",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Theme Toggle Button in the AppBar
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- ARCANE OVERLOAD BANNER (only shown when maxed) ---
            if (arcaneOverload)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.purpleAccent, width: 1.5),
                ),
                child: const Center(
                  child: Text(
                    "ARCANE OVERLOAD ✨",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.5,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ),
              ),

            // --- TOP STATUS METRICS CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(widget.isDark ? 0.3 : 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Mana Counter
                  Column(
                    children: [
                      const Text("MANA", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("$mana", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // Vertical Divider Line
                  Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                  // Spells Cast Counter
                  Column(
                    children: [
                      const Text("SPELLS CAST", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("$spellsCast", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)),
                    ],
                  ),
                  // Vertical Divider Line
                  Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                  // Arcane Power Indicator
                  Column(
                    children: [
                      const Text("ARCANE PWR", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("${arcanePower.toInt()}%", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Spell Status Banner
            Text(
              "LAST SPELL: $lastSpell",
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
                color: widget.isDark ? Colors.purpleAccent : Colors.deepPurple,
              ),
            ),

            // Feedback message for failed casts (insufficient mana)
            if (_feedbackMessage != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                ),
                child: Text(
                  _feedbackMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            const SizedBox(height: 28),

            // --- 2x2 GRID OF TACTILE SPELL BUTTONS ---
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                SpellButton(
                  icon: Icons.local_fire_department,
                  label: "FIREBALL",
                  manaCost: 20,
                  currentMana: mana,
                  accentColor: Colors.deepOrangeAccent,
                  isDark: widget.isDark,
                  onPressed: () => _castSpell("Fireball", 20),
                ),
                SpellButton(
                  icon: Icons.shield,
                  label: "SHIELD",
                  manaCost: 15,
                  currentMana: mana,
                  accentColor: Colors.cyanAccent,
                  isDark: widget.isDark,
                  onPressed: () => _castSpell("Shield", 15),
                ),
                SpellButton(
                  icon: Icons.flash_on,
                  label: "TELEPORT",
                  manaCost: 30,
                  currentMana: mana,
                  accentColor: Colors.purpleAccent,
                  isDark: widget.isDark,
                  onPressed: () => _castSpell("Teleport", 30),
                ),
                SpellButton(
                  icon: Icons.favorite,
                  label: "HEAL",
                  manaCost: 25,
                  currentMana: mana,
                  accentColor: Colors.greenAccent,
                  isDark: widget.isDark,
                  onPressed: () => _castSpell("Heal", 25),
                ),
              ],
            ),
            const SizedBox(height: 36),

            // --- INTERACTIVE ARCANE POWER SLIDER ---
            Text(
              "Arcane Power Calibration: ${arcanePower.toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Slider(
              value: arcanePower,
              min: 0,
              max: 100,
              activeColor: Colors.purpleAccent,
              inactiveColor: Colors.grey.withOpacity(0.3),
              // setState updates arcanePower immediately during slider drag
              onChanged: (newVal) => setState(() => arcanePower = newVal),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 4. REUSABLE TACTILE SPELL BUTTON WIDGET
// ============================================================================
// Summary: A self-contained StatefulWidget that tracks its own isPressed flag
// and uses GestureDetector + two opposing BoxShadows to fake a physical
// push-button depress-and-release effect. Automatically disables itself (dims
// and blocks taps) whenever currentMana is less than manaCost.
// Reference: https://api.flutter.dev/flutter/widgets/GestureDetector-class.html
class SpellButton extends StatefulWidget {
  final IconData icon;          // Icon to display in center
  final String label;           // Button title text
  final int manaCost;           // Mana required to cast this spell
  final int currentMana;        // Player's current mana, used to gate the button
  final Color accentColor;      // Active glow color
  final bool isDark;            // Light or Dark theme mode
  final VoidCallback onPressed; // Action callback triggered on tap

  const SpellButton({
    super.key,
    required this.icon,
    required this.label,
    required this.manaCost,
    required this.currentMana,
    required this.accentColor,
    required this.isDark,
    required this.onPressed,
  });

  @override
  State<SpellButton> createState() => _SpellButtonState();
}

class _SpellButtonState extends State<SpellButton> {
  // Local boolean state tracking whether button is currently being held down
  bool isPressed = false;

  bool get _disabled => widget.currentMana < widget.manaCost;

  @override
  Widget build(BuildContext context) {
    // Determine dynamic background and shadow colors
    final baseColor = widget.isDark ? const Color(0xFF241A3E) : const Color(0xFFE4DDF2);
    final darkShadow = widget.isDark ? Colors.black87 : const Color(0xFFB3A6CC);
    final lightShadow = widget.isDark ? const Color(0xFF352755) : Colors.white;

    return Opacity(
      // Dim the whole button when the player can't afford the spell
      opacity: _disabled ? 0.4 : 1.0,
      child: GestureDetector(
        // 1. User touches button -> depress button (ignored while disabled)
        onTapDown: _disabled ? null : (_) => setState(() => isPressed = true),
        // 2. User releases button -> restore position and fire callback
        onTapUp: _disabled
            ? null
            : (_) {
                setState(() => isPressed = false);
                widget.onPressed();
              },
        // 3. User cancels touch -> restore position safely
        onTapCancel: _disabled ? null : () => setState(() => isPressed = false),
        // Still allow a tap while disabled to surface the "not enough mana" feedback
        onTap: _disabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100), // Smooth 100ms spring transition
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(24),
            // Dual opposing BoxShadows create the 3D Neomorphic depth effect
            boxShadow: isPressed && !_disabled
                ? [
                    // Pressed (Sunken) Shadow Offsets
                    BoxShadow(color: darkShadow.withOpacity(0.5), offset: const Offset(2, 2), blurRadius: 4),
                    BoxShadow(color: lightShadow.withOpacity(0.5), offset: const Offset(-2, -2), blurRadius: 4),
                  ]
                : [
                    // Unpressed (Elevated) Shadow Offsets
                    BoxShadow(color: darkShadow.withOpacity(0.7), offset: const Offset(8, 8), blurRadius: 16),
                    BoxShadow(color: lightShadow.withOpacity(0.9), offset: const Offset(-8, -8), blurRadius: 16),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dynamic Icon that changes size and glows on press
              Icon(
                widget.icon,
                size: isPressed && !_disabled ? 40 : 46,
                color: isPressed && !_disabled
                    ? widget.accentColor
                    : (widget.isDark ? Colors.white70 : Colors.black87),
              ),
              const SizedBox(height: 6),
              // Button Label
              Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.1,
                  color: isPressed && !_disabled
                      ? widget.accentColor
                      : (widget.isDark ? Colors.white54 : Colors.black54),
                ),
              ),
              const SizedBox(height: 2),
              // Mana cost subtitle
              Text(
                "${widget.manaCost} MP",
                style: TextStyle(
                  fontSize: 10,
                  color: widget.isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}