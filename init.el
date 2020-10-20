;;; init.el --- Initialization for Emacs

;;; From emacs-init


;;(require 'cl) ; a rare necessary use of REQUIRE, this is for common lisp!

;;; Commentary:
;; 

;;; Code:

(defvar *emacs-load-start* (current-time))

;; Using https://github.com/danielmai/.emacs.d/blob/master/init.el
;; ========== Essential settings ==========
;;(setq inhibit-startap-message t)
(setq initial-scratch-message "")
(setq inhibit-startup-screen t)


;; load el-get here.
;;(setq el-get-dir (expand-file-name "el-get" user-emacs-directory))
;;(add-to-list 'load-path (concat user-emacs-directory "el-get/el-get"))
;;
;;(unless (require 'el-get nil 'noerror)
;;  (with-current-buffer
;;      (url-retrieve-synchronously
;;       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
;;    (let (el-get-master-branch)
;;      (goto-char (point-max))
;;      (eval-print-last-sexp))))
;;
;;(add-to-list 'el-get-recipe-path (concat user-emacs-directory "recipes"))
;;(set-variable 'el-get-user-package-directory (concat user-emacs-directory "el-get-inits"))

;; The latest version of org-mode should be loaded to make sure every other package depending on it works
;;(when (el-get-package-exists-p "org-mode")
;;  (el-get 'sync (list "org-mode")))
;;(el-get 'sync)

(load (expand-file-name "shared-init.el" user-emacs-directory))
;(org-babel-load-file (expand-file-name "emacs-init.org" user-emacs-directory) )
;; load up emacs init
;(message "Loading emacs-init")

;;(org-babel-load-file (expand-file-name "emacs-init.org" user-emacs-directory))
;;(org-babel-load-file (expand-file-name "gnus.org" user-emacs-directory))

(message "init.el has loaded in %d s" (destructuring-bind (hi lo ms ps) (current-time) (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))
;;; init.el ends here
;;; [end emacs-init]

(load "~/.emacs.d/init-pc")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "679ee3b86b4b34661a68ba45bbd373eab0284caee6249139b2a090c9ddd35ce0" "84890723510d225c45aaff941a7e201606a48b973f0121cb9bcb0b9399be8cba" default)))
 '(elm-indent-offset 4)
 '(elm-sort-imports-on-save t)
 '(exec-path
   (quote
    ("C:/Program Files/Git/usr/bin" "c:/Program Files/AdoptOpenJDK/jdk-11.0.8.10-openj9/bin" "C:/Windows/system32" "C:/Windows" "C:/Windows/System32/Wbem" "C:/Windows/System32/WindowsPowerShell/v1.0/" "C:/Program Files/Git/cmd" "C:/Program Files/Git/mingw64/bin" "C:/Program Files/Git/usr/bin" "C:/Program Files/PuTTY/" "C:/Go/bin" "C:/TDM-GCC-64/bin" "C:/HashiCorp/Vagrant/bin" "C:/Windows/System32/WindowsPowerShell/v1.0/" "f:/opt/nvm" "C:/Program Files/nodejs" "C:/Program Files (x86)/Elm/0.19.1/bin" "C:/Users/MGM/AppData/Roaming/local/bin" "C:/Users/MGM/.cargo/bin" "F:/Ruby22/bin" "C:/Users/MGM/AppData/Local/Programs/Python/Python38-32" "C:/Users/MGM/AppData/Local/Programs/Python/Python38-32/Scripts" "C:/Users/MGM/go/bin" "f:/opt/nvm" "C:/Program Files/nodejs" "c:/opt/emacs-26.2-x86_64/libexec/emacs/26.2/x86_64-w64-mingw32")))
 '(package-selected-packages
   (quote
    (avy diminish counsel-projectile org-evil lsp-haskell yasnippet flycheck-elm nix-mode purescript-mode psc-ide elm-mode tide typescript-mode lsp-ui lsp-mode rust-mode flx-ido sunburn-theme zenburn-theme color-theme-sanityinc-solarized color-theme-modern color-theme-sanityinc-solarizedcolor-theme-sanityfinc-solarized sanityinc-solarized-dark frame-fns use-package)))
 '(projectile-indexing-method (quote hybrid))
 '(projectile-mode-line-prefix " P")
 '(purescript-mode-hook
   (quote
    (turn-on-purescript-indent turn-on-purescript-indentation)))
 '(safe-local-variable-values (quote ((org-use-property-inheritance . t))))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "outline" :slant normal :weight normal :height 113 :width normal)))))
