;;; flow-completion-at-point.el --- FLow autocomplete support for completion-at-point command  -*- lexical-binding: t; -*-

;; Copyright (C) 2018 Mikhail Pontus

;; Author:  <m.pontus@gmail.com>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Provides minor mode which extends `completion-at-point-functions'
;; with Flow autocomplete command.

;; Add the following code to your initialization script to enable this
;; mode for javascript files:

;; (add-hook 'js-mode-hook 'flow-completion-at-point-mode)

;;; Code:

(require 'json)

(defun flow-completion-at-point--execute-command (buffer line column)
  "Return the raw output from executing Flow autocomplete command.

BUFFER is the source buffer, LINE and COLUMN specify position in
the buffer at which to perform completion."
  (with-temp-buffer
    (let ((output-buffer (current-buffer)))
      (with-current-buffer buffer
	(call-process-region
	 (point-min)
	 (point-max)
	 "flow"
	 nil
	 (list output-buffer t)
	 nil
	 "autocomplete"
	 "--json"
	 (buffer-file-name buffer)
	 (format "%d" line)
	 (format "%d" (1+ column))))
      (buffer-substring (point-min) (point-max)))))

(defun flow-completion-at-point--get-completions ()
  "Return the list of Flow completions as strings."
  (let* ((result-raw (flow-completion-at-point--execute-command
		      (current-buffer)
		      (line-number-at-pos)
		      (current-column)))
	 (result
	  (cdr (assq 'result
		     (json-read-from-string result-raw)))))
    (mapcar
     (lambda (it)
       (cdr (assq 'name it)))
     result)))

(defun flow-completion-at-point ()
  "Perform completion at point using Flow autocomplete."
  (let ((bounds (or (bounds-of-thing-at-point 'symbol)
		    (cons (point) (point)))))
    (list (car bounds)
	  (cdr bounds)
	  (completion-table-dynamic
	   (lambda (str)
	     (ignore str) ;; suppress lint warning
	     (flow-completion-at-point--get-completions)))
	   :exclusive 'no)))

;;;###autoload
(define-minor-mode flow-completion-at-point-mode
  "Add Flow autocomplete to completion-at-point functions."
  nil
  nil
  nil
  (if flow-completion-at-point-mode
      (add-to-list 'completion-at-point-functions #'flow-completion-at-point)
    (setq completion-at-point-functions
	  (delq 'flow-completion-at-point completion-at-point-functions))))

(provide 'flow-completion-at-point)
;;; flow-completion-at-point.el ends here
