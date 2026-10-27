# herdr-flexoki

A [Flexoki](https://stephango.com/flexoki) **Light** theme for [Herdr](https://herdr.dev), matching the existing Flexoki ports for Ghostty and Neovim.

Herdr 0.9.x does not load external theme files. A theme is a `[theme]` block in `~/.config/herdr/config.toml`, combining a built-in base with per-token overrides under `[theme.custom]`. Herdr's UI has exactly 19 color tokens; this theme overrides all of them, so the result is pure Flexoki rather than a tint of the base theme.

## Palette

Accents use the 600-level Flexoki values (the set intended for light backgrounds). Text and surfaces use the `black` / `paper` / `base-*` ramp.

| Herdr token | Flexoki | Hex | Role |
| --- | --- | --- | --- |
| `panel_bg`, `sidebar_bg` | — | `reset` | transparent (host paper shows through) |
| `active_row_bg` | base-100 | `#E6E4D9` | active space / focused agent row |
| `selection_bg` | base-150 | `#DAD8CE` | Navigate-mode cursor row |
| `surface0` / `surface1` / `surface_dim` | base-100/200/100 | `#E6E4D9` / `#CECDC3` / `#E6E4D9` | surfaces and separators |
| `text` | black | `#100F0F` | primary text (Ghostty `fg`) |
| `subtext0` | base-600 | `#6F6E69` | subdued text |
| `overlay0` / `overlay1` | base-400 / base-500 | `#9F9D96` / `#878580` | muted text |
| `accent`, `blue` | blue-600 | `#205EA6` | highlights, borders, navigation |
| `teal` | cyan-600 | `#24837B` | notifications / unseen markers |
| `green` | green-600 | `#66800B` | done / idle |
| `yellow` | yellow-600 | `#AD8301` | working / running |
| `peach` | orange-600 | `#BC5215` | interrupted / warning |
| `red` | red-600 | `#AF3029` | blocked / needs attention |
| `mauve` | purple-600 | `#5E409D` | branch / special labels |

The host terminal background is `paper` `#FFFCF0` and the foreground is `black` `#100F0F`, matching [Ghostty's built-in `Flexoki Light`](https://ghostty.org) and [kepano/flexoki-neovim](https://github.com/kepano/flexoki-neovim).

## Install

```sh
git clone git@github.com:<you>/herdr-flexoki.git
cd herdr-flexoki
./install.sh
herdr server reload-config
```

`install.sh` appends a managed block to `${HERDR_CONFIG_PATH:-~/.config/herdr/config.toml}`, backing the file up first. Re-running it upgrades the block in place. It refuses to run if the config already has a `[theme]` table outside the managed block, to avoid a duplicate-table TOML error.

Manual install: copy the contents of [`flexoki.toml`](./flexoki.toml) into `~/.config/herdr/config.toml`, then run `herdr server reload-config` (or press `prefix+shift+r` inside Herdr).

## Transparent vs solid surfaces

By default `panel_bg` and `sidebar_bg` are `"reset"`, so the terminal's background (and its opacity/blur) shows through the tab bar, panels, and sidebar. This pairs well with a translucent Ghostty and a transparent Neovim setup.

For solid Flexoki surfaces instead, change those two lines in `flexoki.toml` to:

```toml
panel_bg   = "#F2F0E5" # base-50
sidebar_bg = "#F2F0E5" # base-50
```

## Optional: follow the terminal's light/dark appearance

Herdr can switch themes when the host terminal reports a light/dark change. Add the following to `config.toml` (replacing the plain `[theme]` block). The shared palette above stays the light mode; `[theme.custom.dark]` overrides it for dark mode.

```toml
[theme]
name = "catppuccin-latte"
auto_switch = true
light_name = "catppuccin-latte"
dark_name = "catppuccin"

[theme.custom.dark]
panel_bg      = "reset"
sidebar_bg    = "reset"
active_row_bg = "#282726" # base-900
selection_bg  = "#343331" # base-850
surface0      = "#282726" # base-900
surface1      = "#343331" # base-850
surface_dim   = "#282726" # base-900
text          = "#CECDC3" # base-200
subtext0      = "#878580" # base-500
overlay0      = "#6F6E69" # base-600
overlay1      = "#878580" # base-500
accent        = "#4385BE" # blue-400
blue          = "#4385BE" # blue-400
teal          = "#3AA99F" # cyan-400
green         = "#879A39" # green-400
yellow        = "#D0A215" # yellow-400
peach         = "#DA702C" # orange-400
red           = "#D14D41" # red-400
mauve         = "#8B7EC8" # purple-400
```

The dark side mirrors Flexoki's dark variant: `black`/`base-950` backgrounds, `base-200` text, and 400-level accents.

## Notes

- Tested with Herdr 0.9.3 on macOS. Herdr also exposes `theme.custom.light` / `theme.custom.dark` subtables; this repo keeps one shared palette plus an optional dark override.
- Herdr reads UI themes from the **local client** config, so on a remote attach the theme comes from the machine running your client.
- Not affiliated with Herdr or Flexoki.

## License

MIT. Flexoki itself is MIT by [Steph Ango](https://stephango.com/flexoki); the palette values and attribution come from [kepano/flexoki](https://github.com/kepano/flexoki).
