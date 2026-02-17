;;; init-c.el --- Simple C/C++ Development Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; 简单的 C/C++ 开发环境配置，使用 Clang 作为补全后端，集成 clang-format 自动格式化

;;; Code:

(message "Loading simple C/C++ configuration...")

;; ==================== 基础编辑设置 ====================
(defun my-c-mode-hook ()
  "C模式钩子函数，设置缩进和编码风格"
  (setq c-basic-offset 2)        ;; 基础缩进为2个空格
  (setq tab-width 4)              ;; Tab键宽度为4
  (setq indent-tabs-mode nil)     ;; 缩进使用空格代替Tab字符
  (c-set-offset 'substatement-open 0)) ;; 控制语句后的大括号缩进

;; 文件关联设置
(add-to-list 'auto-mode-alist '("\\.c\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))

;; ==================== Company 补全框架 ====================
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.2)           ;; 延迟0.2秒弹出补全
  (setq company-minimum-prefix-length 1)  ;; 输入1个字符就开始补全
  (setq company-clang-arguments '("-Wall" "-Wextra")) ;; Clang 参数
  (message "Company mode configured"))

;; ==================== Clang 补全后端 ====================
;; 使用内置的 company-clang 后端
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-clang))

;; ==================== Clang-Format 配置 ====================
(use-package clang-format
  :ensure t
  ;; 为 C/C++ 模式启用保存时自动格式化
  :hook ((c-mode c++-mode) . clang-format-on-save-mode)
  :config
  ;; 设置代码风格 - 优先使用项目中的 .clang-format 文件
  (setq clang-format-style "file")
  ;; 如果没有找到 .clang-format 文件，使用 Google 风格作为备选
  (setq clang-format-fallback-style "Google")
  
  ;; 检查 clang-format 是否可用
  (unless (executable-find "clang-format")
    (message "⚠️ Warning: clang-format not found. Please install it with: sudo apt install clang-format"))
  
  ;; 格式化整个文件函数（带光标位置恢复）
  (defun my-clang-format-buffer ()
    "使用clang-format格式化整个缓冲区"
    (interactive)
    (if (executable-find "clang-format")
        (progn
          ;; 保存当前光标位置
          (let ((line (line-number-at-pos))
                (col (current-column)))
            ;; 执行格式化
            (clang-format-buffer)
            ;; 恢复光标位置
            (goto-char (point-min))
            (forward-line (1- line))
            (forward-char (min col (line-end-position)))
            (message "✅ Buffer formatted with clang-format")))
      (message "❌ clang-format not found")))
  
  ;; 检查 clang-format 状态函数
  (defun my-check-clang-format ()
    "检查clang-format是否可用"
    (interactive)
    (if (executable-find "clang-format")
        (progn
          (message "✅ clang-format found at %s" (executable-find "clang-format"))
          (if clang-format-on-save-mode
              (message "✅ clang-format-on-save-mode is ACTIVE")
            (message "❌ clang-format-on-save-mode is INACTIVE")))
      (message "❌ clang-format not found. Install with: sudo apt install clang-format")))
  
  (message "Clang-format configured with save-on-format"))

;; ==================== Flycheck 语法检查 ====================
(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode)
  :config
  ;; 使用内置的 C/C++ 检查器
  (flycheck-add-next-checker 'c/c++-clang 'c/c++-cppcheck)
  (message "Flycheck configured"))

;; ==================== 编译配置 ====================
(defun my-compile-function ()
  "自定义编译函数，智能选择编译命令"
  (interactive)
  (let ((compile-command
         (cond
          ((file-exists-p "Makefile") "make -k")
          ((file-exists-p "makefile") "make -k")
          ((string-match-p "\\.c$" (buffer-file-name))
           (format "gcc -o %s %s -Wall -g"
                   (file-name-base buffer-file-name)
                   (file-name-nondirectory buffer-file-name)))
          ((string-match-p "\\.cpp$" (buffer-file-name))
           (format "g++ -o %s %s -Wall -g"
                   (file-name-base buffer-file-name)
                   (file-name-nondirectory buffer-file-name)))
          (t "make -k"))))
    (setq-local compile-command compile-command)
    (call-interactively 'compile)))

;; ==================== 自定义快捷键 ====================
(defun my-c-mode-key-bindings ()
  "C/C++模式下的自定义快捷键"
  ;; 编译相关
  (local-set-key (kbd "C-c C-c") 'my-compile-function)  ;; 编译
  (local-set-key (kbd "C-c C-k") 'kill-compilation)     ;; 终止编译
  (local-set-key (kbd "C-c C-r") 'recompile)            ;; 重新编译
  
  ;; 格式化相关
  (local-set-key (kbd "C-c C-f") 'my-clang-format-buffer)   ;; 格式化整个文件
  
  ;; 检查 clang-format 状态
  (local-set-key (kbd "C-c C-h") 'my-check-clang-format)    ;; 检查格式化状态
)

(add-hook 'c-mode-common-hook 'my-c-mode-key-bindings)

;; ==================== 彩虹括号 ====================
(use-package rainbow-delimiters
  :ensure t
  :hook (c-mode-common-hook . rainbow-delimiters-mode))

;; ==================== 显示行号 ====================
(add-hook 'c-mode-common-hook 'display-line-numbers-mode)

;; ==================== 钩子设置 ====================
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

;; ==================== 启动后检查 ====================
;; 在 Emacs 启动后检查 clang-format 状态
(run-with-idle-timer 2 nil
  (lambda ()
    (unless (executable-find "clang-format")
      (message "⚠️ 提示: clang-format 未安装。自动格式化功能不可用。安装命令: sudo apt install clang-format"))))

;; ==================== 初始化提示 ====================
(message "✅ Simple C/C++ configuration loaded (Clang backend + Clang-format auto-format on save)")

(provide 'init-c)
;;; init-c.el ends here
