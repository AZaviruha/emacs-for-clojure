;; This is where your customizations should live

;; env PATH
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))


;(setq initial-frame-alist '((top . 0) (left . 0) (width . 160) (height . 40)))


;; Place downloaded elisp files in this directory. You'll then be able
;; to load them.
(add-to-list 'load-path "~/.emacs.d/vendor")

;; shell scripts
(setq-default sh-basic-offset 2)
(setq-default sh-indentation 2)

;; Themes
;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;(add-to-list 'load-path "~/.emacs.d/themes")
;; Uncomment this to increase font size
;; (set-face-attribute 'default nil :height 140)
;(load-theme 'tomorrow-night-bright t)

;; Flyspell often slows down editing so it's turned off
(remove-hook 'text-mode-hook 'turn-on-flyspell)

(load "~/.emacs.d/vendor/clojure")

;; hippie expand - don't try to complete with file names
(setq hippie-expand-try-functions-list (delete 'try-complete-file-name hippie-expand-try-functions-list))
(setq hippie-expand-try-functions-list (delete 'try-complete-file-name-partially hippie-expand-try-functions-list))

(setq ido-use-filename-at-point nil)

;; Save here instead of littering current directory with emacs backup files
(setq backup-directory-alist `(("." . "~/.saves")))

(require 'pomodoro) 
(pomodoro-add-to-mode-line)

; ============================================================================= ;
; ================================= EMACS AS PLANNER ========================== ;
; ============================================================================= ;
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

; ============================================================================= ;
; ================================= EMACS AS PLAYER =========================== ;
; ============================================================================= ;
(setq exec-path (append exec-path '("c:/usr/soft/mplayer-svn-37242")))
(require 'emms-setup)
(require 'emms-player-mplayer)
(emms-standard)
(emms-default-players)
(define-emms-simple-player mplayer '(file url)
      (regexp-opt '(".ogg" ".mp3" ".wav" ".mpg" ".mpeg" ".wmv" ".wma"
                    ".mov" ".avi" ".divx" ".ogm" ".asf" ".mkv" "http://" "mms://"
                    ".rm" ".rmvb" ".mp4" ".flac" ".vob" ".m4a" ".flv" ".ogv" ".pls"))
      "mplayer" "-slave" "-quiet" "-really-quiet" "-fullscreen")
(setq emms-source-file-default-directory "c:/Users/azaviruha/Downloads/music")


; ============================================================================= ;
; ================================= EMACS AS IDE ============================== ;
; ============================================================================= ;

(global-linum-mode 1)
(add-hook 'after-init-hook #'global-flycheck-mode)


; ================================ ;
; ========== VIM ================= ;
; ================================ ;
;; (global-set-key "\C-w" 'clipboard-kill-region)
;; (global-set-key "\M-w" 'clipboard-kill-ring-save)
;; (global-set-key "\C-y" 'clipboard-yank)

(global-set-key [(shift delete)] 'clipboard-kill-region)
(global-set-key [(control insert)] 'clipboard-kill-ring-save)
(global-set-key [(shift insert)] 'clipboard-yank)

; NerdCommenter
(require 'evil-nerd-commenter)
(evilnc-default-hotkeys)

(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader ",")

(require 'evil)
(evil-mode 1)

; NerdTree
(require 'neotree)

; ================================ ;
; ========== Markup ============== ;
; ================================ ;
; Web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 4) )

(add-hook 'web-mode-hook 'my-web-mode-hook)


; Emmet
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

; ================================ ;
; ========== JavaScript ========== ;
; ================================ ;
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-mode))

; JSHint
(require 'flycheck)
(add-hook 'js-mode-hook (lambda () (flycheck-mode t)))

; Tern
(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))


;;-------------- flycheck-jscs ---------------------
(add-hook 'js2-mode-hook
          (lambda ()
            (tern-mode t)
            (setq flycheck-check-syntax-automatically '(save mode-enabled))))

(flycheck-def-config-file-var flycheck-jscs javascript-jscs ".jscs.json"
  :safe #'stringp)

(flycheck-define-checker javascript-jscs
  "A JavaScript code style checker.
See URL `https://github.com/mdevils/node-jscs'."
  :command ("jscs" "--reporter" "checkstyle"
            "--preset=airbnb"
            ;;(config-file "--config" flycheck-jscs)
            source)
  :error-parser flycheck-parse-checkstyle
  :modes (js-mode js2-mode js3-mode)
  :next-checkers (javascript-jshint))

(add-to-list 'flycheck-checkers 'javascript-jscs)
;;-------------- flycheck-jscs ---------------------


; Auto-complete mode
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

; REPL
(require 'js-comint)
;; Use node as our repl
(setq inferior-js-program-command "node --interactive")


;; Line up
(defun align-to-equals (begin end)
  "Align region to equal signs"
   (interactive "r")
   (align-regexp begin end "\\(\\s-*\\)=" 1 1 ))

(global-set-key "\C-c\C-b" 'align-to-equals)

(defun align-to-colon (begin end)
  "Align region to equal signs"
   (interactive "r")
   (align-regexp begin end "\\(\\s-*\\)\\:" 1 1 )
   (align-regexp begin end "\\:\\(\\s-*\\)" 1 1 ))

(global-set-key "\C-c\C-v" 'align-to-colon)


; ================================ ;
; ========== Haskell ============= ;
; ================================ ;
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

(custom-set-variables
  '(haskell-process-suggest-remove-import-lines t)
  '(haskell-process-auto-import-loaded-modules t)
  '(haskell-process-log t))

(define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
(define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
(define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
(define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
(define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
(define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)
(define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)


; ================================ ;
; ========== Gherkin ============= ;
; ================================ ;
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\\.feature\\'" . feature-mode))


; ================================ ;
; ========== Clojure ============= ;
; ================================ ;
;; (require 'clj-refactor)
;; (add-hook 'clojure-mode-hook (lambda ()
;;                                (clj-refactor-mode 1)
;;                                ;; insert keybinding setup here
;;                                ))
;(add-hook 'cider-mode-hook #'eldoc-mode)
;; (define-key cider-mode-map (kbd "M-.") 'cider-jump)
(define-key evil-insert-state-map (kbd "M-.") 'cider-jump)
(define-key evil-motion-state-map (kbd "M-.") 'cider-jump)
(define-key evil-normal-state-map (kbd "M-.") 'cider-jump)
;; (define-key cider-mode-map (kbd "C-c M-.") 'cider-jump-to-resource)

