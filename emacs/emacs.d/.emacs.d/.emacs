(add-to-list 'load-path "/home/cosmo/.emacs.d")
(require 'auto-complete)
(require 'auto-complete-config)    ; ɬ�ܤǤϤʤ��Ǥ������
(global-auto-complete-mode t)
;; ��ư���Υ�����,ɽ������,�ե���Ȥ����
(setq initial-frame-alist
      (append (list
	       '(width . 120)
	       '(height . 45)
	       '(top . 0)
	       '(left . 0)
	       '(font . "VL Gothic-11")
	       )
	      initial-frame-alist))
(setq default-frame-alist initial-frame-alist)
