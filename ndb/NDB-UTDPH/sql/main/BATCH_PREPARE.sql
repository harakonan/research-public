-- ��͎��s�̂��߂ɕK�v�ȏ��������s���Ă����o�b�`

-- �p���������s��ݒ�
alter session force parallel ddl parallel 30
alter session force parallel dml parallel 30
alter session force parallel query parallel 30

-- USER�\�̈�̎c��e�ʂ��m�F����
@TABLE_SIZE.sql

-- ���Z�v�g��ʂ̃}�X�^�[��TEMPORARY TABLE RCP_CLS_MASTER���쐬
@CREATE_RCP_CLS_MASTER.sql

--  RCP_CLS_MASTER�ɓ����Ă���COSTSHARING��'10','20','1020'��'10'�ɂ܂Ƃ߂�VIEW
@CREATE_RCP_CLS_MASTER_SIMPLE.sql

-- �����o�����i�R�[�h��TEMPORARY TABLE MEDICATION_TABLE���쐬
@CREATE_MEDICATION_TABLE.sql

-- �O���ł̈�ȃ��Z�v�g����̉@�������ƒ��܃��Z�v�g����̉@�O�����𒊏o�����f�[�^������TABLE IY_DATA������
@CREATE_TABLE_IY_DATA.sql

-- �͋[�\�o���̕ʓY9�ɓ�����N�G����TABLE������
@CREATE_TABLE_SUMMARY.sql

-- ���O�����₷�����邽�߂̐ݒ�
SET ECHO ON
SET LINESIZE 32767
SET PAGESIZE 50000
SET TRIMSPOOL ON
