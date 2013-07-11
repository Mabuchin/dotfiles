(require 'my-ostype)
;;change default directory for Ubuntu
(when run-linux
  (cond
   ((equal (file-exists-p "/media/Data/Document") t)
    (cd "/media/Data/Document"))
   ((equal (file-exists-p "/media/Data2/Document") t)
    (cd "/media/Data2/Document"))
   ((equal (file-exists-p "~/Document") t)
    (cd "~/Document"))
   ))
(provide 'cd-linux)