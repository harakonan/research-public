-- 抜き出す医薬品コードのTEMPORARY TABLE MEDICATION_TABLEを作成
CREATE GLOBAL TEMPORARY TABLE MEDICATION_TABLE
(	MEDICINE_SHORT VARCHAR2 (8) NOT NULL PRIMARY KEY,
	INGREDIENT VARCHAR2 (12),
	DISEASE VARCHAR2 (12)
	) ON COMMIT PRESERVE ROWS;

INSERT INTO MEDICATION_TABLE VALUES('1190012F','Donepezil','Dementia');
INSERT INTO MEDICATION_TABLE VALUES('2171022F','Amlodipine','Hypertension');
INSERT INTO MEDICATION_TABLE VALUES('2149039F','Losartan','Hypertension');
INSERT INTO MEDICATION_TABLE VALUES('2149040F','Candesartan','Hypertension');
INSERT INTO MEDICATION_TABLE VALUES('2189016F','Pitavastatin','Dyslipidemia');
INSERT INTO MEDICATION_TABLE VALUES('2189015F','Atorvastatin','Dyslipidemia');
INSERT INTO MEDICATION_TABLE VALUES('2189011F','Simvastatin','Dyslipidemia');
INSERT INTO MEDICATION_TABLE VALUES('3969004F','Voglibose','Diabetes');
INSERT INTO MEDICATION_TABLE VALUES('3961008F','Glimepiride','Diabetes');
INSERT INTO MEDICATION_TABLE VALUES('3969007F','Pioglitazone','Diabetes');