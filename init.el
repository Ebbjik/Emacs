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
;; 加载暗黑主题
(load-theme 'modus-vivendi-deuteranopia t)

;; 启动waka
(use-package wakatime-mode
  :ensure t
  :config
  ;; 展开 ~ 为完整路径
  (setq wakatime-cli-path (expand-file-name "~/wakatime/wakatime-cli-windows-amd64.exe"))
  ;; 从环境变量获取 API Key
  (setq wakatime-api-key (getenv "WAKATIME_API_KEY"))
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

;; ==================== 加载模块化配置 ====================
;; 将 lisp 目录添加到加载路径
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; ==================== Vue 3 开发配置 ====================
(require 'init-vue nil t)


;; ==================== C/C++ 开发配置 ====================
(require 'init-c nil t)  ;; t参数表示如果文件不存在也不报错

;; ==================== JavaScript/TypeScript 开发配置 ====================
(require 'init-js nil t)   ;; 新增这一行
