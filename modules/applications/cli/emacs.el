(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(defun move-line-up()
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))


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


(setq next-line-add-newlines t)


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



;;(use-package evil
;;  :ensure t
  ;;:custom
  ;;(evil-want-keybinding nil)
  ;; :bind
  ;; (("M->" . next-buffer)
  ;;  ("M-<" . previous-buffer)
  ;;  (:map evil-normal-state-map (
  ;; 				"g.r" . (kbd "/ C-r \" <return> cgn C-@"))))

  ;; :init
  ;; (setq evil-want-keybinding nil)
  ;; (setq evil-undo-system 'undo-tree)
  ;; (setq evil-search-module 'evil-search)
  ;; :config

  ;; (define-key evil-normal-state-map (kbd "g.r") (lambda ()
  ;; 						  (interactive)
  ;; 						  (execute-kbd-macro (kbd "/ C-r \" <return> cgn C-@"))))
  ;; (global-set-key (kbd "M->") 'next-buffer)
  ;; (global-set-key (kbd "M-<") 'previous-buffer)
  ;; ;; (qevil-mode)
;;  )

;; (use-package evil-collection
;; ;;  :ensure t
;;   :after evil
;;   ;;:custom
;;   ;;(evil-want-keybinding nil)
;;   :init
;;   ;(setq evil-want-keybinding nil)
;; ;  (evil-collection-init)
;;   )


(use-package multiple-cursors
  :ensure t
  :bind ((	 "C->" . 'mc/mark-next-like-this)
	 ( "C-<" . 'mc/mark-previous-like-this)
	 ( "C-c C-<" . 'mc/mark-all-like-this)
  ))

(use-package helm
  :ensure t
  :bind  ((
	 "M-x" . helm-M-x)
	("C-x C-f" . helm-find-files )
	("C-x C-b" . helm-buffers-list)
	("M-g i" .  helm-imenu)
	("M-g I" . helm-imenu-in-all-buffers)
	("M-g o" . helm-occur)
	("C-c h" . helm-mini))
  :config
  (helm-mode 1)
  (helm-ff-icon-mode 1 ))


(use-package helm-projectile
  :ensure t
  :bind (:map projectile-mode-map
	      ("C-c p f" . helm-projectile-find-file-dwim)
	      ("C-c p p" . helm-projectile-switch-project)
	      ("C-c p b" . helm-projectile-switch-to-buffer)
	      ("C-c p s g" . helm-projectile-grep) ;;This is broken
	      ;;("C-c p s r" . helm-projectile-rg)))
	      ))


(use-package helm-rg
  :ensure t
  )
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


(defun my/lsp-mode-hook ()
  (message "my/lsp-mode-hook called")
  (flycheck-mode t)
  (company-mode t)
  (when (and
	 (fboundp 'lsp-feature?)
	     (lsp-feature? "textDocument/inlayHint"))
    (lsp-inlay-hints-mode t))

  ;; (when (and
  ;; 	 (fboundp 'lsp-feature?)
  ;; 	     (lsp-feature? "textDocument/documentFormatting"))
  ;;   (define-key evil-normal-state-map (kbd "=") #'lsp-format-buffer))

  
  (lsp-ui-mode t)
  )
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
            (setcar orig-result command-from-exec-path))
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)
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
   (lsp-configure . my/lsp-mode-hook)
   (c-mode-common . lsp-deferred )
   (nix-mode . lsp-deferred )
   (LaTeX-mode . lsp-deferred)
   (lisp-mode . lsp-deferred )
   (typescript-mode . lsp-deferred)
   (python-mode . lsp-deferred))
  :commands (lsp lsp-deferred))


(use-package typescript-mode
  :ensure t)
(use-package lsp-ui
  :ensure t
  ;; :bind (:map evil-motion-state-map
  ;; 	      ("K" . lsp-ui-doc-glance))
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

(use-package nerd-icons-dired
  :after nerd-icons
  :ensure t
  :init
  (add-hook 'dired-mode-hook #'nerd-icons-dired-mode))

;; (use-package ivy-rich
;;   :ensure t
;;   )

;; (use-package nerd-icons-ivy-rich
;;   :ensure t
;;   :after ivy-rich
;;   :init (nerd-icons-ivy-rich-mode 1)
;;   (ivy-rich-mode 1))

;; (use-package all-the-icons
;;   :ensure t)
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


(use-package markdown-preview-mode
  :ensure t
  )


(use-package python-mode
  :ensure t)


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
	 ("C-c n i" . org-roam-node-insert))
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


(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") `projectile-command-map)
  (setq projectile-switch-project-action 'projectile-commander)
  (projectile-mode 1)
  )

(use-package nerd-icons
  :ensure t)

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
  (defhydra hydra-m-g (global-map "M-g")
	    "navigate with m-g"
	    ("M-n" next-error "next")
	    ("M-p" previous-error "prev")))




