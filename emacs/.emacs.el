;; OS��Ƚ�̡�UNIX�ϡ�
(defvar run-unix
  (or (equal system-type 'gnu/linux)
      (or (equal system-type 'usg-unix-v)
          (or  (equal system-type 'berkeley-unix)
               (equal system-type 'cygwin)))))
; OS��Ƚ�̡�����Ƚ��
(defvar run-linux
  (equal system-type 'gnu/linux))
(defvar run-system-v
  (equal system-type 'usg-unix-v)); OpenSolaris2090.06
(defvar run-bsd
  (equal system-type 'berkeley-unix))
(defvar run-cygwin ;; cygwin��unix���롼�פˤ��Ƥ���
  (equal system-type 'cygwin))

(defvar run-w32
  (and (null run-unix)
       (or (equal system-type 'windows-nt)
           (equal system-type 'ms-dos))))
(defvar run-darwin (equal system-type 'darwin))
;;for Ubuntu setting
(when run-linux
  (setq load-path (append '("~/.emacs.d/site-lisp/"
                            "~/.emacs.d/site-elisp/"
							"~/.emacs.d/elisp/"
							"/usr/local/share/gtags/"
                            )
                            load-path))
  ;;Ubuntu����apt-get����Elisp�Ϥ������֤����
  (let ((default-directory "/usr/share/emacs/site-lisp/"))
    (normal-top-level-add-subdirs-to-load-path))
)
;;for OSX setting
(when run-darwin
  (add-to-list 'load-path "~/.emacs.d/site-elisp/")
  (add-to-list 'load-path "~/.emacs.d/apel/")
  (add-to-list 'load-path "~/.emacs.d/"))
;;for Ubuntu setting
(when run-linux
  (load-file "~/.emacs.d/cedet/common/cedet.el")
  (require 'semantic-gcc)
  ;;(global-ede-mode t)
  (require 'semanticdb)
  ;; if you want to enable support for gnu global
  (when (cedet-gnu-global-version-check t)
    (require 'semanticdb-global)
    (semanticdb-enable-gnu-global-databases 'c-mode)
    (semanticdb-enable-gnu-global-databases 'c++-mode))
  (defun my-semantic-hook ()
    ;;for linux Kernel Reading (x86)
    (semantic-add-system-include "/media/Data/Kernel/linux-3.4.4/include" 'c-mode)
    (semantic-add-system-include "/media/Data/Kernel/linux-3.4.4/arch/x86/include" 'c-mode)
    ;;for BSD Kernel Reading
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/bhyve_inc/lib/libvmmapi" 'c-mode)
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/bhyve_inc/sys/amd64/vmm" 'c-mode)
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/9.0.0/sys/" 'c-mode)
	;;for boost library
	(semantic-add-system-include "/media/Data/libboost_1_49_0/include" 'c++-mode)

	;;�ؿ���̾���������Υ��������٤�imenu���ɲ�
    (imenu-add-to-menubar "cedet-TAGS")
  )
  (semantic-load-enable-gaudy-code-helpers)
  ;;����¾�������ꤹ���
  (add-hook 'semantic-init-hooks 'my-semantic-hook)
  (add-hook 'c++-mode-common-hook 'my-c++-mode-cedet-hook)
  
  (defun my-cedet-hook ()
    (local-set-key [(control return)] 'semantic-ia-complete-symbol) 
    ;(local-set-key "." 'semantic-complete-self-insert)
    ;(local-set-key ">" 'semantic-complete-self-insert)
    (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
    (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
    (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
    (local-set-key "\C-xp" 'eassist-switch-h-cpp)
    (local-set-key "\C-xe" 'eassist-list-methods)
	;;����ܥ�λ��Ȥ򸡺�
    (local-set-key "\C-c/" 'semantic-symref)
	;;insert get/set methoid pair inc class field
    (local-set-key "\C-cgs" 'srecode-insert-getset)
	;;�����ȤΤҤʷ�������
	(local-set-key "\C-ci" 'srecode-document-insert-comment)
  )
  (add-hook 'c-mode-common-hook 'my-cedet-hook)
  (add-hook 'c++-mode-common-hook 'my-cedet-hook)
  (setq qt4-base-dir "/usr/include/qt4")
  (semantic-add-system-include qt4-base-dir 'c++-mode)
  (add-to-list 'auto-mode-alist (cons qt4-base-dir 'c++-mode))
  (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig.h"))
  (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-dist.h"))
  (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qglobal.h"))
  (setq semantic-default-submodes 
    '(
       global-semantic-idle-scheduler-mode 
       global-semantic-idle-completions-mode
       global-semanticdb-minor-mode
       global-semantic-decoration-mode
       global-semantic-highlight-func-mode
       global-semantic-stickyfunc-mode
       global-semantic-mru-bookmark-mode
	)))
(require 'auto-complete)
(require 'auto-complete-config)    ; ɬ�ܤǤϤʤ��Ǥ������
;�䴰��auto-complete�����뤫���פ�ʤ�����
;(define-key global-map "\C-c\C-i" 'dabbrev-expand)   
;; dirty fix for having AC everywhere
(define-globalized-minor-mode real-global-auto-complete-mode
  auto-complete-mode (lambda ()
                       (if (not (minibufferp (current-buffer)))
                         (auto-complete-mode 1))
                       ))
(when run-linux
  (require 'auto-complete-etags)) 
;;�䴰�����C-n/C-p�Ǥ�����Ǥ���褦��
;;Vimmer�ˤϴ򤷤����⡣
(add-hook 'auto-complete-mode-hook
          (lambda ()
            (define-key ac-completing-map (kbd "C-n") 'ac-next)
            (define-key ac-completing-map (kbd "C-p") 'ac-previous)))
(real-global-auto-complete-mode t)
;;twmode
(when run-darwin
  (add-to-list 'exec-path "/opt/local/bin"))
(autoload 'twittering-mode "twittering-mode" "Emacs twitter client." t)
(setq twittering-icon-mode t)
(setq twittering-use-master-password t)
(setq twittering-update-status-function 'twittering-update-status-from-pop-up-buffer)
(setq twittering-convert-fix-size 48)
(setq twittering-timer-interval 90)
(setq twittering-initial-timeline-spec-string
      '(":favorites"
        ":direct_messages"
        ":replies"
        ":home"))
 (add-hook 'twittering-mode-hook
           (lambda ()
             (mapc (lambda (pair)
                     (let ((key (car pair))
                           (func (cdr pair)))
                       (define-key twittering-mode-map
                         (read-kbd-macro key) func)))
                   '(("T" . twittering-friends-timeline)
                     ("R" . twittering-replies-timeline)
                     ("U" . twittering-user-timeline)
                     ("W" . twittering-update-status-interactive)
					 ("F". twittering-favorite )))))
;; ���ֹ�ɽ��
(require 'linum)
(global-linum-mode t)
(when run-linux
  (require 'anything)
  (require 'anything-config)
  (add-to-list 'anything-sources 'anything-c-source-emacs-commands)
  (define-key global-map (kbd "C-x b") 'anything)
  (autoload 'gtags-mode "gtags" "" t))

; twmode ��̵���ˤ���
(defadvice linum-on(around my-linum-twmode-on() activate)
  (unless (eq major-mode 'twittering-mode) ad-do-it))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;verify file mode section
;;--------------------------------------------------------------------------
;;such as ... 
;;C,C++,C#,Ruby,Obj-C,Haskell,CUDA,Python,Fortran,org-mode,lua,go,rust,perl,D
;;and so on.
;;--------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;org-mode
(autoload 'org "org" "md-lang" t)
(autoload 'org-install "org-mode" "md lang" t)
(add-hook 'org-mode-hook 'turn-on-visual-line-mode)
(setq org-startup-truncated nil)	; �ե�������ޤ��������֤ǳ���
(setq org-return-follows-link t)	; return �ǥ�󥯤��ɤ�
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode)) 	; *.org �� org-mode�ǳ���
(setq org-directory "/media/Data/Document/org-memo/")
;;Haskell-mode
(load-library "haskell-site-file")
(setq auto-mode-alist
  (append auto-mode-alist
    '(("\\.[hg]s$"  . haskell-mode)
      ("\\.hi$"     . haskell-mode)
      ("\\.l[hg]s$" . literate-haskell-mode))))
(autoload 'haskell-mode "haskell-mode"
          "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
          "Major mode for editing literate Haskell scripts." t)
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)(flymake-mode)))
(add-hook 'haskell-mode-hook 'turn-on-haskell-font-lock)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-hugs) ; Hugs��
(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)  
;#!/usr/bin/env runghc ��
(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode)) 
;#!/usr/bin/env runhaskell ��
;(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode))
;;for obj-c
(setq auto-mode-alist
(append '(("\\.h$" . objc-mode)
("\\.m$" . objc-mode))))
;;org-mode for tex
(setq org-export-latex-coding-system 'utf-8)
(setq org-export-latex-date-format "%Y-%m-%d")
;;for c
;;; C-mode,C++-mode������
(defconst my-c-style
  '(
    ;; ���ܥ��ե��å��̤�����
    (c-basic-offset             . 2)
    ;; tab �����ǥ���ǥ�Ȥ�¹�
    (c-tab-always-indent        . t)
    ;; �����ȹԤΥ��ե��å��̤�����
    (c-comment-only-line-offset . 0)
    ;; ���å�����μ�ư���Խ���������
    (c-hanging-braces-alist
     . (
        (class-open after)       ; ���饹�����'{'�θ�
        (class-close nil)            ; ���饹�����'}'�θ�
        (defun-open before after)       ; �ؿ������'{'������
        (defun-close after)             ; �ؿ������'}'�θ�
        (inline-open after)             ; ���饹��Υ���饤��
                                        ; �ؿ������'{'�θ�
        (inline-close after)            ; ���饹��Υ���饤��
                                        ; �ؿ������'}'�θ�
        (brace-list-close after) ; ��󷿡����������'}'�θ�
        (block-open after)              ; ���ơ��ȥ��Ȥ�'{'�θ�
        (block-close after)             ; ���ơ��ȥ��Ȥ�'}'����
        (substatement-open after)       ; ���֥��ơ��ȥ���
                                        ; (if ʸ��)��'{'�θ�
        (statement-case-open after)     ; case ʸ��'{'�θ�
        (extern-lang-open after) ; ¾����ؤΥ�󥱡��������
                                        ; '{'������
        (extern-lang-close before)      ; ¾����ؤΥ�󥱡��������
                                        ; '}'����
		(inexpr-class-open after)
		(inexpr-class-close before)
        ))
    ;; ���������μ�ư���Խ���������
    (c-hanging-colons-alist
     . (
        (case-label after)              ; case ��٥��':'�θ�
        (label after)                   ; ��٥��':'�θ�
        (access-label after)            ; ����������٥�(public��)��':'�θ�
        (member-init-intro)             ; ���󥹥ȥ饯���ǤΥ��С������
                                        ; �ꥹ�Ȥ���Ƭ��':'�Ǥϲ��Ԥ��ʤ�
        (inher-intro before)            ; ���饹����ǤηѾ��ꥹ�Ȥ���Ƭ��
                                        ; ':'�Ǥϲ��Ԥ��ʤ�
        ))
    ;; �������줿;�פʶ���ʸ���Υ���󥻥��������
    ;; ������*��������
    (c-cleanup-list
     . (
	    brace-else-brace                ; else ��ľ��
                                        ; "} * else {"  ->  "} else {"
        brace-elseif-brace              ; else if ��ľ��
                                        ; "} * else if (.*) {"
                                        ; ->  } "else if (.*) {"
        empty-defun-braces              ; ���Υ��饹���ؿ������'}' ��ľ��
                                        ;��"{ * }"  ->  "{}"
        defun-close-semi                ; ���饹���ؿ�������';' ��ľ��
                                        ; "} * ;"  ->  "};"
        list-close-comma                ; ������������'},'��ľ��
                                        ; "} * ,"  ->  "},"
        scope-operator                  ; �������ױ黻��'::' �δ�
                                        ; ": * :"  ->  "::"
        ))
    ;; ���ե��å��̤�����
    ;; ɬ����ʬ�Τ�ȴ��(¾��������դ��Ƥ� info ����)
    ;; ���ե��å��̤ϲ����ǻ���
    ;; +  c-basic-offset�� 1��, ++ c-basic-offset�� 2��
    ;; -  c-basic-offset��-1��, -- c-basic-offset��-2��
    (c-offsets-alist
     . (
        (arglist-intro          . ++)   ; �����ꥹ�Ȥγ��Ϲ�
        (arglist-close          . c-lineup-arglist) ; �����ꥹ�Ȥν�λ��
        (substatement-open      . ++)    ; ���֥��ơ��ȥ��Ȥγ��Ϲ�
        (statement-cont         . ++)   ; ���ơ��ȥ��Ȥη�³��
        (case-label             . 0)    ; case ʸ�Υ�٥��
        (label                  . 0)    ; ��٥��
        (block-open             . 0)    ; �֥�å��γ��Ϲ�
		(member-init-intro      . ++)   ; ���Х��֥������Ȥν�����ꥹ��
		(defun-block-intro      . +)    ; �֥�å��ǻ�����
        ))
    ;; ����ǥ�Ȼ��˹�ʸ���Ͼ����ɽ������
    (c-echo-syntactic-information-p . t)
    )
  "My C Programming Style")
;; hook �Ѥδؿ������
(defun my-c-mode-common-hook ()
  ;; my-c-stye ����Ͽ����ͭ���ˤ���
  (c-add-style "My C Programming Style" my-c-style t)

  ;; ���Υ������뤬�ǥե���Ȥ��Ѱդ���Ƥ���Τ����򤷤Ƥ�褤
  ;; (c-set-style "gnu")
  ;; (c-set-style "k&r")
  ;; (c-set-style "bsd")
  ;; (c-set-style "linux")
  ;; (c-set-style "cc-mode")
  ;; (c-set-style "stroustrup")
  ;; (c-set-style "ellemtel")
  ;; (c-set-style "whitesmith")
  ;; (c-set-style "python")
  
  ;; ��¸�Υ���������ѹ�������ϼ��Τ褦�ˤ���
  ;; (c-set-offset 'member-init-intro '++)

  ;; auto-fill-mode ��ͭ���ˤ���
  (auto-fill-mode t)
  ;; ����Ĺ������
  (make-variable-buffer-local 'tab-width)
  (setq tab-width 4)
  ;; ���֤�����˥��ڡ�����Ȥ�
  (setq indent-tabs-mode nil)
  ;; ��ư����(auto-newline)��ͭ���ˤ���
  (setq c-auto-newline 1)
  ;; Ϣ³�������ΰ����(hungry-delete)��ͭ���ˤ���
  (c-toggle-auto-hungry-state 1)
  ;; ���ߥ����Ǽ�ư���Ԥ��ʤ�
  (setq c-hanging-semi&comma-criteria nil)

  ;; �����Х���ɤ��ɲ�
  ;; ------------------
  ;; C-m        ���ԡܥ���ǥ��
  ;; C-c c      ����ѥ��륳�ޥ�ɤε�ư
  ;; C-h        ����ΰ����
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)
  (define-key c-mode-base-map "\C-cc" 'compile)
  (define-key c-mode-base-map "\C-h" 'c-electric-backspace)

  ;; ����ѥ��륳�ޥ�ɤ�����
  ;; (setq compile-command "gcc ")
  ;;(setq compile-command "make -k ")
  (setq compile-command "")
  ;; (setq compile-command "gmake -k ")
)

;;; Ruby�ѤΥ�������
(c-add-style
 "ruby"
 '("bsd"
   (c-basic-offset . 2)
   (knr-argdecl-intro . 2)
   (defun-block-intro . 2)
   ))
;;; Python�ѤΥ�������
(c-add-style
 "python"
 '("python"
   (c-basic-offset . 2)
   (knr-argdecl-intro . 2)
   (defun-block-intro . 2)
   ))
;; �⡼�ɤ�����Ȥ��˸ƤӽФ� hook ������
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(setq auto-mode-alist (cons '("\\.c$" . c-mode) auto-mode-alist))
;;for asm
(setq auto-mode-alist (cons '("\\.S$" . asm-mode) auto-mode-alist))
;;for java
(setq auto-mode-alist (cons '("\\.java$" . java-mode) auto-mode-alist))
;;for c++
(setq auto-mode-alist (cons '("\\.cpp$". c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cc$". c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cxx$". c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.hpp$". c++-mode) auto-mode-alist))
;;for ruby
(setq auto-mode-alist (cons '("\\.rb$". ruby-mode) auto-mode-alist))
;;for python
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;; for fortran
(setq auto-mode-alist (cons '("\\f$" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.f90$" . fortran-mode) auto-mode-alist))
;;for lua
(autoload 'lua-mode "lua-mode" "LightweightLang." t)
(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
;;for go mode
(autoload 'go-mode "go-mode" "GoLang" t)
(setq auto-mode-alist (cons '("\\.go$". go-mode) auto-mode-alist))
;;for perl mode
(setq auto-mode-alist (cons '("\\.pl$". perl-mode) auto-mode-alist))
;;rust-mode
(autoload 'rust-mode "rust-mode" "a mozilla's language." t)
(setq auto-mode-alist (cons '("\\.rs$". rust-mode) auto-mode-alist))
;; for C# mode
(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist (cons '("\\.cs$" . csharp-mode) auto-mode-alist))
;; for SML mode
(autoload 'sml-mode "sml-mode" "Major mode for editing SML code." t)
(setq auto-mode-alist (cons '("\\.sml$" . sml-mode) auto-mode-alist))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;C# mode setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Patterns for finding Microsoft C# compiler error messages:
(require 'compile)
(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): error" 1 2 3 2) compilation-error-regexp-alist)
(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): warning" 1 2 3 1) compilation-error-regexp-alist)

;; Patterns for defining blocks to hide/show:
(push '(csharp-mode
	"\\(^\\s *#\\s *region\\b\\)\\|{"
	"\\(^\\s *#\\s *endregion\\b\\)\\|}"
	"/[*/]"
	nil
	hs-c-like-adjust-block-beginning)
      hs-special-modes-alist)
;;cuda-mode
(autoload 'cuda-mode "cuda-mode" "NVIDIA GPGPU Computing Lang." t)
(setq auto-mode-alist (cons '("\\.cu\\w?" . cuda-mode) auto-mode-alist))
;;tuareg-mode for OCaml
(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(autoload 'tuareg-mode "tuareg-mode" "Major mode for editing Caml code" t)
;;for D Lang
(autoload 'd-mode "d-mode" "Major mode for editing D code." t)
(add-to-list 'auto-mode-alist '("\\.d[i]?\\'" . d-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;verify mode section end.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;for magit
(autoload 'magit "magit" "Emacs git client." t)
;; �ޤ���install-elisp �Υ��ޥ�ɤ�Ȥ����ͤˤ��ޤ���
(autoload 'install-elisp "install-elisp" "install emacs lisp" t)
;; ���ˡ�Elisp �ե�����򥤥󥹥ȡ��뤹�������ꤷ�ޤ���
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")
;;;Hide message
(setq inhibit-startup-message t)
(load "elscreen" "ElScreen" t)
(global-set-key "\M-n" 'next-buffer)
(global-set-key "\M-p" 'previous-buffer)
;; �ʲ��ϼ�ư�ǥ����꡼������������������
(defmacro elscreen-create-automatically (ad-do-it)
  `(if (not (elscreen-one-screen-p))
       ,ad-do-it
     (elscreen-create)
     (elscreen-notify-screen-modification 'force-immediately)
     (elscreen-message "New screen is automatically created")))

(defadvice elscreen-next (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))
(defadvice elscreen-previous (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))
(defadvice elscreen-toggle (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

;; elscreen-server
(require 'elscreen-server)
;; elscreen-dired
(require 'elscreen-dired)
;; elscreen-color-theme
(require 'elscreen-color-theme)
;; ��ư���Υ�����,ɽ������,�ե���Ȥ����
(setq initial-frame-alist
      (append (list
	       '(width . 85)
	       '(height . 50)
	      )
	      initial-frame-alist))
(setq default-frame-alist initial-frame-alist)
(setq-default tab-width 4)
(setq default-tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
                      64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���ܸ����Ϥ�����
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;for Ubuntu setting
(when run-linux
  ;; ibus-mode
  (require 'ibus)
  ;; Turn on ibus-mode automatically after loading .emacs
  (add-hook 'after-init-hook 'ibus-mode-on)
  ;; Use C-SPC for Set Mark command
  (ibus-define-common-key ?\C-\s nil)
  ;; Use C-/ for Undo command
  (ibus-define-common-key ?\C-/ nil)
  ;; Change cursor color depending on IBus status
  (setq ibus-cursor-color '("limegreen" "white" "yellow"))
  (global-set-key "\C-\\" 'ibus-toggle)
  ;; �Ѵ�������on��̵�Ѵ�������off���ڤ��ؤ�
  (global-set-key
   [henkan]
   (lambda () (interactive)
     (when (null current-input-method) (toggle-input-method))))
  (global-set-key
   [muhenkan]
   (lambda () (interactive)
     (inactivate-input-method)))
  (defadvice mozc-handle-event (around intercept-keys (event))
    "Intercept keys muhenkan and zenkaku-hankaku, before passing keys to mozc-server (which the function mozc-handle-event does), to properly disable mozc-mode."
  (if (member event (list 'zenkaku-hankaku 'muhenkan))
      (progn (mozc-clean-up-session)
             (toggle-input-method))
    (progn ;(message "%s" event) ;debug
      ad-do-it)))
  (ad-activate 'mozc-handle-event)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; UTF-8 and Japanese Setting

;                      'unicode)
(set-coding-system-priority 'utf-8
                            'euc-jp
                            'iso-2022-jp
                            'cp932)
(set-language-environment 'Japanese)
(set-terminal-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8-unix)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ede-project-directories (quote ("/media/Data/Document")))
 '(haskell-notify-p t)
 '(haskell-process-type (quote cabal-dev)))

;;chmod +x
(defun make-file-executable ()
  "Make the file of this buffer executable, when it is a script source."
  (save-restriction
    (widen)
    (if (string= "#!" (buffer-substring-no-properties 1 (min 3 (point-max))))
        (let ((name (buffer-file-name)))
          (or (equal ?. (string-to-char (file-name-nondirectory name)))
              (let ((mode (file-modes name)))
                (set-file-modes name (logior mode (logand (/ mode 4) 73)))
                (message (concat "Wrote " name " (+x)"))))))))
(add-hook 'after-save-hook 'make-file-executable)
;;change default directory for Ubuntu
(when run-linux
  (cd "/media/Data/Document")
)
;;change default directory for OSX
(when run-darwin
  (cd "~/Document/")
)
(when run-linux
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "unknown" :family "VL �����å�")))))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;����¾��¿������
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �Хå����åץե��������ʤ�
(setq backup-inhibited t)
;;; ��λ���˥����ȥ����֥ե������ä�
(setq delete-auto-save-files t)
;;; ���̤��줿�ե�������Խ��Ǥ���褦�ˤ���
(auto-compression-mode t)
;;; �����ȥ�С��˥ե�����̾��ɽ������
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
;;; �⡼�ɥ饤��˻��֤�ɽ������
(display-time)
(which-function-mode 1)
;; spell check
(flyspell-mode t)
(setq ispell-dictionary "american")
(eval-when-compile
  ;; Emacs 21 defines `values' as a (run-time) alias for list.
  ;; Don't maerge this with the pervious clause.
  (if (string-match "values"
            (pp (byte-compile (lambda () (values t)))))
      (defsubst values (&rest values)
    values)))

;; Ʊ̾�Υե�����򳫤����Ȥ��ƤΥǥ��쥯�ȥ�̾��ɽ��
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; �ե����������
(require 'recentf)
(recentf-mode t)
(setq recentf-exclude '("^\\.emacs\\.bmk$"))
(setq recentf-max-menu-items 10)
(setq recentf-max-saved-items 20)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; �����Х���ɤ�����
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; M-g �ǻ���Ԥإ�����
(global-set-key "\M-g" 'goto-line)

;; �꡼�����򥳥��ȥ�����
(global-set-key "\C-c;" 'comment-region)

;; �Хåե��κǽ�ιԤ� previous-line ���Ƥ⡢
;; "beginning-of-buffer" ����դ���ʤ��褦�ˤ��롣
(defun previous-line (arg)
  (interactive "p")
  (if (interactive-p)
      (condition-case nil
          (line-move (- arg))
        ((beginning-of-buffer end-of-buffer)))
    (line-move (- arg)))
  nil)
;;��ʸ����ʸ������̤�����
(setq default-case-fold-search nil)
