(require 'package)
(setq
 package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                     ("melpa" . "http://melpa.org/packages/")
                     ("melpa-stable" . "http://stable.melpa.org/packages/")
                     ("org" . "http://orgmode.org/elpa/")
                     )
 ;; package-archive-priorities '(("melpa-stable" . 1))
 )
;ooopsie
(package-initialize)

;;; fonts
(let ((font "Menlo-11"))
  (add-to-list 'default-frame-alist (cons 'font font))
  ;(set-face-attribute 'default nil :font font)
  (set-frame-font font)) 

;;; basic shit
;; (setq default-directory "~/")
;; (setq command-line-default-directory "~/")
(setq-default fill-column 100)
(transient-mark-mode 1) ;; No region when it is not highlighted
(show-paren-mode t)
(electric-pair-mode)
(column-number-mode t)
(set-language-environment "UTF-8")
;;(prefer-coding-system 'utf-8)
(setq help-window-select t)
(toggle-word-wrap t)

(global-set-key "\C-M" 'newline-and-indent)
(global-unset-key "\C-Z")
(setq confirm-kill-emacs 'y-or-n-p)

(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))
(dolist (hook-var '(clojure-mode-hook shell-mode-hook))
  (add-hook hook-var 'remove-dos-eol))

(global-set-key (kbd "C-x C-b") 'ibuffer)

(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(add-hook 'comint-output-filter-functions #'comint-truncate-buffer)

;;; compare-windows ignore whitespace by default
(customize-set-variable 'compare-ignore-whitespace t)

;;;; truncate comint buffers at 1024 lines
(add-hook 'comint-output-filter-functions #'comint-truncate-buffer)

;;; any window system
'(use-package frame-fns
  :if window-system
  :config
  (global-unset-key "\C-z")
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  ;;(require 'fit-frame)
  ;;(global-set-key [(control ?x) (control ?_)] 'fit-frame)
  (setq-default indicate-buffer-boundaries 'left)
  (setq-default indicate-empty-lines t)

  ;; frame manipulation
  (use-package frame-fns :disabled
    :config
    (load "frame-cmds")
    (load "frame-cmd-binds")))

(when window-system
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  '(setq-default indicate-buffer-boundaries 'left)
  (setq-default indicate-empty-lines t)
  )
;;; ns (osx/gnustep) stuff
(when (memq window-system '(mac ns x))
  (use-package exec-path-from-shell)
  (exec-path-from-shell-initialize)
  (customize-set-variable 'ns-alternate-modifier 'super)
  (customize-set-variable 'ns-command-modifier 'meta)
  (global-set-key [(meta ?`)] 'other-frame))

;;; Windows stuff
(when (eq 'w32 window-system)
  (customize-set-variable 'w32-apps-modifier 'hyper))

(use-package evil
  :ensure t
  :demand
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-w-in-emacs-state t)
  :config
  ;; Use tab to move between links in help mode.
  (evil-set-initial-state 'dired-mode 'emacs)
  (evil-set-initial-state 'git-commit-mode 'insert)
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
  
  (if t
      (use-package evil-collection
        :ensure t
        :after evil
        :config
        (evil-collection-init)
        )
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
  (use-package evil-magit :ensure t :after magit)
  (use-package evil-surround :ensure t
    :config (global-evil-surround-mode 1)
    )
  (evil-mode 1))

(use-package which-key
  :diminish (which-key-mode . "Ꙍ")
  :config
  (which-key-mode 1))

;;; general: key binding 
(use-package general
  ;; :after 'evil
  :demand :ensure t
  :config
  (general-evil-setup t)
  (general-define-key
   :prefix "SPC" :non-normal-prefix "s-SPC"
   :states '(motion insert emacs)
   "" '(nil :which-key "main")
   "c" (general-simulate-key "C-c" :which-key "C-c-")
   ;;; "c" (general-simulate-key 'C-c')
   ;;custom-mode-map
   "f" '(nil :ignore t :which-key "file")
   "fb" 'ivy-switch-buffer
   "ff" 'find-file
   "fk" 'kill-buffer
   "fo" 'find-file-other-window
   "fr" 'revert-buffer
   "em" 'mc/editlines
   "w"  evil-window-map
   "p"  '(projectile-command-map :which-key "projectile")
   "s" '(nil :ignore t :which-key "search")
   "ss" 'swiper
   "x" ctl-x-map
   ;;"y" (alist-get 33 (alist-get 3 flycheck-mode-map))
   "y" (general-simulate-key "C-c !" :which-key "flychk")
   )
  )

;;; Help

(use-package clojure :disabled
  :mode ("\\.cljs\\.hl$" . clojure-mode)
  :config
  (load "clojure-hook"))

(use-package color-theme-modern :disabled
  :demand :ensure t
  :config
  ;(load "my-color-theme")
 ;(my-color-theme)
  )

(use-package editorconfig
  :ensure t
  :init
  (add-hook 'prog-mode-hook (editorconfig-mode 1))
  (add-hook 'text-mode-hook (editorconfig-mode 1))
  )

(use-package expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)
          ("C-+" . er/contract-region)))

(use-package xah-fly-keys :disabled
  :config
  (xah-fly-keys-set-layout "qwerty")
  (xah-fly-keys 1)
  (define-key xah-fly-key-map (kbd "C-SPC SPC") 'xah-fly-command-mode-activate-no-hook))

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

(use-package company :ensure
  :bind
  (:map company-active-map
        ("C-n". company-select-next)
        ("C-p". company-select-previous)
        ("M-<". company-select-first)
        ("M->". company-select-last))
  (:map company-mode-map
        ("<tab>". tab-indent-or-complete)
        ("TAB". tab-indent-or-complete)))
(defun company-yasnippet-or-completion ()
  (interactive)
  (or (do-yas-expand)
      (company-complete-common)))

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "::") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

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
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
  ;(use-package intero :ensure t)
  ;(add-hook 'haskell-mode-hook 'intero-mode)
  )
(use-package lsp-mode
  :ensure t
  :commands lsp
  :config
  )
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))
(use-package flycheck :ensure)

(use-package lsp-haskell
  :ensure t
  :hook (haskell-mode . lsp))

;;; ido
(if nil
    (progn
      (setq ido-enable-flex-matching t)
      (setq ido-everywhere t)
      (ido-mode 1)
      ;; Display ido results vertically, rather than horizontally
      '(setq ido-decorations '("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]"
                               " [Matched]" " [Not readable]" " [Too big]"
                               " [Confirm]"))
                                        ;(setq ido-use-filename-at-point nil)
      (setq ido-case-fold t)
      (defun ido-disable-line-trucation ()
        (set (make-local-variable 'truncate-lines) nil))
      (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation))
  (use-package ivy
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
  (use-package ivy-hydra :ensure t
    :demand)
  (use-package counsel-projectile :ensure t))

;;; ivy (w/ counsel, swiper

(add-hook 'java-mode-hook
          (lambda ()
            (setq c-basic-offset 4)))

;;; javascript
(use-package js2-mode
  :ensure t
  :mode ("\\.js\\'" . js2-mode)
  ;;; :hook js2-imenu-extras-mode setup-tide-mode)
  :after tide
  :init
  (use-package flymake-eslint
    :hook ((js2-mode prog-mode) . flymake-mode))
  (use-package js2-refactor
    :ensure t :requires js2-mode
    )
  (use-package xref-js2)
  :hook setup-tide-mode
  :config
  ;; configure javascript-tide checker to run after your default javascript checker
  ;;(js2r-add-keybindings-with-prefix "C-c C-r")
  (set-default 'js2-strict-trailing-comma-warning nil)
  (set-default 'js2-strict-missing-semi-warning nil))

(use-package rjsx-mode
  :ensure t
  :mode ("\\.jsx\\'" . rjsx-mode)
  :config
  (defun react-tag-fix ()
    (if (featurep 'evil)
      (define-key evil-insert-state-map (kbd "C-d") nil)))
    ;;(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))
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

(use-package tide
  ;:mode ("\\.ts\\'" . tide-mode)
  :init
  (defun setup-tide-mode ()
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    ;; company is an optional dependency. You have to
    ;; install it separately via package-install
    ;; `M-x package-install [ret] company`
    (company-mode +1))
  :hook ((typescript-mode js2-mode) . setup-tide-mode)
  :config
  ;; aligns annotation to the right hand side
  (setq company-tooltip-align-annotations t))

(use-package magit 
  :bind (("C-x g" . magit-status)
         ;("C-x M-g" . magit-dispatch-popup)
	 ("C-c g " . magit-file-dispatch)))

(use-package markdown-mode :defer t)

;;;; oCAML / ReScript
(use-package "reason-mode" :disabled)

;;; octave
;(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

;;; paredit
;;(eval-after-load "paredit.el"  '(require 'paredit-menu))
;;(package-install 'paredit-everywhere)
;(add-hook 'prog-mode-hook 'paredit-everywhere-mode)
;;;(electric-pair-mode t)

;;; shell mode
(autoload 'poly-sh-mode "poly-sh-mode" "Poly BASH mode" t)
;;; Fucks shell command:
;;; (add-hook 'shell-mode-hook 'poly-sh-mode)

(use-package smartparens :disabled
  :ensure t
  :config
  (smartparens-global-mode t))
;;;(package-install 'smartparens)
;;;(require 'smartparens-config)
;;;(smartparens-global-mode t)

(use-package plantuml-mode
  :mode (("\\.puml$" . plantuml-mode))
  :config
  (require 'org)
  (when (eq 'ns window-system)
    (setq plantuml-jar-path (expand-file-name "~/.local/share/plantuml/plantuml.jar"))
    (setq org-plantuml-jar-path plantuml-jar-path)
    (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))))
  
'(eval-after-load 'org
   (progn
     (org-babel-do-load-languages
       'org-babel-load-languages
       '((plantuml . t)))))

(use-package projectile
  :ensure t
  :bind (("C-c p" . projectile-command-map))
  :init
  (setq projectile-mode-line '(:eval
                               (if
                                   (file-remote-p default-directory)
                                   "《-》"
                                 (format "《%s》"
                                         (projectile-project-name)))))
  :config
  (projectile-mode)
  (add-to-list 'projectile-globally-ignored-directories "node_modules"))

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
              (setq psc-ide-use-npm-bin t)
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

;;; scala / ensime
(use-package ensime :disabled
             :ensure t
             :pin melpa-stable)
(use-package sbt-mode :pin melpa :disabled)
(use-package scala-mode )

;;(use-package rust-mode :disabled
;;  ;; :ensure t
;;  ;; :mode  "\\.rs"
;;  )
(use-package cargo
  :after rustic-mode :defer t
  :hook (rustic-mode . cargo-minor-mode))

;;; https://github.com/rksm/emacs-rust-config/blob/master/init.el
;;; COnfig: https://robert.kra.hn/posts/2021-02-07_rust-with-emacs/
(use-package rustic :ensure
  :mode  ("\\.rs" . rustic-mode)
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status)
              ("C-c C-c e" . lsp-rust-analyzer-expand-macro)
              ("C-c C-c d" . dap-hydra)
              ("C-c C-c h" . lsp-ui-doc-glance) )
  :after lsp-ui
  :init
  (defun rk/rustic-mode-hook ()
    ;; so that run C-c C-c C-r works without having to confirm, but don't try to
    ;; save rust buffers that are not file visiting. Once
    ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
    ;; no longer be necessary.
    (when buffer-file-name
      (setq-local buffer-save-without-query t)))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-signature-auto-activate nil)
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(use-package toml-mode :ensure)
(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

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


(condition-case ex
    (load-theme 'zenburn t)
    ('error (message (format  "ignoring zenburn bug: [%s]" ex))))

;;;;(set-variable 'custom-file (expand-file-name "customization.el" user-emacs-directory))
(setq custom-file (expand-file-name "customization.el" user-emacs-directory))
(if (file-exists-p custom-file)
    (load custom-file))

;(load-theme 'sanityinc-solarized-dark 1)
