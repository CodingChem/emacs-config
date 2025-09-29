(setq package-enable-at-startup nil)
(setq package-quickstart nil)
(setq straight-check-for-modifications nil)
(fmakunbound 'package-initialize)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(defun my/org-auto-tangle-on-save ()
  "Automatically tangle Org file on save if it has code blocks."
  (when (and (string-equal (buffer-file-name)
                           (expand-file-name "~/.emacs.d/README.org"))
             (derived-mode-p 'org-mode))
    (org-babel-tangle)))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'my/org-auto-tangle-on-save
  		    nil 'make-it-local)))
