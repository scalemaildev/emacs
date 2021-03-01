;;;; CONWAY EMACS ;;;;
;; This is John Conway's Emacs Config.
;; Started: 12/20/2018
;; Last Update: 02/28/2021
;;
;; ON WINDOWS:
;; 1. Run emacs
;; 2. Pin icon to taskbar
;; 3. Right click icon -> right click emacs -> properties -> point to runemacs.exe
;;;;;;;;;;;;;;;;;;;;;;

;;;; BACK END ;;;;
;; Package
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
;; Use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
;;;; FRONT END ;;;;
;; Fullscreen on startup
(setq ns-use-native-fullscreen t)
(set-frame-parameter nil 'fullscreen 'fullboth)
;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-spacegrey t))
;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
;; Font
(add-to-list 'default-frame-alist '(font . "mononoki-11"))
;; Titlebar
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-proxy-icon  nil)
(setq frame-title-format nil)
;; Matching parentheses
(setq show-paren-delay 0)
(show-paren-mode 1)
;; Linums to all files
(add-hook 'find-file-hook 'linum-mode)
;; No backup files
(setq make-backup-files nil)
(setq auto-save-default nil)
;; No bells
(setq ring-bell-function 'ignore)
;;;; INDIVIDUAL PACKAGES;;;;
;; Helm
(use-package helm
  :ensure t
  :init
  (setq helm-M-x-fuzzy-match t
  helm-mode-fuzzy-match t
  helm-buffers-fuzzy-matching t
  helm-recentf-fuzzy-match t
  helm-locate-fuzzy-match t
  helm-semantic-fuzzy-match t
  helm-imenu-fuzzy-match t
  helm-completion-in-region-fuzzy-match t
  helm-candidate-number-list 150
  helm-split-window-in-side-p t
  helm-move-to-line-cycle-in-source t
  helm-echo-input-in-header-line t
  helm-autoresize-max-height 0
  helm-autoresize-min-height 20)
  :bind
  (("M-x" . helm-M-x)
   ("C-c m f" . helm-find-files))
  :config
  (helm-mode 1))
;; Projectile
(use-package projectile
  :ensure t
  :config
  (projectile-mode 1))
;; Helm-Projectile
(use-package helm-projectile
  :ensure t
  :init
  (setq helm-projectile-fuzzy-match t)
  :config
  (helm-projectile-on))
;; Magit
(use-package magit
  :ensure t
  :bind
  (("C-c m m" . magit)))
;; Which Key
(use-package which-key
  :ensure t
  :config
  (which-key-mode 1))
;; Ansi-Term
(eval-after-load "term"
  '(define-key term-raw-map (kbd "C-c y") 'term-paste))
;; Flycheck
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))
;; Company
(use-package company
  :ensure t)
;; PDF Tools
(use-package pdf-tools
  :ensure t)
;; CSV-mode
(use-package csv-mode
  :ensure t)
;; Page Break Lines
(use-package page-break-lines
  :ensure t)
;; Beacon
(use-package beacon
  :ensure t
  :init
  (beacon-mode 1))
;; Dimmer
(use-package dimmer
  :ensure t
  :init
  (dimmer-mode))
;; Spaceline
(use-package spaceline
  :ensure t
  :init
  (spaceline-spacemacs-theme))
;; Dashboard
(use-package dashboard
  :ensure t
  :init
  (add-hook 'after-init-hook 'dashboard-refresh-buffer)
  (defun dashboard-custom-banner ()
  (setq dashboard-banner-logo-title
        (format "Boot time: %.2f seconds"
                (float-time (time-subtract after-init-time before-init-time)))))
  (add-hook 'dashboard-mode-hook 'dashboard-custom-banner)
  :config
  (setq dashboard-startup-banner 'logo
	dashboard-items '((agenda . 7)
			(recents  . 7)
                        (bookmarks . 7)
			(projects . 7)))
  (dashboard-setup-startup-hook))
;; Shell-pop
(use-package shell-pop
  :ensure t
  :config
  (defcustom shell-pop-cleanup-buffer-at-process-exit t
  "If non-nil, cleanup the shell's buffer after its process exits.")
  (defun shell-pop--set-exit-action ()
  (if (string= shell-pop-internal-mode "eshell")
      (add-hook 'eshell-exit-hook 'shell-pop--kill-and-delete-window nil t)
    (let ((process (get-buffer-process (current-buffer))))
      (when process
        (set-process-sentinel
         process
         (lambda (_proc change)
           (when (string-match-p "\\(?:finished\\|exited\\)" change)
	     (run-hooks 'shell-pop-process-exit-hook)
             (when shell-pop-cleanup-buffer-at-process-exit
               (kill-buffer))
             (if (one-window-p)
                 (switch-to-buffer shell-pop-last-buffer)
               (delete-window))))))))))
(use-package exec-path-from-shell
  :ensure t)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
;;;; LANGUAGES ;;;
;; Python
(use-package elpy
  :ensure t
  :config
  :init
  (elpy-enable))
;; Ruby
(use-package enh-ruby-mode
  :ensure t
  :config
  (autoload 'enh-ruby-mode "enh-ruby-mode" t)
  (add-to-list 'auto-mode-alist
             '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . enh-ruby-mode))
  (add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode)))
;; Javascript
(use-package js2-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-hook 'js2-mode-hook #'js2-imenu-extras-mode))
;; Web-Mode
(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))
;; Vue
(use-package vue-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode)))
;; C/C++
(use-package irony
  :ensure t
  :config
  (defun my-c-mode-setup ()
    (setq indent-tabs-mode nil)
    (setq c-syntactic-indentation t)
    (c-set-style "ellemtel")
    (setq c-basic-offset 8)
    (setq truncate-lines t)
    (setq tab-width 8))
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  (add-hook 'irony-mode-hook 'my-c-mode-setup t))
;; C#
(use-package omnisharp
  :ensure t
  :config
  (eval-after-load
  'company
  '(add-to-list 'company-backends #'company-omnisharp))
  (defun my-csharp-mode-setup ()
    (omnisharp-mode)
    (company-mode)
    (flycheck-mode)

    (setq indent-tabs-mode nil)
    (setq c-syntactic-indentation t)
    (c-set-style "ellemtel")
    (setq c-basic-offset 8)
    (setq truncate-lines t)
    (setq tab-width 8)

    (local-set-key (kbd "C-c m r r") 'omnisharp-run-code-action-refactoring)
    (local-set-key (kbd "C-c C-c") 'recompile))

  (add-hook 'csharp-mode-hook 'my-csharp-mode-setup t))
;; Haskell
(use-package haskell-mode
  :ensure t)
;; Renpy
;; Download .el file to .emacs.d and uncomment for renpy editing 
;; https://github.com/elizagamedev/renpy-mode
;; (add-to-list 'load-path "~/.emacs.d/")
;; (load "renpy-mode.el")
;;;; CUSTOM KEYBINDS ;;;;
(use-package general
  :ensure t
  :config
  (general-define-key
   ;; Buffers
   "C-c v" '(split-window-below :which-key "split buffer down")
   "C-c r" '(split-window-right :which-key "split buffer right")
   "C-c l"  '(helm-buffers-list :which-key "buffers list")
   ;; Windows
   "C-c f" '(windmove-right :which-key "move right")
   "C-c b" '(windmove-left :which-key "move left")
   "C-c p" '(windmove-up :which-key "move up")
   "C-c n" '(windmove-down :which-key "move down")
   "C-c k" '(delete-window :which-key "delete window")
   ;; Projectile
   "C-c m p f" '(projectile-find-file :which-key "projectile find file")
   ;; Goto
   "C-c g" '(goto-line :which-key "goto line")
   ;; Killring
   "C-c m p r"  '(helm-show-kill-ring :which-key "show kill ring")
   ;; Beacon
   "C-'" '(beacon-blink :which-key "blink beacon")
   ;; General Compiling
   "C-c m c" '(compile :which-key "general compile")
   "C-c m r" '(recompile :which-key "general recompile")
   ))
;;;; CUSTOM SET VARIABLES;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(doom-spacegrey))
 '(custom-safe-themes
   '("8e04ea7bf8a736b0bfacd363f4810ffce774ff9ba24f356172ae2b83307aebb2" "ab9456aaeab81ba46a815c00930345ada223e1e7c7ab839659b382b52437b9ea" "b0fd04a1b4b614840073a82a53e88fe2abc3d731462d6fde4e541807825af342" "a16e816774b437acb78beb9916a60ea236cfcd05784227a7d829623f8468c5a2" "cdb3e7a8864cede434b168c9a060bf853eeb5b3f9f758310d2a2e23be41a24ae" "e95ad48fd7cb77322e89fa7df2e66282ade015866b0c675b1d5b9e6ed88649b4" "614e5089876ea69b515c50b6d7fa0a37eb7ed50fda224623ec49e1c91a0af6a1" "06e4b3fdcbadc29ff95a7146dee846cd027cfefca871b2e9142b54ad5de4832f" "34c99997eaa73d64b1aaa95caca9f0d64229871c200c5254526d0062f8074693" "1a6d627434899f6d21e35b85fee62079db55ef04ecd9b70b82e5d475406d9c69" "4e132458143b6bab453e812f03208075189deca7ad5954a4abb27d5afce10a9a" "f5568ed375abea716d1bdfae0316d1d179f69972eaccd1f331b3e9863d7e174a" "868abc288f3afe212a70d24de2e156180e97c67ca2e86ba0f2bf9a18c9672f07" "9c27124b3a653d43b3ffa088cd092c34f3f82296cf0d5d4f719c0c0817e1afa6" "e3c87e869f94af65d358aa279945a3daf46f8185f1a5756ca1c90759024593dd" "155a5de9192c2f6d53efcc9c554892a0d87d87f99ad8cc14b330f4f4be204445" "d1cc05d755d5a21a31bced25bed40f85d8677e69c73ca365628ce8024827c9e3" default))
 '(dashboard-center-content nil)
 '(dashboard-set-footer nil)
 '(dashboard-set-init-info nil)
 '(elpy-modules
   '(elpy-module-company elpy-module-eldoc elpy-module-pyvenv elpy-module-highlight-indentation elpy-module-yasnippet elpy-module-django elpy-module-sane-defaults))
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount '(1 ((shift) . 5) ((control))))
 '(package-selected-packages
   '(csv-mode shell-pop dashboard which-key magit pdf-tools renpy irony dimmer company-mode helm-projectile enh-ruby-mode omnisharp csharp-mode vue-mode web-mode js2-mode elpy spaceline-config spaceline beacon exec-path-from-shell general doom-themes use-package))
 '(python-indent-offset 4)
 '(shell-pop-autocd-to-working-dir t)
 '(shell-pop-cleanup-buffer-at-process-exit t)
 '(shell-pop-restore-window-configuration t)
 '(shell-pop-shell-type '("eshell" "*eshell*" (lambda nil (eshell))))
 '(shell-pop-universal-key "C-c t"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
