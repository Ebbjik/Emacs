;;; init-vue.el --- Vue 3 development configuration

;; 1. 基础编辑：web-mode 处理 .vue 文件
(use-package web-mode
  :ensure t
  :mode ("\\.vue\\'" . web-mode)
  :config
  (setq web-mode-markup-indent-offset 2      ;; HTML 缩进 2 空格
        web-mode-css-indent-offset 2         ;; CSS 缩进 2 空格
        web-mode-code-indent-offset 2        ;; JavaScript/TypeScript 缩进 2 空格
        web-mode-enable-auto-pairing t       ;; 自动配对标签
        web-mode-enable-auto-closing t       ;; 自动关闭标签
        web-mode-enable-current-element-highlight t) ;; 高亮当前元素
  ;; 让 web-mode 识别更多 Vue 特性
  (setq web-mode-content-types-alist
        '(("vue" . "\\.vue\\'"))))

;; 2. 代码补全框架
(use-package company
  :ensure t
  :hook (web-mode . company-mode)
  :config
  (setq company-idle-delay 0.1          ;; 更短的延迟
        company-minimum-prefix-length 1  ;; 1个字符就触发
        company-tooltip-align-annotations t
        company-global-modes t
        company-frontends               ;; 确保使用正确的显示前端
        '(company-pseudo-tooltip-frontend
          company-echo-metadata-frontend))
  (global-company-mode))                 ;; 全局启用

;; 3. LSP 客户端配置
(use-package lsp-mode
  :ensure t
  :hook ((web-mode . lsp-deferred)       ;; 在 web-mode 中启动 LSP
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred)
  :config
  ;; 安装语言服务器：M-x lsp-install-server 选择 volar
  ;; 或者手动安装：npm install -g @vue/language-server
  (setq lsp-keymap-prefix "C-c l"        ;; LSP 快捷键前缀
        lsp-completion-provider :capf    ;; 使用 company 作为补全后端
        lsp-file-watch-threshold 2000    ;; 文件监控限制
        lsp-log-io nil                    ;; 关闭日志，提高性能
        lsp-restart 'auto-restart)
  ;; 配置 volar（Vue 3 语言服务器）
  (with-eval-after-load "lsp-mode"
    (require 'lsp-volar nil t)  ;; 加载 volar 支持，不报错如果没有
    ;; 设置 volar 相关选项
    (setq lsp-volar-emmet t              ;; 启用 Emmet 补全
          lsp-volar-format-options '(:tabSize 2 :insertSpaces t))))

;; 4. LSP UI 增强
(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t              ;; 显示文档弹窗
        lsp-ui-doc-position 'at-point     ;; 文档显示在光标位置
        lsp-ui-doc-header t               ;; 显示文档标题
        lsp-ui-doc-include-signature t    ;; 包含函数签名
        lsp-ui-doc-use-childframe t       ;; 使用子框架显示
        lsp-ui-sideline-enable t           ;; 在侧边显示代码信息
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-actions t))

;; 5. 语法检查
(use-package flycheck
  :ensure t
  :hook (web-mode . flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled)
        flycheck-emacs-lisp-load-path 'inherit))

;; 6. Emmet 快速编写 HTML/CSS
(use-package emmet-mode
  :ensure t
  :hook (web-mode . emmet-mode)          ;; 在 web-mode 中启用 emmet
  :config
  (setq emmet-expand-jsx-className t))   ;; 支持 React/JSX 语法

;; 7. 代码片段（可选，但很方便）
(use-package yasnippet
  :ensure t
  :hook (web-mode . yas-minor-mode)      ;; 在 web-mode 中启用 yasnippet
  :config
  (yas-reload-all))                      ;; 加载所有片段

;; 8. 代码格式化 - Prettier（需要安装 prettier-js 包）
(use-package prettier-js
  :ensure t
  :hook (web-mode . prettier-js-mode)    ;; 保存时自动格式化
  :config
  (setq prettier-js-args '("--tab-width" "2")))

;; 可选：让 web-mode 更好地高亮 Vue 模板中的表达式
(add-hook 'web-mode-hook
          (lambda ()
            (setq web-mode-enable-part-face t)))

;; 可选：在 treemacs 中显示 LSP 错误和状态
(use-package lsp-treemacs
  :ensure t
  :after (treemacs lsp-mode))

(provide 'init-vue)
;;; init-vue.el ends here
