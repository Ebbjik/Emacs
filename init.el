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

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "WAKATIME_API_KEY"))
;; 字体设置
(set-frame-font "SauceCodePro Nerd Font Mono 15" nil t)

;; 启动waka
(use-package wakatime-mode
  :ensure t
  :config
  (setq wakatime-api-key (getenv "WAKATIME_API_KEY"))
  (global-wakatime-mode 1))

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
 '(custom-enabled-themes '(modus-vivendi-deuteranopia))
 '(package-selected-packages
   '(clang-format company emmet-mode exec-path-from-shell flycheck
		  lsp-treemacs lsp-ui magit prettier-js
		  rainbow-delimiters wakatime-mode web-mode yasnippet)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ==================== 加载模块化配置 ====================
;; 将 lisp 目录添加到加载路径
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; ==================== Vue 3 开发配置 ====================
(require 'init-vue nil t)


;; ==================== C/C++ 开发配置 ====================
(require 'init-c nil t)  ;; t参数表示如果文件不存在也不报错

;; ==================== JavaScript/TypeScript 开发配置 ====================
(require 'init-js nil t)   ;; 新增这一行
