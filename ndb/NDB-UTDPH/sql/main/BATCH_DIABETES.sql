-- IY_DATA�Ƀf�[�^��}�����āA�T�}���[�����A�̃N�G�����J��Ԃ��A�ŏI���ʂ��o�͂���o�b�`

-- �ΏۂƂȂ鎾�����`
-- �������ɕύX����
DEFINE DISEASE = 'Diabetes'

-- ���O��ۑ�
SPOOL SPOOL_&DISEASE..log

-- �^�C������J�n
TIMING START

-- �ΏۂƂȂ���i�̏�������TABLE MEDICINE_CD_EXTRACT���쐬
@&DISEASE/CREATE_TABLE_MEDICINE_CD_EXTRACT.sql

-- ��N����؂��ăN�G�����J��Ԃ�
-- ���Ԃ̕ϐ����`
DEFINE START_YM = '42104'
DEFINE END_YM = '42203'

-- &START_YM����&END_YM�܂ł̊��Ԃ�IY_DATA��INSERT���A�T�}���[���쐬����o�b�`
@BATCH_SUMMARY.sql

-- �J��Ԃ�
DEFINE START_YM = '42204'
DEFINE END_YM = '42303'
@BATCH_SUMMARY.sql

DEFINE START_YM = '42304'
DEFINE END_YM = '42403'
@BATCH_SUMMARY.sql

DEFINE START_YM = '42404'
DEFINE END_YM = '42503'
@BATCH_SUMMARY.sql

DEFINE START_YM = '42504'
DEFINE END_YM = '42603'
@BATCH_SUMMARY.sql

DEFINE START_YM = '42604'
DEFINE END_YM = '42703'
@BATCH_SUMMARY.sql

-- �ŏI�^�C��
TIMING STOP

-- MEDICINE_CD_EXTRACT�͂��̌�g��Ȃ��̂�DROP
TRUNCATE TABLE MEDICINE_CD_EXTRACT;
DROP TABLE MEDICINE_CD_EXTRACT;

-- �T�}���[��csv�o�͂���
-- ���O�̕ۑ����~
SPOOL OFF

-- CSV�o�͂̂��߂̐ݒ�
SET ECHO OFF
SET LINESIZE 1000
SET PAGESIZE 0
SET FEEDBACK OFF

-- SUMMARY_1����W�v���ʂ�csv�o��
@OUTPUT_SUMMARY_1_CSV.sql

-- SUMMARY_2����W�v���ʂ�csv�o��
@OUTPUT_SUMMARY_2_CSV.sql

-- �ݒ��߂�
SET ECHO ON
SET LINESIZE 32767
SET PAGESIZE 50000
SET FEEDBACK ON

-- ���̎����̎��s�̂��߂ɃT�}���[��TRUNCATE
TRUNCATE TABLE SUMMARY_1;
TRUNCATE TABLE SUMMARY_2;
DROP VIEW SUMMARY_1_TIDY;
DROP VIEW SUMMARY_2_TIDY;