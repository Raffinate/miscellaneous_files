
;;; How to:

;;; Complete:
;;; Use "M-n" to activate complete menu
;;; Use "M-n" and "M-p" to select
;;; Use "tab" or "enter" to complete selection

;;; Snippets:
;;; Use "M-p" to activate snippet menu
;;; Use "M-n" and "M-p" to select
;;; Use "tab" or "enter" to complete selection



;;; Init file HowTo:
;;; Variable smmn-packages contains
;;; list of packages that should be loaded
;;; with package manager.
;;; Each package can be activated and set up with
;;; smmn-package-init function.
;;; You can setup emacs adding your custom functions to
;;; smmn-emacs-setup-functions list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Add your packages here ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst smmn-packages
  '(company ;complete any plugin
    company-c-headers ;complete headers
    yasnippet ;snippet plugin
    clean-aindent-mode ;clear emply lines from spaces
    dtrt-indent ;smart indent detector ;couldn't find what it does. =)
    smartparens
    slime
    slime-company
    company-auctex
    haskell-mode
    cider
    emacs-eclim
    ;company-ghc
    ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Add your emacs setup functions here ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst smmn-emacs-setup-functions
  '(smmn-no-startup
    smmn-autosave-setup
    smmn-default-key-maps
    smmn-disable-command-blocks
    smmn-default-tab-setup
    smmn-compile-setup
    smmn-qt-build-system-setup
    smmn-gdb-setup
    smmn-octave-setup
    smmn-sage-setup
    ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Place your init functions here ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun smmn-company-init ()
  "Setup complete any plugin"
  (require 'company)
  (add-hook 'after-init-hook 'global-company-mode)
  (delete 'company-semantic company-backends)
  (setq company-idle-delay nil) ;;Disable idle complete
  (define-key company-active-map (kbd "<tab>") 'company-complete)
  (global-set-key (kbd "M-n") 'company-complete))

(defun smmn-company-c-headers-init ()
  "Setup headers completion for company"
  (require 'company-c-headers)
  (add-to-list 'company-backends 'company-c-headers)
  (add-to-list 'company-c-headers-path-system
	       "/usr/lib/gcc/x86_64-pc-linux-gnu/4.8.3/include/g++-v4"))

(defun smmn-yasnippet-init ()
  "Setup snippets"
  (require 'yasnippet)
  (yas-global-mode 1)
  (global-set-key (kbd "M-p") 'company-yasnippet))

(defun smmn-clean-aindent-mode-init ()
  (require 'clean-aindent-mode)
  (add-hook 'prog-mode-hook 'clean-aindent-mode))

(defun smmn-dtrt-indent-init ()
  (require 'dtrt-indent)
  ;(setq dtrt-indent-verbosity 1)
  (add-hook 'prog-mode-hook 'dtrt-indent-mode))

(defun smmn-smartparens-init ()
  (require 'smartparens-config)
  (show-smartparens-global-mode +1)
  (smartparens-global-mode 1))

(defun smmn-slime-init ()
  (setq inferior-lisp-program "/home/summon/.summon_root/bin/ccl")
  (require 'slime-autoloads)
  (require 'slime-company)
  (slime-setup '(slime-fancy slime-asdf inferior-slime slime-company))
  (add-hook 'slime-mode-hook
	    (lambda () (unless (slime-connected-p)
			 (save-excursion (slime))))))

;; (defun smmn-slime-init () ;;without company
;;   ;(setq inferior-lisp-program "/home/summon/.summon_root/bin/sbcl")
;;   (setq inferior-lisp-program "/home/summon/.summon_root/bin/ccl")
;;   ;(add-to-list 'load-path "/home/summon/Develop/Tools/slime/slime-2013-04-05") 
;;   (require 'slime-autoloads)
;;   (slime-setup)

;;   (add-hook 'slime-mode-hook
;;           (lambda () (unless (slime-connected-p)
;;                        (save-excursion (slime)))))
;;   (add-hook 'slime-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "TAB") 'slime-indent-and-complete-symbol)))
;;   (add-hook 'comint-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "TAB") 'slime-indent-and-complete-symbol))))


(defun smmn-slime-company-init ())

(defun smmn-octave-setup ()
  (autoload 'octave-mode "octave-mod" nil t)
  (setq auto-mode-alist
        (cons '("\\.m$" . octave-mode) auto-mode-alist))

  (add-hook 'octave-mode-hook
            (lambda ()
              (abbrev-mode 1)
              (auto-fill-mode 1)
              (if (eq window-system 'x)
                  (font-lock-mode 1)))))

(defun smmn-company-auctex-init ()
  (require 'company-auctex)
  (company-auctex-init)
  )

(defun smmn-qml-mode-init ()
  (require 'qml-mode))

(defun smmn-haskell-mode-init ()
  (require 'haskell-mode))


(defun smmn-company-ghc-init ()
  (require 'haskell-mode)
  (autoload 'ghc-init "ghc" nil t)
  (autoload 'ghc-debug "ghc" nil t)
  (add-hook 'haskell-mode-hook (lambda () (ghc-init)))
  (add-to-list 'company-backends 'company-ghc))

(defun smmn-cider-init ()
  (require 'cider)
  (add-hook 'clojure-mode-hook #'cider-mode)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  )

(defun smmn-emacs-eclim-init ()
  (require 'eclim)
  (global-eclim-mode t)
  (custom-set-variables
   '(eclim-eclipse-dirs '("~/Develop/Tools/Eclipse/eclipse"))
   '(eclim-executable "~/Develop/Tools/Eclipse/eclipse/eclim"))
  (setq help-at-pt-display-when-idle t)
  (setq help-at-pt-timer-delay 0.1)
  (help-at-pt-set-timer)
  (delete 'company-eclim company-backends)
  (require 'company-emacs-eclim)
  (add-to-list 'company-backends 'company-emacs-eclim)
  ;(company-emacs-eclim-setup)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Place your emacs setup functions here ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun smmn-no-startup ()
  (setq inhibit-startup-message t))

(defun smmn-autosave-setup ()
  (defvar user-temporary-file-directory "~/.emacs.d/backups/")
  (make-directory user-temporary-file-directory t)
  (setq backup-by-copying t)
  (setq backup-directory-alist
	`(("." . ,user-temporary-file-directory)
	  (,tramp-file-name-regexp nil)))
  (setq auto-save-list-file-prefix
	(concat user-temporary-file-directory ".auto-saves-"))
  (setq auto-save-file-name-transforms
	`((".*" ,user-temporary-file-directory t)))
  (setq auto-save-timeout 15)
  (setq auto-save-default t)
  (setq auto-save-interval 50)
  (setq version-control t)
  (setq delete-old-versions t)
  (setq kept-new-versions 50))

(defun smmn-default-key-maps ()
  (define-key global-map (kbd "RET") 'newline-and-indent))

(defun smmn-disable-command-blocks ()
  (put 'downcase-region 'disabled nil)
  (put 'upcase-region 'disabled nil))

(defun smmn-default-tab-setup ()
  (add-hook 'prog-mode-hook (lambda () (interactive)
			      (setq show-trailing-whitespace 1)))
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (setq-default c-basic-offset 4))

(defun smmn-compile-setup ()
  (global-set-key (kbd "<f5>") (lambda ()
				 (interactive)
				 (setq-local compilation-read-command t)
				 (call-interactively 'compile))))

(defun smmn-qt-build-system-setup ()
  (add-to-list 'auto-mode-alist '("\\.qbs\\'" . js-mode)))

(defun smmn-gdb-setup ()
  (setq gdb-many-windows t)
  (setq gdb-show-main t))

(defun smmn-sage-setup ()
  (add-to-list 'load-path
               "/home/summon/Develop/OpenSource/sage/sage-6.2/local/share/emacs/site-lisp/sage-mode")
(require 'sage "sage")
(setq sage-command "/home/summon/Develop/OpenSource/sage/sage-6.2/sage")
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; internal functions ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(defun smmn-install-packages ()
  "Install required packages"
  (interactive)
  (unless package-archive-contents
    (package-refresh-contents))
  (dolist (package smmn-packages)
    (unless (package-installed-p package)
      (package-install package))))

(defun smmn-setup-packages ()
  "Setup installed packages"
  (dolist (package smmn-packages)
    (let ((init-func (intern-soft
		      (concat "smmn-" (symbol-name package) "-init"))))
      (if init-func
	  (funcall init-func)
	(warn "Package \"%s\" has no init function." (symbol-name package))))))

(defun smmn-setup-emacs ()
  (dolist (f smmn-emacs-setup-functions)
    (funcall f)))

(smmn-install-packages)
(smmn-setup-packages)
(smmn-setup-emacs)
;;;;;;;;;;;;;;;;;;;;;;;;;
