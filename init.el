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

;; 从zshrc获取环境变量
;;(use-package exec-path-from-shell
;;  :ensure t
;;  :config
;;  (exec-path-from-shell-initialize)
;;  (exec-path-from-shell-copy-env "WAKATIME_API_KEY"))

;; 字体设置
(set-frame-font "JetBrainsMono NF-12" nil t) 
(set-fontset-font t 'han (font-spec :family "Sarasa Mono SC" :size 18))
(set-fontset-font t 'cjk-misc (font-spec :family "Sarasa Mono SC" :size 18))
;; (set-fontset-font t 'han (font-spec :family "Microsoft Yahei UI" :size 19))
;; (set-fontset-font t 'cjk-misc (font-spec :family "Microsoft Yahei UI" :size 19))

;; 禁用工具栏
(tool-bar-mode -1)
;; 禁用滚动条
(scroll-bar-mode -1)
;; 去掉菜单栏
(menu-bar-mode -1)
;; 使用相对行号
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

;; 启动waka
(use-package wakatime-mode
  :ensure t
  :config
  ;; 使用绝对路径
  (setq wakatime-cli-path "C:/Users/27722/emacs-home/wakatime/wakatime-cli-windows-amd64.exe")
  ;; 设置 API Key
  (setq wakatime-api-key (getenv "WAKATIME_API_KEY"))
  ;; 关闭错误提示（避免烦人的消息）
  (setq wakatime-show-errors nil)
  (global-wakatime-mode 1))

;; treemacs 配置
(use-package treemacs
  :ensure t
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  :bind
  ("M-0" . treemacs))

;; git工具
(use-package magit
  :ensure t)

;; 添加格式化
(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1)
  ;; 直接修改 'prettier-javascript 这个 formatter 的条目
  (setf (alist-get 'prettier-javascript apheleia-formatters)
        '("apheleia-npx" "prettier" "--stdin-filepath" filepath)))

;; 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi-deuteranopia))
 '(package-selected-packages nil)
 '(wakatime-cli-path "\11\11"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "JetBrainsMono NF" :foundry "outline" :slant normal :weight bold :height 120 :width normal)))))

;; ==================== 加载模块化配置 ====================
;; 将 lisp 目录添加到加载路径
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; ==================== Vue 3 开发配置 ====================
(require 'init-vue nil t)


;; ==================== C/C++ 开发配置 ====================
(require 'init-c nil t)  ;; t参数表示如果文件不存在也不报错

;; ==================== JavaScript/TypeScript 开发配置 ====================
(require 'init-js nil t)   ;; 新增这一行
