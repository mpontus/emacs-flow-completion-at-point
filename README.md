# Flow Completion At Point

> Flow autocomplete support for Emacs

[Emacs](https://www.gnu.org/software/emacs/) is a text and code editor and [Flow](https://flow.org/) is a static type checker for Javascript.

This package extends Emacs built-in completion functionality with Flow autocomplete support.

*For company-mode support see: [company-flow](https://github.com/aaronjensen/company-flow).*

## Table of Contents

- [Install](#install)
- [Usage](#usage)
- [Contribute](#contribute)
- [License](#license)

## Install

Hopefully, that by the time you're reading this, this module will be published on the [MELPA](https://melpa.org/#/).

If it is not, then download  [flow-completion-at-point.el](flow-completion-at-point.el) and place it alongside the `load-path`.

*Also please open an issue to remind me to publish it.*

Add `flow-completion-at-point-mode` to `js-mode-hooks` to enable Flow completion in Javascript files:

```emacs-lisp
(add-hook 'js-mode-hook 'flow-completion-at-point-mode)
```

## Usage

Press `C-M-i` in a Javascript file where you want to perform completion.

Not every place will be applicable for completion, and this mode only provides completions returned by Flow.

### Debugging

To see the parsed output of the Flow command, press `M-:` and evaluate the following expression: 

```emacs-lisp
(pp-eval-expression '(json-read-from-string (flow-completion-at-point--execute-command (current-buffer) (line-number-at-pos) (current-column))))
```

To see the raw output, evaluate the following expression instead:

```emacs-lisp
(with-temp-buffer-window "*Flow Output*" nil nil (princ (flow-completion-at-point--execute-command (current-buffer) (line-number-at-pos) (current-column))))
```

## Contribute

PRs accepted.

Small note: If editing the Readme, please conform to the [standard-readme](https://github.com/RichardLitt/standard-readme) specification.

## License

[MIT © Mikahil Pontus.](LICENSE)
