(provide 'my-ftype)
;;my autoload elisp library
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
(autoload 'haskell-mode "haskell-mode" "editing Haskell." t)
(require 'inf-haskell)
(autoload 'literate-haskell-mode "haskell-mode" "editing literate Haskell." t)
(autoload 'haskell-cabal "haskell-cabal" "editing Haskell cabal." t)
(autoload 'ghc-init "ghc" nil t)
(setq auto-mode-alist
  (append auto-mode-alist
    '(("\\.[hg]s$"  . haskell-mode)
      ("\\.hi$"     . haskell-mode)
      ("\\.l[hg]s$" . literate-haskell-mode)
      ("\\.cabal\\'" . haskell-cabal-mode))))
(add-hook 'haskell-mode-hook 'turn-on-haskell-font-lock)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-hugs) ; Hugs��
(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)  
;#!/usr/bin/env runghc ��
(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode)) 
;#!/usr/bin/env runhaskell ��
(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode))
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
        (class-open after)              ; ���饹�����'{'�θ�
        (class-close nil)               ; ���饹�����'}'�θ�
        (defun-open before after)       ; �ؿ������'{'������
        (defun-close after)             ; �ؿ������'}'�θ�
        (inline-open after)             ; ���饹��Υ���饤��
                                        ; �ؿ������'{'�θ�
        (inline-close after)            ; ���饹��Υ���饤��
                                        ; �ؿ������'}'�θ�
        (brace-if-brace after)          ; if��'{'�θ�
        (brace-else-brace after)        ; else'{'�θ�
        (brace-elseif-brace after)      ; else if'{'�θ�
        (brace-list-close after)        ; ��󷿡����������'}'�θ�
        (block-open before)             ; ���ơ��ȥ��Ȥ�'{'�θ�
        (block-close before)            ; ���ơ��ȥ��Ȥ�'}'����
        (substatement-open after)       ; ���֥��ơ��ȥ���
                                        ; (if ʸ��)��'{'�θ�
        (statement-case-open after)     ; case ʸ��'{'�θ�
        (extern-lang-open after)        ; ¾����ؤΥ�󥱡��������
                                        ; '{'������
        (extern-lang-close before)      ; ¾����ؤΥ�󥱡��������
                                        ; '}'����
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
  ;; �Ǹ�˲��Ԥ�����롣
  (setq require-final-newline t)
  ;; Ϣ³�������ΰ����(hungry-delete)��ͭ���ˤ���
  (c-toggle-auto-hungry-state 1)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;���͡�http://d.hatena.ne.jp/syohex/20110119/1295450495
  ;; for whitespace-mode
  (require 'whitespace)
  ;; see whitespace.el for more details
  (setq whitespace-style '(face tabs tab-mark spaces space-mark))
  (setq whitespace-display-mappings
    '((space-mark ?\u3000 [?\u25a1])
      ;; WARNING: the mapping below has a problem.
      ;; When a TAB occupies exactly one column, it will display the
      ;; character ?\xBB at that column followed by a TAB which goes to
      ;; the next TAB column.
      ;; If this is a problem for you, please, comment the line below.
      (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-foreground 'whitespace-tab "#20b2aa")
  (set-face-background 'whitespace-tab 'nil)
  (set-face-underline-p  'whitespace-tab t)
  (set-face-foreground 'whitespace-space "#4169e1")
  (set-face-background 'whitespace-space 'nil)
  (set-face-bold-p 'whitespace-space t)
  (global-whitespace-mode 1)
  (global-set-key (kbd "C-x w") 'global-whitespace-mode)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; white space mode setting end
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
  (setq compilation-window-height 20)
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
;;for Emas Lisp mode
(autoload 'emacs-lisp-mode "emacs-lisp-mode" "editing ELisp." t)
(setq auto-mode-alist (cons '("\\.el$" . emacs-lisp-mode) auto-mode-alist))
(setq auto-mode-alist (cons '(".emacs$" . emacs-lisp-mode) auto-mode-alist))
;;for OpenCL
(setq auto-mode-alist (cons '("\.cl$" . c-mode) auto-mode-alist))
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
;;for Kuin
(autoload 'kuin-mode "kuin-mode" nil t)
(add-hook 'kuin-mode-hook '(lambda () (font-lock-mode 1)))
(setq auto-mode-alist
    (cons (cons "\\.kn$" 'kuin-mode) auto-mode-alist))
