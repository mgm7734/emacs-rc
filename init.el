;;;(add-to-list 'load-path "/Users/mgm/Dropbox/lib/emacs/")
(add-to-list 'load-path "~/.emacs.d/lib")
(load "~/.emacs.d/shared-init")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(compare-ignore-whitespace t)
 '(custom-safe-themes
   '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "679ee3b86b4b34661a68ba45bbd373eab0284caee6249139b2a090c9ddd35ce0" "84890723510d225c45aaff941a7e201606a48b973f0121cb9bcb0b9399be8cba" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default))
 '(haskell-process-path-stack "~/.local/bin/stack")
 '(indent-tabs-mode nil)
 '(intero-stack-executable "~/.local/bin/stack")
 '(js-switch-indent-offset 2)
 '(markdown-command "/usr/local/bin/markdown")
 '(package-selected-packages
   '(spacemacs-theme evil-god-state god-mode psc-ide purescript-mode lsp-haskell lsp-ui lsp-ui-mode lsp-mode intero ess egison-mode eglot js2-refactor xref-js2 poly-markdown polymode sunburn-theme zenburn-theme expand-region markdown-preview-mode edit-indirect avy plantuml-mode evil-col lection rjsx-mode markdown-mode haskell-mode graphviz-dot-mode flx fiplr find-things-fast evil-magit editorconfig counsel-projectile color-theme-solarized color-theme-sanityinc-solarized color-theme-modern))
 '(safe-local-variable-values
   '((js2-additional-externs "db" "printjson" "printjsononeline" "DBQuery")
     (js2-additional-externs "require" "Ti" "exports" "L" "setTimeout" "$" "_" "WPATH" "__filename")
     (js2-additional-externs "require" "Ti" "exports" "L" "setTimeout" "$" "WPATH" "__filename")
     (js2-additional-externs "require" "Ti" "exports" "L" "setTimeout" "$" "__filename")
     (js2-additional-externs "require" "Ti" "exports" "L" "setTimeout" "$")
     (js2-additional-externs "require" "Ti" "exports" "L" "setTimeout")
     (js2-strict-missing-semi-warning . t)
     (js2-additional-externs "require" "Ti" "exports" "L")
     (js2-additional-externs "require" "Ti" "exports")
     (js2-additional-externs "require" "Ti")))
 '(show-trailing-whitespace t)
 '(uniquify-buffer-name-style 'post-forward nil (uniquify))
 '(uniquify-strip-common-suffix nil)
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-fine-diff-B ((t (:background "#0b770b")))))
(put 'downcase-region 'disabled nil)
