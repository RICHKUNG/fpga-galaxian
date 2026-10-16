# Source and module index

Original sources: Logic Design Laboratory, `final_project_繳交用/`. Original evidence: `邏設實final_project.docx`, particularly Design Implementation, Discussion and Work distribution chart.

| Module | Role |
|---|---|
| `top.v` | Integration and sprite ROM instances |
| `game_test.v`, `game.v` | Shared gameplay logic |
| `KeyboardDecoder.v`, `KeyboardCtrl.v`, `Ps2Interface.v` | Keyboard input, including reused helpers |
| `musicFSM.v`, `buzz.v`, `music.v` | Sound-event selection, tone generation and output |
| `fsm_of_interface.v` | Start/play/end interface states |
| `mem_addr_gen.v`, `vga_controller.v` | Display addressing and timing |
| `score_display.v` | Score display |

Image provenance in the DOCX archive: `image2.jpeg` → gameplay; `image61.png` → hardware; `image31.jpeg` → timing sketch. They are copied/extracted unchanged. Module names describe the archived design, not individual authorship of every file.

The original .xci configurations include relative COE paths; the archive retains the corresponding directory structure and picture files. No new license is assigned to reused course helpers, third-party IP or sprite assets.
