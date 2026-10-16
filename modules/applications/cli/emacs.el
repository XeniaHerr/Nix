(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode)

( show-paren-mode 1)
(setq show-paren-delay 0
      kill-buffer-delete-auto-save-files t
      create-lockfiles nil)

(setf make-backup-files nil)

(set-face-attribute 'show-paren-match nil
		    :background "#000000")

(defun move-line-up()
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(with-eval-after-load 'vterm
    (add-to-list 'vterm-tramp-shells `(,teleport-tramp-method "/bin/bash")))

(setq whitespace-style '(face
    tabs spaces trailing space-before-tab 
    indentation space-after-tab
    space-mark tab-mark 
    missing-newline-at-eof))

;;(keymap-global-set "C-<tab>" 'fixup-whitespace)


(add-hook 'prog-mode-hook '(lambda() (whitespace-mode)))
(add-hook 'yaml-ts-mode-hook '(lambda() (whitespace-mode)))

(keymap-global-set "M-#" (lambda () (interactive) (let ((current-prefix-arg -1))
(call-interactively #'mark-word))))

(keymap-global-set "<f6>" 'compile)
(keymap-global-set "S-<f6>" 'recompile)


(defun move-line-down()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))



(defun duplicate-line-tsod()
  "Version stolen from Tsoding"
  (interactive)
  (let ((column (- (point) (line-beginning-position)))
	(line (let (( s (thing-at-point 'line t)))
		(if s (string-remove-suffix "\n" s ) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)
    ))

(keymap-global-set "C-x C-<down>" 'duplicate-line-tsod)



(defun my/open-as-sudo()
  (interactive)
  (let ((p (point))
	(file-name buffer-file-name))
    (when file-name
      (find-alternate-file (concat "/sudo::" file-name))
      (goto-char p)))
  )

(keymap-global-set "C-S-<down>" 'move-line-down)
(keymap-global-set "C-S-<up>" 'move-line-up)

(keymap-global-set "M-n" 'scroll-up-line)
(keymap-global-set "M-p" 'scroll-down-line)
(setq scroll-preserve-screen-position t)
;;(setq scroll-margin  0      )


(defun my/open-vterm (&optional prefix)
  (interactive "P")
  (when prefix
      (split-window-below -10)
       (other-window 1))
  (vterm))

(defun my/make-dev-environment()
    (interactive)
  (split-window-below -10)
  (other-window 1)
  (vterm)
  (other-window -1)
  (split-window-right)
  )




(keymap-global-set "C-c v" 'my/open-vterm)

;; Make magit and compilation happen in current window
(setq display-buffer-alist
      '(("\\*compilation\\*"
	 ( display-buffer-reuse-mode-window display-buffer-reuse-window display-buffer-same-window))
	("\\*magit\\*"
	 (display-buffer-same-window))))
(setq compilation-scroll-output t)


(defun only-this-buffer ()
  "Close all buffer except the active one"
  (interactive)
  (mapc 'kill-buffer (cdr (buffer-list (current-buffer)))))

(setq inhibit-startup-screen t)
(setq debug-on-eval nil)
(setq debug-on-quit nil)

(add-to-list 'default-frame-alist '(font . "Mononoki Nerd Font"))

(setq-default inhibit-startup-message nil)
;; (setq shell-file-name "/bin/sh"
;; explicit-shell-file-name "~/.nix-profile/bin/nu" )


(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

;; (setq scroll-step 1
;;       scroll-conservatively 10000)


(setq next-line-add-newlines nil)


(keymap-global-set "C-x C-b" 'ibuffer)



(use-package ansi-color
  :demand t
  :hook (compilation-filter . ansi-color-compilation-filter))

(defun my/colorize-compilation-buf ()
  (let ((start (or ( bound-and-true-p compilation-filter-start) (point-min)))
	(end (point-max)))
    (ansi-color-apply-on-region start end)))

;; (add-hook 'compilation-filter-hook (lambda ()
;; 				     (ansi-color-apply-on-region compilation-filter-start (point-max))))



(use-package expand-region
  :ensure t
  :bind (( "C-=" .'er/expand-region)))

(use-package multiple-cursors
  :ensure t
  :bind ((	 "C->" . 'mc/mark-next-like-this)
	 ( "C-<" . 'mc/mark-previous-like-this)
	 ( "C-c C-<" . 'mc/mark-all-like-this)
	 (" C-c C->" . 'mc/mark-all-in-region-regexp)
	 (" C-S-c C-S-c" . 'mc/edit-lines)
	 ("C-M-<" . 'mc/mark-more-like-this-extended)
  ))
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode t)
  )

(setq undo-tree-history-directory-alist '(("." .   "~/emacs.d/undo-history")))


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
  )

(use-package nushell-mode
  :ensure t
  :defer t)
(use-package magit
  :ensure t
  :config
  (setq magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1)
  :bind (("C-c m s" . magit-status)
	 ("C-c m l" . magit-log))
  :defer t)
(use-package rust-mode
  :ensure t
  :defer t
  :init
  (setq rust-mode-treesitter-derive t)
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode)))

(use-package haskell-mode
  :ensure t)



(use-package eglot
  :defer t
  :config
  

(with-eval-after-load 'eglot

  (with-eval-after-load 'typst-ts-mode

    (add-to-list 'eglot-server-programs

                 `((typst-ts-mode) .

                   ,(eglot-alternatives `(,typst-ts-lsp-download-path

                                          "tinymist"

                                          "typst-lsp"))))
    (with-eval-after-load 'qml-mode
      (add-to-list 'eglot-server-programs
		   `((qml-mode) . ("qmlls")))))
:ensure t

)
)


(use-package typescript-mode
  :ensure t)
(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-ui-doc-enable t
	lsp-ui-sideline-show-hover nil
	lsp-ui-doc-position 'at-point)
  :commands (lsp-ui-mode))




(use-package which-key
  :ensure t
  :init
  (setq which-key-separator "  ")
  (require 'posframe)
  (defun which-key-custom-popup-max-dimensions-function (ignore)
  (cons (frame-height) (which-key--width-or-percentage-to-width which-key-side-window-max-width)))
(defun fit-horizontally ()
  (let ((fit-window-to-buffer-horizontally t))
    (fit-window-to-buffer)))

(defun which-key-custom-show-popup-function (act-popup-dim)
    (when (posframe-workable-p)
      (save-window-excursion
    (posframe-show which-key--buffer :poshandler posframe-poshandler-frame-bottom-right-corner :border-width 1 :border-color "gray" :height (car act-popup-dim) :width (cdr act-popup-dim))
  )))




;; Should  be done like this
(defun which-key-custom-hide-popup-function ()
  (when (buffer-live-p which-key--buffer)
  (posframe-hide which-key--buffer)))

:config
;;(setq which-key-popup-type 'custom)
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

(use-package nerd-icons-dired
  :after nerd-icons
  :ensure t

  :hook (dired-mode . nerd-icons-dired-mode))


(use-package ivy-rich
  :ensure t
  )

(use-package nerd-icons-ivy-rich
  :ensure t
  :after ivy-rich
  :init (nerd-icons-ivy-rich-mode 1)
  (ivy-rich-mode 1))

(use-package counsel
  :ensure t
  :config
  (counsel-mode 1)
  )
(use-package ivy
  :ensure t
  :config
  ;; (ivy-mode 1)
  )

(use-package ivy-posframe
  :ensure t
  :config
  ;; (ivy-posframe-mode 1)
  )

(use-package markdown-mode
  :ensure t
  :defer t
  :config
  (setq markdown-command "pandoc")
  (custom-set-faces
   '(markdown-header-face (( t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
   '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.8))))
   '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.4))))
   '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.2))))
   '(markdown-bold-face ((t (:inherit font-lock-function-name-face :weight bold))))
   ))


(use-package markdown-preview-mode
  :ensure t
  )


(use-package python-mode
  :ensure t
  :config
  (setq python-shell-switch-buffers-on-execute nil
	py-keep-windows-configuration t
	py-split-window-on-execute nil
	py-switch-buffers-on-execute-p nil)
  (add-to-list `display-buffer-alist
	       '("\\*Python\\*"
		 ( display-buffer-reuse-window display-buffer-use-some-frame
		   )
		 )
	       
	       )
  )


(use-package vterm
  :ensure t
  :bind (:map vterm-mode-map 
	      ("M->" . next-buffer)
	      ("M-<" . previous-buffer))
  )




(use-package org-modern
  :ensure t
  :hook
  ((org-mode .  org-modern-mode))
  )


(use-package org
  :ensure t
  :config
  (setq org-directory "~/org"
	org-agenda-files "agenda.org"
	org-format-latex-options '(:foreground default :background default :scale 3.0 :html-foreground "Black" :html-background "Transparent" :html-scale 3.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[") )))




(defun my/todo-capture-hook()
    (save-excursion 
		     (org-up-heading-safe)
    (unless (org-entry-get nil "ID")
	    (org-id-get-create)))
    (let* ((
	    file-node (org-roam-node-from-id (org-roam-node-id ( save-excursion (beginning-of-buffer) (org-roam-node-at-point)))))
	   (file-title (org-roam-node-title file-node))
	   (title-alias (concat file-title " Tasks")))
	(message title-alias)
	(org-set-property "ROAM_ALIASES" title-alias))
    )

(use-package org-roam
  :ensure t
  :bind ((
	  "C-c n f" . org-roam-node-find)
	 ("C-c n c" . org-roam-capture)
	 ("C-c n i" . org-roam-node-insert)
	 :map org-mode-map
	 ("C-c n t a" . org-roam-tag-add)
	 ("C-c n t d" . org-roam-tag-remove )
	 	 )
  :custom
  (org-roam-directory (file-truename "~/org-roam"))
  (org-roam-node-level 'headline)
  :config
  (setq org-roam-node-level 'headline)
  (setq org-roam-capture-templates '(("d" "default" plain "%?" :target (file+head
									"%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}
") :unnarrowed t)
				     ("t" "todo" checkitem " - [ ] %?" :target (file+olp (lambda () (
													   (org-roam-node-read)))("Tasks"))

				      :hook (my/todo-capture-hook)
				      :unnarrowed t)
				     ("S" "Satz" plain "* ${title}\n\n* Aussage\n%?\n* Proof"
				     :target (file+head "${slug}.org" "#+title: ${title}\n#+filetags: :Math:")
				     :unnarrowed t)
				     ("D" "Definition" plain "* ${title}\n%?"
				      :target (file+head "${slug}.org" "#+title: ${title}\n#+filetags: :Math:")
				      :unnarrowed t)
				     ))
  (org-roam-setup))



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
    (add-to-list 'company-backends 'company-capf 'company-math-symbols-unicode)
  :hook
  ((prog-mode . company-mode)
   (typst-ts-mode . company-mode))
  )



(use-package company-nixos-options
  :ensure t
  :config
  (add-to-list 'company-backends 'company-nixos))

(use-package company-auctex
  :ensure t
  :after company
  :config
  (add-to-list 'company-backends 'company-math-symbols-unicode)
  )


(use-package company-math
  :ensure t
  :after company)

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))


(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") `projectile-command-map)
  (setq projectile-switch-project-action 'projectile-dispatch)
  (projectile-mode 1)
  )

(use-package nerd-icons
  :ensure t
  :init
  (add-to-list 'nerd-icons-mode-icon-alist '( nix-mode nerd-icons-mdicon "nf-md-nixos" :face nerd-icons-blue))
  (add-to-list 'nerd-icons-mode-icon-alist '( nix-ts-mode nerd-icons-mdicon "nf-md-nixos" :face nerd-icons-blue))
  )

(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-icon t
	doom-modeline-major-mode-color-icon t
	doom-modeline-lsp-icon t
	doom-modeline-buffer-encoding nil
	doom-modeline-modal-icon t
	doom-modeline-modal-modern-icon t)
  (doom-modeline-mode 1))


(use-package smartparens
  :ensure t  ;; install the package
  :hook (prog-mode text-mode markdown-mode) ;; add `smartparens-mode` to these hooks
  :bind (( "C-M-)" . sp-slurp-hybrid-sexp)
	 ("C-M-(" . sp-backward-slurp-sexp)
	 ("C-|" . sp-split-sexp)
	 ("C-M-|" . sp-join-sexp)
	 )
  :config
  ;; load default config
  (require 'smartparens-config))


(use-package f
  :ensure t)


(use-package gptel
  :ensure t
  :defer t
  :config
  (setq gptel-api-key  (f-read "~/.config/sops-nix/secrets/passwords/chatgptapikey" )))


(use-package jupyter
  :ensure t
  :config
  (setq jupyter-repl-echo-eval-p t)
  )


(use-package ein
  :ensure t
  :config
  (setq ein:output-area-inlined-images t)
  )


(use-package rg
  :ensure t
  )

(use-package ace-window
  :ensure t
  :bind (("M-o" . 'ace-window))
  :config
  (ace-window-display-mode 1)
  (setq aw-scope 'frame)		
  )

(use-package hydra
  :ensure t
  :config

  (defhydra hydra-smerge (smerge-mode-map "C-c ^ ^")
					  "easier merging"
					  "l" smerge-keep-lower "lower"
					  "u" smerge-keep-upper "upper"
					  "n" smerge-next "next"
					  "p" smerge-prev "prev")
  (defhydra hydra-m-g (global-map "M-g")
	    "navigate with m-g"
	    ("M-n" next-error "next")
	    ("M-p" previous-error "prev")))




(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  )

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  )

(use-package consult
  :ensure t
  :bind ((
	  "C-x b" . consult-buffer)
	 ("M-g i" . consult-imenu)
	 ("M-g M-i" . consult-imenu-multi)
	 ("M-g M-g" . consult-goto-line)
	 ("M-s g" . consult-grep)
	 ("M-s d" . consult-find)
	 ("M-s l" . consult-line)
	 ("M-s L" . consult-line-multi)
	 ("M-s k" . consult-keep-lines)
	 ("M-s u" . consult-focus-lines)
	 ("M-y" . consult-yank-pop)
	 :map minibuffer-local-map
	 ("M-s" . consult-history)
	 ("M-r" . consult-history)

	 )
  )

(use-package marginalia
  :ensure t
  :bind (
	 :map minibuffer-mode-map
	      ("M-A" . marginalia-cycle)	      )
  :init
  (marginalia-mode)
  )


(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("M-." . embark-dwim)
   ))

(use-package embark-consult
  :ensure t
  :hook (embark-collect-mode . consult-preview-at-point-mode))



(use-package typst-ts-mode
  :ensure t)

(use-package qml-mode
  :ensure t)

(use-package go-mode
	     :ensure t)

(use-package rocq-mode
  :vc (:url "https://codeberg.org/jpoiret/rocq-mode.el.git"
            :rev :newest)
;;  :ensure t
  :defer t
  :mode ("\\.v\\'" . rocq-mode)
  :hook
    (rocq-mode . rocq-follow-viewport-mode)
    (rocq-mode . rocq-auto-goals-at-point-mode)
  :config
  (set-face-attribute 'rocq-mode-processing-face nil :background 'unspecified)
  (set-face-attribute 'rocq-mode-last-request nil :background "black")
    
    ;; (add-to-list 'auto-mode-alist '("\\.v\\'" . rocq-mode))
    :init
    :custom
    ;; Whether to show the goal above the context, default is `t`
    (rocq-top-goal t))


(use-package teleport
  :ensure t
  :init
  (teleport-tramp-add-method)
  (add-to-list 'tramp-default-user-alist
             '("\\`tsh\\'" nil "root"))

  ;; Commands from this keymap are called with `default-directory' set to the remote host when called from `teleport-list-nodes' mode.
  :bind (:map teleport-list-nodes-mode-map
              ("v" . vterm)
              ("t" . term)
              ("d" . dired)
	      :map global-map
	      ("C-c t l" . teleport-list-nodes))

  )
