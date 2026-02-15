;; 关闭启动欢迎页面
(setq inhibit-startup-screen t)
;; 关闭编译警告（可选）
(setq byte-compile-warnings nil)
;; 加载 package 和 use-package
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; 如果 use-package 还没安装，自动安装
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; 字体设置
(set-frame-font "SauceCodePro Nerd Font Mono 15" nil t)

;; 使用相对行号
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

;; treemacs 配置
(use-package treemacs
  :ensure t
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  :bind
  ("M-0" . treemacs))

(use-package magit
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
