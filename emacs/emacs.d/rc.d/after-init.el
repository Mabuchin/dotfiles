;; ���ֹ�ɽ��
(require 'linum)
(global-linum-mode t)
;; twmode ��̵���ˤ���
(defadvice linum-on(around my-linum-twmode-on() activate)
  (unless (eq major-mode 'twittering-mode) ad-do-it))
;;http://d.hatena.ne.jp/rubikitch/20100423/bytecomp
;;��ư�Х��ȥ���ѥ����Ԥ�
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)))
;;�����ؿ�
(require 'my-func)
;;powerline
(eval-when-compile
  (require 'cl))
(require 'powerline)
(provide 'after-init)
