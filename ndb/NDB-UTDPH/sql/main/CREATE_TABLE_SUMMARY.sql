-- �͋[�\�o���̕ʓY9�̏�\�ɓ�����N�G����TABLE������
-- ���i�ʁA�N���ʁA�s���{���ʁA�N��ʁA�j���ʂ̃W�F�l���b�N���i�V�F�A
CREATE TABLE SUMMARY_1 (
      GENERIC_SHARE NUMBER
    , MEDICINE_SHORT VARCHAR2(8)
    , PRAC_YM VARCHAR2(5)
    , TDFK VARCHAR2(2)
    , AGE NUMBER(3,0)
    , SEX_DIV VARCHAR2(1)
    , TOTAL_AMNT NUMBER
);
ALTER TABLE SUMMARY_1 NOLOGGING;

-- �͋[�\�o���̕ʓY9�̉��\�ɓ�����N�G����TABLE�̏���
-- ���i�ʁA�N���ʁA�s���{���ʁA�N��ʁA�j���ʁA���ȕ��S�����{����ʂ̃W�F�l���b�N���i�V�F�A
CREATE TABLE SUMMARY_2 (
      GENERIC_SHARE NUMBER
    , MEDICINE_SHORT VARCHAR2(8)
    , PRAC_YM VARCHAR2(5)
    , TDFK VARCHAR2(2)
    , AGE NUMBER(3,0)
    , SEX_DIV VARCHAR2(1)
    , PUBFUND VARCHAR2(1)
    , COSTSHARING VARCHAR(2)
    , TOTAL_AMNT NUMBER
);
ALTER TABLE SUMMARY_2 NOLOGGING;
