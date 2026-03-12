;;; init-js.el --- JavaScript/TypeScript development setup  -*- lexical-binding: t; -*-

;; 确保 use-package 已启用
(require 'use-package)

;; -------------------------------------------------------------------
;; LSP 核心支持
;; -------------------------------------------------------------------
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((js-mode        . lsp-deferred)   ; 普通 JavaScript
         (typescript-mode . lsp-deferred)  ; TypeScript
         (js-ts-mode      . lsp-deferred)  ; Emacs 29+ 的 tree-sitter JS 模式
         (tsx-ts-mode     . lsp-deferred)) ; Emacs 29+ 的 tree-sitter TSX 模式
  :init
  ;; 如果你使用 web-mode 处理 .js/.ts 文件，可以在这里添加
  ;; (add-hook 'web-mode-hook #'lsp-deferred)
  :config
  (setq lsp-keymap-prefix "C-c l")          ; LSP 功能快捷键前缀
  ;; 根据需要调整以下选项
  (setq lsp-completion-provider :capf)      ; 使用 company-capf 补全
  ;; 如果项目较大，可以关闭一些特性以提高性能
  (setq lsp-enable-snippet t)                ; 启用代码片段
  (setq lsp-log-io nil)                       ; 关闭详细日志
  )

;; -------------------------------------------------------------------
;; 友好的 UI 增强
;; -------------------------------------------------------------------
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t)                 ; 鼠标悬停显示文档
  (setq lsp-ui-doc-position 'top)            ; 文档显示位置
  (setq lsp-ui-sideline-enable t)            ; 侧边显示代码信息
  (setq lsp-ui-peek-enable t)                 ; 允许 peek 查看定义/引用
  )

;; -------------------------------------------------------------------
;; 自动补全框架 (Company)
;; -------------------------------------------------------------------
(use-package company
  :ensure t
  :hook (prog-mode . company-mode)           ; 所有编程模式启用 company
  :config
  (setq company-idle-delay 0.2                ; 弹出补全延迟
        company-minimum-prefix-length 1       ; 最少输入字符数
        company-tooltip-align-annotations t)  ; 注释对齐
  ;; 可选：集成 lsp 的补全后端
  (with-eval-after-load 'company
    (add-to-list 'company-backends 'company-capf))
  )

;; -------------------------------------------------------------------
;; 显示按键提示 (可选但推荐)
;; -------------------------------------------------------------------
(use-package which-key
  :ensure t
  :config (which-key-mode))

;; -------------------------------------------------------------------
;; 语法高亮增强 (tree-sitter 可选)
;; -------------------------------------------------------------------
;; 如果使用 Emacs 29+，可以启用 tree-sitter 以获得更精确的高亮
(when (and (fboundp 'tree-sitter-available-p) (tree-sitter-available-p))
  (use-package tree-sitter
    :ensure t
    :hook ((js-mode typescript-mode) . tree-sitter-mode))
  (use-package tree-sitter-langs
    :ensure t
    :after tree-sitter))

;;; init-js.el ends here

(provide 'init-js)
