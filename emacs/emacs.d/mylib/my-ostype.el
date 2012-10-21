(provide 'my-ostype)
;; OS��Ƚ�̡�UNIX�ϡ�
(defvar run-unix
  (or (equal system-type 'gnu/linux)
     (or (equal system-type 'usg-unix-v)
          (or  (equal system-type 'berkeley-unix)
               (equal system-type 'cygwin)))))
;; OS��Ƚ�̡�����Ƚ��
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
