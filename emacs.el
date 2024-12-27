(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)


(add-to-list 'default-frame-alist '(font . "Mononoki Nerd Font"))

(setq-default inhibit-splash-screen 1)
(setq shell-file-name "/bin/sh"
      explicit-shell-file-name "~/.nix-profile/bin/nu" )


(setq scroll-step 1
      scroll-conservatively 10000)


;;(use-package evil
  ;;:ensure t
;;  :init
;;  (setq evil-want-keybinding nil)
;;  :config
;;  (evil-mode 1))
;;(use-package evil-collection
;;  :ensure 
;;  :after evil
;;  :config
;;  (evil-collection-init))


(use-package catppuccin-theme
  :ensure t
  :init
  (setq catppuccin-theme 'mocha)
  (load-theme 'catppuccin :no-confirm))

(use-package treesit-auto
  :ensure t
  :config)

(use-package nix-mode
  :ensure t
  :defer t)

(use-package magit
  :ensure t
  :defer t)
(use-package rust-mode
  :ensure t
  :defer t
  :init
  (setq rust-mode-treesitter-derive t)
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode)))

(use-package cargo-mode
  :ensure t
  :defer t
  :after rust-mode)

(use-package auctex
  :ensure t
  :defer t
  :custom
  (TeX-electric-math (cons "$" "$"))
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
  :defer t)

(use-package vterm
  :ensure t
  :config
  (setq vterm-shell "/home/xenia/.nix-profile/bin/nu" ))

(use-package org-superstar
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1))

(use-package counsel
  :ensure t
  :config
  (counsel-mode 1))


(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") `projectile-command-map)
  (projectile-mode 1)
  )





