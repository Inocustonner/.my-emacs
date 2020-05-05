;; ido mode https://www.masteringemacs.org/article/introduction-to-ido-mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; autopair https://github.com/joaotavora/autopair
(add-to-list `load-path "~/.emacs.d/lisp/autopair")
(require `autopair)
(autopair-global-mode)
(setq autopair-autowrap t)
(show-paren-mode)
(global-hi-lock-mode 1)
;; clear whitespaces
;; (require `ws-butler)
(add-hook 'c-mode-common-hook 'ws-butler-mode)

 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.

;; turn off beep sound
(setq visible-bell 1)

;; ---------------- font -----------------
(setq font-to-use "Inconsolata-12")

;; --------------- undo bind ---------------
(global-set-key (kbd "C-z") `undo)

;; ------------- MELPA -------------
;; melpa https://melpa.org/#/getting-started
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )
(package-initialize)
(add-to-list 'package-archives
             ;; '("melpa-stable" . "https://stable.melpa.org/packages/")
						 `("melpa" . "httpd://melpa.milkbox.net/packages/")
						 t)

(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

;; HELM============================================================================
(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "C-t") nil) ;undef -> rebind
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

(add-hook 'helm-mode (lambda ()
											 (define-key helm-gtags-mode-map (kbd "C-t") nil)))
(global-set-key (kbd "C-t") 'transpose-chars) ;rebind
;; HELM============================================================================

;; SMOOTHSCROLLING=================================================================
(require 'smooth-scrolling)
(setq smooth-scroll-margin 2)
;; SMOOTHSCROLLING=================================================================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
	 (quote
		(smooth-scrolling helm-gtags ws-butler haskell-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; ------------- MELPA -------------
;; autoreloading
(global-auto-revert-mode t)

;; autosaving in tmps
;; helps to avoid pollution of the working directory with ~* and #*# files
(setq create-lockfiles nil)
(defvar user-temporary-file-directory "~/.emacs.d/.emacs.d/tmps")
(setq auto-save-list-file-prefix user-temporary-file-directory)
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

;; backup settings
;; for the same reason as above
(setq backup-directory-alist `(("." . "~/.emacs.d/.saves")))
(setq backup-by-copying-when-linked t)

(defconst emacs-tmp-dir "~/.emacs.d/tmps")

(setq auto-save-file-name-transforms
          `((".*" , emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
	  emacs-tmp-dir)

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; no splash screen
(setq inhibit-startup-message t)

;; Column number
(setq column-number-mode t)

;; custom indetation
(setq-default tab-width 2)
(setq-default tab-always-indent t)

;; Shift the selected region right if distance is postive, left if
;; negative

(defun my-select-line ()
  "Select current line."
  (interactive)
  (let (p1 p2)
    (setq p1 (line-beginning-position))
    (setq p2 (line-end-position))
    (goto-char p1)
    (push-mark p2)
    (setq mark-active t)))

(defun shift-region (distance)
  (let ((mark (mark)) (deact_mark nil))
		(save-excursion
			(when (and (not mark-active) (> 0 distance))
				(my-select-line)
				(setq deact_mark t))

			(let ((end (+ 1 (region-end))))
				(goto-char (region-beginning))
				(move-beginning-of-line 1)
				(indent-rigidly (point) end distance))
			(setq deactivate-mark deact_mark))))

(defun shift-right ()
  (interactive)
  (if mark-active
	  (shift-region tab-width)
	  (tab-to-tab-stop)))

(defun shift-left ()
  (interactive)
  (shift-region (- tab-width)))

(global-set-key (kbd "TAB") `shift-right)
(global-set-key (kbd "<backtab>") `shift-left)

;; enable highliting and higlight current line
(global-hl-line-mode 1)
(set-face-attribute hl-line-face nil :background "#4F4F4F")

;; enter global font lock mode
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;;--------------- theme -----------------
;; (set-face-attribute `default nil :foreground "#DCDCCC")
;; (set-face-attribute `default nil :background "#3F3F3F")
(set-face-attribute `default nil :font font-to-use :foreground "#DCDCCC" :background "#3F3F3F")
(set-face-attribute `font-lock-keyword-face nil :foreground "#DFAF8F")
(set-face-attribute `font-lock-variable-name-face nil :foreground "#DCDCCC")
(set-face-attribute `font-lock-type-face nil :foreground "#EDD686") ;e89393 f0dfaf
(set-face-attribute `font-lock-function-name-face nil :foreground "#DCDCCC")
(set-face-attribute `font-lock-preprocessor-face nil :foreground "#777777")
;; (set-face-attribute `font-lock-type-face nil :foreground "#DCDCCC")
(set-face-attribute `font-lock-comment-face nil :foreground "#696969")
;; (set-face-attribute `font-lock-constant-face nil :foreground "#DCA3A3")
(set-face-attribute `font-lock-constant-face nil :foreground "#DCDCCC")
(set-face-attribute `show-paren-match nil :inherit `default :background "#707070")
(set-face-attribute `show-paren-mismatch nil :inherit `show-paren-match :weight `bold)
;; src https://stackoverflow.com/questions/8860050/emacs-c-mode-how-do-you-syntax-highlight-hex-numbers
(defun highlight-numbers-in-c()
(font-lock-add-keywords nil '(
							  

        ; Valid hex number (will highlight invalid suffix though)
        ("\\b0x[[:xdigit:]]+[uUlL]*\\b" . font-lock-string-face)

        ; Valid floating point number.
        ("\\(\\b[0-9]+\\|\\)\\(\\.\\)\\([0-9]+\\(e[-]?[0-9]+\\)?\\([lL]?\\|[dD]?[fF]?\\)\\)\\b" (1 font-lock-string-face) (3 font-lock-string-face))

        ; Valid decimal number.  Must be before octal regexes otherwise 0 and 0l
        ; will be highlighted as errors.  Will highlight invalid suffix though.
        ("\\b\\(\\(0\\|[1-9][0-9]*\\)[uUlL]*\\)\\b" 1 font-lock-string-face)

        ; Valid octal number
        ("\\b0[0-7]+[uUlL]*\\b" . font-lock-string-face)

        ; Floating point number with no digits after the period.  This must be
        ; after the invalid numbers, otherwise it will "steal" some invalid
        ; numbers and highlight them as valid.
        ("\\b\\([0-9]+\\)\\." (1 font-lock-string-face))
		)))

;; define my custom faces
;; http://stackoverflow.com/a/12934513
(defun --copy-face (new-face face)
  "Define NEW-FACE from existing FACE."
  (copy-face face new-face)
  (eval `(defvar ,new-face nil))
  (set new-face new-face))

(--copy-face 'my-font-lock-constant-face 'font-lock-constant-face)
(set-face-attribute 'my-font-lock-constant-face nil :foreground "#DCA3A3")

;; remove black fringes
(set-fringe-mode `(0 . 0))

;; a bit of my syntax highliting
;; (defun my/add-syntax-highliting ()
;;   (font-lock-add-keywords nil '(
								
;; 								("\\bstatic_assert" . font-lock-keyword-face)
;; 								)))

;;deletion on BACKSPACE or DEL, not killing
(defun my-delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (delete-region
   (point)
   (progn
     (forward-word arg)
     (point))))

(defun my-backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (my-delete-word (- arg)))

(defun my-delete-line ()
  "Delete text from current position to end of line char.
This command does not push text to `kill-ring'."
  (interactive)
  (delete-region
   (point)
   (progn (end-of-line 1) (point)))
  (delete-char 1))

(defun my-delete-line-backward ()
  "Delete text between the beginning of the line to the cursor position.
This command does not push text to `kill-ring'."
  (interactive)
  (let (p1 p2)
    (setq p1 (point))
    (beginning-of-line 1)
    (setq p2 (point))
    (delete-region p1 p2)))

(global-set-key (kbd "M-d") `my-delete-word)
(global-set-key (kbd "M-DEL") `my-backward-delete-word)

(defun my-kill-whole-line ()
  "Delete current line"
  (interactive)
  (back-to-indentation)
  (unless (eq (following-char) ?\n);; if this is an empty line
    (kill-line)
    (my-delete-line-backward))
  (delete-char -1)
  (next-line))

;; (global-set-key (kbd "C-S-k") `my-kill-whole-line)

(defun my-cut ()
	"Cut selection if mark set else line"
	(interactive)
	(if mark-active
		(kill-region (region-beginning) (region-end))
		(my-kill-whole-line)))

(global-set-key (kbd "C-w") `my-cut)


;;C/C++	
(defun my/cc-mode-common-hook()
  ;; Customization for all CC modes
  (require 'cc-mode)
    
  (setq-default tab-width 4)
  (setq c-basic-offset 4)
  ;; ENUM FIX
  (c-set-offset `brace-list-intro `+)
  (c-set-offset `brace-list-open 0)
  ;;(c-set-offset `brace-list-open +)
  (c-set-offset `substatement-open 0)
  ;;(c-set-offset `substatement-open +)
  (c-set-offset `case-label `+)
	;;(c-set-offset `case-label 0)
  (c-set-offset `statement-case-open 0)
  ;;(c-set-offset `case-statement-open +)
  (c-set-offset `statement-cont 0)
  (c-set-offset `statement-cont `+)
  
  (c-set-offset `arglist-intro `+)
  (c-set-offset `arglist-close `+)
  (c-set-offset `arglist-cont 0)
  (c-set-offset `arglist-cont-nonempty `+)

  (highlight-numbers-in-c)
  ;;add binding for space erasing  
  (global-set-key (kbd "C-<Backspace>") `c-hungry-delete-backwards)          
  
  ;;(highlight-regexp "\/\/@.*" `my/cc-todo-comments-face)

  ;; (my/add-syntax-highliting)
  ;; (font-lock-add-keywords nil '(
  ;; 								("\\bstatic_assert" . font-lock-keyword-face)
  ;; 								("\\<\\(true\\|false\\)\\>" . my-font-lock-constant-face))
  (font-lock-add-keywords nil `(
								("\\<\\(true\\|false\\|nullptr\\)\\>"
								 . my-font-lock-constant-face)
;; doesn't work for some reason ("\\bstatic_assert" . font-lock-keyword-face)
								))
	(ws-butler-mode)
  (message "cc-mode")
 )

(add-hook `c-mode-common-hook `my/cc-mode-common-hook)

(defun my/js-mode-hook()
	(font-lock-add-keywords nil `(
							("\\<\\(of\\)\\>"
							 . font-lock-keyword-face)))
  (font-lock-add-keywords nil `(
								("\\<\\(true\\|false\\|undefined\\)\\>"
								 . my-font-lock-constant-face)))
	(setq tab-width 4))

(add-hook `js-mode-hook `my/js-mode-hook)

(defun my/py-hook ()
  (setq tab-width 4)
  (setq python-indent-offset 4)
	(define-key python-mode-map (kbd "<backtab>") `shift-left))
(add-hook `python-mode-hook `my/py-hook)

(defun my/elisp-hook ()
	(setq tab-width 2))

(add-hook 'emacs-lisp-mode-hook 'my/elisp-hook)

(defun haskell-setup ()
  "Setup variables for editing Haskell files."
	(setq tab-width 2)
  (setq whitespace-line-column 70)
  (make-local-variable 'tab-stop-list)
  (setq tab-stop-list (number-sequence tab-width 80 tab-width))
  (haskell-indentation-mode 0)
  (setq indent-line-function 'indent-relative))

(add-hook 'haskell-mode-hook 'haskell-setup)

(message "loaded")
