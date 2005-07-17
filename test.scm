;;;
;;; Test dbd.mysql
;;;

(use gauche.test)
(use gauche.collection)
(use srfi-1)
(use srfi-13)
(use dbi)

(test-start "dbd.mysql")
(use dbd.mysql)
(test-module 'dbd.mysql)

;; dbi-make-driver �Υƥ���:
;; "mysql" �ɥ饤�С�����ɤ���
;; ���饹 <mysql-driver> �Υ��󥹥��󥹤��ä�����
(define mysql-driver (dbi-make-driver "mysql"))
(test* "dbi-make-driver mysql"
       #t
       (is-a? mysql-driver <mysql-driver>))

;; dbi-make-connection �Υƥ���:
;; <mysql-driver>���Υ��󥹥��󥹤�����ˤ����Ȥ�
;; dbi-make-connection ������ͤ� 
;; <mysql-connection>���Υ��󥹥��󥹤��ä�����
;; ��: (sys-getenv "USER")�Ǽ����������ߤΥ桼�������ѥ���ɤʤ���
;;     MySQL��"test"�ǡ����١�������³�Ǥ���ɬ�פ����롣
(define current-user (sys-getenv "USER"))
(define mysql-connection
  (dbi-make-connection mysql-driver current-user "" "db=test"))
(test* "dbi-make-connection <mysql-driver>"
       #t
       (is-a? mysql-connection <mysql-connection>))

;; dbi-make-query �Υƥ���:
;; <mysql-connection>���Υ��󥹥��󥹤�����ˤ����Ȥ�
;; dbi-make-query������ͤ�
;; <mysql-query>���Υ��󥹥��󥹤��ä�����
(define mysql-query (dbi-make-query mysql-connection))
(test* "dbi-make-query <mysql-connection>"
       #t
       (is-a? mysql-query <mysql-query>))
;;
;;;; test�ǡ����١�����drop���Ƥ���
;(dbi-execute-query mysql-query "drop database dbi-mysql-test")
;;;; test�ǡ����١�����������Ƥ���
;(dbi-execute-query mysql-query "create database dbi-mysql-test")
;;;; test�ǡ����١�������³����
;(dbi-execute-query mysql-query "connect test")
;;;; test�ơ��֥��drop���Ƥ���
(with-error-handler
  (lambda (e) #t)
 (lambda () (dbi-execute-query mysql-query "drop table test")))
;;;; test�ơ��֥��������Ƥ���
(dbi-execute-query mysql-query
		   "create table test (id integer, name varchar(255))")
;;;; test�ơ��֥�˥ǡ�����insert���Ƥ���
(dbi-execute-query mysql-query
		   "insert into test (id, name) values (10, 'yasuyuki')")
(dbi-execute-query mysql-query
		  "insert into test (id, name) values (20, 'nyama')")

;; dbi-execute-query �Υƥ���:
;; <mysql-query>���Υ��󥹥��󥹤�����ˤ����Ȥ�
;; dbi-execute-query ������ͤ�
;; <mysql-result-set>���Υ��󥹥��󥹤��ä�����
(define mysql-result-set (dbi-execute-query mysql-query "select * from test"))
(test* "dbi-execute-query <mysql-query>"
       #t
       (is-a? mysql-result-set <mysql-result-set>))

;; dbi-get-value�Υƥ���:
;; map ����� mysql-get-value ��Ȥä� <mysql-result-set> ���餹�٤ƤιԤ��������
;; ���餫���� insert���줿 (("10" "yasuyuki") ("20" "nyama")) ����������й��
(test* "dbi-get-value with map"
       '(("10" "yasuyuki") ("20" "nyama"))
  (map (lambda (row)
	      (list (dbi-get-value row 0) (dbi-get-value row 1)))
	    mysql-result-set))

;; dbi-close <dbi-result-set> �Υƥ���:
;; <mysql-result-set>���Υ��󥹥��󥹤�close���ƺ��٥�����������
;; <dbi-exception>��ȯ����������
(dbi-close mysql-result-set)
(test* "dbi-close <mysql-result-set>" *test-error*
       (dbi-close mysql-result-set))

;; dbi-close <dbi-query> �Υƥ���:
;; <mysql-query>���Υ��󥹥��󥹤�close���ƺ��٥�����������
;; <dbi-exception>��ȯ����������
(dbi-close mysql-query)
(test* "dbi-clse <mysql-query>" *test-error*
       (dbi-close mysql-query))

;; dbi-close <dbi-connection> �Υƥ���:
;; <mysql-connection>���Υ��󥹥��󥹤�close���ƺ��٥�����������
;; <dbi-exception>��ȯ����������
(dbi-close mysql-connection)
(test* "dbi-close <mysql-connection>" *test-error*
       (dbi-cluse mysql-connection))

;; epilogue
(test-end)





