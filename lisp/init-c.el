;;; init-c.el --- Simple C/C++ Development Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; 简单的 C/C++ 开发环境配置，使用 Clang 作为补全后端

;;; Code:

(message "Loading simple C/C++ configuration...")

;; ==================== 基础编辑设置 ====================
(defun my-c-mode-hook ()
  "C模式钩子函数，设置缩进和编码风格"
  (setq c-basic-offset 4)        ;; 基础缩进为4个空格
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
  (local-set-key (kbd "C-c C-c") 'my-compile-function)  ;; 编译
  (local-set-key (kbd "C-c C-k") 'kill-compilation)     ;; 终止编译
  (local-set-key (kbd "C-c C-r") 'recompile))           ;; 重新编译

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

;; ==================== 初始化提示 ====================
(message "✅ Simple C/C++ configuration loaded (Clang backend)")

(provide 'init-c)
;;; init-c.el ends here
