// Herdr TUI's prefix keys in Herdr app: press ctrl+b, let go, then one key.
// The table follows the Herdr TUI defaults (`[keys]` in herdr's config.toml),
// mapped onto Herdr app commands, plus a few tmux-style extras that don't
// clash with them. keys.json: "ctrl-b": "mod.open:prefix-mine".
// Esc leaves prefix mode without doing anything.
//
// TUI defaults with no Herdr app command, so not mapped: reload_config
// (shift+r; the app reloads config by itself), open_notification_target (o),
// rename_pane (shift+p), edit_scrollback (e), cycle_pane_next/previous
// (tab/shift+tab) and resize_mode (r).

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { run, closeOverlay, openOverlay, focused, props, theme } from "herdr";

// US-layout shifted characters, so shift+5 is "%", shift+' is "\"" and
// shift+7 is "&". e.key is the printed key, the shift is in modifiers.
const SHIFTED = {
  "1": "!", "2": "@", "3": "#", "4": "$", "5": "%", "6": "^", "7": "&", "8": "*", "9": "(", "0": ")",
  "-": "_", "=": "+", "[": "{", "]": "}", "\\": "|", ";": ":", "'": "\"", ",": "<", ".": ">", "/": "?",
  "`": "~",
};

// The key as written in the table below, or null for a chord Herdr owns.
function chord(e) {
  if (e.modifiers.control || e.modifiers.alt || e.modifiers.cmd) return null;
  const key = e.key;
  if (e.modifiers.shift) {
    if (SHIFTED[key]) return SHIFTED[key];
    return /^[a-z]$/.test(key) ? key.toUpperCase() : key;
  }
  return key.length === 1 ? key.toLowerCase() : key;
}

const NAV = { h: "left", j: "down", k: "up", l: "right" };

// The TUI's "new worktree" (prefix+shift+g) opens the same dialog as the
// space menu's "New worktree", for the shown space.
function newWorktree() {
  const space = focused()?.space;
  if (space) openOverlay({ mod: "worktree", kind: "dialog", width: 440, height: 260, props: { space, action: "new" } });
}

// Rows show in the dialog; every key in `keys` (except "…" and the
// specials handled in key()) runs `cmd`: a [command, args] pair or a function.
const GROUPS = [
  ["tabs", [
    { keys: ["c"], label: "new tab", cmd: ["tab.new"] },
    { keys: ["n", "]"], label: "next tab", cmd: ["tab.next"] },
    { keys: ["p", "["], label: "previous tab", cmd: ["tab.prev"] },
    { keys: ["1", "…", "9"], label: "show tab", cmd: "digits" },
    { keys: ["T", ","], label: "rename tab", cmd: ["tab.rename"] },
    { keys: ["X", "&"], label: "close tab", cmd: ["tab.close"] },
  ]],
  ["panes", [
    { keys: ["v", "%"], label: "split right", cmd: ["pane.split", { direction: "right" }] },
    { keys: ["-", "\""], label: "split down", cmd: ["pane.split", { direction: "down" }] },
    { keys: ["h", "j", "k", "l"], label: "focus left down up right", cmd: "nav" },
    { keys: ["←", "→"], label: "focus left / right", cmd: "arrows" },
    { keys: ["H", "J", "K", "L"], label: "move pane the same way", cmd: "swap" },
    { keys: ["x"], label: "close pane", cmd: ["pane.close"] },
    { keys: ["z"], label: "zoom pane", cmd: ["pane.zoom"] },
  ]],
  ["spaces", [
    { keys: ["↑", "↓"], label: "previous / next space", cmd: "arrows" },
    { keys: ["w", "g"], label: "go to…", cmd: ["mod.open", { name: "picker" }] },
    { keys: ["N"], label: "new space", cmd: ["space.new"] },
    { keys: ["W", "$"], label: "rename space", cmd: ["space.rename"] },
    { keys: ["D"], label: "close space", cmd: ["space.close"] },
    { keys: ["G"], label: "new worktree", cmd: newWorktree },
    { keys: ["a"], label: "next agent", cmd: ["agent.next"] },
    { keys: ["A"], label: "previous agent", cmd: ["agent.prev"] },
  ]],
  ["window", [
    { keys: ["b"], label: "hide or show sidebar", cmd: ["layout.toggle", { id: "sidebar" }] },
    { keys: ["y"], label: "hide or show changes", cmd: ["layout.toggle", { id: "panel" }] },
    { keys: ["s"], label: "settings", cmd: ["app.settings"] },
    { keys: ["?"], label: "all keys", cmd: ["app.help"] },
    { keys: [":"], label: "commands", cmd: ["app.palette"] },
    { keys: ["q"], label: "detach (terminals keep running)", cmd: ["window.close"] },
    { keys: ["Esc"], label: "leave prefix", cmd: "close" },
  ]],
];

// key -> command, built from the table above.
const MAP = {};
for (const [, rows] of GROUPS) {
  for (const r of rows) {
    if (typeof r.cmd === "string") continue;
    for (const k of r.keys) MAP[k] = r.cmd;
  }
}

// Left/right focus panes; up/down move between spaces, like the TUI's
// navigate keys for the sidebar.
const ARROWS = {
  left: ["pane.go", { direction: "left" }],
  right: ["pane.go", { direction: "right" }],
  up: ["space.prev"],
  down: ["space.next"],
};

export default class Prefix extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
    // The dialog is already focused on open; ask again once so a slow
    // first frame can't leave the keys going to the terminal behind.
    cx.timer.after(120, () => this.handle.focus());
  }

  close() {
    closeOverlay(props().overlay);
  }

  go(cmd) {
    this.close();
    if (typeof cmd === "function") cmd();
    else if (cmd && cmd[0]) run(cmd[0], cmd[1] ?? {});
  }

  key(e, cx) {
    const c = chord(e);
    if (c === null) return;
    cx.stop_propagation();
    if (c === "escape") return this.close();
    if (/^[1-9]$/.test(c)) return this.go(["tab.select", { index: Number(c) }]);
    if (ARROWS[c]) return this.go(ARROWS[c]);
    if (NAV[c]) return this.go(["pane.go", { direction: NAV[c] }]);
    const lower = c.toLowerCase();
    if (c !== lower && NAV[lower]) return this.go(["pane.swap", { direction: NAV[lower] }]);
    if (MAP[c]) return this.go(MAP[c]);
    cx.notify();
  }

  chip(t, text) {
    return h_flex()
      .flex_none()
      .justify_center()
      .px(6)
      .h(20)
      .min_w(22)
      .rounded(5)
      .bg(t.background)
      .border_1()
      .border_color(t.border)
      .text_size(11.5)
      .text_color(t.accent)
      .child(text);
  }

  row(t, r) {
    return h_flex()
      .h(27)
      .gap(9)
      .items_center()
      .flex_none()
      .child(this.chip(t, r.keys.join(" ")))
      .child(div().text_size(12.5).text_color(t.foreground).child(r.label));
  }

  group(t, g) {
    return v_flex()
      .flex_1()
      .min_w(0)
      .gap(3)
      .child(div().pb(3).text_size(11).font_medium().text_color(t.dim).child(g[0]))
      .children(g[1].map((r) => this.row(t, r)));
  }

  render() {
    const t = theme();
    return v_flex()
      .id("prefix")
      .track_focus(this.handle)
      .w_full()
      .p(16)
      .gap(12)
      .rounded(12)
      .bg(t.popover)
      .border_1()
      .border_color(t.border)
      .text_color(t.foreground)
      .on_key_down((e, cx) => this.key(e, cx))
      .child(
        h_flex()
          .items_center()
          .gap(9)
          .child(this.chip(t, "ctrl+b"))
          .child(div().flex_1().text_size(14).font_semibold().child("then a key"))
          .child(div().text_size(11).text_color(t.dim).child("Esc leaves")),
      )
      .child(
        h_flex()
          .items_start()
          .gap(20)
          .children([
            v_flex().flex_1().gap(12).children([this.group(t, GROUPS[0]), this.group(t, GROUPS[1])]),
            v_flex().flex_1().gap(12).children([this.group(t, GROUPS[2]), this.group(t, GROUPS[3])]),
          ]),
      );
  }
}
