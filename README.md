# Activity 4 - Team JBF
## Team Members
### Janiya Green
### Brandon Walker
### Femi Ijimayowa
### Word Doc Link: https://studentgsu-my.sharepoint.com/:w:/r/personal/jgreen156_student_gsu_edu/Documents/MAD_Inclass4.docx?d=w6b14c453c31e4c9098740e4eef0b2c19&csf=1&web=1&e=cnupBc

## How To Run
Bug fix:
SC1;We changed the parameters of the the function so that the button can react
SC2; We changed the value of the powerLevel
SC3;We changed the highligh offset and shadow so that the button can be pressed
SC4; We increased the value of the physical callback
## Build Challenge
## State Defense
The app's state is split across two levels, each owning exactly what it needs and nothing more. At the top, _MagicSpellConsoleAppState holds a single boolean, isDarkMode, which is the only thing the root widget cares about. It passes that value down to SpellConsoleScreen as a plain isDark field and hands down a VoidCallback (onToggleTheme) that the child can invoke to flip it. This is the classic "lift state up, pass callbacks down" pattern: the child never mutates isDarkMode directly — it can only ask the parent to change it, and the parent's setState() is what triggers a rebuild of the whole MaterialApp with a new ThemeData.

The screen widget holds all the actual game data: mana, spells cast, arcane power, and the last spell used. Everything lives together here because the mana display, the spell buttons, and the status message all need to update at the same time. When you cast a spell, one setState() call updates all of them at once — so you never see mismatched info, like a new spell message next to an old mana number. One value, "arcane overload," isn't stored at all — it's just calculated on the spot from arcane power, so it's always correct.

Each spell button also keeps a tiny bit of its own state: whether it's currently being pressed. That's private to the button, since nothing else needs to know about it. Whether a button is enabled or disabled isn't stored either — it's recalculated every time based on current mana, so it's always accurate.

## Round 1 Findings
STATE IDENTIFICATION BLITZ — TEAM FINDINGS REPORT  

Team Name: JBF 

 

SCENARIO 1 / 6 — PriceTag: We answered "STATELESS" — CORRECT (actual: STATELESS) SCENARIO 2 / 6 — LikeToggle: We answered "STATEFUL" — CORRECT (actual: STATEFUL) SCENARIO 3 / 6 — MenuActionTile: We answered "STATELESS" — CORRECT (actual: STATELESS) SCENARIO 4 / 6 — SearchField: We answered "STATEFUL" — CORRECT (actual: STATEFUL) SCENARIO 5 / 6 — StatBadge: We answered "STATELESS" — CORRECT (actual: STATELESS) SCENARIO 6 / 6 — PulsingDot: We answered "STATEFUL" — CORRECT (actual: STATEFUL) 

Final Score: 6 / 6 

## Round 2 Bug Fixes,