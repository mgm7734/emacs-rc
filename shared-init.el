;;add-to-list 'load-path "~/.emacs.d/lib")

;;; Set up package management
(require 'package)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
 ;;package-archive-priorities '(("melpa-stable" . 1)))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
;(require 'diminish)
(require 'bind-key)
(setq use-package-always-ensure t)


;;; delight the mode line
(use-package delight)

;;; misc simple
(blink-cursor-mode t)
(column-number-mode 1)                        ;; Show column-number in the mode line
(delete-selection-mode t)                     ;; Make it so that selected text are removed on new entries
(electric-pair-mode)
(global-set-key "\C-M" 'newline-and-indent)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key [f11] 'visual-line-mode)      ;; Toggle nice soft line wrapping
(global-set-key [f12] 'toggle-truncate-lines) ;; Toggle-truncate-lines keybinding
(global-set-key [f1] 'menu-bar-mode)          ;; Toggle menu bar mode with f1
(global-unset-key "\C-Z")
(scroll-bar-mode -1)                          ;; Removes the scroll bar
(set-language-environment "UTF-8")
(setq blink-matching-delay .1)                ;; Matching parenthesis timer default 1
(setq confirm-kill-emacs 'y-or-n-p)
(setq help-window-select t)
(setq-default fill-column 100)                 ;; Make newline insertion in the right place
(setq-default indent-tabs-mode nil)           ;; Make sure no tabs are present.
(setq-default tab-width 4)
(show-paren-mode t)
(tool-bar-mode -1)                            ;; Hide toolbar in graphics mode
(transient-mark-mode 1) ;; No region when it is not highlighted
;(menu-bar-mode -1)                            ;; Remove the menu bar, Remove this when menu becomes part of the global menu.
;;(prefer-coding-system 'utf-8)

(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))
(dolist (hook-var '(clojure-mode-hook shell-mode-hook))
  (add-hook hook-var 'remove-dos-eol))


;;; compare-windows
;;;(set-var compare-ignore-whitespace t)

;;; any window system
;;(use-package frame-fns :disabled ; for windows!
;;  :if window-system
;;  :config
;;  (global-unset-key "\C-z")
;;  (tool-bar-mode -1)
;;  (scroll-bar-mode -1)
;;  ;;(require 'fit-frame)
;;  ;;(global-set-key [(control ?x) (control ?_)] 'fit-frame)
;;  (setq-default indicate-buffer-boundaries 'left)
;;  (setq-default indicate-empty-lines t)
;;
;;  ;; frame manipulation
;;  (use-package frame-fns :disabled
;;    :config
;;    (load "frame-cmds")
;;    (load "frame-cmd-binds")))


;;; ns (osx/gnustep) stuff
(when (eq 'ns window-system)
  (setq ns-alternate-modifier 'super)
  (setq ns-command-modifier 'meta)
  (global-set-key [(meta ?`)] 'other-frame))

;;; Windows stuff
(when (eq 'w32 window-system)
  (setq w32-apps-modifier 'hyper))


(use-package clojure :disabled
  :mode ("\\.cljs\\.hl$" . clojure-mode)
  :config
  (load "clojure-hook"))

;;(use-package color-theme-modern :disabled
;;  :demand :ensure t
;;  :config
;;  ;(load "my-color-theme")
;; ;(my-color-theme)
;;  )
;;(use-package color-theme-modern :ensure)
;;(use-package color-theme-sanityinc-solarized :ensure)
;;(load-theme 'sanityinc-solarized-dark 1)
(use-package zenburn-theme
  :ensure t)
(load-theme 'zenburn 1)

(use-package editorconfig
  :ensure t
  :delight " EC"
  :config
  (editorconfig-mode))

;;(use-package eglot :ensure t)

(use-package expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)
          ("C-+" . er/contract-region)))

(use-package elm-mode
  :ensure t
  :mode "\\.elm$"
  )
(use-package flycheck-elm
  :config
  :hook (flycheck . flycheck-elm-setup))

(use-package evil 
  :init
  (setq evil-want-C-w-in-emacs-state t)
  (setq evil-want-keybinding nil)
  (setq evil-want-integration nil)
  :config
  ;; Use tab to move between links in help mode.
  (evil-set-initial-state 'dired-mode 'emacs)
  (evil-define-key 'motion help-mode-map (read-kbd-macro "TAB") 'forward-button)
  (setq evil-default-cursor (quote (t "orange"))
        evil-normal-state-cursor '("DarkGoldenrod2" box)
        evil-insert-state-cursor '("chartreuse3" (bar . 2))
        evil-visual-state-cursor '("gray" hbar)
        evil-motion-state-cursor '("plum" box)
        evil-emacs-state-cursor '("red" box) ; SkyBlue2 in spacemeacs
        evil-replace-state-cursor '("chocolate" (hbar . 2))
        evil-hybrid-state-cursor '("SkyBlue2" (bar . 2))
        evil-evilified-state-cursor '("LightGoldenrod3" box))
                                        ;evil-operator-state-cursor evil-half-cursor
  (if t
      (use-package evil-collection :ensure t)
    (mapc (lambda (mode) (evil-set-initial-state mode 'emacs))
          '(inferior-emacs-lisp-mode
            comint-mode
            shell-mode
            git-rebase-mode
            term-mode
            magit-branch-manager-mode
            eww-mode))
    (mapc (lambda (mode) (evil-set-initial-state mode 'normal))
          '(git-commit-mode)))
  (use-package evil-magit :ensure t)
  (evil-mode 1))

(use-package go-mode 
  :ensure t
  :config
  (if (featurep 'evil)
    (evil-define-key 'normal go-mode (kbd "g C-]") #'godef-jump))
  (add-hook 'go-mode-hook
            (lambda ()
              (setenv "PATH" (concat "C:/go/bin" ";" (getenv "PATH")))
              (local-set-key (kbd "M-.") #'godef-jump)
              (setq tab-width 4)))
  )

(use-package god-mode :disabled
  :ensure t
  :bind ("<escape>" . god-local-mode)
  :init
  (defun my-update-cursor ()
    (set-cursor-color (if god-local-mode ;;;(or god-local-mode buffer-read-only)
                          "purple"
                        "white")))

  (add-hook 'god-mode-enabled-hook 'my-update-cursor)
  (add-hook 'god-mode-disabled-hook 'my-update-cursor)
  :config
  (god-mode)
  ;;  (setq god-exempt-major-modes nil
  ;;        god-exempt-predicates nil)
  )

(use-package graphviz-dot-mode
  :mode "\\.gv$"
  :config
  (setq graphviz-dot-indent-width 2))

;;; groovy
(use-package groovy-mode :ensure t
  :mode "\\.groovy\\'")

;;; haskell
(use-package haskell-mode
  ; :ensure t
  :mode "\\.hs\\'"
  :config
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation))
;; LSP
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode t)
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(use-package yasnippet
  :ensure t)
(use-package lsp-mode
  :ensure t
  :hook (haskell-mode . lsp)
  :commands lsp)
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)
(use-package lsp-haskell
 :ensure t
 :config
 (setq lsp-haskell-process-path-hie "ghcide")
 (setq lsp-haskell-process-args-hie '())
 ;; Comment/uncomment this line to see interactions between lsp client/server.
 ;;(setq lsp-log-io t)
)
;;; ido
(if t
    (progn
      (use-package flx-ido :ensure t)
      (setq ido-enable-flex-matching t)
      (setq ido-everywhere t)
      (ido-mode 1)
      ;; Display ido results vertically, rather than horizontally
      '(setq ido-decorations '("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]"
                               " [Matched]" " [Not readable]" " [Too big]"
                               " [Confirm]"))
                                        ;(setq ido-use-filename-at-point nil)
      (defun ido-disable-line-trucation ()
        (set (make-local-variable 'truncate-lines) nil))
      (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation))
  (use-package ivy :disabled
    :ensure t
    :diminish (ivy-mode . "")
    :config
    (setq ivy-height 20)
    (ivy-mode 1))
  (use-package flx :ensure t)
  (use-package avy :ensure t)
  (use-package counsel :ensure t
    :bind ("C-s" . swiper)
    :config
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t
          recentf-max-saved-items 100
          ivy-count-format "(%d/%d) "
          projectile-completion-system 'ivy))
  (use-package ivy-hydra :disabled
    :demand)
  (use-package counsel-projectile :ensure t))

;;(use-package projectile :ensure t :bind (("C-c p" . projectile-command-map)))

;;; ivy (w/ counsel, swiper)



;;; javascript
(use-package rjsx-mode
  :ensure t
  :mode ("\\.jsx?\\'" . rjsx-mode)
  :config
  (defun react-tag-fix ()
    (if (featurep 'evil)
      (define-key evil-insert-state-map (kbd "C-d") nil)))
    ;;(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))
    (set-default 'js2-strict-trailing-comma-warning nil)
    (set-default 'js2-strict-missing-semi-warning nil)
    (add-hook 'rjsx-mode-hook 'react-tag-fix))
;(add-hook 'js-mode-hook
;	  (lambda ()
;	    (setq js-indent-level 2)))

;;; jsx
;(add-to-list 'auto-mode-alistv '("\\.jsx\\'" . jsx-mode))
;(autoload 'jsx-mode "jsx-mode" "JSX mode" t)
;(add-hook 'jsx-mode-hook
;	  (lambda ()
;	    (setq jsx-indent-level 2)))

(use-package magit :defer t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup)))
(use-package markdown-mode :defer t)

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")
;;; octave
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

;;; paredit
;;(eval-after-load "paredit.el"  '(require 'paredit-menu))
;;(package-install 'paredit-everywhere)
;(add-hook 'prog-mode-hook 'paredit-everywhere-mode)
;;;(electric-pair-mode t)

(use-package smartparens :disabled
  :ensure t
  :config
  (smartparens-global-mode t))
;;;(package-install 'smartparens)
;;;(require 'smartparens-config)
;;;(smartparens-global-mode t)

(use-package plantuml-mode :ensure t
  :mode (("\\.uml\\'" . plantuml-mode))
  :config
  (unless (eq 'w32 window-system)
    (setq plantuml-jar-path "~/opt/plantuml/plantuml.jar")) )


(use-package projectile
  :init
  '(setq projectile-mode-line '(:eval
                               (if
                                   (file-remote-p default-directory)
                                   "《-》"
                                 (format "《%s》"
                                         (projectile-project-name)))))
  :bind (("C-c p" . projectile-command-map))
  :config
  (projectile-mode t)
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  ; :delight '(:eval (concat " " (projectile-project-name)))
  )

;;; Purescript
(use-package purescript-mode
  :ensure 
  :mode "\\.purs\\'"
  :init
  (use-package repl-toggle :disabled
    :config
    (add-to-list 'rtog/mode-repl-alist '(purescript-mode . psci)))
  (use-package psci)
  :config
  (add-hook 'purescript-mode-hook
	    (lambda ()
	      (psc-ide-mode)
	      (company-mode)
	      (flycheck-mode)
	      (inferior-psci-mode)
	      (turn-on-purescript-indentation)
          (customize-set-variable 'psc-ide-add-import-on-completion t)))
  (use-package psc-ide :ensure t))



;;; rails
;(add-hook 'projectile-mode-hook 'projectile-rails-on)

;;; ruby
;(package-install 'ruby-block)
;(require 'ruby-block)
(add-hook 'ruby-mode-hook
	  (lambda ()
	    (electric-indent-mode)))

(use-package rust-mode
  :ensure t
  :mode  "\\.rs")
(use-package cargo
  :after rust-mode :defer t
  :hook (rust-mode . cargo-minor-mode))


;;; scala / ensime
;;(use-package ensime :disabled
;;             :ensure t
;;             :pin melpa-stable)
;;(use-package sbt-mode :pin melpa :disabled)
;;(use-package scala-mode :disabled :pin melpa)

;;(require 'ensime)
;;(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;;; web-mode -- see javascript
(use-package web-mode :disabled
  :mode (("\\.html?\\'" . web-mode)
         ("\\.s?css\\'" . web-mode)
         ("\\.jsx?\\'" . web-mode))
  :config
  (add-hook 'web-mode-hook
            (lambda ()
              (setq web-mode-enable-auto-quoting nil)
              (if (equal web-mode-content-type "javascript")
                  (web-mode-set-content-type "jsx")
                (message "now set to: %s" web-mode-content-type)))))

(use-package yaml-mode
  :ensure t
  :mode (("\\.ya?ml\\'" . yaml-mode)))

(use-package yasnippet :disabled
  :config
  (yas-global-mode 1))
(use-package yasnippet-snippets :disabled)

;;;;;;;;;;; Go from https://github.com/golang/tools/blob/master/gopls/doc/emacs.md
;;(use-package lsp-mode
;;  :ensure t
;;  :commands (lsp lsp-deferred)
;;  :hook (go-mode . lsp-deferred))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Optional - provides fancier overlays.
;; Company mode is a standard completion package that works well with lsp-mode.
(use-package company
  :ensure t
  :config
  ;; Optionally enable completion-as-you-type behavior.
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1))

(use-package typescript-mode
  :ensure
  :mode "\\.ts")

(use-package tide  :disable
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))
