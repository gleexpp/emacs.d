                                        ; evil, the Extensible VI Layer! seee http://gitorious.org/evil/pages/Home
(add-to-list 'load-path "~/.emacs.d/script/evil")
(require 'evil)
(evil-mode 1)
                                        ; some keymaps from ~/.vimrc
(define-key evil-insert-state-map [f1] 'save-buffer) ; save
(define-key evil-normal-state-map [f1] 'save-buffer) ; save
(define-key evil-normal-state-map ",w" 'save-buffer) ; save
(define-key evil-normal-state-map ",q" 'kill-buffer) ; quit (current buffer; have to press RETURN)
(define-key evil-normal-state-map ",x" 'save-buffers-kill-emacs) ; save and quit
                                        ; make "kj" behave as ESC key ,adapted from http://permalink.gmane.org/gmane.emacs.vim-emulation/684
                                        ; you can easily change it to map "jj" or "kk" or "jk" to ESC)
(defun escape-if-next-char (c)
  "Watches the next letter.  If c, then switch to Evil's normal mode; otherwise insert a k and forward unpressed key to unread-command events"
  (self-insert-command 1)
  (let ((next-key (read-event)))
    (if (= c next-key)
        (progn
          (delete-backward-char 1)
          (evil-esc))
      (setq unread-command-events (list next-key)))))

(defun escape-if-next-char-is-j (arg)
  (interactive "p")
  (if (= arg 1)
      (escape-if-next-char ?j)
    (self-insert-command arg)))

(define-key evil-insert-state-map (kbd "k") 'escape-if-next-char-is-j)
                                        ; simulate vim's "nnoremap <space> 10jzz"
(define-key evil-normal-state-map " " (lambda ()
                                        (interactive)
                                        (next-line 10)
                                        (evil-scroll-line-down 10)
                                        ))
                                        ; simulate vim's "nnoremap <backspace> 10kzz"
(define-key evil-normal-state-map (kbd "DEL") (lambda ()
                                                (interactive)
                                                (previous-line 10)
                                                (evil-scroll-line-up 10)
                                                ))

                                        ; make evil work for org-mode!
(define-key evil-normal-state-map "O" (lambda ()
                                        (interactive)
                                        (end-of-line)
                                        (org-insert-heading)
                                        (evil-append nil)
                                        ))

(defun always-insert-item ()
  (interactive)
  (if (not (org-in-item-p))
      (insert "\n- ")
    (org-insert-item)))

(define-key evil-normal-state-map "O" (lambda ()
                                        (interactive)
                                        (end-of-line)
                                        (org-insert-heading)
                                        (evil-append nil)
                                        ))

(define-key evil-normal-state-map "o" (lambda ()
                                        (interactive)
                                        (end-of-line)
                                        (always-insert-item)
                                        (evil-append nil)
                                        ))

(define-key evil-normal-state-map "t" (lambda ()
                                        (interactive)
                                        (end-of-line)
                                        (org-insert-todo-heading nil)
                                        (evil-append nil)
                                        ))
(define-key evil-normal-state-map (kbd "M-o") (lambda ()
                                                (interactive)
                                                (end-of-line)
                                                (org-insert-heading)
                                                (org-metaright)
                                                (evil-append nil)
                                                ))
(define-key evil-normal-state-map (kbd "M-t") (lambda ()
                                                (interactive)
                                                (end-of-line)
                                                (org-insert-todo-heading nil)
                                                (org-metaright)
                                                (evil-append nil)
                                                ))
(define-key evil-normal-state-map "T" 'org-todo) ; mark a TODO item as DONE
(define-key evil-normal-state-map ";a" 'org-agenda) ; access agenda buffer
(define-key evil-normal-state-map "-" 'org-cycle-list-bullet) ; change bullet style

                                        ; allow us to access org-mode keys directly from Evil's Normal mode
(define-key evil-normal-state-map "L" 'org-shiftright)
(define-key evil-normal-state-map "H" 'org-shiftleft)
(define-key evil-normal-state-map "K" 'org-shiftup)
(define-key evil-normal-state-map "J" 'org-shiftdown)
(define-key evil-normal-state-map (kbd "M-l") 'org-metaright)
(define-key evil-normal-state-map (kbd "M-h") 'org-metaleft)
(define-key evil-normal-state-map (kbd "M-k") 'org-metaup)
(define-key evil-normal-state-map (kbd "M-j") 'org-metadown)
(define-key evil-normal-state-map (kbd "M-L") 'org-shiftmetaright)
(define-key evil-normal-state-map (kbd "M-H") 'org-shiftmetaleft)
(define-key evil-normal-state-map (kbd "M-K") 'org-shiftmetaup)
(define-key evil-normal-state-map (kbd "M-J") 'org-shiftmetadown)

(define-key evil-normal-state-map (kbd "<f12>") 'org-export-as-html)
