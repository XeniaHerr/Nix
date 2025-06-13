(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)

(defun move-line-up()
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))
  

(defun move-line-down()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))


(keymap-global-set "C-S-<down>" 'move-line-down)
(keymap-global-set "C-S-<up>" 'move-line-up)


;; Make magit and compilation happen in current window
(setq display-buffer-alist
      '(("\\*compilation\\*"
	 (display-buffer-same-window))
	("\\*magit\\*"
	 (display-buffer-same-window))))

(defun only-this-buffer ()
  "Close all buffer except the active one"
  (interactive)
  (mapc 'kill-buffer (cdr (buffer-list (current-buffer)))))

(setq inhibit-startup-screen t)
(setq debug-on-eval nil)

(add-to-list 'default-frame-alist '(font . "Mononoki Nerd Font"))

(setq-default inhibit-startup-message nil)
;;(setq shell-file-name "/bin/sh"
;;explicit-shell-file-name "~/.nix-profile/bin/nu" )


(setq gc-cons-threshold 100000000)

(setq read-process-output-max (* 1024 1024))

(setq scroll-step 1
      scroll-conservatively 10000)


(keymap-global-set "C-x C-b" 'ibuffer)

(use-package evil
  :ensure t
  :bind
  (("M->" . next-buffer)
   ("M-<" . previous-buffer))
  :init
  (setq evil-want-keybinding nil
	evil-undo-system 'undo-tree)

  (evil-mode 1))

(use-package evil-collection
  :ensure t
  :after evil
  :init
  (setq evil-want-keyinding nil)
  (evil-collection-init))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode t))


(use-package catppuccin-theme
  :ensure t
  :init
  (setq catppuccin-theme 'mocha)
  (load-theme 'catppuccin :no-confirm))

(use-package treesit-auto
  :ensure t)

(use-package nix-mode
  :ensure t
  :defer t)

(use-package nixos-options
  :ensure t)

(use-package nix-sandbox
  :ensure t)

(use-package direnv
  :ensure t
  :config
  (direnv-mode))

(use-package nushell-mode
  :ensure t
  :defer t)
(use-package magit
  :ensure t
  :bind (("C-c m s" . magit-status)
	 ("C-c m l" . magit-log))
  :defer t)
(use-package rust-mode
  :ensure t
  :defer t
  :init
  (setq rust-mode-treesitter-derive t)
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode)))


(defun my/lsp-mode-hook ()
  (message "my/lsp-mode-hook called")
  (flycheck-mode t)
  (company-mode t)
  (when (and (
	      fboundp 'lsp-feature?)
	     (lsp-feature? "textDocument/inlayHint"))
    (lsp-inlay-hints-mode t))

  (when (and (
	      fboundp 'lsp-feature?)
	     (lsp-feature? "textDocument/documentFormatting"))
    (define-key evil-normal-state-map (kbd "=") #'lsp-format-buffer))

  
  (lsp-ui-mode t)
  )

(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l"
	lsp-clients-clangd-args
	'("--clang-tidy"
	  "--background-index"
	  "--completion-style=detailed"
	  "--header-insertion=iwyu"
	  "--inlay-hints=true"))
  :bind ((
	  "C-c C-/" . comment-or-uncomment-region))
  :hook
  (
   (lsp-mode . my/lsp-mode-hook)
   (c-mode-common . lsp-deferred )
   (nix-mode . lsp-deferred )
   (tex-mode . lsp-deferred)
   (lisp-mode . lsp-deferred ))
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :ensure t
  :bind (:map evil-motion-state-map
	      ("K" . lsp-ui-doc-glance))
  :config
  (setq lsp-ui-doc-enable t
	lsp-ui-sideline-show-hover nil
	lsp-ui-doc-position 'at-point)
  :commands (lsp-ui-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode 1))

(use-package cargo-mode
  :ensure t
  :defer t
  :after rust-mode)


(use-package lisp-mode
  )


(use-package cmake-mode
  :ensure t)


(use-package flycheck
  :ensure t
  )

(use-package auctex
  :ensure t
  :defer t
  :config
  ;;  (add-to-list 'TeX-view-program-list '("Zathura" . zathura))
  (setq TeX-source-correlate-mode t)
  (setq LaTeX-electric-left-right-brace t)
  (setq TeX-view-program-selection '((output-pdf  "Zathura" )))
  :custom
  (TeX-electric-math (cons "$" "$"))
  )

(use-package pdf-tools
  :ensure t
  :config
  ;;  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  )
(use-package all-the-icons
  :ensure t
  )

(use-package all-the-icons-dired
  :after all-the-icons
  :ensure t
  :init
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))


(use-package all-the-icons-ivy
  :ensure t
  :after all-the-icons
  :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

(use-package markdown-mode
  :ensure t
  :defer t
  :config
  (custom-set-faces
   '(markdown-header-face (( t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
   '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.8))))
   '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.4))))
   '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.2))))
   '(markdown-bold-face ((t (:inherit font-lock-function-name-face :weight bold))))
   ))

;; (use-package multiple-cursors
;;   :ensure t
;;   :bind
;;   (("C-S-c C-S-s" . mc/edit-lines  )	; Need active region
;;    ("C->" . mc/mark-next-like-this)
;;    ("C-<" . mc/mark-previous-like-this)))


;; (use-package evil-multiedit
;;   :ensure t
;;   )
(use-package evil-mc
  :ensure t
  :bind (:map evil-visual-state-map
	      ("C-S-R" . evil-mc-make-all-cursors)
	      ("C-I" . evil-mcmake-cursor-in-visual-selection-beg)
	      ("C-A" . evil-mcmake-cursor-in-visual-selection-end)
	      )
  :config
  (global-evil-mc-mode 1))

(use-package vterm
  :ensure t
  :bind (:map vterm-mode-map 
	      ("M->" . next-buffer)
	      ("M-<" . previous-buffer))
  )
					;  :config
					;  (setq vterm-shell "/home/xenia/.nix-profile/bin/nu" ))

(use-package org-superstar
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

(use-package ivy

  :config
  (ivy-mode 1))

(use-package counsel
  :ensure t
  :config
  (counsel-mode 1))


(use-package swiper
  :ensure t
  :after ivy
  :bind (("C-s" . swiper)
	 ("C-r" . swiper))
  )

(use-package company
  :ensure t
  :bind (
	 :map company-active-map
	 ("RET" . nil)
	 ("[return]" . nil)
	 ("TAB" . company-complete-selection)
	 ("<tab>" . company-complete-selection)
	 ("C-n" . company-select-next)
	 ("C-p" . company-select-previous)
	 )
  :config
  (add-to-list 'company-backends 'company-files)
  :hook
  ((prog-mode . company-mode))
  )


(use-package company-nixos-options
  :ensure t
  :config
  (add-to-list 'company-backends 'company-nixos))

(use-package company-auctex
  :ensure t
  :after company
  )

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;;(use-package helm
;; :ensure t
;;)
;;(helm-mode 1)

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") `projectile-command-map)
  (setq projectile-switch-project-action 'projectile-commander)
  (projectile-mode 1)
  )


(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))


(use-package smartparens
  :ensure t  ;; install the package
  :hook (prog-mode text-mode markdown-mode) ;; add `smartparens-mode` to these hooks
  :config
  ;; load default config
  (require 'smartparens-config))



