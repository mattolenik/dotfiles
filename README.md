deco.zsh
========

Enjoy your CUI life with text-decoration!

![deco-gif](https://i.gyazo.com/3904b12225980b477fe51cc0a4676d4d.gif)


Features
--------

- foreground and background 256-colors
- support normal colors, default color, and bright colors
- support underline, blink, and reverse
- input can be as parameter, pipe, or redirect
- no need to reset unlike zsh's `colors` or `tput`


Installation
------------

### Antigen

```
antigen bundle amutake/deco.zsh
antigen apply
```

### Manual

```
git clone git://github.com/amutake/deco.zsh /path/to/deco.zsh
source /path/to/deco.zsh/deco.plugins.zsh # edit your .zshrc and put this line
```


Usage
-----

- `deco [options] text`
- `command | deco [options]`
- `deco [options] < file`

### Options

#### `-f, --fg, --foreground <color>`

Set foreground color. Available `<color>` attributes are the followings.

- `default`
- `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`
- `bright-black`, `bright-red`, `bright-green`, `bright-yellow`, `bright-blue`, `bright-magenta`, `bright-cyan`, `bright-white`
- 0 to 255

#### `-b, --bg, --background <color>`

Set background color. See `--foreground` section for available `<color>` attributes.

#### `-u, --underline`

Draw underline.

#### `-B, --blink`

Blink text.

#### `-r, --reverse`

Reverse foreground color and background color.

#### `-n, --no-newline`

Print text without newline.

#### `-h, --help`

Show help text and exit.

#### `-v, --version`

Show the version and exit.


License
-------

MIT


Reference
---------

- https://en.wikipedia.org/wiki/ANSI_escape_code#graphics
