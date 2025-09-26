(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil)
  :config
  (evil-mode 1))
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))


(use-package general
  :ensure t
  :config
  (general-create-definer my/leader-keys
    :keymaps '(normal visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package magit
  :commands (magit-status)
  :general
  (my/leader-keys
    "g"  '(:ignore t :which-key "git")
    "gs" '(magit-status :which-key "status")))

(setq org-directory "~/org/")
(setq org-default-notes-file (expand-file-name "todo.org" org-directory))

(use-package org
  :straight (:type built-in) ;; org is built into Emacs
  :hook (org-mode . visual-line-mode)
  :config
  (setq org-hide-emphasis-markers t
        org-startup-indented t
        org-ellipsis " ▾"
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 2
        org-log-done 'time
        org-log-into-drawer t)
  :general
  (my/leader-keys
    "x" '(org-capture :which-key "capture")
    "a" '(org-agenda :which-key "agenda"))
  )

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  :config
  (org-roam-db-autosync-mode)

  ;; Load org-roam-dailies from within org-roam
  (require 'org-roam-dailies)

  ;; Configure dailies
  (setq org-roam-dailies-directory "daily/")
  (setq org-roam-dailies-capture-templates
        '(("j" "Journal"
           entry
           "* %<%H:%M> %?"
           :if-new (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n"))))
  :general
  (my/leader-keys
    "n"  '(:ignore t :which-key "notes")
    "nt"  '(org-roam-dailies-goto-today :which-key "today")
    "nd"  '(org-roam-dailies-find-date :which-key "date")
    "nr"  '(:ignore t :which-key "roam")
    "nri"  '(org-roam-node-insert :which-key "insert node")
    "nrf" '(org-roam-node-find :which-key "find node"))
  )

(setq visible-bell t)

(setq org-capture-templates
      '(("t" "Task" entry
         (file+headline "~/org/todo.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry
         (function org-roam-dailies-capture-today)
         "* %<%H:%M> %?\n")))
(use-package auctex
  :ensure t
  :defer t)

(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install))
(setq TeX-view-program-selection '((output-pdf "PDF Tools")))
(setq TeX-command-default "LatexMk")
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (add-to-list 'TeX-command-list
                         '("LatexMk" "latexmk -pdf %s" TeX-run-TeX nil t))))
(use-package citar
  :straight t
  :custom
  ;;(citar-bibliography '("~/path/to/your.bib")) ; <-- adjust this path
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  :hook
  ((org-mode LaTeX-mode) . citar-capf-setup)) ; enables completion-at-point
;; Vertico: vertical completion UI
(use-package vertico
  :straight t
  :init (vertico-mode))

;; Orderless: fuzzy matching
(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; Marginalia: metadata in minibuffer
(use-package marginalia
  :straight t
  :init (marginalia-mode))

;; Embark: contextual actions
(use-package embark
  :straight t
  :bind
  (("C-." . embark-act)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))
(use-package lsp-mode
  :straight t
  :hook ((python-mode . lsp)
         (rust-mode . lsp)
         (c++-mode . lsp)
         (latex-mode . lsp)) ;; optional, if you use LSP for LaTeX
  :commands lsp
  :custom
  (lsp-enable-snippet t)
  (lsp-headerline-breadcrumb-enable t))

(use-package lsp-ui
  :straight t
  :commands lsp-ui-mode)

(use-package company
  :straight t
  :hook (prog-mode . company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))
(defun my/citar-set-project-bib ()
  "Set `citar-bibliography` to .bib files in the current project."
  (when-let* ((project (project-current))
              (root (project-root project))
              (bib-files (directory-files-recursively root "\\.bib$")))
    (setq-local citar-bibliography bib-files)))

(add-hook 'LaTeX-mode-hook #'my/citar-set-project-bib)
(add-hook 'org-mode-hook #'my/citar-set-project-bib)
