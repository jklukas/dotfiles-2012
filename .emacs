;;;; load packages
(add-to-list 'load-path (expand-file-name "~/.emacs.d"))

;; load python-mode
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; setup scons
(setq auto-mode-alist
      (cons '("SConstruct" . python-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("SConscript" . python-mode) auto-mode-alist))

;; load package for reStructuredText
(require 'rst)
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))

;; other filetypes
(setq auto-mode-alist
      (append '(("\\.scss$" . css-mode)
                ("\\.sass$" . css-mode)) auto-mode-alist))

;; various
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-compression-mode t nil (jka-compr))
 '(case-fold-search t)
 '(current-language-environment "English")
 '(global-font-lock-mode t nil (font-lock))
 '(inhibit-startup-screen t)
 '(show-paren-mode t nil (paren)))

;; set key bindings
(global-set-key "\r" 'newline) 
(global-set-key (kbd "C-c #") 'comment-region)
(setq mac-option-modifier 'meta)

;; display the column number as well as the line number
(setq column-number-mode t)
;; If not using default Emacs on Mac (22.1.1), toggle toolbar off
(if (not (equal emacs-minor-version 1)) (tool-bar-mode 0))
;; Insert spaces instead of tab character when tab is pressed
(setq-default indent-tabs-mode nil)

;; Function to easily browse fonts on a Mac
(defun jfb-set-mac-font (name  size)
  (interactive
   (list (completing-read "font-name: " (mapcar (lambda (n) (list n n)) (mapcar (lambda (p) (car p)) (x-font-family-list))) nil t) 
         (read-number "size: " 12)))
  (set-face-attribute 'default nil 
                      :family name
                      :slant  'normal
                      :weight 'normal
                      :width  'normal
                      :height (* 10 size)))

;; If on a Mac
(if (equal system-type 'darwin)
    (progn                           ; execute each argument
     (jfb-set-mac-font "menlo" 10)   ; use 10-pt Menlo
     (auto-fill-mode -1)             ; stop inserting line breaks!
     (remove-hook 'text-mode-hook 'smart-spacing-mode) ; do not use smart spacing in text modes
     ;; (add-to-list 'LaTeX-command-style
     ;;         '("\\`fontspec\\'" "xelatex %S%(PDFout)")) ; add XeLaTeX in AucTex
     ;; fix annoying Aquamacs settings
     (if (boundp 'aquamacs-version)
         (progn
           (remove-hook 'text-mode-hook 'auto-detect-wrap) ; don't insert linebreaks!
           (aquamacs-autoface-mode -1)     ; no mode-specific faces
           (global-smart-spacing-mode -1)  ; not on by default
           (define-key osx-key-mode-map (kbd "C-<right>") 'forward-word)
           (define-key osx-key-mode-map (kbd "C-<left>") 'backward-word)
           (define-key osx-key-mode-map (kbd "C-c #") 'comment-region)
           ;; (osx-key-mode -1)  ; no Mac-specific key bindings
     ))
))
