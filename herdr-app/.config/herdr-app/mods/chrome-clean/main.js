import { View, div, svg } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { theme, run, props, window, shared, layout } from "herdr";

function find(node, id) {
  if (node?.id === id) return node;
  for (const child of node?.children ?? []) {
    const found = find(child, id);
    if (found) return found;
  }
  return null;
}

// The sidebar's rail goes by its width, not a flag: dragging its edge narrows it too.
const narrow = () => (find(layout(), "sidebar")?.size?.px ?? Infinity) < 160;

export default class WorkspaceChrome extends View {
  render() {
    const t = theme();
    const collapsed = narrow();
    if (props()?.footer) {
      const row = (id, icon, label, dim, action) => h_flex().id(id).h(28).px(8).gap(9).items_center()
        .when(collapsed, el => el.relative().w(32).px(0).justify_center().tooltip(label))
        .text_color(dim ? t.dim : t.muted)
        .when(!collapsed, el => el.rounded(8).hover(s => s.bg(t.hover).text_color(t.foreground)))
        .when(collapsed, el => el.hover(s => s.text_color(t.foreground)))
        .cursor_pointer()
        .on_click(action).child(svg(`mods/chrome-clean/${icon}.svg`).size(14))
        .when(!collapsed, el => el.child(label));
      return v_flex().size_full().bg(collapsed ? t.canvas : t.chrome)
        .px(8).pt(4).pb(8).text_size(13)
        .when(collapsed, el => el.px(0).items_center())
        .child(row("machine", "plus", "Add machine", true, () => run("mod.open", { name: "machine-add" })));
    }
    return h_flex().size_full().bg(collapsed ? t.canvas : t.chrome).pl(collapsed ? 6 : 14).pr(10).gap(4).items_center().text_size(13.5)
      .when(window()?.platform === "macos" && !window()?.fullscreen && !collapsed, el => el.pl(76))
      .child(div().flex_1());
  }
}
