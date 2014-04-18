;;; mof.el --- Emacs major mode for editing MOF files

;; Copyright (C) 2014 Jan Synáček

;; Author: Jan Synáček <jan.synacek@gmail.com>
;; URL: https://github.com/jsynacek/mof-mode
;; Version: 0.01
;; Maintainer: Jan Synáček <jan.synacek@gmail.com>
;; Created: Jan 2014
;; Keywords: mof

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:

;; Emacs major mode for editing MOF (Managed Object Format) files.

;;; TODO:

;; indentation rules
;; add more keywords, constants, builtins (according to the MOF specification)

;;; Code:

(defvar mof-mode-syntax-table
  (let ((st (make-syntax-table)))
    ;; make _ part of a word
    (modify-syntax-entry ?_ "w" st)
    ;; C++-like comments
    (modify-syntax-entry ?/ ". 124b" st)
    (modify-syntax-entry ?* ". 23" st)
    (modify-syntax-entry ?\n "> 2b" st)
    st)
  "Syntax table for `mof-mode'.")

(defvar mof-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-c\C-i" 'imenu)
    map)
  "Keymap for `mof-mode'.")

(defvar mof-font-lock-keywords
  (let* ((mof-keywords '("class" "instance" "of"))
         (mof-data-types '("uint16" "uint32" "uint64" "sint16" "sint32"
                           "sint64" "string" "boolean" "datetime" "REF"))
         (mof-constants '("true" "false"))
         (mof-builtin '("IN" "OUT" "Version" "Implemented" "Override"
                        "Description" "Association" "ValueMap" "Values"
                        "ArrayType" "ModelCorrespondence" "Key" "Weak"
                        "Aggregation" "Aggregate" "Min" "Max"
                        "EmbeddedInstance" "Required" "Provider"
                        "Indication"))
         (mof-keywords-regexp (regexp-opt mof-keywords 'words))
         (mof-data-types-regexp (regexp-opt mof-data-types 'words))
         (mof-constants-regexp (regexp-opt mof-constants 'words))
         (mof-builtin-regexp (regexp-opt mof-builtin 'words))
         (mof-preprocessor-regexp "^#pragma"))
    `((,mof-keywords-regexp . font-lock-keyword-face)
      (,mof-data-types-regexp . font-lock-type-face)
      (,mof-constants-regexp . font-lock-constant-face)
      (,mof-builtin-regexp . font-lock-builtin-face)
      (,mof-preprocessor-regexp . font-lock-preprocessor-face)))
  "Keyword highlighting for `mof-mode'")


(defvar mof-imenu-generic-expression
  '((nil "^\\s-*class *\\(\\w+\\)" 1))
  "MOF mode's `imenu-generic-expression'.")

;;;###autoload
(define-derived-mode mof-mode fundamental-mode "MOF"
  "Major mode for editing MOF files."
  :syntax-table mof-mode-syntax-table
  (setq-local comment-start "/*")
  (setq-local comment-end   "*/")
  (setq-local font-lock-defaults '(mof-font-lock-keywords))
  ;; (setq-local indent-line-function 'mof-indent-line)
  (setq-local imenu-generic-expression mof-imenu-generic-expression))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.mof\\'" . mof-mode))

(provide 'mof)

;; Local Variables:
;; coding: utf-8
;; End:

;;; mof.el ends here
