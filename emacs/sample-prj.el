(jde-project-file-version "1.0")

(jde-set-variables
 '(jde-make-args "jar")
 '(jde-gen-buffer-boilerplate 
   (quote 
    ("/**" 
     " * @author Yun, Jonghyouk"
     " */")))   
 '(jde-log-max 5000)
 '(jde-enable-abbrev-mode t)
 '(jde-run-application-class "com.popbill.etax.apps.JettyLauncher")   
 '(jde-make-program "ant")
 ;'(jde-javadoc-version-tag-template "\"* @version $Id: prj.el,v 1.4 2003/04/23 14:28:25 kobit Exp $\"")   
 ;; Defines bracket placement style - now it is set according to SUN standards
 '(jde-gen-k&r t)    
 ;; Do you prefer to have java.io.* imports or separate import for each 
 ;; used class - now it is set for importing classes separately
 '(jde-import-auto-collapse-imports nil)    
 ;; You can define many JDKs and choose one for each project
 '(jde-compile-option-target (quote ("1.6")))    
 ;; Nice feature sorting imports.
 '(jde-import-auto-sort t)    
 ;; For syntax highlighting and basic syntax checking parse buffer
 ;; number of seconds from the time you changed the buffer.
 '(jde-auto-parse-buffer-interval 600)    
 ;; Only for CygWin users it improves path resolving
 '(jde-cygwin-path-converter (quote (jde-cygwin-path-converter-cygpath)))    
 ;; You can set different user name and e-mail address for each project
)

(setq +my-java-home+ (getenv "JAVA_HOME"))
(setq +my-jde-project-home+ (getenv "ETAX_JAVA_PROJECT_HOME"))

(setq jde-global-classpath 
    (append
        (list (concat +my-jde-project-home+ "/bin"))
        (directory-files (concat +my-jde-project-home+ "/lib") t ".*jar$")
        (directory-files (concat +my-java-home+ "/lib") t ".*jar$")))

(setq jde-sourcepath 
    (append
        (list (concat +my-java-home+ "/src"))
        (list (concat +my-jde-project-home+ "/src"))))

(setq jde-run-working-directory +my-jde-project-home+)
