;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'ox-publish)


;; (defun org-publish-attachment (_plist filename pub-dir)
;;   "Publish a file with no transformation of any kind.

;; FILENAME is the filename of the Org file to be published.  PLIST
;; is the property list for the given project.  PUB-DIR is the
;; publishing directory.

;; Return output file name."
;;   (unless (file-directory-p pub-dir)
;;     (make-directory pub-dir t))
;;   (let ((output (expand-file-name (file-name-nondirectory filename) pub-dir)))
;;     (unless (file-equal-p (expand-file-name (file-name-directory filename))
;;                           (file-name-as-directory (expand-file-name pub-dir)))
;;       (copy-file filename output t))
;;     ;; Return file name.
;;     output))
;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "org-site:main"
             :recursive t
             :base-directory "./content"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public"
             :with-author t           ;; Don't include author name
             :with-creator nil            ;; Include Emacs and Org versions in footer
             :with-toc t                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil)
;; HRISHI it all has to be org-site:img, ./public/img and ./content/img
;;HRISHI This means inside content->there is a dir called "img" and that dir has to be uploaded
       (list "org-site:img"
        :base-directory "./content/img"
        :base-extension "png\\|jpg\\|pdf" ;; tells to honor links to pdf files as well
        :publishing-directory "./public/img" ;; HRISHI not sure what happens if I delete public
        :publishing-function 'org-publish-attachment
        )

       ))    ;; Don't include time stamp in file

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
